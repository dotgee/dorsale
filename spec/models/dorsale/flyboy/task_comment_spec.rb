require 'rails_helper'

describe Dorsale::Flyboy::TaskComment do
  it { is_expected.to belong_to(:task) }

  it { is_expected.to validate_presence_of :task }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :description }

  it { is_expected.to belong_to :author }
  it { is_expected.to validate_presence_of :author }

  it 'should have a valid factory' do
    expect(build(:flyboy_task_comment)).to be_valid
  end

  it 'should update the task progress upon creation' do
    task    = create(:flyboy_task, progress: 10)
    comment = create(:flyboy_task_comment, progress: 20, task: task)
    expect(task.reload.progress).to eq(20)
  end

  it 'should mark task as complete when progress == 100' do
    task    = create(:flyboy_task, progress: 10, done: false)
    comment = create(:flyboy_task_comment, progress: 100, task: task)
    expect(task.reload.done).to be true
  end

  it 'should mark task as un complete when progress < 100' do
    task    = create(:flyboy_task, progress: 100, done: true)
    comment = create(:flyboy_task_comment, progress: 90, task: task)
    expect(task.reload.done).to be false
  end

  describe "default values" do
    it "#new progress should be 0 if no task" do
      expect(Dorsale::Flyboy::TaskComment.new.progress).to eq 0
    end

    it "#new progress should be task progress if task specified" do
      task = create(:flyboy_task, progress: 50)
      expect(task.comments.new.progress).to eq 50
    end

    it "#new progress should not override exisring progress" do
      task = create(:flyboy_task)
      comment1 = create(:flyboy_task_comment, task: task, progress: 30)
      comment2 = create(:flyboy_task_comment, task: task, progress: 50)
      expect(task.reload.progress).to eq 50
      expect(comment1.reload.progress).to eq 30
      expect(comment2.reload.progress).to eq 50
    end

  end
end
