require 'poundpay/resource'
include Poundpay

class FakeElement < Resource
  self.site = "http://api.example.com/version/"
end

describe Resource do
  describe "#self.primary_key" do
    it "should default to 'sid'" do
      Resource.primary_key.should == "sid"
    end
  end

  describe "#self.element_path" do
    it "should not add a extension to the element_path" do
      FakeElement.element_path(1).should == "/version/fake_elements/1"
    end
  end

  describe "#self.new_element_path" do
    it "should not add a extension to the new_element_path" do
      FakeElement.new_element_path.should == "/version/fake_elements/new"
    end
  end

  describe "#self.collection_path" do
    it "should not add a extension to the collection_path" do
      FakeElement.collection_path.should == "/version/fake_elements"
    end
  end
  
  describe "#self.custom_method_collection_url" do
    it "should not add a extension to the custom_method_collection_url" do
      FakeElement.custom_method_collection_url("").should == "/version/fake_elements/"
    end
  end

  describe "#self.instantiate_collection" do
    it "should handle paginated responses" do
      collection = {"fake_elements" => [{"sid" => 1}, {"sid" => 2}]}
      fake_elements = FakeElement.instantiate_collection(collection)
      fake_elements.should == [FakeElement.new(:sid => 1), FakeElement.new(:sid => 2)]
    end
  end

  describe "#encode" do
    it "should urlencode the attributes" do
      fake_element = FakeElement.new(:foo => "bar baz")
      fake_element.encode.should == "foo=bar+baz"
    end
    it "should urlencode the attributes wuihtout brackets" do
      fake_element = FakeElement.new(:foo => ["bar", "baz"])
      fake_element.encode.should == "foo=bar&foo=baz"
    end
  end

  describe "#collection_name" do
    it "should get the collection_name" do
      FakeElement.new.collection_name.should == "fake_elements"
    end
  end
end