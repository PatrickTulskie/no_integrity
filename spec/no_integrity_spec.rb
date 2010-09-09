require 'spec_helper'

context "An object with NoIntegrity" do
  
  before(:each) do
    @arbs = MrArbitrary.new
  end
  after(:each) do
    @arbs = nil
  end
  
  it "should know where the attributes are being stored" do
    @arbs.class.attr_store.should be_an_instance_of Symbol
  end
  
  it "should be able to list the attributes it is familiar with" do
    @arbs.no_attributes.should be_an_instance_of Array
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
  
  it "should not allow mass assignment of attributes if they are not in a hash" do
    lambda { @arbs.update_no_attributes("monkey") }.should raise_exception("Type mismatch: I received a String when I was expecting a Hash.")
  end

end