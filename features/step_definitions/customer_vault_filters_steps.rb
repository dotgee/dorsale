Given(/^an existing corporation with tags hello and world$/) do
  @corporation1 = create(:customer_vault_corporation, tag_list: "hello, world")
end

Given(/^an other existing corporation with tags hello and goodbye$/) do
  @corporation2 = create(:customer_vault_corporation, tag_list: "hello, goodbye")
end

Given(/^an other existing corporation with tag yeah$/) do
  @corporation3 = create(:customer_vault_corporation, tag_list: "yeah")
end

When(/^I go the to people list$/) do
  visit dorsale.customer_vault_people_list_path
end

When(/^I filter with tag hello$/) do
  select("hello")
  find(".filter-submit").click
end

Then(/^only first and second corporation appear$/) do
  expect(page).to have_content @corporation1.name
  expect(page).to have_content @corporation2.name
  expect(page).to_not have_content @corporation3.name
end

When(/^I add the second tag world$/) do
  select "world"
  find(".filter-submit").click
end

Then(/^only the first corporation appear$/) do
  expect(page).to have_content @corporation1.name
  expect(page).to_not have_content @corporation2.name
  expect(page).to_not have_content @corporation3.name
end
