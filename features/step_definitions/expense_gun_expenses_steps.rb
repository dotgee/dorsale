When(/^I go on the expenses page$/) do
  visit dorsale.expense_gun_expenses_path
end

Then(/^I see (\d+) expenses?$/) do |n|
  expect(page).to have_selector(".expense", count: n.to_i)
end

When(/^I create a new expense$/) do
  @expenses_count      = Dorsale::ExpenseGun::Expense.count
  @expense_lines_count = Dorsale::ExpenseGun::ExpenseLine.count

  find("[href$='expenses/new']").click
  fill_in :expense_name, with: "ExpenseName"

  within all(".nested-fields").first do
    find("input[id$='_name']").set            "ExpenseLine1Name"
    find("input[id$='_date']").set            "21/06/2015"
    select @category.name
    find("input[id$='_total_all_taxes']").set "100"
    find("input[id$='_vat']").set             "20"
  end

  find(".add_fields").click
  expect(page).to have_selector(".nested-fields", count: 2)

  within all(".nested-fields").last do
    find("input[id$='_name']").set            "ExpenseLine2Name"
    find("input[id$='_date']").set            "12/06/2015"
    select @category.name
    find("input[id$='_total_all_taxes']").set "200"
    find("input[id$='_vat']").set             "40"
  end

  find("[type=submit]").click
end

Then(/^the expense is created$/) do
  expect(Dorsale::ExpenseGun::Expense.count).to eq(@expenses_count + 1)
  expect(Dorsale::ExpenseGun::ExpenseLine.count).to eq(@expense_lines_count + 2)

  @expense = Dorsale::ExpenseGun::Expense.reorder(:id).last

  expect(@expense.name).to eq "ExpenseName"
  expect(@expense.expense_lines.first.name).to eq "ExpenseLine1Name"
end

Then(/^I am redirected on the expense page$/) do
  expect(current_path).to eq dorsale.expense_gun_expense_path(@expense)
end

Then(/^I see (\d+) expense lines?$/) do |n|
  expect(page).to have_selector(".expense-line", count: n.to_i)
end

Given(/^an existing expense$/) do
  @expense = create(:expense_gun_expense)
end

When(/^I update the expense$/) do
  @expenses_count      = Dorsale::ExpenseGun::Expense.count
  @expense_lines_count = Dorsale::ExpenseGun::ExpenseLine.count

  find("#main [href$=edit]").click

  fill_in :expense_name, with: "NewExpenseName"
  all(".remove_fields").sample.click

  find("[type=submit]").click
end

Then(/^the expense is update$/) do
  expect(Dorsale::ExpenseGun::Expense.count).to eq(@expenses_count)
  expect(Dorsale::ExpenseGun::ExpenseLine.count).to eq(@expense_lines_count - 1)

  @expense.reload

  expect(@expense.name).to eq "NewExpenseName"
end

When(/^I submit the expense$/) do
  find("[href$='/submit']").click
end

Then(/^I am redirect to the expenses page$/) do
  wait_for { current_path }.to include dorsale.expense_gun_expenses_path
  wait_for { current_path }.to include "state/all"
end

Then(/^the expense state is "([^"]*)"$/) do |new_state|
  expect(@expense.reload.state).to eq new_state
end

Given(/^the expense is submited$/) do
  @expense.update_columns(state: "submited")
end

When(/^I cancel the expense$/) do
  find("[href$='/cancel']").click
end

When(/^I accept the expense$/) do
  find("[href$='/accept']").click
end

When(/^I refuse the expense$/) do
  find("[href$='/refuse']").click
end

Then(/^I am redirect to the expense page$/) do
  wait_for { current_path }.to include dorsale.expense_gun_expense_path(@expense)
end

When(/^I go on the expense page$/) do
  visit dorsale.expense_gun_expense_path(@expense)
end

When(/^I copy the expense$/) do
  @expenses_count = Dorsale::ExpenseGun::Expense.count

  find("[href$=copy]").click

  all(".nested-fields").each do |line|
    within line do
      find("input[id$='_date']").set "12/06/2015"
    end
  end

  find("[type=submit]").click
end

Then(/^an expense copy is created$/) do
  expect(Dorsale::ExpenseGun::Expense.count).to eq(@expenses_count + 1)
  @expense = Dorsale::ExpenseGun::Expense.reorder(:id).last
end
