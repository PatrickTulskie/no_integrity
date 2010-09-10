require 'rubygems'
require 'spec'
require 'lib/no_integrity'

class MrArbitrary
  include NoIntegrity
  
  attr_accessor :some_random_hash
  
  no_attr_store :some_random_hash
  no_attributes :hair, :eyes, :height
  
  def initialize(*args)
    @some_random_hash ||= { :hair => 'brown' }
  end
  
end