require 'poundpay/resource'
require 'poundpay/elements'
require 'poundpay/callback'

module Poundpay
  WWW_URL = "https://www.poundpay.com"
  API_URL = "https://api.poundpay.com"
  API_VERSION = "silver"

  class << self
    attr_writer :api_version

    def configure(developer_sid, auth_token)
      unless developer_sid.start_with? "DV"
        raise ArgumentError.new "developer_sid should start with 'DV'.  Make sure " \
          "you're using the right developer_sid"
      end

      yield self if block_given?
        
      api_url.sub! /(\/)$/, ""  # Remove trailing backslash
      www_url.sub /(\/)$/, ""
      Resource.site = "#{api_url}/#{api_version}/"
      Resource.user = developer_sid
      Resource.password = auth_token
    end

    def www_url
      @www_url || WWW_URL
    end

    def www_url=(value)
      @www_url = value.sub /(\/)$/, ""  # Remove trailing backslash
    end

    def api_url
      @api_url || API_URL
    end

    def api_url=(value)
      @api_url = value.sub /(\/)$/, ""  # Remove trailing backslash
    end

    def api_version
      @api_version || API_VERSION
    end
  end
end