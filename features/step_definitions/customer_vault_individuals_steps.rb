When(/^I create an new individual$/) do
  @individuals_count = Dorsale::CustomerVault::Individual.count

  visit dorsale.new_customer_vault_individual_path
end

When(/^I add his first_name, last_name and email$/) do
  fill_in 'person_first_name', with: 'Benoit'
  fill_in 'person_last_name', with: 'Gantaume'
  fill_in 'person_email', with: 'benoit@agilidee.com'
end

When(/^I fill the address$/) do
  fill_in 'person_address_attributes_street', with: '3 Rue Marx Dormoy'
  fill_in 'person_address_attributes_street_bis', with: ''
  fill_in 'person_address_attributes_city', with: 'Marseille'
  fill_in 'person_address_attributes_zip', with: '13004'
  fill_in 'person_address_attributes_country', with: 'France'
end

When(/^I validate the new individual$/) do
  find("[type=submit]").click
end

Then(/^i see an error message for the missing names$/) do
  expect(page).to have_selector ".person_first_name.has-error"
  expect(page).to have_selector ".person_last_name.has-error"
end

Then(/^the individual is created$/) do
  expect(Dorsale::CustomerVault::Individual.count).to eq(@individuals_count + 1)

  @individual = Dorsale::CustomerVault::Individual.reorder(:id).last

  expect(@individual.first_name).to eq "Benoit"
  expect(@individual.last_name).to eq "Gantaume"
end

Given(/^an existing individual$/) do
  @individual = create(:customer_vault_individual)
end

When(/^I edit this individual$/) do
  visit dorsale.edit_customer_vault_individual_path(@individual)
end

When(/^I add tags to this individual$/) do
  page.execute_script %(
    $("#person_tag_list").append("<option value='mytag1'>mytag1</option>")
    $("#person_tag_list").append("<option value='mytag2'>mytag2</option>")
  )

  select "mytag1"
  select "mytag2"
end

When(/^I submit this individual$/) do
  find("[type=submit]").click
end

Given(/^an existing individual with tags$/) do
  @individual = create(:customer_vault_individual, tag_list: "mytag1, mytag2")
end

When(/^I remove tags to this individual$/) do
  unselect "mytag1"
end

When(/^I go on this individual$/) do
  visit dorsale.customer_vault_individual_path(@individual)
end

