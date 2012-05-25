require 'spec_helper'

describe NoIntegrity do
  
  context "An object with NoIntegrity" do

    before(:each) do
      @arbs = MrArbitrary.new
    end
    after(:each) do
      @arbs = nil
    end

    it "should know where the attributes are being stored" do
      @arbs.class.no_attr_store.should be_an_instance_of Symbol
    end

    it "should be able to list the attributes it is familiar with" do
      @arbs.no_attributes.should be_an_instance_of Hash
    end

    it "should be able to retrieve attributes from the store" do
      @arbs.hair.should == 'brown'
    end

    it "should be able to have an attribute assigned" do
      @arbs.hair = "black"
      @arbs.hair.should == 'black'
    end

    it "should be able to mass assign attributes" do
      @arbs.update_no_attributes( :hair => 'blonde' )
      @arbs.hair.should == 'blonde'
    end

    it "should coerce boolean types" do
      @arbs.friendly = 1
      @arbs.should be_friendly
      @arbs.friendly.should == true
    end

    it "should coerce interger types" do
      @arbs.age = "25"
      @arbs.age.should == 25
    end

    it "should allow arbitrary types" do
      @arbs.misc = ['junk']
      @arbs.misc.should == ['junk']
    end

    it "should allow for arrays of arbitary types" do
      @arbs.no_attributes.keys.should include(:cheese)
      @arbs.no_attributes.keys.should include(:ham)
      @arbs.no_attributes.keys.should include(:balogne)
    end

    it "should allow for hashes of types" do
      @arbs.no_attributes.keys.should include(:height)
      @arbs.no_attributes.keys.should include(:eyes)
      @arbs.no_attributes.keys.should include(:friendly)
    end

    it "should coerce types on mass assignment" do
      @arbs.update_no_attributes(:age => "22")
      @arbs.age.should == 22
    end

    it "should coerce booleans from numbers" do
      @arbs.friendly = "0"
      @arbs.should_not be_friendly
      @arbs.friendly = "1"
      @arbs.should be_friendly
    end

    it "should coerce booleans from strings" do
      @arbs.friendly = "false"
      @arbs.should_not be_friendly
      @arbs.friendly = "true"
      @arbs.should be_friendly
    end

    it "should not allow mass assignment of attributes if they are not in a hash" do
      lambda { @arbs.update_no_attributes("monkey") }.should raise_exception("Type mismatch: I received a String when I was expecting a Hash.")
    end

    it "should return nil for every attribute if the store is not a hash" do
      @arbs.some_random_hash = nil
      @arbs.hair.should be_nil
    end

    it "should set the store to a hash when setting an attribute" do
      @arbs.some_random_hash = "POTATO"
      @arbs.eyes = 'red'
      @arbs.eyes.should == 'red'
    end

    it "should return an empty hash if there are no defined attributes" do
      @arbs.no_attributes.should be_an_instance_of(Hash)
    end

  end
  
end