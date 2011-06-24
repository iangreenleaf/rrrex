require 'rrrex/string_match'
module Rrrex
  class UnescapedStringMatch < Regin::Expression
    include Match
    def to_regexp_string
      wrap atom
    end
  end
end
