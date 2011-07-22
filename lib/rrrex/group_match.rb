require 'rrrex/match'
require 'rrrex/single_atom_match'
module Rrrex
  class GroupMatch < Regin::Expression
   def initialize atom, name
     @name = name
     super Regin::Group.new Regin::Expression.new atom
   end

   def to_regexp_string
     "(#{atom.to_regexp_string})"
   end

   def group_names
     names = @atom.group_names || []
     names.unshift @name
   end

   def +(other)
     ary = other.is_a?(self.class) ? other.internal_array : other
     ary = @array + ary + [options.to_h(true)]
     Regin::Group.new(*ary)
   end
  end
end
