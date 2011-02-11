require 'cgi'
require 'active_resource'
require 'poundpay/formats'

module Poundpay
  class Resource < ActiveResource::Base
    self.format = Formats::UrlencodedJsonFormat

    class << self
      attr_accessor_with_default(:primary_key, 'sid')

      # Modified default to not use an extension
      def element_path(id, prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{collection_name}/#{URI.escape id.to_s}#{query_string(query_options)}"
      end

      # Modified default to not use an extension
      def new_element_path(prefix_options = {})
        "#{prefix(prefix_options)}#{collection_name}/new"
      end

      # Modified default to not use an extension
      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
      end

      # Handle paginated collections
      def instantiate_collection(collection, prefix_options = {})
        # TODO: Consume pages
        collection = collection[collection_name]
        super(collection, prefix_options)
      end
    end

    # Poundpay accepts urlencoded form parameters
    # Ideally we should override this functionality in the format, but it's not very straightforward to do so
    def encode
      urlencode(@attributes)
    end

    def collection_name
      self.class.collection_name
    end

    protected
      def urlencode(params)
        params.to_a.collect! { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")
      end
  end
end