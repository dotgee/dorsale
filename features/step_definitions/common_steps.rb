When(/^I search "(.*?)"$/) do |q|
  fill_in "q", with: q
  find("form.search button").click
end

When(/^an existing customer$/) do
  @customer = create(:customer_vault_corporation)
end

When(/^he goes to the next page$/) do
  find(".next").click
end

Given(/^an existing id card$/) do
  @id_card = create(:billing_machine_id_card)
end

Given(/^an existing payment term$/) do
  @payment_term = create(:billing_machine_payment_term)
end

Given(/^an authenticated user$/) do
  @user = create(:user)
  sign_in @user
end


Given(/^an active user$/) do
  @user = create(:user)
end

Given(/^an inactive user$/) do
  @user = create(:user, is_active: false)
end

Given(/^an existing "(.*?)" having "(.*?)" set to "(.*?)"$/) do |factory, key, value|
  create(factory, key => value)
end

Then(/^the selected filter is "(.*?)"$/) do |value|
  selected_values = all(".filters select").map(&:value)
  expect(selected_values).to include value
end

