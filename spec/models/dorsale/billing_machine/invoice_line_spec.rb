require "rails_helper"

describe ::Dorsale::BillingMachine::InvoiceLine, type: :model do
  it { is_expected.to belong_to :invoice }
  it { is_expected.to validate_presence_of :invoice }

  it { is_expected.to respond_to :quantity }
  it { is_expected.to respond_to :label }
  it { is_expected.to respond_to :vat_rate }
  it { is_expected.to respond_to :total }
  it { is_expected.to respond_to :unit }
  it { is_expected.to respond_to :unit_price }

  it "should have a valid factory" do
    expect(build(:billing_machine_invoice_line)).to be_valid
  end

  describe "default values" do
    it "quantity should be 0" do
      expect(::Dorsale::BillingMachine::InvoiceLine.new.quantity).to eq 0
    end

    it "unit_price should be 0" do
      expect(::Dorsale::BillingMachine::InvoiceLine.new.unit_price).to eq 0
    end

    it "vat_rate should be 0" do
      expect(::Dorsale::BillingMachine::InvoiceLine.new.vat_rate).to eq ::Dorsale::BillingMachine::DEFAULT_VAT_RATE
    end
  end

  it "should be sorted by created_at" do
    line1 = create(:billing_machine_invoice_line, :created_at => Time.zone.now + 1.minutes)
    line2 = create(:billing_machine_invoice_line, :created_at => Time.zone.now + 2.minutes)
    line3 = create(:billing_machine_invoice_line, :created_at => Time.zone.now + 3.minutes)
    line4 = create(:billing_machine_invoice_line, :created_at => Time.zone.now + 4.minutes)
    line3.update!(:created_at => Time.zone.now + 5.minutes)

    lines = ::Dorsale::BillingMachine::InvoiceLine.all
    expect(lines).to eq [line1, line2, line4, line3]
  end

  it "should update the total upon save" do
    invoice = create(:billing_machine_invoice_line, quantity: 10, unit_price: 10, total: 0)
    expect(invoice.total).to eq(100)
  end

  it "should update the total gracefully with invalid data" do
    invoice = create(:billing_machine_invoice_line, quantity: nil, unit_price: nil, total: 0)
    expect(invoice.total).to eq(0)
  end
end
