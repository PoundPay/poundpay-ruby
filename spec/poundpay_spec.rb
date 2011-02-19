require 'poundpay'

describe Poundpay, ".configure" do
  it "should require developer_sid to start with 'DV'" do
    expect {
      # Pass developer_sid and auth_token in wrong order
      Poundpay.configure(
        "c31155b9f944d7aed204bdb2a253fef13b4fdcc6ae1540200449cc4526b2381a",
        "DV0383d447360511e0bbac00264a09ff3c")
    }.to raise_error(ArgumentError, /DV/)
  end

  it "should be configured with default api_url and api_version" do
    developer_sid = "DV0383d447360511e0bbac00264a09ff3c"
    auth_token = "c31155b9f944d7aed204bdb2a253fef13b4fdcc6ae1540200449cc4526b2381a"
    Poundpay.configure(developer_sid, auth_token)
    Poundpay::Resource.user.should == developer_sid
    Poundpay::Resource.password.should == auth_token
    Poundpay::Resource.site.to_s.should == "https://api.poundpay.com/silver/"
    Poundpay.www_url.should == "https://www.poundpay.com"
    Poundpay.api_url.should == "https://api.poundpay.com"
    Poundpay.api_version.should == "silver"
  end

  it "should accept optional api_url and api_version via block" do
    Poundpay.configure("DV0383d447360511e0bbac00264a09ff3c", "c31155b9f944d7aed204bdb2a253fef13b4fdcc6ae1540200449cc4526b2381a") do |c|
      c.www_url = "https://www-sandbox.poundpay.com"
      c.api_url = "https://api-sandbox.poundpay.com"
      c.api_version = "gold"
    end
    Poundpay::Resource.site.to_s.should == "https://api-sandbox.poundpay.com/gold/"
    Poundpay.www_url.should == "https://www-sandbox.poundpay.com"
    Poundpay.api_url.should == "https://api-sandbox.poundpay.com"
    Poundpay.api_version.should == "gold"
  end

  it "should allow api_url to have a trailing backslash" do
    Poundpay.configure("DV0383d447360511e0bbac00264a09ff3c", "c31155b9f944d7aed204bdb2a253fef13b4fdcc6ae1540200449cc4526b2381a") do |c|
      c.www_url = "https://www-sandbox.poundpay.com/"
      c.api_url = "https://api-sandbox.poundpay.com/"
      c.api_version = "gold"
    end
    Poundpay::Resource.site.to_s.should == "https://api-sandbox.poundpay.com/gold/"
    Poundpay.www_url.should == "https://www-sandbox.poundpay.com"
    Poundpay.api_url.should == "https://api-sandbox.poundpay.com"
    Poundpay.api_version.should == "gold"
  end
end