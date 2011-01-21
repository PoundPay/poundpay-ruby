require 'application'

use Rack::ShowExceptions
use Rack::Lint

run SimpleApplication.new