require "rails_helper"

RSpec.describe Dorsale::BillingMachine::Quotation::ToInvoice do
  let(:quotation) {
    quotation = create(:billing_machine_quotation)

    quotation.update_columns(
      :label      => "ABC",
      :date       => 3.days.ago,
      :state      => "canceled",
      :created_at => 3.days.ago,
      :updated_at => 3.days.ago,
    )

    line = create(:billing_machine_quotation_line,
      :quotation => quotation,
      :label     => "DEF",
    )

    quotation
  }

  let(:invoice) {
    Dorsale::BillingMachine::Quotation::ToInvoice.(quotation)
  }

  it "should convert quotation to invoice" do
    expect(invoice).to     be_a Dorsale::BillingMachine::Invoice
    expect(invoice).to_not be_persisted
    expect(invoice.label).to             eq "ABC"
    expect(invoice.lines.length).to      eq 1
    expect(invoice.lines.first.label).to eq "DEF"
  end

  it "should reset date" do
    expect(quotation.date).to_not eq Time.zone.now.to_date
    expect(invoice.date).to       eq Time.zone.now.to_date
  end

  it "should reset unique_index, tracking_id, created_at, updated_at" do
    expect(invoice.unique_index).to_not eq quotation.unique_index
    expect(invoice.tracking_id).to_not  eq quotation.tracking_id
    expect(invoice.created_at).to_not   eq quotation.created_at
    expect(invoice.updated_at).to_not   eq quotation.updated_at
  end
end
