require 'active_resource/formats/json_format'

module Poundpay
  module Formats
    module UrlencodedJsonFormat
      extend ActiveResource::Formats::JsonFormat
      extend self

      def mime_type
        "application/x-www-form-urlencoded"
      end
    end
  end
end