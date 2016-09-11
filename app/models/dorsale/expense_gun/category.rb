class Dorsale::ExpenseGun::Category < ActiveRecord::Base
  self.table_name = "dorsale_expense_gun_categories"

  validates :name, presence: true
  validates :vat_deductible, inclusion: {in: [true, false]}

  def to_s
    if code.present?
      "#{name} (#{code})"
    else
      name
    end
  end
end
