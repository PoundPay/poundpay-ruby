require 'uri'

require 'poundpay/resource'

class PaymentException < Exception
end

class PaymentAuthorizeException < PaymentException
end

class PaymentEscrowException < PaymentException
end

class PaymentReleaseException < PaymentException
end

class PaymentCancelException < PaymentException
end

class ChargePermissionException < Exception
end

class ChargePermissionDeactivateException < ChargePermissionException
end

module Poundpay
  class Developer < Resource
    def self.me
      find(self.user)
    end

    def save
      validate_url callback_url
      validate_url charge_permission_callback_url
      super
    end

    def callback_url=(url)
      validate_url url
      attributes['callback_url'] = url
    end
    
    def charge_permission_callback_url=(url)
      validate_url url
      attributes['charge_permission_callback_url'] = url
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

  class User < Resource
  end
  
  class ChargePermission < Resource
    def deactivate
      states = ['CREATED', 'ACTIVE']
      unless states.include?(state)
        raise ChargePermissionDeactivateException.new "Charge permission state is #{state}.  Only CREATED or ACTIVE charge permissions may be deactivated."
      end
      attributes['state'] = 'INACTIVE'
      save
    end
  end

  class Payment < Resource

    def authorize
      unless status == 'STAGED'
        raise PaymentAuthorizeException.new "Payment status is #{status}.  Only STAGED payments may be AUTHORIZED."
      end
      attributes['status'] = 'ESCROWED'
      save
    end

    def escrow
      unless status == 'AUTHORIZED'
        raise PaymentEscrowException.new "Payment status is #{status}.  Only AUTHORIZED payments may be ESCROWED."
      end
      attributes['status'] = 'ESCROWED'
      save
    end

    def release
      statuses = ['ESCROWED']
      unless statuses.include?(status)
        raise PaymentReleaseException.new "Payment status is #{status}.  Only ESCROWED payments may be RELEASED."
      end
      # Tried setting status with status=, but save still had status == 'ESCROWED'.
      # Setting the status through the attributes, however, does work.
      attributes['status'] = 'RELEASED'
      save
    end

    def cancel
      statuses = ['AUTHORIZED', 'ESCROWED']
      unless statuses.include?(status)
        raise PaymentCancelException.new "Payment status is #{status}.  Only payments with statuses " \
        "#{statuses.join(', ')} may be canceled"
      end

      attributes['status'] = 'CANCELED'
      save
    end
  end
end
