module TRegexp
  class MatchData
    def initialize( atom, match_data )
      @atom = atom
      @match_data = match_data
    end

    def []( i )
      if i.is_a? Symbol
        named_groups[ i ]
      else
        @match_data[ i ]
      end
    end

    def named_groups
      @named_groups ||=
        begin
          result = {}
          names = @atom.group_names
          names.each_index do |i|
            result[ names[ i ] ] = @match_data[ i + 1 ]
          end
          result
        end
    end

    def to_a
      @match_data.to_a
    end

    def method_missing( name, *args )
      @match_data.send name, *args
    end
  end
end
