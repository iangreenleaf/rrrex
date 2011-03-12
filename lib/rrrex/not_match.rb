require 'rrrex/match'
require 'rrrex/single_atom_match'
module Rrrex
  class NotMatch < Match
   include SingleAtomMatch
   def to_regexp_string
     "(?!#{atom.to_regexp_string})"
   end
  end
end
