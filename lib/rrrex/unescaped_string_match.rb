require 'rrrex/string_match'
module Rrrex
  class UnescapedStringMatch < StringMatch
    def to_regexp_string
      wrap atom
    end
  end
end
