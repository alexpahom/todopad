require 'mongoid'
require 'pry'
Mongoid.load! '/home/alexpahom/projects/todopad/mongoid.config'

class Task
  include Mongoid::Document

  field :title, type: String
  field :description, type: String
  field :rank, type: Integer
  field :status, type: Symbol

  validates :title, presence: true, length: { maximum: 30 }
  validates :rank, presence: true, numericality: { only_integer: true }
  validates :rank, presence: true, numericality: { only_integer: true }#, uniqueness: {
  #    scope: :status, message: 'Error! Cannot have the same rank withing the same status'
  #}, on: :update
  validates :status, presence: true, inclusion: { in: %i(open progress close) }

  index(title: 'text')

  before_validation :generate_rank
  before_update :process_ranks

  def generate_rank
    return unless new_record?
    self.rank = Task.where(status: status).count + 1
  end

  def process_ranks
    initial_status, initial_rank = Task.where(id: id).pluck(:status, :rank).first
    if initial_status == status
      offset = initial_rank < rank ? -1 : 1
      min_rank, max_rank = [initial_rank, rank].sort
      Task.where(status: status, rank: (min_rank..max_rank)).inc(rank: offset)
    else
      Task.where(status: initial_status, :rank.gt => initial_rank).inc(rank: -1)
      Task.where(status: status, :rank.gte => rank).inc(rank: 1)
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
