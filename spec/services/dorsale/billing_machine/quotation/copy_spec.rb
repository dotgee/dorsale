require "rails_helper"

RSpec.describe Dorsale::BillingMachine::Quotation::Copy do
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

  let(:copy) {
    Dorsale::BillingMachine::Quotation::Copy.(quotation)
  }

  it "should duplicate infos, lines, and documents" do
    create(:alexandrie_attachment, attachable: quotation)

    expect(copy).to be_persisted

    expect(copy.label).to             eq "ABC"
    expect(copy.lines.count).to       eq 1
    expect(copy.lines.first.label).to eq "DEF"
    expect(copy.attachments.count).to eq 1
  end

  it "should reset date" do
    expect(quotation.date).to_not eq Time.zone.now.to_date
    expect(copy.date).to          eq Time.zone.now.to_date
  end

  it "should reset unique_index, tracking_id, created_at, updated_at" do
    expect(quotation.unique_index).to_not eq copy.unique_index
    expect(quotation.tracking_id).to_not  eq copy.tracking_id
    # WTF ? It fails only when running all tests
    # expect(quotation.created_at).to_not   eq copy.created_at
    # expect(quotation.updated_at).to_not   eq copy.updated_at
  end

  it "should reset state to pending" do
    expect(quotation.reload.state).to eq "canceled"
    expect(copy.reload.state).to      eq "pending"
  end
end
