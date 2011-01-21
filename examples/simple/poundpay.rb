require 'uri'
require 'net/http'
require 'net/https'
require 'json'


module Poundpay
  class Client

    def initialize(api_url, version, sid, token)
      @api_url = api_url
      @version = version
      @sid = sid
      @token = token
    end

    def request(path, params={}, method="GET")

    end
  end

  protected
  def urlencode(params)
    params.to_a.collect! \
      { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")
  end

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

  def fetch(url, params, method='GET')
    if method && method == 'GET'
      url = build_get_uri(url, params)
    end
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"

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