require 'poundpay/resource'

module Poundpay
  API_URL = "https://api.poundpay.com"
  API_VERSION = "silver"

  class << self
    def configure(developer_sid, auth_token, api_url=API_URL, version=API_VERSION)
      unless developer_sid.start_with? "DV"
        raise ArgumentError.new "developer_sid should start with DV.  Make sure " \
          "you're using the right developer_sid"
      end
      Resource.site = "#{api_url}/#{version}/"
      Resource.user = developer_sid
      Resource.password = auth_token
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