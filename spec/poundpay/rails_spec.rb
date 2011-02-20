require 'poundpay'

describe Poundpay do
  module Rails
  end

  after (:each) do
    Poundpay.clear_config!
  end

  it "should automatically load config if exists" do
    load File.expand_path("../../../lib/poundpay/rails.rb", __FILE__)

    module Rails
      def self.root
        Pathname(File.expand_path("../../fixtures", __FILE__))
      end

      def self.env
        "development"
      end
    end

    Poundpay.configured?.should be_false
    Poundpay.configure_from_yaml "config/poundpay.yml"
    Poundpay.configured?.should be_true
    Poundpay::Resource.password.should == "development_auth_token"
  end

  it "should not do anything if config does not exist" do
    load File.expand_path("../../../lib/poundpay/rails.rb", __FILE__)

    module Rails
      def self.root
        Pathname(File.expand_path("../../fixtures", __FILE__))
      end

      def self.env
        "development"
      end
    end

    Poundpay.configured?.should be_false
    expect { Poundpay.configure_from_yaml "wrong_path" }.to raise_error(ArgumentError, /wrong_path/)
    Poundpay.configured?.should be_false
    Poundpay::Resource.password.should == nil
  end

end