Readable Regexps
================

tregexp is a new syntax for regular expressions. It trades compactness for readability by real humans, and picks up a couple nice perks
along the way.

Crash Course
============

    "The string you'd like to search".rmatch? { "string" }

    "abc".rmatch? { "ab" + "c" }

    "abc".rmatch? { "xyz".or "abc" }

You don't have to worry about escaping special characters in your strings any more:
    "{symbols} .*&+ [galore]".rmatch? { "{symbols} .*&+ [galore]" }

You can combine operations and get the expected precedence:
    "abc".rmatch? { "ab" + ( "z".or "c" ) }

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

Special character sets:
    "abc1234.&*".rmatch? { 10.exactly any_char }
    "abc1234".rmatch? { 3.exactly letter }
    "abc1234".rmatch? { 4.exactly digit }
    "abc_123".rmatch? { 7.exactly word_char }
    " ".rmatch? { whitespace }
Or create your own:
    "abc".rmatch? { 3.exactly "a".."c" }

TODO Doc
========
_not
.not
groups
