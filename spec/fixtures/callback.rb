module Poundpay
  module CallbackFixture
    def valid_callback
      {
        :url => "http://awesomemarketplace.com/poundpay/callback",
        :params => { "first" => "hello", "second" => "world" },
        :signature => "gsdhVc5rnDSuDt6MX0wm6TrBVng=",
      }
    end
  end
end