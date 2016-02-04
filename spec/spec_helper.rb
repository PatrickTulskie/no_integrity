require 'rubygems'
require 'rspec'
require 'byebug'
require './lib/no_integrity'

class MrArbitrary
  include NoIntegrity

  attr_accessor :some_random_hash

  no_attr_store :some_random_hash

  no_attribute :misc
  no_attribute :hair, type: 'String'
  no_attribute :age, type: 'Integer'
  no_attribute :height, type: 'String'
  no_attribute :eyes, type: 'String'
  no_attribute :friendly, type: 'Boolean', default: true
  no_attribute :cheese, default: "Cheddar"
  no_attribute :ham
  no_attribute :balogne

  def initialize(attributes = nil)
    @some_random_hash = attributes
  end

end