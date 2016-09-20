require "dorsale/search"
require "dorsale/polymorphic_id"

class Dorsale::Flyboy::Task < ActiveRecord::Base
  self.table_name = "dorsale_flyboy_tasks"

  include ::Dorsale::Search

  paginates_per 50

  belongs_to :taskable, polymorphic: true
  belongs_to :owner, polymorphic: true
  has_many :comments, class_name: ::Dorsale::Flyboy::TaskComment, inverse_of: :task, dependent: :destroy
  polymorphic_id_for :taskable
  polymorphic_id_for :owner

  scope :delayed,  -> { where(done: false).where("term < ?", Time.zone.now.to_date)    }
  scope :today,    -> { where(done: false).where("term = ?", Time.zone.now.to_date)    }
  scope :tomorrow, -> { where(done: false).where("term = ?", Date.tomorrow) }

  scope :this_week, -> {
    min = Date.tomorrow
    max = Time.zone.now.to_date.end_of_week
    where(done: false).where("term > ?", min).where("term <= ?", max)
  }

  scope :next_week, -> {
    min = Time.zone.now.to_date.end_of_week
    max = Time.zone.now.to_date.next_week.end_of_week
    where(done: false).where("term > ?", min).where("term <= ?", max)
  }

  scope :next_next_week, -> {
    min = Time.zone.now.to_date.next_week.end_of_week
    max = Time.zone.now.to_date.next_week.next_week.end_of_week
    where(done: false).where("term > ?", min).where("term <= ?", max)
  }


  validates :taskable, presence: true
  validates :name,     presence: true
  validates :term,     presence: true
  validates :reminder, presence: true

  validate :validates_reminder_and_term

  def validates_reminder_and_term
    if reminder && term && reminder > term
      # errors.add(:reminder, "La date de relance doit être antérieure ou égale à la date d'échéance")
      errors.add(:reminder, :less_than, count: term)
    end
  end

  def initialize(*args)
    super
    self.done = false                                    if done.nil?
    self.reminder = Time.zone.now.to_date + snooze_default_reminder if reminder.nil?
    self.term     = Time.zone.now.to_date + snooze_default_term     if term.nil?
    self.progress = 0                                    if progress.nil?
  end

  after_save    :update_taskable_progress!
  after_destroy :update_taskable_progress!

  def update_taskable_progress!
    taskable.try(:update_progress!)
  end

  def snooze
    if term_not_passed_yet
      if self.reminder + snooze_default_reminder > Time.zone.now.to_date
        self.reminder += snooze_default_reminder
        self.term     += snooze_default_term
      else
        self.reminder = Time.zone.now.to_date + 1
      end
    else
      self.reminder = Time.zone.now.to_date + snooze_default_reminder
      self.term     = Time.zone.now.to_date + snooze_default_term
    end
  end

  def snooze_default_reminder
    7
  end

  def snooze_default_term
    30
  end

  def snoozable?
    return false if done?
    return false if reminder >= Time.zone.now.to_date
    return true
  end

  def term_not_passed_yet
    self.term > Time.zone.now.to_date
  end
end
