class Fixnum
  def exactly( atom )
    Rrrex::NumberMatch.new atom, self, self
  end

  def or_more( atom, opts={} )
    Rrrex::NumberMatch.new atom, self, nil, opts
  end

  def or_less( atom, opts={} )
    Rrrex::NumberMatch.new atom, nil, self, opts
  end
end
