module Rrrex
  module SingleAtomMatch

    attr_reader :atom

    def initialize( a )
      self.atom = a
    end

    def atom=( a )
      @atom = input a
    end

    def to_regexp_string
      wrap atom.to_regexp_string
    end

    def group_names
      if @atom.respond_to? :group_names
        @atom.group_names if @atom.respond_to? :group_names
      else
        []
      end
    end
  end
end
