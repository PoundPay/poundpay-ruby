require 'active_resource/exceptions'

# monkey patch the base AR exception class to provide access to the response body in a structured format.
module ActiveResource
  class ConnectionError
    def data
      @data ||= ActiveSupport::JSON.decode(self.response.body).symbolize_keys rescue {}
    end
  end
end
