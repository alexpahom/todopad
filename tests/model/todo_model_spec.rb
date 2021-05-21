require_relative '../test_helper'

class TodoModelTest < BaseCase
  describe 'Task should be working' do
    def err
      @err = @task.errors.messages
    end

    def rand
      @rand = Time.now.strftime('%d%H%M%S%L').to_i
    end

    it 'generate_rank generates rank for new record' do
      @task = Task.new(title: 'Manual rank generation')
      @task.generate_rank
      assert @task.rank, 'Rank was not generated'
    end

    it 'generate_rank returns for existing record' do
      @task = Task.first
      init_rank = @task.rank
      @task.generate_rank
      assert_equal @task.rank, init_rank, 'rank should not change for existing record'
    end

    it 'rank generated for new record' do
      @task = Task.create(title: 'Generate rank', status: :open)
      assert @task.rank, 'Rank was not generated'
    end

    it 'rank remains for existing record' do
      @task = Task.first
      rank = @task.rank
      @task.update(title: 'Test title')
      assert_equal @task.rank, rank, 'Rank should not be changed'
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

    it 'rank should be integer' do
      @task = Task.first
      @task.update(rank: 1.40)
      assert @task.invalid?, "Task cannot save float rank. #{err}"
    end

    # Not implemented
    # it 'rank should be unique for certain status' do
    #   rank = rand
    #   @task1 = Task.create(title: "Regular task", status: :close)
    #   @task = Task.create(title: "Regular task2", status: :close)
    #   @task.update(rank: rank)
    #   @task1.update(rank: rank)
    #   refute_equal @task.rank, @task1.rank, "Should not save task with existing rank. #{err}"
    # end
  end

end
