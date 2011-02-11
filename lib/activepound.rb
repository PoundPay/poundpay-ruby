require 'cgi'

require 'active_resource'
require 'active_resource/formats'


module ActiveResource
  module Formats
    module UrlencodedJsonFormat
      extend self

      def extension
        "json"
      end

      def mime_type
        "application/x-www-form-urlencoded"
      end

      def decode(json)
        ActiveSupport::JSON.decode(json)
      end
    end
  end
end


module Poundpay
  class PoundpayResource < ActiveResource::Base
    self.site = "http://localhost:8000/silver/"
    self.user = "DV8539761e250011e0a81d1231400042c7"
    self.password = "5d291d63059f5c2fe8d144820a847982a9fba7004a1009a35ed7a5fdf1f67960"
    self.format = ActiveResource::Formats::UrlencodedJsonFormat

    class << self
      attr_accessor_with_default(:primary_key, 'sid')

      def element_path(id, prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{collection_name}/#{URI.escape id.to_s}#{query_string(query_options)}"
      end

      def new_element_path(prefix_options = {})
        "#{prefix(prefix_options)}#{collection_name}/new"
      end

      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
      end

      def instantiate_collection(collection, prefix_options = {})
        # TODO: Consume pages
        collection = collection[collection_name]
        super(collection, prefix_options)
      end
    end

    def encode
      @attributes.to_a.collect { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")
    end

    def collection_name
      self.class.collection_name
    end
  end


  class Developer < PoundpayResource
    class << self
      def me
        find(self.user)
      end
    end
  end


  class Payment < PoundpayResource
    def release
      self.status = 'RELEASED'
      self.save
    end
  end
end