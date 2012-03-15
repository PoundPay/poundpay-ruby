require 'poundpay'

describe Poundpay do
  module Rails
    def self.root
      Pathname(File.expand_path("../../fixtures", __FILE__))
    end

    def self.env
      "development"
    end
  end

  load File.expand_path("../../../lib/poundpay/rails.rb", __FILE__)

  before do
    Poundpay.should_not be_configured
  end

  after do
    Poundpay.clear_config!
  end

  it "should automatically load config if exists" do
    Poundpay.configure_from_yaml "poundpay.yml"

    Poundpay.should be_configured
    Poundpay::Resource.password.should == "development_auth_token"
  end

  it "configures using ERB files to allow ENV variables" do
    Poundpay.configure_from_yaml "poundpay.yml.erb"

    Poundpay.should be_configured
    Poundpay::Resource.password.should == "erb_development_auth_token"
  end

  it "should raise argument error and configure nothing if config does not exist" do
    expect {
      Poundpay.configure_from_yaml "wrong_path"
    }.to raise_error(ArgumentError, /wrong_path/)

    Poundpay.should_not be_configured
    Poundpay::Resource.password.should_not be
  end
end
