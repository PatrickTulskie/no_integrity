require 'rubygems'
require 'rspec'
require './lib/no_integrity'

class MrArbitrary
  include NoIntegrity

  attr_accessor :some_random_hash

  no_attr_store :some_random_hash
  no_attribute :misc
  no_attribute :hair => 'String'
  no_attribute :age => 'Integer'
  no_attribute :height => 'String', :eyes => 'String', :friendly => 'Boolean'
  no_attribute [:cheese, :ham, :balogne]

  def initialize(*args)
    @some_random_hash ||= { :hair => 'brown' }
  end

end