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

    def self.batch_update(params)
      body = self.put('', {}, self.urlencode(params)).body
      collection = self.format.decode(body)
      return self.instantiate_collection(collection)
    end

    def authorize
      unless state == 'CREATED'
        raise PaymentAuthorizeException.new "Payment state is #{state}.  Only CREATED payments may be AUTHORIZED."
      end
      attributes['state'] = 'AUTHORIZED'
      save
    end

    def escrow
      unless state == 'AUTHORIZED'
        raise PaymentEscrowException.new "Payment state is #{state}.  Only AUTHORIZED payments may be ESCROWED."
      end
      attributes['state'] = 'ESCROWED'
      save
    end

    def release
      states = ['ESCROWED']
      unless states.include?(state)
        raise PaymentReleaseException.new "Payment state is #{state}.  Only ESCROWED payments may be RELEASED."
      end
      # Tried setting state with state=, but save still had state == 'ESCROWED'.
      # Setting the state through the attributes, however, does work.
      attributes['state'] = 'RELEASED'
      save
    end

    def cancel
      states = ['CREATED', 'AUTHORIZED', 'ESCROWED']
      unless states.include?(state)
        raise PaymentCancelException.new "Payment state is #{state}.  Only payments with states " \
        "#{states.join(', ')} may be canceled"
      end

      attributes['state'] = 'CANCELED'
      save
    end
  end
end
