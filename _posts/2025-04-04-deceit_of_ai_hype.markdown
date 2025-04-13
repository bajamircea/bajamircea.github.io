---
layout: post
title: 'The deceit of AI hype'
categories: engineering ai
---

We're in a period of AI hype that is marketed so hard that it became a
deceitful scam


# The fundamentals

We have Turing's test: the idea is that if one cannot distinguish between a
human and a machine, then the machine can think. The problem with that is that
it does not shed any light on what thinking, intelligence etc. are.

[Hume's First Enquiry][hume-enquiry], written about two centuries earlier than
Turing's paper, has more to say about how humans think. And the answer is a bit
disappointing: humans don't think much. Our thinking is basically inductive,
based on past experience: if all the swans we've seen before were white then we
conjuncture that "all the swans are white".

The AI models work exactly the same: they get data and expected outcomes, then
the next time the same data appears they conjecture the previous outcome. To
achieve the fit they use a large number of parameters. It is a long known issue
that models with large number of parameters can do good fits: [Von Neumann's
elephant][dyson] is an example where with four parameters one "can fit an
elephant" and with five "can also wiggle its tail". Current ML models use way
more than just four. That creates the problem that the number of possible
states is so large that it's difficult to thoroughly test them, setting
barriers to the confidence in the outcomes produces by such models: they fit
until they don't (e.g. the hallucination problems).

So that's **the bad news: humans thinking does not amount to much, in that
respect humans don't have an advantage to computer models which kind of do the
thing based on previous/training information.**

But **the good news is that experience matters**. If computer models are fed
low quality data, they will have low quality outputs. Even when I wax lyrical
about Hume, Hume has written many things, I'm very selective about specific
things he wrote, there is value in knowing what of all he wrote is meaningful.

**The other thing that matters is reputation**. Proofs become really
complicated for all but the most trivial things for which we have direct
experience. We implicitly rely on the reputations of an expert, so thinking
that X is true often comes to "we've checked the reputation of someone that
says X".


# Motivation of unfounded claims and generic tricks

AI has a history of going though boom and bust ("AI winters" as they call
them). This is rooted in disingenuous use of misleading terminology and
unfounded claims.

**The misleading terminology and unfounded claims are caused by the desire to
attract funding for research and development, get customers and gain market
share, but it's basically a fraud when the claims are incorrect (even if the
claimant believes in the erroneous claims) and meant to deceive.**

**An example of misleading terminology is anthropomorphising the machine** "The
chat boot understands/wants/needs/etc." without any qualification of what e.g.
"understands" means in this context.

Unfounded claims is often starts with "just imagine". We can imagine all sort
of things with ease, but, that does not make them real, at least not at the
same speed at which we can imagine.

**The "just imagine" trick seeks to confuse and charge in sales for a promise
that will not materialize for that transaction.**


# Prompt engineering

You interact with a generative AI model and you don't get good results: try
again with a different query. For this situation someone came with the term
"prompt engineering". This is an example of misleading terminology. How is this
engineering? You have people building bridges, airplanes, software etc.: those
are engineers. **"The AI model is not fit for purpose" is not "engineering"**.
The misleading term is meant to deflect, it tries to blame the user: they did
not use the model properly.


# Driver-less cars

"Just imagine driver-less cars that eliminate the X thousands of accidents each
year". Without any justification on how this will eliminate all the accidents
and not create new kind of accidents, the claim is just an aspiration. 

**The claims are often cleverly formulated so that they can't be falsified**.
[Elon Musk claimed in a Fortune interview: “We’re going to end up with complete
autonomy, and I think we will have complete autonomy in approximately two
years.”](https://fortune.com/2015/12/21/elon-musk-interview/), he further that
the regulators will lag  behind the technology therefore in some jurisdictions
it may take five years or more. That was in 2015, we're in 2025, technically 9
years is "five years or more". The issue with the regulators is disguising the
admission that it's easy to make a claim, but it's harder to convince an expert
that the claim is valid. Read "regulators will lag" as "Tesla will lag
until they have convincing evidence".

Tesla is a particular case of over-hyping and over charging for what are cheap
choices. E.g. the decision to keep costs down by relying on cameras alone
rather than additional sensors causes accidents where the obstacle is not
detected: because of the unusual shape (an overturned truck), because of blind
spots between the space regions visible by cameras (e.g. due to camera's
positioning not being correctly calibrated) etc.


# Self improvement loop

eric schmidt (of Google fame) mentioned several times this idea that you get an
AI engine set to work on a problem, then next day you ask it to solve it
better, some kind of "self improvement loop". Just imagine perpetual
exponential progress.

The obvious problem with this is quite quickly the solution becomes difficult
to analyse for correctness, feedback quality decreases and progress stagnates.


# Cloud based AI

Recent years saw huge expenditure in data centres to support training large ML
models by the likes of Amazon, Microsoft, Google etc. with Nvidia selling them all
chips to build that infrastructure, with the hope that they will then be able
to recoup those costs via sales.

I've recently been to a "training" session on "using cloud hosted huge large
language models" which was really a sales pitch. E.g. they clearly had a cloud
based model where they hope to arbitrage between what they charge for usage and
what it costs to run. There was no mention of simpler solutions of lower cost,
maybe local rather than requiring cloud infrastructure and not a deep dive into
the privacy implications of uploading personal data into their data centres.
**That** is the analysis that you have to do to avoid being conned. The example
of DeekSeek is that cheaper options are possible.


# AI coding

This is the driver-less story applied to programmers: "hey look, AI can code,
it will replace developers".

To start with, the availability of training data matters a lot in this story.

Some tasks have been previously done repeatedly:
- There are sites for interview preparation like LeetCode, with lots of
  submissions for algorithm solutions.
- Processing common file formats such as CSV.
- Downloading and parsing web pages for formatted content (e.g. table from
  Wikipedia page)
- Companies publish APIs and popular APIs have many users that commented on how
  to use it correctly (including the API documentation)
  - e.g. Windows or Linux system APIs
  - cloud APIs like using AWS S3, EC2 etc.
  - database APIs like using MongoDb, SQL Server etc.
AI can successfully interpolate and provide reasonable answers to questions
like "how do I extract a JSON from a ZIP file in a S3 bucket and import it in
MongoDb?".

But on the other side when the requirement is to do something new, specific
then AI will fail. **A particular insidious type of failure is when it provides
answers that are convincing, but wrong**.

My experience with tools like Git Copilot is that I have to think what I want
to do, and then if the tool suggests that, then fine. E.g. it is good at
generating code like the 2nd line if I wrote most of the first line, but that's
not that much of a help, it does not help with "What should this class do?".

{% highlight c++ linenos %}
some_class(const some_class&) = delete;
some_class& operator=(const some_class&) = delete;
{% endhighlight %}

I had a recent case where a senior developer faced a subtle undefined behaviour
issue involving `std::generator`, range-based `for` loops, temporaries lifetime
and uncertainties about which C++23 features are implemented by our compiler at
work. They spend some hours trying to isolate the issue. I could give him some
hints about the cause and some temporary plan of action. Still a bit confused,
I crafted a question for Stack Overflow about a code example in the C++
standard. Luckily I got a good answer from an expert.

Then I though "What would ChatGPT have to say about a related code containing
a bug?". Well, it told me lots of things that looked convincing, but wrong, and
more importantly did not point out the bug. That's yet another case where the
AI can fool a naive user. **In a way it passes the Turing test, it's not always
clear if it's a machine or a person, but it's clear it's a stupid person**.

Simply the reason tools like Git Copilot are pushed for developers, with all
the manufactured stories about what developers need, and there is no propaganda
"CEOs will be replaced with AI" is that simply **when you plan to charge $30
per user it makes sense to target developers rather then CEOs for the simple
reason that there are more developers than CEOs**.


# In the end

AI is fine when the outcome does not matter "Recommend me some music to listen
to", but when things matter, unfounded trust in AI leads from loss of time and
money to real damage, including human life.


[hume-enquiry]:    {% post_url 2024-10-27-hume-first-enquiry %}
[dyson]:           {% post_url 2020-04-04-freeman-dyson %}

