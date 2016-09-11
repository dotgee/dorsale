Given(/^the user goes on the new id_card page$/) do
  visit dorsale.billing_machine_id_cards_path
  find(".link_create").click
end

Given(/^an existing id_card$/) do
  @id_card = create(:billing_machine_id_card)
end

When(/^he fills the id_card's information$/) do
  fill_in 'billing_machine_id_card_id_card_name', with: "Id Card name"
  fill_in 'billing_machine_id_card_entity_name', with: "Id Card entity name"
  fill_in 'billing_machine_id_card_contact_full_name', with: "Id Card contact full name"
end

When(/^creates a new id_card$/) do
  find("[type=submit]").click
end

Then(/^he is redirected on the id_cards page$/) do
  expect(current_path).to eq dorsale.billing_machine_id_cards_path
end

Then(/^the id_card is added to the id_card list$/) do
  expect(page).to have_content "Id Card name"
  expect(page).to have_content "Id Card entity name"
  expect(page).to have_content "Id Card contact full name"

end

Then(/^the current id_card's label should be pre\-filled$/) do
  expect(page).to have_field("billing_machine_id_card_id_card_name", with: @id_card.id_card_name)
  expect(page).to have_field("billing_machine_id_card_entity_name", with: @id_card.entity_name)
  expect(page).to have_field("billing_machine_id_card_contact_full_name", with: @id_card.contact_full_name)
end

When(/^the user edits the id_card$/) do
  visit dorsale.billing_machine_id_cards_path
  find(".link_update").click
end

When(/^he validates the new id_card$/) do
  fill_in "billing_machine_id_card_id_card_name", with: "New Id Card Name"
  fill_in "billing_machine_id_card_entity_name", with: "New Id Card Entity Name"
  fill_in "billing_machine_id_card_contact_full_name", with: "New Id Card Contact Full Name"
  find("[type=submit]").click
end

Then(/^the id_card's label is updated$/) do
  expect(page).to have_content "New Id Card Name"
  expect(page).to have_content "New Id Card Entity Name"
  expect(page).to have_content "New Id Card Contact Full Name"
end