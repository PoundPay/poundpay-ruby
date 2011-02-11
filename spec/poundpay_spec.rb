require 'poundpay'

describe Poundpay do
  describe "#configure" do
    it "should be configured with default api_url and version" do
      developer_sid = "DV0383d447360511e0bbac00264a09ff3c"
      auth_token = "c31155b9f944d7aed204bdb2a253fef13b4fdcc6ae1540200449cc4526b2381a"
      Poundpay.configure(developer_sid, auth_token)
      Poundpay::Resource.user.should == developer_sid
      Poundpay::Resource.password.should == auth_token
      Poundpay::Resource.site.to_s.should == "https://api.poundpay.com/silver/"
    end
  end
end