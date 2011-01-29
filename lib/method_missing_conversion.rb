module MethodMissingConversion
  def self.included receiver
    receiver.extend ClassMethods
  end

  module ClassMethods
    def sends_methods_to methods, convert_to
      define_method :method_missing_helper do |name, args, block|
        if methods.include? name
          convert_to.new( self ).send name, *args
        else
          method_missing_without_regexp name, *args, &block
        end
      end
      alias_method :method_missing_without_regexp, :method_missing
      alias_method :method_missing, :method_missing_with_regexp
    end
  end

  def method_missing_with_regexp( name, *args, &block )
    method_missing_helper name, args, block
  end
end
