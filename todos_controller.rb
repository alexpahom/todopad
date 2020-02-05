require 'sinatra'
require 'sinatra/namespace'
require_relative 'todo_model'

set :port, 4568
namespace '/api/v1' do
  before { content_type 'application/json' }

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
    all_tasks = Task.all.map { |task| TaskSerializer.new(task) }
    # TODO: not finished
    all_tasks.map do |task|
      { title: task.title, rank: task.rank, id: task.id }.to_json
    end
  end

  get '/todos/:id' do |id|
    halt_unless_found!
    serialize task
  end

  post '/todos' do
    binding.pry
    task = Task.new(json_params)
    halt 422, serialize(task) unless task.save

    response.headers['Location'] = "#{base_url}/api/v1/todos/#{task.id}"
    status 201
  end

  patch '/todos/:id' do |id|
    halt_unless_found!
    halt 422, serialize(task) unless task.update_attributes(json_params)
    serialize task
  end

  delete '/todos/:id' do |id|
    task.destroy if task
    status 204
  end
end
