class Fixnum
  def exactly( atom )
    Rrrex::NumberMatch.new atom, self, self
  end

  def or_more( atom )
    Rrrex::NumberMatch.new atom, self, nil
  end

  def or_less( atom )
    Rrrex::NumberMatch.new atom, nil, self
  end
end
