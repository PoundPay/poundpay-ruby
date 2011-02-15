require 'base64'
require 'openssl'

module Poundpay
  def self.verified_callback?(signature, params = {})
    # Make a request to Poundpay for callback_url once
    @callback_url = Developer.me.callback_url unless @callback_url
    signature == calculate_signature(@callback_url, params)
  end

  protected
    def self.calculate_signature(url, params)
      data = url
      @token = Resource.password
      params.sort.each do |name, value|
        data += "#{name}#{value}"
      end
      digest = OpenSSL::Digest::Digest.new('sha1')
      Base64.encode64(OpenSSL::HMAC.digest(digest, @token, data)).strip
    end
end


module ActionController
  class Base
    protected
      def verify_poundpay_callback
        signature = request.headers['HTTP_X_POUNDPAY_SIGNATURE']
        Poundpay.verified_callback?(signature, request.POST) || handle_unverified_callback
      end

      def handle_unverified_callback
        raise RoutingError.new('Not Found')
      end
  end
end