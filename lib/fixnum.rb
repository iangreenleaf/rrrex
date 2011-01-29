class Fixnum
  def exactly( atom )
    TRegexp::NumberMatch.new atom, self, self
  end

  def or_more( atom )
    TRegexp::NumberMatch.new atom, self, nil
  end

  def or_less( atom )
    TRegexp::NumberMatch.new atom, nil, self
  end
end
