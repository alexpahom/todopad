require 'mongoid'
Mongoid.load! '/mnt/d/projects/todopad/mongoid.config'

class Task
  include Mongoid::Document

  field :title, type: String
  field :description, type: String
  field :rank, type: Integer
  field :status, type: String

  validates :title, presence: true
  validates :rank, presence: true
  validates :status, presence: true

  index(title: 'text')
end

class TaskSerializer
  attr_reader :task

  def initialize(task)
    @task = task
  end

  def as_json(*)
    data = {
        id: task.id.to_s,
        title: task.title,
        description: task.description,
        rank: task.rank,
        status: task.status
    }
    data[:errors] = task.errors if task.errors.any?
    data
  end
end
