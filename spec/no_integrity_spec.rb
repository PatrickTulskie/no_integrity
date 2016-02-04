require 'spec_helper'

describe NoIntegrity do

  context "class methods" do

    it "stores mappings of the various types of attributes" do
      expect(MrArbitrary.no_attribute_mappings[:hair][:type]).to eq('String')
      expect(MrArbitrary.no_attribute_mappings[:friendly][:type]).to eq('Boolean')
    end

  end

  context "An object with NoIntegrity" do

    let(:arbs) { MrArbitrary.new }

    context "that has been initialized" do
      let(:arbs) { MrArbitrary.new({ hair: 'brown' }) }

      it "should be able to get all of the attributes" do
        expect(arbs.__no_attr_store).to be_an_instance_of Hash
      end

      it "should be able to retrieve attributes from the store" do
        expect(arbs.hair).to eq('brown')
      end
    end

    it "should know where the attributes are being stored" do
      expect(arbs.class.no_attr_store).to be_an_instance_of Symbol
    end

    it "should be able to list the attributes it is familiar with" do
      expect(arbs.no_attributes).to be_an_instance_of Hash
    end

    it "should be able to have an attribute assigned" do
      arbs.hair = "black"
      expect(arbs.hair).to eq('black')
    end

    it "should be able to mass assign attributes" do
      arbs.update_no_attributes( :hair => 'blonde' )
      expect(arbs.hair).to eq('blonde')
    end

    it "should coerce boolean types" do
      arbs.friendly = 1
      expect(arbs).to be_friendly
      expect(arbs.friendly).to eq(true)
    end

    it "should coerce interger types" do
      arbs.age = "25"
      expect(arbs.age).to eq(25)
    end

    it "should allow arbitrary types" do
      arbs.misc = ['junk']
      expect(arbs.misc).to eq(['junk'])
    end

    it "should allow for arrays of arbitary types" do
      expect(arbs.no_attributes.keys).to include(:cheese)
      expect(arbs.no_attributes.keys).to include(:ham)
      expect(arbs.no_attributes.keys).to include(:balogne)
    end

    it "should allow for hashes of types" do
      expect(arbs.no_attributes.keys).to include(:height)
      expect(arbs.no_attributes.keys).to include(:eyes)
      expect(arbs.no_attributes.keys).to include(:friendly)
    end

    it "should coerce types on mass assignment" do
      arbs.update_no_attributes(:age => "22")
      expect(arbs.age).to eq(22)
    end

    it "should coerce booleans from numbers" do
      arbs.friendly = "0"
      expect(arbs).not_to be_friendly
      arbs.friendly = "1"
      expect(arbs).to be_friendly
    end

    it "should coerce booleans from strings" do
      arbs.friendly = "false"
      expect(arbs).not_to be_friendly
      arbs.friendly = "true"
      expect(arbs).to be_friendly
    end

    it "should not allow mass assignment of attributes if they are not in a hash" do
      expect { arbs.update_no_attributes("monkey") }.to raise_exception("Type mismatch: I received a String when I was expecting a Hash.")
    end

    it "should return nil for every attribute if the store is not a hash" do
      arbs.some_random_hash = nil
      expect(arbs.hair).to be_nil
    end

    it "should set the store to a hash when setting an attribute" do
      arbs.some_random_hash = "POTATO"
      arbs.eyes = 'red'
      expect(arbs.eyes).to eq('red')
    end

    it "should return an empty hash if there are no defined attributes" do
      expect(arbs.no_attributes).to be_an_instance_of(Hash)
    end

    it "returns the default value" do
      expect(arbs.friendly).to eq true
      expect(arbs.cheese).to eq 'Cheddar'
    end

  end

end