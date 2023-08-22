---
layout: post
title: 'Software Engineering'
categories: story coding
---

Software engineering is much more than coding: it's dealing with other people
and with uncertainties. Philosophical thoughts on situations that you might
encounter as a professional developer.


# Hare vs. tortoise

I learned the Aesop fable when I was little, it was funny, the hare was silly
(why did it stop running?), but did not think that's something that can be
applied, it was just a funny children story.

Many years later I was cycling from London to Brighton. Somewhere, midway the
distance, I was going slowly when a couple of cyclists gently overtook me. I
thought "I can keep up with them", and I pedalled harder to keep up with them.
Half an hour later, also a bit tired from the extra effort to keep up, I
started to have doubts that I was going in the right direction and eventually I
stopped to check the map. It turned out that instead of heading southwards, at
some point after a gentle curve we ended going eastwards, they were not going
south to Brighton, I cycled fast for most of the half an hour in the wrong
direction.  I would have made more progress with less effort if I would have
cycled instead in the right direction.

**Accidental design** is the situation where there something was done, it had
bugs, bugs were fixed by adding complexity, and that repeated, until the code
is really complex and still not bug free, but at no point anyone stopped to ask
"Are we doing the right thing? Is there a simpler option available?" and pursue
the simpler option earlier on.

If you have a vision for the direction of the software product and implement
things so that fit within that vision and move in the right direction, or
having an idea of which bug fixes would have the largest impact and fixing
those bugs, will lead to more results than just doing random stuff quickly or
fixing quickly insignificant bugs. Working hard might make less progress that
working clever.

> Corollary: it's not enough to be clever, it's also important to be wise


# Essence of agile

The essence of agile is figuring out what's important, work on that, be
intellectually alert on what's happening, think, don't be afraid to change plan
when it makes sense based on new information. It does not mean avoiding all
planning and design.

> Lengthy and costly "agile" development would often have benefited by a little
> bit of design.

There is the canonical example of the best method to fill, seal and attach a
stamp to a number of envelopes. There is the option of filling all envelopes,
seal all the envelopes then stamp all the envelopes or the other option of
doing one envelope at a time (fill, seal, stamp, then move to the next
envelope). One of the methods is faster, and if there are enough envelopes to
handle, [a little bit of testing, to see which one, will give surprisingly
faster outcomes](https://www.youtube.com/watch?v=Dr67i5SdXiM).


# Uncertainties: how long will it take

Sometimes it is possible to get a good estimate on how long will it take to
develop some functionality: that's the case when the team has the experience of
similar previous work.

But doing repeatedly the same thing becomes low value, there is more value in
doing new things that have not been done (the same way) before, That's harder
to estimate to the same degree of precision.

There is no point pretending that both are the same, in particular trying to
commit to precise timelines when there is a lot of uncertainty: that's either
naive or unethical.

A typical antipattern is as follows (PM stands e.g. for a project manager, Dev
stands for a developer):

<p><pre>
PM: How long will it take?
Dev: I don't know.
PM: No. How long will it take?
Dev: I really don't know.
PM: No, no, it does not work like that, you have to tell me how long it will
take,
Dev: I don't know. 5 days?
PM: Great, I'll write that down.

  Later that day
Stakeholder: How long will it take?
PM: 5 days.

  5 days later
PM: Is it done?
Dev: No, because I hit an unexpected problem ...
PM: Fine. How long will it take?
Dev: I don't know.
PM: No, no, you have to tell me how long it will take.
Dev: I don't know? 3 more days?

  Later that day
Stakeholder: What's the project status?
PM: It's late by 3 days. It's the developer's fault.
Stakeholder: Tell them to not be late again.
</pre></p>

What happens above is that the developer's uncertainties are ignored. The
problem was framed wrongly, on the assumption that precise estimates are
possible, from the interaction above why would any reasonable person really
believe that is the case? A more grown up behaviour would have been to at least
acknowledge the uncertainty, try to explore what would reduce it e.g "what
information is needed to reduce the uncertainty?", "would a more experienced
developer be able to provide better estimates?" and monitor progress, don't
wait to the end of the 5 days, maybe a solution can be found to overcome the
unexpected difficulties before the deadline.

What also happened is that the project manager defines their role as of just
relaying data between the developer and stakeholder not really doing their job,
the stakeholder let them get away with that and suffers unpleasant surprises,
while the developer (who has no project management expertise) suffers
unconstructive pressure from those two and gets little credit for the technical
achievements.


# The human factor

This gets us to the point that a lot of the software development is not about
technical issues, but about interacting with other people. It's so satisfying
and beneficial to resolve problems based on reason and facts. But to get there
requires a lot of human interaction skill.

Often in meetings there is a question and the answer is "Blah, blah, blah,
blah", maybe true and maybe interesting, but not really answering the question.

There are at least two behaviours that help to get back to reason and facts.
One is to do active listening:
- Is the question important?
- What are they saying as the reply?
- Does it answer the question?
- Why are they saying something else then? Is that important to come back later
  to?
- What's the next bit of info that would help to explore?
- etc.

The second, related, behaviour is to respect people. Generally people want to
achieve things, to be recognized for that, even when we malfunction in
corporate groups, stay positive and focus on what would make things better.
