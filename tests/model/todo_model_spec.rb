require_relative '../test_helper'
require 'minitest/assertions'
require 'pry'

class TodoModelTest < BaseCase
  include Minitest::Assertions

  describe 'Task should be working' do

    def err
      @err = @task.errors.messages
    end

    def rand
      @rand = Time.now.strftime('%d%H%M%S%L').to_i
    end

    it 'Title should present' do
      @task = Task.create(rank: rand, status: :open)
      assert @task.invalid?, "Task title cannot be empty!. #{err}"
    end

    it 'title should not be long' do
      @task = Task.create(title: 'a' * 35, rank: rand, status: :open)
      assert @task.invalid?, "Task title cannot be longer 30 signs!. #{err}"
    end

    it 'description can present' do
      @task = Task.create(title: 'case', description: 'hello', rank: rand, status: :progress)
      assert @task.valid?, "Task should be able to have description. #{err}"
    end

    it 'description can be empty' do
      @task = Task.create(title: 'case', description: nil, rank: rand, status: :progress)
      assert @task.valid?, "Task should be able not to have description. #{err}"
    end

    it 'status should present' do
      @task = Task.create(title: 'Test', rank: rand)
      assert @task.invalid?, "Task must have status. #{err}"
    end

    it 'status should match appropriate value' do
      %i(open progress close).each do |status|
        @task = Task.create(title: "Allah case", rank: rand, status: status)
        assert @task.valid?, "Task of #{status} status should be valid. #{err}"
      end
    end
    
    it 'status cannot be arbitrary' do
      @task = Task.create(title: "Allah case", rank: rand, status: :trololo)
      assert @task.invalid?, "Task of :trololo status should be invalid. #{err}"
    end

    it 'rank should present' do
      @task = Task.create(title: "Allah case", status: :open)
      assert @task.invalid?, "Task cannot be without rank. #{err}"
    end

    it 'rank should be integer' do
      @task = Task.create(title: "Allah case", status: :open, rank: 1.40)
      assert @task.invalid?, "Task cannot save float rank. #{err}"
    end

    it 'rank should be unique for certain status' do
      rank = rand
      @task1 = Task.create(title: "Regular task", status: :close, rank: rank)
      @task = Task.create(title: "Regular task2", status: :close, rank: rank)
      assert @task.invalid?, "Should not save task with existing rank. #{err}"
    end
  end


end
