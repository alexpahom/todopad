require 'mongoid'
Mongoid.load! '/mnt/d/projects/todopad/mongoid.config'

class Task
  include Mongoid::Document

  field :title, type: String
  field :description, type: String
  field :rank, type: Integer
  field :status, type: Symbol

  validates :title, presence: true, length: { maximum: 30 }
  validates :rank, presence: true, numericality: { only_integer: true }, uniqueness: {
      scope: :status, message: 'Error! Cannot have the same rank withing the same status'
  }
  validates :status, presence: true, inclusion: { in: %i(open progress close) }

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
