---
layout: post
title: 'XMLHTTPRPCSerializer'
categories: coding cpp
---

How to handle acronyms in various programming naming conventions


Well like that:

<table>
<tr>
  <th></th>
  <th>Yes</th>
  <th>No</th>
</tr>
<tr>
  <th rowspan="2">Pascal</th>
  <td><code>XmlHttpRpcSerializer</code></td>
  <td><code>XMLHTTPRPCSerializer</code></td>
</tr>
<tr>
  <td><code>XmlFile</code></td>
  <td><code>XMLFile</code></td>
</tr>
<tr>
  <th rowspan="2">Snake case</th>
  <td><code>xml_http_rpc_serializer</code></td>
  <td><code>XML_HTTP_RPC_serializer</code></td>
</tr>
<tr>
  <td><code>xml_file</code></td>
  <td><code>XML_file</code></td>
</tr>
<tr>
  <th rowspan="2">Camel case</th>
  <td><code>xmlHttpRpcSerializer</code></td>
  <td><code>xMLHTTPRPCSerializer</code></td>
</tr>
<tr>
  <td><code>xmlFile</code></td>
  <td><code>XMLFile</code></td>
</tr>
</table>

The rationale is that the ability to distinguish different words, to being able
to read the function/type/variable name especially in sequences of acronyms,
and the case convention, for consistency purposes, take precedence over using
upper case for the acronym.

However the acronyms must be spelled correctly in a programming comment where
there are no restrictions.

{% highlight c++ linenos %}
// Implements the XML HTTP RPC serializer
{% endhighlight %}

