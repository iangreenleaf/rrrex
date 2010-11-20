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

  def self.any r
    AnyMatch.new r
  end

  class Match

    attr_reader :atom

    def initialize( a )
      @atom = a
    end

    def atom=( a )
      @atom = a.kind_of?( Match ) ? a : Match.new( a )
    end

    def to_regexp_string(s=nil)
      if s.nil?
        s = atom
        s = Regexp.escape s if ! s.is_a? Match
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

    def +(p)
      ConcatMatch.new self, p
    end

  end

  class CompositeMatch < Match
    def initialize(*args)
      @atoms = args.collect do |a|
        a.kind_of?( Match ) ? a : Match.new( a )
      end
    end
  end

  class OrMatch < CompositeMatch
    def to_regexp_string
      super @atoms.map {|p| p.to_regexp_string }.join "|"
    end
  end

  class ConcatMatch < CompositeMatch
    def to_regexp_string
      super @atoms.map {|p| p.to_regexp_string }.join ""
    end
  end

  class AnyMatch < Match
    def initialize( a )
      self.atom = a
    end
    def to_regexp_string
      super atom.to_regexp_string + "*"
    end
  end
end
