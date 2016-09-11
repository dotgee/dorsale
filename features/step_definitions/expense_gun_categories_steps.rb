Given(/^the user goes on the new expense category page$/) do
  visit dorsale.expense_gun_categories_path
  find(".link_create").click
end

When(/^he fills the category's information$/) do
  fill_in 'category_name', with: "Category Name"
  fill_in 'category_code', with: "Category Code"
  select "Oui"
end

When(/^creates a new expense category$/) do
  find("[type=submit]").click
end

Then(/^the category is added to the category list$/) do
  expect(page).to have_content "Category Name"
  expect(page).to have_content "Category Code"
  expect(page).to have_css(".fa-check")
end

Given(/^an existing expense category$/) do
  @category = create(:expense_gun_category, vat_deductible: true)
end

When(/^I edit the expense category$/) do
  visit dorsale.expense_gun_categories_path
  find(".link_update").click
end

Then(/^the current expense category's label should be pre\-filled$/) do
  expect(page).to have_field("category_name", with: @category.name)
end

When(/^he validates the new expense category$/) do
  fill_in "category_name", with: "New Category Name"
  fill_in "category_code", with: "New Category Code"
  select "Non"
  find("[type=submit]").click
end

Then(/^he is redirected on the expense categories page$/) do
  expect(current_path).to eq dorsale.expense_gun_categories_path
end

Then(/^the expense category's label is updated$/) do
  expect(page).to have_content "New Category Name"
  expect(page).to have_content "New Category Code"
  expect(page).to have_css(".fa-remove")
end
