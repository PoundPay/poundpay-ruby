require 'application'

use Rack::ShowExceptions
use Rack::Lint

run Simple.new