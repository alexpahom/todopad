require_relative '../test_helper'
require 'minitest/assertions'
require 'pry'

class TodoModelTest < BaseCase
  include Minitest::Assertions

  describe 'Task should be working' do
    it 'Title should present' do
      task = Task.create(rank: 1, status: :open)
      assert task.invalid?, 'Task title cannot be empty!'
    end

    it 'title should not be long' do
      task = Task.create(title: 'a' * 35, rank: 1, status: :open)
      assert task.invalid?, 'Task title cannot be longer 30 signs!'
    end

    it 'description can present' do
      task = Task.create(title: 'case', description: 'hello', rank: 2, status: :progress)
      binding.pry
      assert task.valid?, 'Task should be able to have description'
    end

    it 'description can be empty' do
      task = Task.create(title: 'case', description: nil, rank: 2, status: :progress)
      assert task.valid?, 'Task should be able not to have description'
    end
  end
  #
  #describe 'status should present'
  #
  #describe 'status should match appropriae value'
  #
  #describe 'rank should present'
  #
  #describe 'rank should be integer'
  #
  #describe 'rank should be unique for certain status'
end
