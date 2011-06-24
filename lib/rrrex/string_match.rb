require 'rrrex/match'
require 'rrrex/single_atom_match'
module Rrrex
  class StringMatch < Regin::Expression
    include Match
    def initialize( a )
      super Regexp.escape( a )
    end

    def to_regexp_string
      to_s
    end
  end
end
