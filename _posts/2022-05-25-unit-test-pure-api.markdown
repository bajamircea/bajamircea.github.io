---
layout: post
title: 'Unit tests: Pure vs API tests'
categories: coding cpp
---

Not all the unit tests are pure calculation tests.


# Pure unit tests

Say you have a function like:

{% highlight c++ linenos %}
// Return the n-th prime
int nth_prime(int n);
{% endhighlight %}

A basic unit test would look like:

{% highlight c++ linenos %}
TEST(nth_prime, happy_path)
{
  EXPECT_EQ(2, nth_prime(1));
  EXPECT_EQ(3, nth_prime(2));
  EXPECT_EQ(5, nth_prime(3));
  EXPECT_EQ(7, nth_prime(4));
}

TEST(nth_prime, invalid)
{
  EXPECT_THROW(nth_prime(0), std::invalid_argument);
  EXPECT_THROW(nth_prime(-1), std::invalid_argument);
}
{% endhighlight %}

`nth_prime` is a regular function, that performs a calculation: for equal
arguments, the return value will be the same. It does not need to to do any
input/output. Functions like that are prime candidates for unit tests. They are
usually run as part of the build.


# API unit tests

Say you have a function like:

{% highlight c++ linenos %}
// Return true if the file is read only
bool is_read_only_file(const std::filesystem::path & path);
{% endhighlight %}

One could write tests using the same unit test framework.

{% highlight c++ linenos %}
TEST(is_read_only_file, happy_path)
{
  // ... setup test files
  EXPECT_TRUE(is_read_only_file("path_to_read_only_file"));
  EXPECT_FALSE(is_read_only_file("path_to_full_permissions_file"));
}

TEST(is_read_only_file, errors)
{
  // ... setup test files
  EXPECT_THROW(is_read_only_file("path_to_missing_file", std::system_error));
  EXPECT_THROW(is_read_only_file("path_to_access_denied_file", std::system_error));
}
{% endhighlight %}

`is_read_only_file` is not a regular function: for equal arguments, the return
value might vary. At different times the same file might have different permissions.
It will have to eventually call system APIs to check the permissions for the
file. The function will perform input/output, it is not just pure calculation.
Input/output usually causes functions (and tests) like this to run about 100
times slower than the pure calculation ones.

The unit test purists insist on the doctrine that functions that involve
input/output are not unit tests.

Regardless of terminology, the reality is that such tests are worth having.
They confirm that APIs are called correctly. They are usually run on multiple
target platforms, to cover the risk that different platforms vary in their API
behaviour.


# Maybe pure, maybe API unit

Say you have a function like:

{% highlight c++ linenos %}
// Base64 encode
std::string base64_encode(const std::vector<unsigned char> & input);
{% endhighlight %}

A basic unit test might be like:

{% highlight c++ linenos %}
TEST(base64_encode, happy_path)
{
  EXPECT_EQ("MA==", base64_encode({0});
  EXPECT_EQ("MSAyIDM=", base64_encode({1, 2, 3});
}
{% endhighlight %}

This is again a regular function: for equal inputs, the output will be the
same.

But without checking the implementation, one can't know if it's a pure
calculation or it it calls an API (e.g. `CryptBinaryToStringA` on Windows or
`EVP_EncodeBlock` from OpenSSL).

It's situations like this that make it impractical to try to separate pure unit
tests from unit tests that cover APIs and involve input/output.


# Conclusion

A unit test framework can be used to test both pure calculation and confirm
that APIs are called correctly. We've also seen an example where it's hard to
predict in which category a test will fall. Such test executables should be run
on multiple platforms to cover API behaviour; the overhead of running pure unit
tests multiple times is usually negligible.
