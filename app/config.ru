require_relative './logging_middleware'
require_relative './hit_counter'
require_relative './rack_app'

use LoggingMiddleware
use HitCounterMiddleware

run RackApp.new
