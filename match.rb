class String
  def plus_with_regexp( str2 )
    if str2.kind_of? TRegex::Match
      TRegex::Match.new( self ) + str2
    else
      self.plus_without_regexp str2
    end
  end
  alias_method :plus_without_regexp, :+
  alias_method :+, :plus_with_regexp

  def method_missing_with_regexp( name, *args, &block )
    if [ :or, :and ].include? name
      args.collect! do |a|
        a.kind_of?( TRegex::Match ) ? a : TRegex::Match.new( a )
      end
      TRegex::Match.new( self ).send name, *args
    else
      method_missing_without_regexp name, *args, &block
    end
  end
  alias_method :method_missing_without_regexp, :method_missing
  alias_method :method_missing, :method_missing_with_regexp

  def rmatch?( &block )
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
