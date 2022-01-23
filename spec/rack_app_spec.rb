require 'rack/test'
require 'pry'

path = File.join(File.dirname(__FILE__), '../app/config.ru')
OUTER_APP = Rack::Builder.parse_file(path).first

describe RackApp do
	include Rack::Test::Methods

  def app
    OUTER_APP
  end

end
