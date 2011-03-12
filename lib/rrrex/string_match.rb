require 'rrrex/match'
require 'rrrex/single_atom_match'
module Rrrex
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
