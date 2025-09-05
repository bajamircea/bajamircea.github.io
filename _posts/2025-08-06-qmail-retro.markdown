---
layout: post
title: 'Qmail retrospective'
categories: coding cpp
---

Review of `qmail`'s author retrospective on writing code free of security bugs


# Background info

I started to look at Rust, following the official tutorial and saw that the
sample "Guessing game" was pulling `rand_chacha`. ChaCha? It turns out it's a
stream cipher developed by Daniel J. Bernstein. It turns out he's the chap that
wrote `qmail` that was new at the time (mid 1990s) as it was security aware. So
I stumbled across this: [the qmail author's reflection 10 years later, on how
that went][qmailsec]. And I thought "Yeah, I've seen that back in the day, I
always wondered how was he that confident to offer $500 bounty for a security
bug find, but did not get it at the time". Reading the paper now, it made
sense, I have more experience to refer to.


# Points

Agree: Having less code to review, code that was written competently and with
care leads to less bugs, plus proper fixes for bugs, leads to code that also
has less security bugs and the speed of development can be maintained
unhindered by distractions.

Agree: "Avoid parsing": one of the buggiest piece of code I wrote was a parser.

Agree: `stat()` AKA `file exists?` has three outcomes: yes, no, error (don't
know). All of them have to be handled.

Agree with a twist:
{% highlight c++ linenos %}
if (dup2(fdv[1], 1) < 0) {
  syserr("%s: cannot dup2 for stdout", argv[0]);
  _exit(EX_OSERR);
}
close(fdv[1]);
{% endhighlight %}

He suggests the advantage to having such small functions, while I would take it
further and say "use C++ RAII to ensure the descriptor is closed on scope
exit".

Agree:
{% highlight c++ linenos %}
if (!stralloc_cats(&dtline,"\n")) temp_nomem();
{% endhighlight %}
Say you concatenate strings and handle the case where you fail to allocate
additional memory. For a short running program a viable option is to exit the
process in in those circumstances. But for long running programs that's not
acceptable. That is a challance for libraries that assume termination (e.g. by
terminating if low memory conditions). For special domains is fine to have
specialized libraries, but long running programs are not that different.
Ideally an off the shelf library should handle long running programs.

Agree with a twist:
{% highlight c++ linenos %}
if (!stralloc_cats(&dtline,"\n")) temp_nomem();
//vs.
stralloc_cats(&dtline,"\n");
//or
dtline += "\n";
{% endhighlight %}

So this leads to the conclusion that for concatenating string we should rather
have code like the one above, which throws an exception in low memory
conditions (low memory conditions are exceptional). That is linked to having
less source code (the exception throwing code is hidden from view). He says
that he should have considered a tool like Bjarne Stroustrup's cfront. I would
take it further: use C++. `dtline += "\n";` is how string concatenation is done
in C++, the code implies that on low memory conditions a `std::bad_alloc`
exception will be thrown, short running programs can catch it and exit, long
running programs can catch it and retry later.

Disagree: In the discussion about "minimizing privilege", I think there is
value in creating moats so that the impact of a security bug is reduced. Sure,
the bug still needs to fixed, but there is value in reducing the harm an
attacker can do. There is a difference between "the attacker crashed the site
of an online seller" vs. "the attacker stole the customer names, addresses and
their credit cards".

# Reference
[Daniel J. Bernstein: Some thoughts on security after ten years of qmail 1.0 - 2007-Nov-02][qmailsec]

[qmailsec]: https://cr.yp.to/qmail/qmailsec-20071101.pdf
