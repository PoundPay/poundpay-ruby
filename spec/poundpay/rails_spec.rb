require 'poundpay'

describe Poundpay do
  after (:each) do
    Poundpay.clear_config!
  end

  it "should automatically load config if exists" do
    module Rails
      class << self
        def root
          Pathname(File.expand_path("../../fixtures", __FILE__))
        end

        def env
          "development"
        end
      end
    end
    
    Poundpay.configured?.should be_false
    load File.expand_path("../../../lib/poundpay/rails.rb", __FILE__)
    Poundpay.configured?.should be_true
    Poundpay::Resource.password.should == "development_auth_token"
  end

  it "should not do anything if config does not exist" do
    module Rails
      class << self
        def root
          Pathname(File.expand_path("wrong_directory", __FILE__))
        end

        def env
          "development"
        end
      end
    end
    
    Poundpay.configured?.should be_false
    load File.expand_path("../../../lib/poundpay/rails.rb", __FILE__)
    Poundpay.configured?.should be_false
    Poundpay::Resource.password.should == nil
  end

end