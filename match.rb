module TRegex
  class Match

    def initialize(pattern)
      @pattern = pattern
    end

    def to_regexp_string
      @pattern
    end

    def match(str)
      Regexp.new( to_regexp_string ).match str
    end

  end
end
