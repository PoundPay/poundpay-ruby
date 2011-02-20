require 'uri'

require 'poundpay/resource'

class PaymentReleaseException < Exception
end

module Poundpay
  class Developer < Resource
    def self.me
      find(self.user)
    end

    def save
      validate_url callback_url
      super
    end

    def callback_url=(url)
      validate_url url
      attributes['callback_url'] = url
    end

    protected
      def validate_url(url)
        begin
          URI.parse(url) unless url == nil or url == ''
        rescue URI::InvalidURIError
          raise URI::InvalidURIError.new "Invalid URL format: #{url}"
        end
      end
  end

  class Payment < Resource
    def release
      unless status == 'ESCROWED'
        raise PaymentReleaseException.new "Payment status is #{status}.  Only ESCROWED payments may be released"
      end
      # Tried setting status with status=, but save still had status == 'ESCROWED'.
      # Setting the status through the attributes, however, does work.
      attributes['status'] = 'RELEASED'
      save
    end
  end
end