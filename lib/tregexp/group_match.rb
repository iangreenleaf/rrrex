require 'tregexp/match'
require 'tregexp/single_atom_match'
module TRegexp
  class GroupMatch < Match
   include SingleAtomMatch
   def initialize atom, name
     @name = name
     super atom
   end

   def to_regexp_string
     "(#{atom.to_regexp_string})"
   end

   def group_names
     names = @atom.group_names || []
     names.unshift @name
   end
  end
end
