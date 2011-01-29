require 'tregexp/match'
require 'tregexp/single_atom_match'
module TRegexp
  class StringMatch < Match
   include SingleAtomMatch
    def initialize( a )
      @atom = a
    end

    def to_regexp_string
      wrap Regexp.escape atom
    end
  end
end
