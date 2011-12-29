require 'poundpay'
require 'poundpay/elements'
require 'fixtures/payments'
require 'fixtures/developers'
require 'fixtures/charge_permissions'

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

  describe "#callback_url=" do
    before (:all) do
      @developer = Developer.new :callback_url => nil
    end

    it "should not allow invalid urls to be assigned" do
      invalid_url = "http://71.212.135.207:3000:payments"  # There's a colon after the port number instead of a backslash
      expect { @developer.callback_url = invalid_url }.to raise_error(URI::InvalidURIError, /format/)
    end

    it "should allow a developer to set their url" do
      valid_url = "http://71.212.135.207:3000/payments"
      @developer.callback_url = valid_url
      @developer.callback_url.should == valid_url
      @developer.callback_url = nil
      @developer.callback_url.should == nil
    end
  end

  describe "#save" do
    it "should not allow saving with an invalid callback_url" do
      Developer.should_not_receive(:create)
      developer = Developer.new :callback_url => 'i am invalid'
      expect { developer.save }.to raise_error(URI::InvalidURIError)
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

  describe "#authorize" do
    it "should not be able to authorize a non CREATED payment" do
      @non_created_payment = Payment.new authorized_payment_attributes
      expect {@non_created_payment.authorize}.to raise_error(PaymentAuthorizeException)
    end

    it "should authorize a CREATED payment" do
      @created_payment = Payment.new created_payment_attributes
      @created_payment.should_receive(:save).and_return(Payment.new authorized_payment_attributes)

      @created_payment.authorize
      @created_payment.state.should == 'AUTHORIZED'
    end
  end

  describe "#escrow" do
    it "should not be able to escrow a CREATED payment" do
      @created_payment = Payment.new created_payment_attributes
      expect {@created_payment.escrow}.to raise_error(PaymentEscrowException)
    end

    it "should escrow an AUTHORIZED payment" do
      @authorized_payment = Payment.new authorized_payment_attributes
      @authorized_payment.should_receive(:save).and_return(Payment.new escrowed_payment_attributes)

      @authorized_payment.escrow
      @authorized_payment.state.should == 'ESCROWED'
    end
  end

  describe "#release" do
    it "should not be able to release a CREATED payment" do
      @created_payment = Payment.new created_payment_attributes
      expect {@created_payment.release}.to raise_error(PaymentReleaseException)
    end

    it "should release an ESCROWED payment" do
      @escrowed_payment = Payment.new escrowed_payment_attributes
      @escrowed_payment.should_receive(:save).and_return(Payment.new released_payment_attributes)

      @escrowed_payment.release
      @escrowed_payment.state.should == 'RELEASED'
    end
  end  

  describe "#cancel" do
    it "should not be able to cancel a RELEASED payment" do
      @released_payment = Payment.new released_payment_attributes
      expect {@released_payment.cancel}.to raise_error(PaymentCancelException)
    end

    it "should cancel an ESCROWED payment" do
      @escrowed_payment = Payment.new escrowed_payment_attributes
      @escrowed_payment.should_receive(:save).and_return(Payment.new canceled_payment_attributes)

      @escrowed_payment.cancel
      @escrowed_payment.state.should == 'CANCELED'
    end

    it "should cancel a CREATED payment" do
      @created_payment = Payment.new created_payment_attributes
      @created_payment.should_receive(:save).and_return(Payment.new canceled_payment_attributes)

      @created_payment.cancel
      @created_payment.state.should == 'CANCELED'
    end
  end
end

describe ChargePermission do
  include ChargePermissionFixture

  before (:all) do
    Poundpay.configure(
      "DV0383d447360511e0bbac00264a09ff3c",
      "c31155b9f944d7aed204bdb2a253fef13b4fdcc6ae1540200449cc4526b2381a")
  end

  after (:all) do
    Poundpay.clear_config!
  end

  describe "#deactivate" do
    it "should not be able to deactivate an INACTIVE charge permission" do
      @inactive_charge_permission = ChargePermission.new inactive_attributes
      expect {@inactive_charge_permission.deactivate}.to raise_error(ChargePermissionDeactivateException)
    end

    it "should deactivate a CREATED charge permission" do
      @created_charge_permission = ChargePermission.new created_attributes
      @created_charge_permission.should_receive(:save).and_return(ChargePermission.new created_attributes)
      @created_charge_permission.deactivate
      @created_charge_permission.state.should == 'INACTIVE'
    end
    
    it "should deactivate an ACTIVE charge permission" do
      @active_charge_permission = ChargePermission.new active_attributes
      @active_charge_permission.should_receive(:save).and_return(ChargePermission.new active_attributes)
      @active_charge_permission.deactivate
      @active_charge_permission.state.should == 'INACTIVE'
    end
  end
end
