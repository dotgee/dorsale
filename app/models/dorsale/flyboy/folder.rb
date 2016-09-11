require "dorsale/search"
require "dorsale/polymorphic_id"

class Dorsale::Flyboy::Folder < ActiveRecord::Base
  self.table_name = "dorsale_flyboy_folders"

  include AASM
  include ::Dorsale::Search

  paginates_per 50

  aasm(column: "status", whiny_transitions: false) do
    state :open, initial: true
    state :closed

    event :close, if: :no_undone_tasks? do
      transitions from: [:open], to: :closed
    end

    event :open do
      transitions from: [:closed], to: :open
    end
  end

  belongs_to :folderable, polymorphic: true
  has_many :tasks, dependent: :destroy, as: :taskable

  validates :name, presence: true
  validates :status, inclusion: {
    in: proc { ::Dorsale::Flyboy::Folder.aasm.states.map(&:to_s) }
  }

  def initialize(*args)
    super
    self.progress = 0 if progress.nil?
  end

  def no_undone_tasks?
    tasks.where(done: false).count == 0
  end

  def revision
    "#{tracking} #{version}"
  end

  before_create :create_tracking

  def create_tracking
    dailycounter  = self.class.where("DATE(created_at) = ?", Time.zone.now.to_date).count + 1
    self.tracking = "#{Time.zone.now.strftime("%y%m%d")}-#{dailycounter}"
  end

  before_save :update_version

  def update_version
    self.version = 0 if self.version.nil?
    self.version = self.version + 1
  end

  def update_progress
    if tasks.count.zero?
      self.progress = 0
    else
      self.progress = tasks.sum(:progress) / tasks.count
    end
  end

  def update_progress!
    update_progress
    save
  end

end
