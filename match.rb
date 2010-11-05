module TRegex
  class Match

    def initialize(pattern)
      @pattern = pattern
    end

    def to_regexp
      @pattern
    end

  end
end
