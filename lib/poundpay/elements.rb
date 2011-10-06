require 'uri'

require 'poundpay/resource'

class PaymentException < Exception
end

class PaymentEscrowException < PaymentException
end

class PaymentPartiallyReleaseException < PaymentException
end

class PaymentReleaseException < PaymentException
end

class PaymentCancelException < PaymentException
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
    def escrow
      unless status == 'AUTHORIZED'
        raise PaymentEscrowException.new "Payment status is #{status}.  Only AUTHORIZED payments may be released"
      end
      attributes['status'] = 'ESCROWED'
      save
    end

    def partially_release(amount_to_release)
      statuses = ['ESCROWED', 'PARTIALLY_RELEASED']
      unless statuses.include?(status)
        raise PaymentPartiallyReleaseException.new "Payment status is #{status}.  Only ESCROWED or PARTIALLY_RELEASED payments may be released"
      end
      # Tried setting status with status=, but save still had status == 'ESCROWED'.
      # Setting the status through the attributes, however, does work.
      attributes['status'] = 'PARTIALLY_RELEASED'
      attributes['amount_to_release'] = amount_to_release
      save
      attributes.delete('amount_to_release')
    end

    def release
      statuses = ['ESCROWED', 'PARTIALLY_RELEASED']
      unless statuses.include?(status)
        raise PaymentReleaseException.new "Payment status is #{status}.  Only ESCROWED or PARTIALLY_RELASED payments may be released"
      end
      # Tried setting status with status=, but save still had status == 'ESCROWED'.
      # Setting the status through the attributes, however, does work.
      attributes['status'] = 'RELEASED'
      save
    end

    def cancel
      statuses = ['ESCROWED', 'PARTIALLY_RELEASED']
      unless statuses.include?(status)
        raise PaymentCancelException.new "Payment status is #{status}.  Only ESCROWED or PARTIALLY_RELEASED payments may be canceled"
      end

      attributes['status'] = 'CANCELED'
      save
    end
  end
end
