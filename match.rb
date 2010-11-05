class String
  def rmatch( &block )
    pattern = TRegex.module_exec &block
    TRegex::Match.new( pattern ).match self
  end
end

module TRegex

  def self.s(str)
    Match.new str
  end

  class Match

    def initialize(pattern)
      @pattern = pattern
    end

    def to_regexp_string
      if @pattern.is_a? Match
        @pattern.to_regexp_string
      else
        @pattern
      end
    end

    def match(str)
      Regexp.new( to_regexp_string ).match str
    end

    def or(pattern)
      OrMatch.new self, pattern
    end

    def any
      AnyMatch.new self
    end

    def +(p)
      ConcatMatch.new self, p
    end

  end

  class OrMatch < Match
    def initialize(p1, p2)
      @patterns = [p1, p2]
    end

    def to_regexp_string
      @patterns.map {|p| p.to_regexp_string }.join "|"
    end
  end

  class ConcatMatch < Match
    def initialize(p1, p2)
      @patterns = [p1, p2]
    end

    def to_regexp_string
      @patterns.map {|p| p.to_regexp_string }.join ""
    end
  end

  class AnyMatch < Match
    def to_regexp_string
      @pattern.to_regexp_string + "*"
    end
  end
end
