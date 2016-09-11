Given(/^the user goes on the new payment_term page$/) do
  visit dorsale.billing_machine_payment_terms_path
  find(".link_create").click
end

When(/^he fills the payment_term's information$/) do
  fill_in 'billing_machine_payment_term_label', with: "Payment Term Label"
end

When(/^creates a new payment_term$/) do
  find("[type=submit]").click
end

Then(/^he is redirected on the payment_terms page$/) do
  expect(current_path).to eq dorsale.billing_machine_payment_terms_path
end

Then(/^the payment_term is added to the payment_term list$/) do
  expect(page).to have_content "Payment Term Label"
end

Given(/^an existing payment_term$/) do
  @payment_term = create(:billing_machine_payment_term)
end

When(/^the user edits the payment_term$/) do
  visit dorsale.billing_machine_payment_terms_path
  find(".link_update").click
end

Then(/^the current payment_term's label should be pre\-filled$/) do
  expect(page).to have_field("billing_machine_payment_term_label", with: @payment_term.label)
end

When(/^he validates the new payment_term$/) do
  fill_in "billing_machine_payment_term_label", with: "New Payment Term Label"
  find("[type=submit]").click
end

Then(/^the payment_term's label is updated$/) do
  expect(page).to have_content "New Payment Term Label"
end