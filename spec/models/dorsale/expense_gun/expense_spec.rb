require 'rails_helper'

RSpec.describe ::Dorsale::ExpenseGun::Expense, type: :model do
  it { is_expected.to have_many(:expense_lines).dependent(:destroy) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :date }

  it "expense factory should be valid?" do
    expect(build(:expense_gun_expense)).to be_valid
  end

  it "default #date should be tody" do
    expect(::Dorsale::ExpenseGun::Expense.new.date).to eq Time.zone.now.to_date
  end

  it "new expense should have new state" do
    expect(::Dorsale::ExpenseGun::Expense.new.current_state).to be :new
  end

  describe "new state" do
    before :each do
      @expense = build(:expense_gun_expense)
    end

    it "new expense can be submited" do
      expect(@expense.go_to_submited).to be true
      expect(@expense.current_state).to be :submited
    end

    it "new expense can't be accepted" do
      expect(@expense.go_to_accepted).to be false
      expect(@expense.current_state).to be :new
    end

    it "new expense can't be refused" do
      expect(@expense.go_to_refused).to be false
      expect(@expense.current_state).to be :new
    end

    it "new expense can be canceled" do
      expect(@expense.go_to_canceled).to be true
      expect(@expense.current_state).to be :canceled
    end
  end

  describe "submited state" do
    before :each do
      @expense = build(:expense_gun_expense)
      @expense.go_to_submited
    end

    it "submitted expense can be accepted" do
      expect(@expense.go_to_accepted).to be true
      expect(@expense.current_state).to be :accepted
    end

    it "submitted expense can be refused" do
      expect(@expense.go_to_refused).to be true
      expect(@expense.current_state).to be :refused
    end

    it "submitted expense can be canceled" do
      expect(@expense.go_to_canceled).to be true
      expect(@expense.current_state).to be :canceled
    end
  end

  describe "acceped state" do
    before :each do
      @expense = build(:expense_gun_expense)
      @expense.go_to_submited
      @expense.go_to_accepted
    end

    it "acceped expense can't be submited" do
      expect(@expense.go_to_submited).to be false
      expect(@expense.current_state).to be :accepted
    end

    it "acceped expense can't be refused" do
      expect(@expense.go_to_refused).to be false
      expect(@expense.current_state).to be :accepted
    end

    it "acceped expense can be canceled" do
      expect(@expense.go_to_canceled).to be true
      expect(@expense.current_state).to be :canceled
    end
  end

  describe "refused state" do
    before :each do
      @expense = build(:expense_gun_expense)
      @expense.go_to_submited
      @expense.go_to_refused
    end

    it "refused expense can't be submited" do
      expect(@expense.go_to_submited).to be false
      expect(@expense.current_state).to be :refused
    end

    it "refused expense can't be acceped" do
      expect(@expense.go_to_accepted).to be false
      expect(@expense.current_state).to be :refused
    end

    it "refused expense can't be canceled" do
      expect(@expense.go_to_canceled).to be false
      expect(@expense.current_state).to be :refused
    end
  end

  describe "canceled state" do
    before :each do
      @expense = build(:expense_gun_expense)
      @expense.go_to_canceled
    end

    it "canceled expense can't be submited" do
      expect(@expense.go_to_submited).to be false
      expect(@expense.current_state).to be :canceled
    end

    it "canceled expense can't be acceped" do
      expect(@expense.go_to_accepted).to be false
      expect(@expense.current_state).to be :canceled
    end

    it "canceled expense can't be refused" do
      expect(@expense.go_to_refused).to be false
      expect(@expense.current_state).to be :canceled
    end
  end

  it "#total_all_taxes should return sum of lines" do
    expense = build(:expense_gun_expense, expense_lines: [])
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10)
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10)
    expect(expense.total_all_taxes).to eq 20.0
  end

  it "#total_employee_payback should return sum of lines" do
    expense = build(:expense_gun_expense, expense_lines: [])
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10, company_part: 100)
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10, company_part: 50)
    expect(expense.total_employee_payback).to eq 15.0
  end

  it "#total_vat_deductible should return sum of lines" do
    expense = build(:expense_gun_expense, expense_lines: [])
    category1 = build(:expense_gun_category, vat_deductible: true)
    category2 = build(:expense_gun_category, vat_deductible: false)
    expense.expense_lines << build(:expense_gun_expense_line, vat: 10, category: category1, company_part: 50)
    expense.expense_lines << build(:expense_gun_expense_line, vat: 10, category: category2, company_part: 50)
    expect(expense.total_vat_deductible).to eq 5.0
  end

  it "#may_edit? should return false unless expense is not submited" do
    expect(::Dorsale::ExpenseGun::Expense.new(state: :new).may_edit?).to be true
    expect(::Dorsale::ExpenseGun::Expense.new(state: :submited).may_edit?).to be false
    expect(::Dorsale::ExpenseGun::Expense.new(state: :acceped).may_edit?).to be false
    expect(::Dorsale::ExpenseGun::Expense.new(state: :refused).may_edit?).to be false
    expect(::Dorsale::ExpenseGun::Expense.new(state: :canceled).may_edit?).to be false
  end
end
