require 'cgi'
require 'active_resource'
require 'poundpay/formats'

module Poundpay
  class Resource < ActiveResource::Base
    self.format = Formats::UrlencodedJsonFormat

    class << self
      attr_accessor :primary_key
      
      def primary_key
        @primary_key ||= 'sid'
      end

      # Modified default to not use an extension
      def element_path(id, prefix_options = {}, query_options = nil)
        path = super(id, prefix_options, query_options)
        remove_extension(path)
      end

      # Modified default to not use an extension
      def new_element_path(prefix_options = {})
        path = super(prefix_options)
        remove_extension(path)
      end

      # Modified default to not use an extension
      def collection_path(prefix_options = {}, query_options = nil)
        path = super(prefix_options, query_options)
        remove_extension(path)
      end

      # Handle paginated collections
      def instantiate_collection(collection, prefix_options = {})
        # TODO: Consume pages
        collection = collection[collection_name]
        super(collection, prefix_options)
      end

      protected
        def remove_extension(path)
          path.sub /(\.#{format.extension})$/, ""
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