require 'rrrex/unescaped_string_match'
require 'rrrex/group_match'
require 'rrrex/number_match'
module Rrrex
  module DslContext

    WORD_CHAR = '\w'
    DIGIT = '\d'
    WHITESPACE = '\s'
    LETTER = '[[:alpha:]]'
    ANY_CHAR = '.'

    constants.each do |const|
      ( class << self; self; end ).instance_eval do
        define_method const.downcase.to_sym do
          UnescapedStringMatch.new const_get( const )
        end
      end
    end

    def self.any r
      NumberMatch.new r, 0, nil
    end

    def self.some r
      NumberMatch.new r, 1, nil
    end

    def self._not r
      any_char.not r
    end

    def self.group( name_or_atom=nil, atom=nil, &block )
      if name_or_atom.kind_of? Symbol
        name = name_or_atom
        atom = atom || DslContext.module_exec( &block )
      elsif name_or_atom.kind_of? Hash
        name = name_or_atom.keys.first
        atom = name_or_atom[ name ]
      else
        name = nil
        atom = name_or_atom
      end
      GroupMatch.new atom, name
    end
  end
end
