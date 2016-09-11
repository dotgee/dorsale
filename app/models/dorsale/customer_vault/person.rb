require "dorsale/search"

class Dorsale::CustomerVault::Person < ActiveRecord::Base
  self.table_name = "dorsale_customer_vault_people"

  extend Forwardable
  include ::Dorsale::Search
  include ::Dorsale::Users::Avatar

  def self.policy_class
    Dorsale::CustomerVault::PersonPolicy
  end

  def initialize(*)
    if self.class == ::Dorsale::CustomerVault::Person
      # self.abstract_class does not work with STI
      raise "Cannot directly instantiate Person class"
    else
      super
    end
  end

  acts_as_taggable

  has_many :comments, -> { order(id: :desc) }, class_name: ::Dorsale::Comment, as: :commentable, dependent: :destroy
  has_one :address, class_name: ::Dorsale::Address, as: :addressable, inverse_of: :addressable, dependent: :destroy
  has_many :tasks, class_name: ::Dorsale::Flyboy::Task, as: :taskable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true

  after_destroy :destroy_links

  default_scope -> {
    order("LOWER(COALESCE(corporation_name, '') || COALESCE(last_name, '') || COALESCE(first_name, '')) ASC")
  }

  def person_type
    self.class.to_s.demodulize.downcase.to_sym
  end

  def corporation?
    person_type == :corporation
  end

  def individual?
    person_type == :individual
  end

  def tags_on(*args)
    super(*args).order(:name)
  end

  def links
    a = ::Dorsale::CustomerVault::Link.where(alice_id: id)
      .each { |l| l.person = l.alice ; l.other_person = l.bob }

    b = ::Dorsale::CustomerVault::Link.where(bob_id: id)
      .each { |l| l.person = l.bob ; l.other_person = l.alice }

    return a + b
  end

  def destroy_links
    links.each(&:destroy!)
  end

end
