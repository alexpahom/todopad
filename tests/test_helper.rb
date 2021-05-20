require 'minitest/autorun'
require 'rack/test'
require File.expand_path '../../app/todos_controller', __FILE__
require 'pry'

class BaseCase < Minitest::Test
  include Minitest::Assertions
  include Rack::Test::Methods


end
