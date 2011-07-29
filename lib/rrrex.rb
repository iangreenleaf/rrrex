require 'rrrex/core_ext'
module Rrrex
  def self.to_s &block
    self.build( &block ).to_regexp_string
  end

  def self.build &block
    Match.convert Rrrex::DslContext.module_exec &block
  end
end
