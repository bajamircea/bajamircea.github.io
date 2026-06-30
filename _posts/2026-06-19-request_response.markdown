---
layout: post
title: 'Request-response design'
categories: engineering protocol
---

Advice on designing request-response protocols.

Say you have two processes that you want to communicate with each other. I'm
assuming that you don't have a special problem (high volume, low latency,
etc.), instead you care for some message exchange protocol between the
processes that is easy to understand, check for correctness and maintain.

# Example of a request-response protocol

Client is a temperature and humidity sensor. Client connects to server. Server
configures client to send humidity every 2 mins, temperature every minute. Then
the client sends humidity and temperature data (as requests) with the
configured periodicity until connection breaks. Comments indicate direction of
messages below them.

{% highlight text linenos %}
// server -> client
{ "type": "config_nofifications", "id": 0, "data": { "humidity": 120, "temperature" : 60} }
// server <- client:
{ "id": 0, "data": { } }

// server <- client (a minute later):
{ "type": "temp", "id": 0, "data": { "value": 28.5 } }
// server -> client
{ "id": 0, "data": { } }

// server <- client (another minute later):
{ "type": "humidity", "id": 1, "data": { "value": 50.0, "dewpoint": 8.5 } }
{ "type": "temp", "id": 2, "data": { "value": 28.0 } }
// server -> client
{ "id": 2, "data": { } }
{ "id": 1, "data": { } }
{% endhighlight %}

This is an example where either side can send requests, each request has a
response and responses are not necessarily in the order of the requests. The
point of the requests is that if say the server is slow, the client will wait
until the server responds before sending further data of the same type.

Requests have:
- a `"type"` string: what kind of request this is
- an `"id"` integer
- a `"data"` object: arguments for the request, potentially an empty `{}`
  object, the exact content depends on the type of the request

Responses have:
- the `"id"` of the corresponding request
- a `"data"` object: contents of the response, potentially an empty `{}`
  object, the exact content depends on type of the request

We'll look now at options we can make to get to a protocol like the one above.

Protocols come in a stack of protocols. Usually you know what you want to
achieve in the upper layers, but let's from the lower layers to the upper ones.


# Transport layer

Choose how will the two processes talk to each other? Choices could be:
- Via TCP sockets
- Via Windows named pipes
- Maybe one process is the child of the other, then one option is via the
  standard input and output of the child process

For high volume, low latency, high scalability you might make other choices
e.g. UDP (instead of TCP) for low latency where you can deal with data loss.
I'm not exploring that further here.


# Message layer

Over that you want to send messages. Choices to delimit messages could be:
- The lower protocol already does that: e.g. Windows names pipes have message
  modes. This is the simplest option
- The lower protocol does not do that: it only provides a stream of bytes

To create messages on top of a stream of bytes you can:
- Send the length of the message (e.g. 4 bytes little endian), followed by
  the message of that length.
- Parse until you decide that the message is completed. This is more
  complicated, for no gain.


# Message encoding

Then you need to encode the data into the message. Choices could be:
- Use a humanly readable format. E.g. JSON. Avoid XML. This is the simplest
  choice. Human readable messages always win in the ability to troubleshoot.
- Use some binary encoding e.g. Protobuf or DER. Use this more complex option
  if you have a good reason e.g.: "We already do that, we have knowhow", speed
  of encoding/decoding or reduction in bytes to transport gives you a
  measurable gain that would make a difference for your application.

At this point we have enough to send messages from one process to another, but
for how these are sequenced we could:
- Have a unstructured approach, e.g. "If one process sends this kind of
  message, then the other process follows with this kind of message, then the
  first process follows with this kind of message etc."
- The other approach is to have a request-response approach that is much easier
  to maintain


# Request-response layer

In this approach messages are either requests or responses, and every request
receives exactly one response (except if the connection between the processes
breaks).

Who can send requests. Options are:
- Only one side sends requests (e.g. the client that initiates the connection,
  or the parent process). This implies that the other side only sends
  responses.
- Either side sends requests (implies either side can send responses). This is
  the more flexible approach for maintenance, because even if initially that's
  not the case, things can change over time. When a message is received, you
  need some way to know that the message is a request or response.


## Request type

There are several kinds of requests. You need a field to specify the kind of
request. Common names for such a field are `type`, `method`, `kind`, `req`,
`name`. The field type is commonly a string or an integer. String is easier to
diagnose. Even if string, the value is meant for the code to do a `switch` on
such strings, not a human: e.g. `"auth"`, not `"Please authenticate"`.


## Match the request to the response

The sender of requests:
- Can be constrained to always wait for the response of a previous request
  before making more requests. This is the simplest approach. The API can me
  made to block when a request is made and return when the response is
  received.
- Can send further request without waiting for a response. This provides good
  value in terms of communication delays and flexibility, for a small increase
  in complexity.

Responses can be provided:
- Always in the same order as the requests were received. This includes the
  case where a side can continue to send further requests before receiving a
  response to the previous request (called pipelining). For pipelining the
  sender has to store a queue so that when the responses are received it can
  know what request they correspond to.
- Or responses are not guaranteed to be send in the same order as the requests
  are received. This provides good value in terms of communication delays and
  flexibility, for a small increase in complexity. It requires that the
  requests have an ID, a sequence field, which is present with the same value
  in the corresponding request, allowing them to be matched. Common names for
  such a field are `id`, `seq`, etc. The field type is commonly an integer. The
  values have to be unique per side of communication and per connection e.g.:
  when connection starts each side makes their first request with `"id": 0` and
  they increment the value by one after each request they make. The sender of
  requests has to have a dictionary where when a request is send with an ID, it
  then stores the data associated with that request so that it can be used when
  the response comes back (e.g. at least to check that the response ID is valid
  and corresponds to a pending request).


## Data

Then you have to send the actual data (request type dependent). You can:
- Send them as top level fields side by side with the `id` and request `type`,
  but then you risk name collision
- Or better, you group that under another field. This is the more robust
  choice. Common name for that field are `data` (for both request or response),
  `params` or `args` (for the the request data), or `result` (for the response
  data). A good strategy is for the data to be a JSON object: because it can be
  extended with new fields, Use an empty object `{}` when no additional data is
  sent.


## Error

Responses can communicate error. A good name for the field is `error`. A
response can send either `data` or `error`, not both. At it's simplest the
error is an integer. For complex cases it can be a JSON object with a `code`,
the error code as an integer and a human readable `message` string. Choose
simple (human readable raises translation questions).

You might want to have some predefined error codes for:
- Not implemented: for when the request type is not implemented by the party
  that responds.
- Invalid data: for when the data content of the request is invalid, e.g. it
  fields are missing or an unexpected type.
- Temporary error.

For issues like a response `id` does not match a pending request `id`: you
disconnect rather than returning an error.


# Flow control

In a communication where two parties are involved, one is bound to be slower
than the other.

When you write on a connection like TCP you use some API. Commonly writes are
buffered, that is the write function will often copy the data provided into a
buffer and return quickly before the buffer was sent to and acknowledged by the
other end. But if the communication is slower than the rate of writing,
eventually the buffers fill, the write will block until transmission empties
enough of the buffer so that the data can be then put into the buffer, so
writes will be slower to return, and the writer is slowed down by the rule that
you're not supposed to invoke another write (on the same connection) until the
previous one returned.

For requests that represent state, such as temperature in the example above, if
the other side does not respond before a new value is produced, then you queue
the value and send it when the response eventually arrives. If more than one
value is produced before the response arrives, only keep the last value, so
that in face of slow systems, we accept data loss. In effect we limited to just
one pending request of that type. For more complex scenarios you can limit to a
number of pending request (overall or per request type), but if we have more
data that can be processed, data loss is a reasonable consequence.

On top of that, if you have to choose between writing a response or a request,
which one should prioritise? Prioritising the response is not stable because
the other side might make another request, to which then you respond, and so
on, without having a chance to send your requests. A good strategy is to
prioritise sending your request. Combined with the limit to the number of
pending requests, this results on a system that eventually makes progress when
one party is slower than the other.


# Notifications

Then somone comes with the idea of sending some messages that do not expect
requests. **Don't do that**. It means you've not understood the flow control
problem.

You might get away if the notifications are one off, i.e. if there is an
absolute limit of such messages per connection, e.g. some message "will
disconnect".

For example if progress of an activity is send as notification for each
percentage, you could flood the other party with 100 messages, which ,if the
other party is slow, will slow it further. On the other side if progress is
send as a request response, then the other slower party might respond only by
the time we reached 25%, resulting in about 4 requests (and 4 responses)
instead.


# Versioning

Another temptation is to add a `version` field to address versioning. This does
not help with backwards compatibility because it does not handle the case where
the version is higher than expected.

A better strategy for version is:
- Don't add a `version` field
- A request or a response can add additional fields to the `data` they send.
  Each party should ignore the fields they don't understand. This works for
  some incremental evolution
- For larger changes use new request types, handle the error "not implemented"
  e.g. fall back on an older request type.


# Example: JSON RPC

I'm referring to [JSON RPC](https://www.jsonrpc.org/specification) 2.0
Specification (Updated 2013-01-04).

The good parts:
- It defines a request-response protocol
- The `id` is called `id`. It is a number, it is present in both the request
  and the corresponding response
- The request type is called `method`. It is a string.
- The data is called `params` for requests and `result` for responses
- The response sends either a `result` or an `error`

The OK parts:
- the  `error` is an object, a choice on the more complex spectrum, but not a
  bad one for a stadard that's supposed to be used in a wide range of
  applications.
- some complexity around batching: don't use batching
- data, e.g. `params` is not necessarily an object, can be omitted, but you can
  still decide to always send an JSON object, even if empty.

The bad parts:
- It defines notifications as requests without an `id`. Don't use them.
- It has a `"jsonrpc": "2.0"`, basically a version number. This is an incorrect
  versioning approach.

