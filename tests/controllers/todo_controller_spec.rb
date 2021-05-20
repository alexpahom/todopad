require_relative '../test_helper'

class TodoControllerSpec < BaseCase

  describe 'Todo controller should work' do
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    it 'should get index' do
      get '/api/v1/todos'
      assert last_response.ok?, 'tasks#index should work'
    end

    it 'should get show' do
      id = Task.first.id.to_s
      get "/api/v1/todos/#{id}"
      assert last_response.ok?, 'task#show should work'
    end

    it 'should be able to post' do
     post '/api/v1/todos', { title: '1', rank: Time.now.strftime('%d%H%M%S%L').to_i, status: :close }.to_json
     assert_equal 201, last_response.status, 'Could not post task'
    end

   it 'should be able to patch' do
     id = Task.first.id.to_s
     patch "/api/v1/todos/#{id}", { title: 'Another title' }.to_json
     assert_equal 200, last_response.status, 'Could not patch task'
   end

    it 'should be able to delete' do
      id = Task.first.id.to_s
      delete "/api/v1/todos/#{id}"
      assert_equal 204, last_response.status
    end
  end
end
