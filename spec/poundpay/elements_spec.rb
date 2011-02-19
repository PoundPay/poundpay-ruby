require 'poundpay'
require 'poundpay/elements'
require 'fixtures/payments'
require 'fixtures/developers'

include Poundpay

describe Developer do
  include DeveloperFixture

  before (:all) do
    Poundpay.configure(
      "DV0383d447360511e0bbac00264a09ff3c",
      "c31155b9f944d7aed204bdb2a253fef13b4fdcc6ae1540200449cc4526b2381a")
  end

  after (:all) do
    Poundpay.clear_config!
  end

  describe "#me" do
    it "should return the developer's information" do
      Developer.should_receive(:find).with(Developer.user).and_return(Developer.new developer_attributes)
      @developer = Developer.me
    end
  end
end

describe Payment do
  include PaymentFixture

  before (:all) do
    Poundpay.configure(
      "DV0383d447360511e0bbac00264a09ff3c",
      "c31155b9f944d7aed204bdb2a253fef13b4fdcc6ae1540200449cc4526b2381a")
  end

  after (:all) do
    Poundpay.clear_config!
  end

  describe "#release" do
    it "should not be able to release a STAGED payment" do
      @staged_payment = Payment.new staged_payment_attributes
      expect {@staged_payment.release}.to raise_error(PaymentReleaseException)
    end

    it "should release an ESCROWED payment" do
      @escrowed_payment = Payment.new escrowed_payment_attributes
      @escrowed_payment.should_receive(:save).and_return(Payment.new released_payment_attributes)

      @escrowed_payment.release
      @escrowed_payment.status.should == 'RELEASED'
    end
  end
end