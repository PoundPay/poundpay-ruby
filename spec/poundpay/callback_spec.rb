require 'poundpay'
require 'poundpay/callback'
require 'fixtures/callback'

describe Poundpay do
  include Poundpay
  include Poundpay::CallbackFixture

  before (:all) do
    Poundpay.configure(
      "DV0383d447360511e0bbac00264a09ff3c",
      "c31155b9f944d7aed204bdb2a253fef13b4fdcc6ae1540200449cc4526b2381a")
  end

  after (:all) do
    Poundpay.clear_config!
  end

  describe ".calculate_signature" do
    it "should calculate the correct signature using HMAC-SHA1" do
      signature = Poundpay.calculate_signature(valid_callback[:url], valid_callback[:params])
      signature.should == valid_callback[:signature]
    end
  end

  describe ".verified_callback?" do
    before(:all) do
      @developer = Poundpay::Developer.new :callback_url => valid_callback[:url]
      Poundpay::Developer.should_receive(:me).and_return(@developer)
    end

    it "should validate a valid callback and only make request for callback_url once" do
      Poundpay.verified_callback?(valid_callback[:signature], valid_callback[:params]).should == true
      Poundpay.verified_callback?(valid_callback[:signature], valid_callback[:params]).should == true
    end

    it "should invalidate an invalid signature" do
      Poundpay.verified_callback?("invalid signature", valid_callback[:params]).should == false
    end
  end
end