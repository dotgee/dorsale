class Dorsale::CustomerVault::Link < ActiveRecord::Base
  self.table_name = "dorsale_customer_vault_links"

  belongs_to :alice, class_name: ::Dorsale::CustomerVault::Person
  belongs_to :bob,   class_name: ::Dorsale::CustomerVault::Person

  validates :alice, presence: true
  validates :bob,   presence: true

  attr_accessor :person
  attr_accessor :other_person
end
