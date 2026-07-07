---
layout: post
title: 'AI marketing deceit'
categories: engineering ai
---

A collection of fallacies employed to deceit about AI capabilities.


AI is here to stay. You need to develop an understanding of it: what it is, how
it works, where it can be useful, what are it's weak points. Here is a
catalogue of misleading techniques that don't help you get that clarity.


# Unsubstantiated claims and scaremongering

A typical example is the debate around Anthropic's Claude Mythos: "This new
engine is so powerful, it would be dangerous to release it". Then the US
government forbids it's release. Then it's released. The emotional message of
implied fear leaves in the end uncontested the clam that it's powerful. By what
independent verifiable evidence is that the case? Unsubstantiated claims are
lies and deception.


# Just imagine

"Just image, it can do everything". This exaggerated claim does not provide the
clarity: how it works, what are the strong points, what is good at, what are
it's limits. It exploits our ability to easily imagine things that are not
real. Implies blame on the user: if it does not work it must be the user's
fault.


# Mistakes

"Just like anything it can make mistakes". This downplays the wide range of
results that AI can give, while it ignores that specialized code can be
reasoned about mathematically, tested deterministically and be pretty correct.


# Wrong prompt

You get the wrong result: "you used the wrong prompt". This is from a variety
of similar claims "you use the wrong engine", "the wrong depth level", "too
large of a context", "not enough context". Blame the user for the lack of
sophistication of the AI tool.


# Lack of security

[The lethal
trifecta](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/) is often
invoked as a security model. The idea is to avoid for LLMs the combination of
access to private data, exposure to untrusted content and ability to externally
communicate. The problem is that we don't have that much leverage. The models
are cloud based, they do web searches: the external communication is build in.
The training was vetted to some degree, but given its volume, it still has
untrusted content risks; did I say web searches? You should at least not give
it access to private data. There is no security.


# Compared with search engines

At the end of this article I'm throwing an observation.

Compared with a traditional search engine an LLM based agent would do better at
a task like "Explain this code <<code fragment here>>", because it can map the
specific code fragment to the pre-trained specification of a programming
language.

But recently I got better results from an LLM for generic searches like
"Windows C API to do <<such and such>>" then what I got from a Google search.
The reason is probably a consequence of the enshitification of Google search,
which now leaves a gap in the market to be filled.

History will repeat.
