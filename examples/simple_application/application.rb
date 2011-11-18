require 'pp'
require 'poundpay'

require './config'

class SimpleController
  attr_reader :poundpay_client

  def initialize
    if Poundpay.configured?
      return
    end
    config = SimpleApplication::CONFIG[:poundpay]
    puts config
    Poundpay.configure_from_hash(config)
  end

  def return_404
    response = Rack::Response.new(["Page Not Found"], 404, {"Content-Type" => "text/plain"})
    response.finish
  end

end

class Index < SimpleController

  def call env
    request = Rack::Request.new(env)
    unless request.path == '/' and request.get?
      return return_404
    end
    # Create payment request
    payment = SimpleApplication::CONFIG[:default_payment]
    # Render and return page
    www_poundpay_url = Poundpay.www_url
    template = ERB.new(open("index.html.erb").read)
    page = template.result(binding)
    response = Rack::Response.new([page], 200, {"Content-Type" => "text/html"})
    response.finish
  end

end

class Payment < SimpleController

  def call env
    request = Rack::Request.new(env)
    return_value = case request.path.gsub(/\/$/, '')  # trim trailing /
      when '/payment' then request.post? ? create(request) : nil
      when '/payment/release' then request.post? ? release(request) : nil
      when '/payment/authorize' then request.post? ? authorize(request) : nil
      when '/payment/cancel' then request.post? ? cancel(request) : nil
      when '/payment/escrow' then request.post? ? escrow(request) : nil
      else nil
    end

    if return_value
      response = Rack::Response.new([return_value], 201, {"Content-Type" => "text/html"})
      response.finish
    else
      return_404
    end
  end

  def create request
    payment = Poundpay::Payment.create(request.POST)
    payment.sid
  end

  def authorize request
    payment = Poundpay::Payment.find(request.POST['sid'])
    payment.authorize
    payment.save
    PP.pp(payment.schema, '')
  end

  def release request
    payment = Poundpay::Payment.find(request.POST['sid'])
    payment.release
    payment.save
    PP.pp(payment.schema, '')
  end

  def cancel request
    payment = Poundpay::Payment.find(request.POST['sid'])
    payment.cancel
    payment.save
    PP.pp(payment.schema, '')
  end

  def escrow request
    payment = Poundpay::Payment.find(request.POST['sid'])
    payment.escrow
    payment.save
    PP.pp(payment.schema, '')
  end

end


class User < SimpleController

  def call env
    request = Rack::Request.new(env)
    return_value = case request.path.gsub(/\/$/, '')  # trim trailing /
                     when '/user' then request.post? ? create(request) : nil
                     else nil
                   end

    if return_value
      response = Rack::Response.new([return_value], 201, {"Content-Type" => "text/html"})
      response.finish
    else
      return_404
    end
  end

  def create request
    user = Poundpay::User.create({
         :first_name => request.POST['user_first_name'],
         :last_name => request.POST['user_last_name'],
         :email_address => request.POST['user_email_address']
    })
    PP.pp(user.schema, '')
  end

end


class ChargePermission < SimpleController

  def call env
    request = Rack::Request.new(env)
    return_value = case request.path.gsub(/\/$/, '')  # trim trailing /
                     when '/charge_permission' then request.post? ? create(request) : nil
                     when '/charge_permission/find' then request.post? ? show(request) : nil
                     when '/charge_permission/deactivate' then request.post? ? deactivate(request) : nil
                     else nil
                   end

    if return_value
      response = Rack::Response.new([return_value], 201, {"Content-Type" => "text/html"})
      response.finish
    else
      return_404
    end
  end

  def create request
    charge_permission = Poundpay::ChargePermission.create(request.POST)
    PP.pp(charge_permission.schema, '')
  end

  def show request
    charge_permissions = Poundpay::ChargePermission.all(:email_address => request.POST['email_address'])
    if charge_permissions
      PP.pp(charge_permissions.map {|cp| cp.schema}, '')
    else
      nil
    end
  end

  def deactivate request
    charge_permission = Poundpay::ChargePermission.find(request.POST['sid'])
    charge_permission.deactivate
    PP.pp(charge_permission.schema, '')
  end

end