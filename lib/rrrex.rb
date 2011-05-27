require 'rrrex/core_ext'
module Rrrex
  def self.to_s &block
    match = Match.convert Rrrex::DslContext.module_exec &block
    match.to_regexp_string
  end
end
