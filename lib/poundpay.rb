require 'poundpay/resource'
require 'poundpay/elements'
require 'poundpay/callback'
require 'poundpay/rails'


module Poundpay
  WWW_URL = "https://www.poundpay.com"
  API_URL = "https://api.poundpay.com"
  API_VERSION = "silver"

  class << self
    attr_writer :api_version
    attr_accessor :callback_url

    def configure(developer_sid, auth_token)
      warn "warning: Poundpay is already configured" if configured?
      raise ArgumentError.new "developer_sid is required" unless developer_sid
      raise ArgumentError.new "auth_token is required" unless auth_token

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
      @configured = true

      # Set callback_url if defined in configuration
      if callback_url
        @me = Developer.me
        @me.callback_url = callback_url
        @me.save!
      end
    end

    def configure_from_hash(config)
      configure(config["developer_sid"], config["auth_token"]) do |c|
        c.www_url = config["www_url"] || WWW_URL
        c.api_url = config["api_url"] || API_URL
        c.api_version = config["api_version"] || API_VERSION
        c.callback_url = config["callback_url"] || nil
      end
    end

    def clear_config!
      @www_url = nil
      @api_url = nil
      @api_version = nil
      @callback_url = nil
      Resource.site = nil
      Resource.user = nil
      Resource.password = nil
      @configured = false
    end

    def configured?
      @configured
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