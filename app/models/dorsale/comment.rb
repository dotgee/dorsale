class Dorsale::Comment < ActiveRecord::Base
  belongs_to :author, polymorphic: true
  belongs_to :commentable, polymorphic: true

  validates :author,      presence: true
  validates :commentable, presence: true
  validates :text,        presence: true

  default_scope -> {
    order(created_at: :desc)
  }
end
