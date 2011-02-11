require 'poundpay/resource'
include Poundpay

class FakeElement < Resource
  self.site = "http://api.example.com/version/"
end

describe Resource do
  describe "#primary_key" do
    it "should default to 'sid'" do
      Resource.primary_key.should == "sid"
    end
  end

  describe "#element_path" do
    it "should not add a extension to the element_path" do
      FakeElement.element_path(1).should == "/version/fake_elements/1"
      FakeElement.element_path("FExxxx").should == "/version/fake_elements/FExxxx"
    end
  end

  describe "#new_element_path" do
    it "should not add a extension to the new_element_path" do
      FakeElement.new_element_path.should == "/version/fake_elements/new"
    end
  end

  describe "#collection_path" do
    it "should not add a extension to the collection_path" do
      FakeElement.collection_path.should == "/version/fake_elements"
    end
  end
end