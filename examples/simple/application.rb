require 'uri'
require 'net/http'
require 'net/https'
require 'json'
require 'erb'
require 'rack/request'
require 'rack/response'

require 'config'

class Poundpay
  attr_reader :api_url, :version, :sid, :token

  def initialize(api_url, version, sid, token)
    @api_url = api_url
    @version = version
    @sid = sid
    @token = token
  end

  def post(endpoint, params)
    request_url = "#{@api_url}/#{@version}/#{endpoint}"
    puts request_url, params
    uri = URI.parse request_url
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = uri.scheme == "https"
    req = Net::HTTP::Post.new uri.request_uri
    req.set_form_data params
    req.basic_auth @sid, @token
    response = http.request req
    JSON.load response.body
  end
end


class Simple
  attr_reader :poundpay_client

  def initialize
    config = Simple::CONFIG[:poundpay]
    @poundpay_client = Poundpay.new(config[:api_url], config[:version], config[:sid], config[:token])
    Signal.trap(2) {}
  end

  def call(env)
    puts env
    # Create payment request
    params = {
      'amount'                  => 20000,  # In USD cents
      'payer_fee_amount'        => 0,
      'recipient_fee_amount'    => 500,
      'recipient_email_address' => 'david@example.com',
      'description'             => 'Beats by Dr. Dre',
    }
    payment_request = @poundpay_client.post 'payment_requests', params
    puts payment_request

    # Render and return page
    www_poundpay_url= Simple::CONFIG[:poundpay][:www_url]
    template = ERB.new(open("index.html.erb").read)
    page = template.result(binding)
    [200, {"Content-Type" => "text/html"}, [page]]
  end
end


if $0 == __FILE__
  require 'rack'
  require 'rack/showexceptions'
  Rack::Handler.default.run \
    Rack::ShowExceptions.new(Rack::Lint.new(Simple.new)),
    Port: 9292
end