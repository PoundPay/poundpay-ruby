require 'poundpay'

describe ActiveResource::ConnectionError do
  describe ".data" do
    it "should return the parsed response body" do
      response = double('response')
      response.stub(:body).and_return('{"error_message":"You screwed up!"}')
      ActiveResource::ConnectionError.new(response).data.should == {error_message: "You screwed up!"}
    end
  end
end
