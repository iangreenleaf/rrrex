require 'tregexp/string_match'
module TRegexp
  class UnescapedStringMatch < StringMatch
    def to_regexp_string
      wrap atom
    end
  end
end
