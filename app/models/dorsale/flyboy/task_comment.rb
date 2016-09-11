class Dorsale::Flyboy::TaskComment < ActiveRecord::Base
  self.table_name = "dorsale_flyboy_task_comments"

  belongs_to :task
  belongs_to :author, polymorphic: true

  validates :author,      presence: true
  validates :task,        presence: true
  validates :date,        presence: true
  validates :description, presence: true
  validates :progress,    inclusion: {in: 0..100}

  default_scope -> { order("created_at DESC") }

  def initialize(*args)
    super

    self.date = Time.zone.now if date.nil?

    if progress.nil?
      self.progress = task ? task.progress : 0
    end
  end

  after_create :update_task_progress

  def update_task_progress
    task.update!(
      :progress => progress,
      :done     => progress.equal?(100)
    )
  end
end
