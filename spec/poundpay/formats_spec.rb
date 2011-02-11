require 'active_resource/formats'
require 'poundpay/formats'
include Poundpay

describe Formats::UrlencodedJsonFormat do
  describe "#mime_type" do
    it "should have a content type for a urlencoded form" do
      Formats::UrlencodedJsonFormat.mime_type.should == "application/x-www-form-urlencoded"
    end

    it "should extend from active_resource JsonFormat" do
      Formats::UrlencodedJsonFormat.should be_a ActiveResource::Formats::JsonFormat
    end
  end
end