require 'poundpay/resource'

module Poundpay
  API_URL = "https://api.poundpay.com"
  VERSION = "silver"

  class << self
    def configure(sid, token, api_url=API_URL, version=VERSION)
      Resource.site = "#{api_url}/#{version}/"
      Resource.user = sid
      Resource.password = token
    end
  end

  class Developer < Resource
    class << self
      def me
        find(self.user)
      end
    end
  end

  class Payment < Resource
    def release
      self.status = 'RELEASED'
      self.save
    end
  end
end