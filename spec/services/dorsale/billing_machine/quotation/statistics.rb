require "rails_helper"

describe Dorsale::BillingMachine::Quotation::Statistics do
  let(:statistics) {
    Dorsale::BillingMachine::Quotation::Statistics.new(Dorsale::BillingMachine::Quotation.all)
  }

  it "stats should not include canceled quotations" do
    q1 = create(:billing_machine_quotation_line, quantity: 1, unit_price: 10)
    q1.quotation.update!(state: "pending")

    q2 = create(:billing_machine_quotation_line, quantity: 1, unit_price: 10)
    q2.quotation.update!(state: "canceled")

    expect(statistics.total_excluding_taxes).to eq 10
  end

  it "stats should be 0 if no quotations" do
    expect(statistics.total_excluding_taxes).to eq 0
    expect(statistics.vat_amount).to eq 0
    expect(statistics.total_including_taxes).to eq 0
  end
end
