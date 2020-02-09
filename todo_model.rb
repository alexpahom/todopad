require 'mongoid'
require 'pry'
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
  }, on: :update
  validates :status, presence: true, inclusion: { in: %i(open progress close) }

  index(title: 'text')

  before_create :generate_rank
  #before_update :upshift_ranks
  #after_destroy :downshift_ranks

  def generate_rank
    self.rank = Task.where(rank: self.rank).count + 1
  end

  def upshift_ranks
    tasks_to_process = Task.where(:rank.gte => self.rank)
    tasks_to_process.each do |task|
      task.rank += 1
      task.save
    end
  end

  def downshift_ranks
    tasks_to_process = Task.where(:rank.gt => self.rank)
    tasks_to_process.each do |task|
      task.rank -= 1
      task.save
    end
  end
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
