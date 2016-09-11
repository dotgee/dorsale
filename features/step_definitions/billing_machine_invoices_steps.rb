Given(/^an existing emtpy invoice$/) do
  @invoice = create(:billing_machine_invoice, label: nil, customer: nil, payment_term_id: nil, id_card: @id_card)
  @invoice.due_date = nil
  @invoice.save
end

Given(/^(\d+) existing invoices$/) do |count|
  create_list(:billing_machine_invoice, count.to_i, id_card: @id_card)
end

Given(/^an existing invoice$/) do
  @invoice = create(:billing_machine_invoice, id_card: @id_card, customer: @customer)
  @invoice.lines.create(quantity: 1, unit_price: 9.99)
end

Given(/^an existing invoice with a "(.*?)"% VAT rate$/) do |rate|
  @invoice = create(:billing_machine_invoice, id_card: @id_card)
  create(:billing_machine_invoice_line, vat_rate: rate, invoice: @invoice)
end

Given(/^an existing paid invoice$/) do
  @invoice = create(:billing_machine_invoice, id_card: @id_card, paid: true)
end

Given(/^billing machine in single vat mode$/) do
  ::Dorsale::BillingMachine.vat_mode = :single
end

Given(/^a bunch of existing invoices$/) do
  c1 = create(:customer_vault_corporation, name: 'Bidule')
  c2 = create(:customer_vault_corporation, name: 'Machin')
  c3 = create(:customer_vault_corporation, name: 'Chose')

  i1 = create(:customer_vault_individual, first_name: 'Oh')
  i2 = create(:customer_vault_individual, first_name: 'Ah')
  i3 = create(:customer_vault_individual, first_name: 'Eh')

  create(:billing_machine_invoice, id_card: @id_card, customer: c1, date: Time.zone.now.to_date, paid: true)
  create(:billing_machine_invoice, id_card: @id_card, customer: c2, date: Time.zone.now.to_date)
  create(:billing_machine_invoice, id_card: @id_card, customer: c3, date: Time.zone.now.to_date)
  create(:billing_machine_invoice, id_card: @id_card, customer: c1, date: Time.zone.now.to_date - 2.days)

  create(:billing_machine_invoice, id_card: @id_card, customer: i1, date: Time.zone.now.to_date - 3.days)
  create(:billing_machine_invoice, id_card: @id_card, customer: i2, date: Time.zone.now.to_date - 3.days)
  create(:billing_machine_invoice, id_card: @id_card, customer: i3, date: Time.zone.now.to_date - 3.days)
end

Given(/^an existing unpaid invoice$/) do
  @invoice = create(:billing_machine_invoice, id_card: @id_card, paid: false)
end

Given(/^its due date is not yet passed$/) do
  @invoice.update!(due_date: (Time.zone.now.to_date + 1))
end

Given(/^its due date is the same day$/) do
  @invoice.update!(due_date: (Time.zone.now.to_date))
end

Given(/^its due date is yesterday$$/) do
  @invoice.update!(due_date: (Time.zone.now.to_date - 1))
end

Given(/^its due date is (\d+) days ago$/) do |days|
  @invoice.update!(due_date: (Time.zone.now.to_date - days.to_i))
end

Given(/^existing "(.*?)" invoices with "(.*?)" amount$/) do |n, amount|
  n.to_i.times do
    invoice = create(:billing_machine_invoice, advance: 0)
    invoice_line = create(:billing_machine_invoice_line,
      invoice: invoice,
      quantity: 1,
      unit_price: amount,
      total: nil
    )
  end
end

When(/^(the user|he) goes to the invoices page$/) do |arg1|
  visit dorsale.billing_machine_invoices_path
end

When(/^he creates a new invoice$/) do
  find(".link_create").click
end

When(/^he fills the reference, the date, the vat rate and the payment terms$/) do
  fill_in 'invoice_label', with: @label = 'My reference'
  fill_in 'invoice_date', with: @date = '01/01/2014'
  fill_in 'invoice_vat_rate', with: '20'
  select @payment_term.label
end

When(/^he chooses the customer$/) do
  select @customer.name
end

When(/^the user goes to the invoice details$/) do
  visit dorsale.billing_machine_invoice_path(@invoice)
end

When(/^wants to copy it$/) do
  find(".link_copy").click
end

When(/^he fills a line with "(.*?)", "(.*?)", "(.*?)", "(.*?)"$/) do |label, quantity, unit, unit_price|
  within all('.line').last do
    find(".line-label textarea").set label
    find(".line-quantity input").set  quantity
    find(".line-unit input").set  unit
    find(".line-unit_price input").set unit_price
  end
end

When(/^he goes on the edit page of the invoice$/) do
  visit dorsale.edit_billing_machine_invoice_path(@invoice)
end

When(/^changes the label$/) do
  @new_label=  @invoice.label + " Edited"
  fill_in 'invoice_label', with: @new_label
end

When(/^he changes the VAT rate to "(.*?)"$/) do |new_rate|
  fill_in 'invoice_vat_rate', with: new_rate
end

When(/^he changes the commercial discount to "(.*?)"€$/) do |arg1|
  fill_in 'invoice_commercial_discount', with: arg1
end

When(/^he adds a new line$/) do
  click_link 'add-new-line'
end

When(/^he saves the invoice$/) do
  find("[type=submit]").click
end

When(/^he finds and clicks on the download CSV export file$/) do
  find("[href$=csv]").click
end

When(/^he set the invoice as paid$/) do
  find("[href$=pay]").click
end

When(/^he marks the invoice as unpaid$/) do
  within '.form-group.select.invoice_paid' do
    select 'No'
  end
end

When(/^he changes the advance to "(.*?)"€$/) do |value|
  fill_in 'invoice_advance', with: value
end

When(/^he goes to the newly created invoice page$/) do
  @invoice = ::Dorsale::BillingMachine::Invoice.unscoped.order(:id).last
  visit dorsale.edit_billing_machine_invoice_path(@invoice)
end

When(/^he filters by date on today$/) do
  select "Aujourd'hui"
  find(".filter-submit").click
end

When(/^he filters by one customer$/) do
  within('.filters') do
    select('Bidule')
    find(".filter-submit").click
  end
end

When(/^he filters by status on paid$/) do
  within('.filters') do
    select('Payée')
    find(".filter-submit").click
  end
end

When(/^the user download the pdf$/) do
  visit dorsale.billing_machine_invoice_path(@invoice)
  find(".link_download").click
end

Then(/^he should see (\d+) invoices$/) do |count|
  expect(page).to have_selector '.invoice', count: count
end

Then(/^the invoice is displayed correctly$/) do
  expect(page).to have_selector '.tracking_id', @invoice.tracking_id
end

Then(/^the total excluding taxes is "(.*?)"$/) do |total|
  expect(find(".total_excluding_taxes input").value).to eq total
end

Then(/^the VAT due is "(.*?)"$/) do |vat|
  expect(find(".vat_amount input").value).to eq vat
end

Then(/^the total including taxes is "(.*?)"$/) do |total|
  expect(find(".total_including_taxes input").value).to eq total
end

Then(/^he fill the commercial discount with "(.*?)"$/) do |value|
  find(".commercial_discount input").set value
end

Then(/^it's added to the invoice list$/) do
  step('the user goes to the invoices page')
  expect(page).to have_selector '.invoice .date', text: @date
  # There are no other invoices for this test so we should get the right number
  tracking_id = ::Dorsale::BillingMachine::Invoice.first.tracking_id
  expect(page).to have_selector '.invoice .tracking_id', text: tracking_id
  expect(page).to have_selector '.invoice .customer_name', text: @customer.name
  expect(page).to have_selector '.invoice .total_excluding_taxes', text: '180,00 €'
end

Then(/^the commercial discount is "(.*?)"€$/) do |discount|
   expect( find(".commercial_discount input").value).to eq discount
end

Then(/^the invoices's label has changed$/) do
  visit dorsale.edit_billing_machine_invoice_path(@invoice)
  expect(page).to have_field('invoice_label', with: @new_label)
end

Then(/^the VAT rate is "(.*?)"$/) do |rate|
  expect( find(".vat_rate input").value).to eq rate
end

Then(/^the new line total is "(.*?)"$/) do |value|
  within all('.line').last do
    expect( find(".line-total input").value).to eq value
  end
end

Then(/^the invoice is marked paid$/) do
  expect(page).to have_selector '.paid'
end

Then(/^can't set the invoice as paid again$/) do
  expect(page).to_not have_selector("[href$=pay]")
end

Then(/^the invoice is marked unpaid$/) do
  expect(page).to_not have_selector '.paid'
end

Then(/^the invoice status is set to unpaid$/) do
  expect(@invoice.reload.paid?).to be false
end

Then(/^the invoice status is set to paid$/) do
  expect(@invoice.reload.paid?).to be true
end

Then(/^a message signals the success of the update$/) do
  expect(find('.alert-success')).to be_visible
end

Then(/^a message signals the success of the creation$/) do
  expect(find('.alert-success')).to be_visible
end

Then(/^a message signals that the invoice is set to paid$/) do
  expect(find('.alert-success')).to be_visible
end

Then(/^the advance is "(.*?)"€$/) do |advance|
  expect( find(".advance input").value).to eq advance
end

Then(/^the balance is "(.*?)"$/) do |balance|
  expect( find(".balance input").value).to eq balance
end

Then(/^the invoice line shows the right date$/) do
  expect(page).to have_selector '.date' , text: I18n.l(@invoice.date)
end

Then(/^the invoice line shows the right traking-id$/) do
  expect(page).to have_selector '.tracking_id' , text: @invoice.tracking_id
end

Then(/^the invoice line shows the right total excluding taxes value$/) do
  expect(page).to have_selector '.total_excluding_taxes' , text: "9,99 €"
end

Then(/^the invoice line shows the right total including taxes value$/) do
  expect(page).to have_selector '.total_including_taxes' , text: "11,99 €" #@invoice.total_all_taxes pb d'arrondi
end

Then(/^the invoice line shows the right customer's name$/) do
  expect(page).to have_selector '.customer_name', text: @customer.name
end

Then(/^the invoice default date is set to today's date\.$/) do
  expect(page).to have_field('invoice_date', with: I18n.l(Time.zone.now.to_date))
end

Then(/^the invoice default due date is set to today's date\.$/) do
  expect(page).to have_field('invoice_due_date', with: I18n.l(Time.zone.now.to_date + 30.days))
end

Then(/^a new invoice is displayed with the informations$/) do
  expect(page).to have_field('invoice_label', with: @invoice.label)
end

Then(/^he can see all the informations$/) do
  expect(page).to have_selector '.invoice-label', @invoice.label
end

Then(/^only the invoices of this customer do appear$/) do
  expect(page).to have_selector(".customer_name", text: 'Bidule', count: 2)
end

Then(/^only the invoices of today do appear$/) do
  expect(page).to have_selector(".invoice", count: 3)
end

Then(/^only the invoices paid do appear$/) do
  expect(page).to have_selector(".invoice", count: 1)
end

Then(/^the invoice paid status should not have a color$/) do
  expect(find(".invoice")[:class]).to_not include("paid", "late", "onalert")
end

Then(/^the invoice status should be "(.*?)"$/) do |color|
  expect(find(".invoice")[:class]).to include(color)
end

Then(/^the PDF should have the filename "([^\"]*)"$/) do |filename|
  expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
end

Then(/^data total amount is "(.*?)"$/) do |text|
  expect(page).to have_content text
end

When(/^he send invoice to customer by email$/) do
  ActionMailer::Base.deliveries.clear

  @invoice.customer = create(:customer_vault_corporation, email: "aaa@example.org")
  @invoice.save!

  find("[href$=email]").click
  fill_in :email_subject, with: "abc"
  fill_in :email_body, with: "def"
  find("[type=submit]").click
end

Then(/^an invoice is sent to customer$/) do
  expect(ActionMailer::Base.deliveries.count).to eq 1
  email = ActionMailer::Base.deliveries.first

  expect(email.to).to include "aaa@example.org"
  expect(email.subject).to eq "abc"
  expect(email.parts.first.body).to eq "def"
  expect(email.attachments.count).to eq 1
end
