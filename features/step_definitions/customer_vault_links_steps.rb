
Given(/^an existing corporation$/) do
  @corporation= create(:customer_vault_corporation)
end

Given(/^an existing indidual$/) do
  @individual = create(:customer_vault_individual)
end

Given(/^an existing link$/) do
  @link = create(:customer_vault_link)
  @individual = @link.alice
  @corporation = @link.bob
end

When(/^I navigate to the link section of the indidual details$/) do
  visit dorsale.customer_vault_individual_path(@individual)
  find("a[href$=links]").click
end

When(/^I add a new link to the corporation$/) do
  find(".tab-content [href$='links/new']").click
  expect(current_path).to eq dorsale.new_customer_vault_corporation_link_path(@corporation)
end

When(/^I add a new link to the individual$/) do
  find(".tab-content [href$='links/new']").click
  expect(current_path).to eq dorsale.new_customer_vault_individual_link_path(@individual)
end

When(/^I provide the link and the target corporation$/) do
  select @corporation.name
  fill_in 'link_title', with: 'Manager'
end

When(/^I validate the link$/) do
  find("[type=submit]").click
end

When(/^I edit the link$/) do
  find(".person .pull-right .link_update").click
end

When(/^I change the title$/) do
  fill_in 'link_title', with: 'Manager 2'
end

When(/^I navigate to the link section of the corporation details$/) do
  visit dorsale.customer_vault_corporation_path(@corporation)
  find("a[href$=links]").click
end

When(/^I provide the link and the target individual$/) do
  select @individual.name
  fill_in 'link_title', with: 'Manager'
end

When(/^I delete the link$/) do
  find(".person .pull-right .link_delete").click
end

Then(/^the new link is displayed$/) do
  expect(page).to have_selector '.title', text: 'Manager'
end

Then(/^the edited link is displayed$/) do
  expect(page).to have_selector '.title', text: 'Manager 2'
end

Then(/^the targeted link is removed$/) do
  expect(page).to_not have_selector '.title', text: 'Manager'
end
