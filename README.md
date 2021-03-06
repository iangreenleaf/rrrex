Really Readable Regular Expressions
================

rrrex is a new syntax for regular expressions. It trades compactness for readability by real humans, and picks up a couple nice perks
along the way.

[![Build Status]](http://travis-ci.org/iangreenleaf/rrrex)

Crash Course
============

    "The string you'd like to search".rmatch? { "string" }

    "abc".rmatch? { "ab" + "c" }

    "abc".rmatch? { "xyz".or "abc" }

You don't have to worry about escaping special characters in your strings any more:

    "{symbols} .*&+ [galore]".rmatch? { "{symbols} .*&+ [galore]" }

You can combine operations and get the expected precedence:

    "abc".rmatch? { "ab" + ( "z".or "c" ) }

You can use `Rrrex.build` to make reusable, composable objects:

    names = Rrrex.build { "foo".or "bar" }
    nums = Rrrex.build { "1".or "2" }
    names.match "foo"
    "foo112".rmatch? { names + ( some nums )}

Repetition:

    "aaabc".rmatch? { 1.or_more "a" }
    "aaabc".rmatch? { 5.or_less "a" }
    "aaabc".rmatch? { 3.exactly "a" }
    "aaabc".rmatch? { (1..5).of "a" }

These are equivalent:

    "aaabc".rmatch? { 0.or_more "a" }
    "aaabc".rmatch? { any "a" }

And these are equivalent:

    "aaabc".rmatch? { 1.or_more "a" }
    "aaabc".rmatch? { some "a" }

Repetition can be nongreedy:

    "aaabc".rmatch? { 2.or_more "a", :greedy => false } # matches "aa"

Special character sets:

    "abc1234.&*".rmatch? { 10.exactly any_char }
    "abc1234".rmatch? { 3.exactly letter }
    "abc1234".rmatch? { 4.exactly digit }
    "abc_123".rmatch? { 7.exactly word_char }
    " ".rmatch? { whitespace }

Or create your own:

    "abc".rmatch? { 3.exactly "a".."c" }

Two types of negation:

    "x".rmatch? { word_char.not "x" } # => nil
    "y".rmatch? { word_char.not "x" }
    "x".rmatch? { _not "x" } # => nil
    "y".rmatch? { _not "x" }


Groups:

    "aaabc".rmatch? { group(1.or_more "a") }[1]
    "aaabc".rmatch? { group(:alpha, (1.or_more "a")) }[:alpha]

    match = "1234567890       Central Processing".rmatch? do
        group :serial do
            some digit
        end + some whitespace + group :source do
            any any_char
        end
    end
    match

See the [examples](https://github.com/iangreenleaf/rrrex/tree/master/examples/) for more ideas.

[Build Status]: https://travis-ci.org/iangreenleaf/rrrex.png?branch=master
