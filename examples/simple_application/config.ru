# http://stackoverflow.com/questions/2900370/
# why-does-ruby-1-9-2-remove-from-load-path-and-whats-the-alternative

require 'rack'
require 'rack/urlmap'

use Rack::ShowExceptions
use Rack::Lint
use Rack::Static, :urls => ["/static"]

require './application'

app = Rack::URLMap.new(
    '/' => Index.new,
    '/payment' => Payment.new,
    '/charge_permission'=> ChargePermission.new,
    '/user' => User.new,
)

run app