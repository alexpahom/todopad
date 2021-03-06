require 'sinatra'
require 'sinatra/namespace'
require_relative 'todo_model'
require 'pry'
require './db_seeds'
set :port, 4568
namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
    end

    def json_params
      JSON.parse(request.body.read)
    rescue
      halt 400, { message: 'Invalid JSON' }.to_json
    end

    def task
      @task ||= Task.where(id: params[:id]).first
    end

    def halt_unless_found!
      halt(404, { message: 'Task No found' }.to_json) unless task
    end

    def serialize(task)
      TaskSerializer.new(task).to_json
    end
  end

  get '/todos' do
    tasks = {}
    %i(open progress close).each do |status|
      tasks[status] = Task
                      .where(status: status)
                      .order_by(%i(rank asc))
                      .map { |task| TaskSerializer.new task }
    end
    tasks.to_json
  end

  get '/todos/:id' do
    halt_unless_found!
    serialize(task)
  end

  post '/todos' do
    task = Task.new(json_params)
    halt 422, serialize(task) unless task.save

    response.headers['Location'] = "#{base_url}/api/v1/todos/#{task.id}"
    response.body = serialize task
    status 201
  end

  patch '/todos/:id' do
    halt_unless_found!
    halt 422, serialize(task) unless task.update_attributes(json_params)
    serialize(task)
  end

  delete '/todos/:id' do
    task.destroy if task
    status 204
  end
end
