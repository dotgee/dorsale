class Dorsale::Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true, inverse_of: :address

  validates :addressable, presence: true

  def one_line
    zip_city = [zip, city].select(&:present?).join(' ')
    [street, street_bis, zip_city, country].select(&:present?).join(', ')
  end
end
