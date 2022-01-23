require_relative './logging_middleware'
require_relative './rack_app'

use LoggingMiddleware

run RackApp.new
