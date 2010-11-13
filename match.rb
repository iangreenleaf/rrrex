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

    def initialize(atom)
      @atom = atom
    end

    def to_regexp_string(s=nil)
      if s.nil?
        s = @atom
        s = Regexp.escape @atom if ! s.is_a? Match
      end
      s = s.to_regexp_string if s.is_a? Match
      "(?:#{s})"
    end

    def match(str)
      Regexp.new( to_regexp_string ).match str
    end

    def or(atom)
      OrMatch.new self, atom
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
      @atoms = [p1, p2]
    end

    def to_regexp_string
      super @atoms.map {|p| p.to_regexp_string }.join "|"
    end
  end

  class ConcatMatch < Match
    def initialize(p1, p2)
      @atoms = [p1, p2]
    end

    def to_regexp_string
      super @atoms.map {|p| p.to_regexp_string }.join ""
    end
  end

  class AnyMatch < Match
    def to_regexp_string
      super @atom.to_regexp_string + "*"
    end
  end
end
