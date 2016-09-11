require 'rails_helper'

RSpec.describe ::Dorsale::ExpenseGun::ExpenseLine, type: :model do
  it { is_expected.to belong_to :expense }
  it { is_expected.to validate_presence_of :expense }
  it { is_expected.to validate_presence_of :category }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :total_all_taxes }
  it { is_expected.to validate_presence_of :vat }
  it { is_expected.to validate_numericality_of(:total_all_taxes).is_greater_than_or_equal_to(0) }

  it "expense line factory should be valid?" do
    expense_line = build :expense_gun_expense_line, expense: build(:expense_gun_expense)
    expect(expense_line).to be_valid
  end

  it "#vat should be decimal" do
    expense_line = build(:expense_gun_expense_line, vat: 123)
    expect(expense_line.valid?).to be false
    expect(expense_line.vat).to eq 123.0
  end

  it "#company_part should be present" do
    expect(build(:expense_gun_expense_line)).to validate_presence_of :company_part
  end

  it "#company_part should be >=0 and <= 100" do
    expect(build(:expense_gun_expense_line)).to validate_numericality_of(:company_part).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100.0)
  end

  it "#company_part should be 100 as default" do
    expense_line = ::Dorsale::ExpenseGun::ExpenseLine.new
    expect(expense_line.company_part).to eq 100.0
  end

  it "#employee_payback should be correct" do
    expense_line = ::Dorsale::ExpenseGun::ExpenseLine.new(total_all_taxes: 100, company_part: 100)
    expect(expense_line.employee_payback).to eq 100.0

    expense_line = ::Dorsale::ExpenseGun::ExpenseLine.new(total_all_taxes: 250, company_part: 50)
    expect(expense_line.employee_payback).to eq 125.0

    expense_line = ::Dorsale::ExpenseGun::ExpenseLine.new(total_all_taxes: 200, company_part: 80)
    expect(expense_line.employee_payback).to eq 160.0
  end

  it "#total_vat_deductible should be proportional to #company_part}" do
    category     = build(:expense_gun_category, vat_deductible: true)
    expense_line = build(:expense_gun_expense_line, category: category, total_all_taxes: 200, vat: 40, company_part: 50)
    expect(expense_line.total_vat_deductible).to eq 20.0
  end

  it "#total_vat_deductible should be 0 if categorie is non vat_decuctible" do
    category     = build(:expense_gun_category, vat_deductible: false)
    expense_line = build(:expense_gun_expense_line, category: category)
    expect(expense_line.total_vat_deductible).to eq 0.0
  end
end
