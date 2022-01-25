require 'rack/test'
require 'pry'
require 'timecop'

include Rack::Test::Methods

path = File.join(File.dirname(__FILE__), '../app/config.ru')
OUTER_APP = Rack::Builder.parse_file(path).first

def app
	OUTER_APP
end

# require all the ruby file in the app
Dir[File.join(__dir__, '../app', '*.rb')].each { |file| require file }
