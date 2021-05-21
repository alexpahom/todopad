require_relative '../test_helper'

class TodoControllerSpec < BaseCase

  describe 'Todo controller should work' do
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    # components
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

    # integration
    it 'should create rank automatically' do
      post '/api/v1/todos', { title: '1', status: :close }.to_json
      task = JSON.parse last_response.body
      assert task['rank'], 'Rank is not created'
    end

    it 'should shift ranks properly within single status' do
      task1, task2, task3 = Task.where(status: :open, :rank.lte => 3)
      patch "/api/v1/todos/#{task2['id']}", { rank: 3 }.to_json
      get "/api/v1/todos/#{task1['id']}"
      task1 = JSON.parse(last_response.body)
      get "/api/v1/todos/#{task3['id']}"
      task3 = JSON.parse(last_response.body)
      assert_equal 1, task1['rank']
      assert_equal 2, task3['rank']
    end

    it 'should shift ranks properly across different statuses' do
      task1 = Task.where(status: :open, rank: 2).first
      task2, task3 = Task.where(status: :close, rank: (1..2))
      patch "/api/v1/todos/#{task1['id']}", { rank: 1, status: :close }.to_json
      get "/api/v1/todos/#{task2['id']}"
      task2 = JSON.parse(last_response.body)
      get "/api/v1/todos/#{task3['id']}"
      task3 = JSON.parse(last_response.body)
      assert_equal 2, task2['rank']
      assert_equal 3, task3['rank']
    end

    it 'shift ranks when deleting' do
      task1, task2 = Task.where(status: :close, rank: (1..2))
      delete "/api/v1/todos/#{task1['id']}"
      get "/api/v1/todos/#{task2['id']}"
      task2 = JSON.parse(last_response.body)
      assert_equal 1, task2['rank']
    end
  end
end
