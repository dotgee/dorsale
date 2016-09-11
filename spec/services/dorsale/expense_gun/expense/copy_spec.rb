require "rails_helper"

RSpec.describe ::Dorsale::ExpenseGun::Expense::Copy do
  let(:expense) {
    expense = Dorsale::ExpenseGun::Expense.create!(
      :user  => create(:user),
      :name  => "ExpenseName",
      :date  => Time.zone.now.to_date,
      :state => "accepted",
    )

    line = create(:expense_gun_expense_line,
      :expense => expense,
      :name    => "ExpenseLineName",
      :date    => Time.zone.now.to_date,
    )

    expense.reload
  }

  let(:copy) {
    ::Dorsale::ExpenseGun::Expense::Copy.(expense)
  }

  it "should duplicate expense attributes" do
    expect(copy.name).to eq "ExpenseName"
  end

  it "should duplicate expense lines attributes" do
    expect(copy.expense_lines.length).to eq 1
    expect(copy.expense_lines.first.name).to eq "ExpenseLineName"

    expect(copy.expense_lines.first.category).to be_present
    expect(copy.expense_lines.first.category).to eq expense.expense_lines.first.category

    expect(copy.expense_lines.first.total_all_taxes).to be_present
    expect(copy.expense_lines.first.total_all_taxes).to eq expense.expense_lines.first.total_all_taxes

    expect(copy.expense_lines.first.vat).to be_present
    expect(copy.expense_lines.first.vat).to eq expense.expense_lines.first.vat

    expect(copy.expense_lines.first.company_part).to be_present
    expect(copy.expense_lines.first.company_part).to eq expense.expense_lines.first.company_part
  end

  it "should not be persisted" do
    expect(copy).to_not be_persisted
  end

  it "should reset expense user" do
    expect(expense.user).to be_present
    expect(copy.user).to be_nil
  end

  it "should reset expense date" do
    expect(expense.date).to be_present
    expect(copy.date).to be_nil
  end

  it "should reset expense state" do
    expect(expense.state).to eq "accepted"
    expect(copy.state).to eq "new"
  end

  it "should reset expense created_at/updated_at" do
    expect(expense.created_at).to be_present
    expect(copy.created_at).to be_nil

    expect(expense.updated_at).to be_present
    expect(copy.updated_at).to be_nil
  end

  it "should reset expense line date" do
    expect(expense.expense_lines.first.date).to be_present
    expect(copy.expense_lines.first.date).to be_nil
  end

  it "should reset expense lines created_at/updated_at" do
    expect(expense.expense_lines.first.created_at).to be_present
    expect(copy.expense_lines.first.created_at).to be_nil

    expect(expense.expense_lines.first.updated_at).to be_present
    expect(copy.expense_lines.first.updated_at).to be_nil
  end

end

