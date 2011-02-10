# @author PoundPay
module PoundPay
  require 'net/http'
  require 'net/https'
  require 'uri'
  require 'cgi'
  require 'json'

  API_URL = 'https://api.poundpay.com'
  VERSION = 'silver'

  class PoundPayClient
      
    #initialize a poundpay account object
    #
    #@param [String, String] Your PoundPay Acount SID and Auth Token
    #@return [Object] PoundPay account object
    def initialize(sid, token, api_url=API_URL, version=VERSION)
      @sid = sid
      @token = token
      @api_url = api_url
      @version = version
    end
    
    #sends a request and gets a response from the PoundPay REST API
    #
    #@param [String, String, Hash]
    #path, the URL (relative to the endpoint URL, after the /v1
    #method, the HTTP method to use, defaults to POST
    #vars, for POST or PUT, a dict of data to send
    #
    #@return PoundPay response JSON
    #@raises [ArgumentError] Invalid path parameter
    #@raises [NotImplementedError] Method given is not implemented
    def request(path, method=nil, vars={})
      if !path || path.length < 1
          raise ArgumentError, 'Invalid path parameter'
      end
      if method && !['GET', 'POST', 'DELETE', 'PUT'].include?(method)
        raise NotImplementedError, 'HTTP %s not implemented' % method
      end

      if path[0, 1] != '/'
        path = '/' + path
      end
      uri = base_url + path
      return fetch(uri, vars, method)
    end
    
    #enocde the parameters into a URL friendly string
    #
    #@param [Hash] URL key / values        
    #@return [String] Encoded URL
    protected
    def base_url
      return "#{@api_url}/#{@version}"
    end

    def urlencode(params)
      params.to_a.collect! \
        { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")
    end
    
    # Create the uri for the REST call
    #
    #@param [String, Hash] Base URL and URL parameters        
    #@return [String] URI for the REST call
    def build_get_uri(uri, params)
      if params && params.length > 0
        if uri.include?('?')
          if uri[-1, 1] != '&'
            uri += '&'
          end
            uri += urlencode(params)
          else
            uri += '?' + urlencode(params)
        end
      end
      return uri
    end
    
    # Returns a http request for the given url and parameters
    #
    #@param [String, Hash, String] Base URL, URL parameters, optional METHOD        
    #@return [String] URI for the REST call
    def fetch(url, params, method=nil)
      if method && method == 'GET'
        url = build_get_uri(url, params)
      end
      uri = URI.parse(url)
      
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      
      if method && method == 'GET'
        req = Net::HTTP::Get.new(uri.request_uri)
      elsif method && method == 'DELETE'
        req = Net::HTTP::Delete.new(uri.request_uri)
      elsif method && method == 'PUT'
        req = Net::HTTP::Put.new(uri.request_uri)
        req.set_form_data(params)
      else
        req = Net::HTTP::Post.new(uri.request_uri)
        req.set_form_data(params)
      end
      req.basic_auth(@sid, @token)
      
      return http.request(req)
    end
  end
end


class Net::HTTPResponse
  def json
    if not @json
      @json = JSON.load @body
    end
    return @json
  end
end