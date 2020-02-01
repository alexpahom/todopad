#ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
#require 'rack/test'
require File.expand_path '../../todos_controller', __FILE__

class BaseCase < Minitest::Test
#class BaseCase < Minitest::Unit::TestCase
  #include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end
