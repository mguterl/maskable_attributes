require 'spec/spec_helper'

class MaskedPerson < Struct.new(:name, :email, :phone)
  include MaskableAttributes

  masked_attributes :email, :phone
end

class CustomMaskedPerson < Struct.new(:name, :email, :phone)
  include MaskableAttributes

  masked_attributes :email, :phone, :with => "----------"
end

class CustomLambdaMaskedPerson < Struct.new(:name, :email, :phone)
  include MaskableAttributes

  masked_attributes :email, :phone, :with => lambda { |value| "*" * value.size }
end

class PredefinedStrategyMaskedPerson < Struct.new(:name, :email, :phone)
  include MaskableAttributes

  masked_attributes :email, :phone, :with => :stars
end

describe MaskableAttributes do

  it 'should have a default masking' do
    MaskableAttributes.default_masking.should == "************"
  end

  it 'should allow you to set default masking' do
    MaskableAttributes.default_masking = "#(*$(W*$*(W$"
    MaskableAttributes.default_masking.should == "#(*$(W*$*(W$"
    MaskableAttributes.default_masking = MaskableAttributes::DEFAULT_MASKING
  end

  describe "with default masking" do

    before do
      @person = MaskedPerson.new("Michael", "michael@recruitmilitary.com")
    end

    it 'should mask the specified attributes' do
      @person.email.should == MaskableAttributes.default_masking
      @person.phone.should == MaskableAttributes.default_masking
    end

    it 'should not affect other attributes' do
      @person.name.should == "Michael"
    end

  end

  describe "with custom masking" do

    before do
      @person = CustomMaskedPerson.new("Michael", "michael@recruitmilitary.com")
    end

    it 'should mask the specified attributes' do
      @person.email.should == "----------"
      @person.phone.should == "----------"
    end

    it 'should not affect other attributes' do
      @person.name.should == "Michael"
    end

  end

  describe "with custom lambda masking" do

    before do
      @person = CustomLambdaMaskedPerson.new("Michael", "michael@recruitmilitary.com")
    end

    it 'should mask the specified attributes' do
      @person.email.should == "*" * @person.email.size
    end

    it 'should return nil if the masked attribute is nil' do
      @person.phone.should == nil
    end

    it 'should not affect other attributes' do
      @person.name.should == "Michael"
    end

  end

  describe "with symbol representing the strategy" do

    before do
      @person = PredefinedStrategyMaskedPerson.new("Michael", "michael@recruitmilitary.com")
    end

    it 'should mask the specified attributes' do
      @person.email.should == "*" * @person.email.size
    end

    it 'should return nil if the masked attribute is nil' do
      @person.phone.should == nil
    end

    it 'should not affect other attributes' do
      @person.name.should == "Michael"
    end

  end

end
