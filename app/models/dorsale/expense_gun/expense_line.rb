class Dorsale::ExpenseGun::ExpenseLine < ActiveRecord::Base
  self.table_name = "dorsale_expense_gun_expense_lines"

  belongs_to :expense,  class_name: ::Dorsale::ExpenseGun::Expense
  belongs_to :category, class_name: ::Dorsale::ExpenseGun::Category

  def initialize(*)
    super
    self.company_part = 100 if company_part.nil?
  end

  validates :expense,         presence: true
  validates :name,            presence: true
  validates :date,            presence: true
  validates :category,        presence: true
  validates :total_all_taxes, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :vat,             presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :company_part,    presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100.0}

  def employee_payback
    (total_all_taxes * company_part / 100)
  end

  def total_vat_deductible
    category.vat_deductible == true ? (vat * company_part / 100) : 0.0
  end

end
