require "rails_helper"

describe ::Dorsale::BillingMachine::Invoice, type: :model do
  # Reset to default mode before each test
  before :each do
    ::Dorsale::BillingMachine.vat_mode = :single
  end

  it { is_expected.to belong_to :customer }
  it { is_expected.to belong_to :payment_term }
  it { is_expected.to have_many(:lines).dependent(:destroy) }

  it { is_expected.to validate_presence_of :id_card }
  it { is_expected.to validate_presence_of :date }

  it { is_expected.to respond_to :date }
  it { is_expected.to respond_to :label }
  it { is_expected.to respond_to :vat_amount }
  it { is_expected.to respond_to :unique_index }
  it { is_expected.to respond_to :commercial_discount }

  it {is_expected.to respond_to :total_excluding_taxes}
  it {is_expected.to respond_to :total_including_taxes}

  it { is_expected.to respond_to :advance }

  it "should have a valid factory" do
    expect(create(:billing_machine_invoice)).to be_valid
  end

  describe "unique_index" do
    context "when unique index is 69" do
      it "should be assigned upon creation" do
        invoice1 = create(:billing_machine_invoice, date: "2014-02-01", unique_index: 69)
        invoice2 = create(:billing_machine_invoice, date: "2014-02-01")
        expect(invoice2.unique_index).to eq(70)
      end
    end

    context "when unique index is nil" do
      it "should be assigned upon creation" do
        ::Dorsale::BillingMachine::Invoice.destroy_all
        invoice1 = create(:billing_machine_invoice, date: "2014-02-01")
        expect(invoice1.unique_index).to eq(1)
      end
    end
  end

  describe "tracking_id" do
    it "should return correct tracking_id" do
      invoice = create(:billing_machine_invoice, date: "2014-02-01")
      expect(invoice.tracking_id).to eq("2014-01")
    end
  end

  describe "payment_status" do
    it "should be pending if nothing special" do
      invoice = create(:billing_machine_invoice, due_date: Time.zone.now.to_date, date: Time.zone.now.to_date, paid: false)
      expect(invoice.payment_status).to eq(:pending)
    end

    it "should be late if a bit late" do
        invoice = create(:billing_machine_invoice, due_date: Time.zone.now.to_date-1, date: Time.zone.now.to_date-1, paid: false)
        expect(invoice.payment_status).to eq(:late)
    end

    it "should be on_alert if a too late" do
        invoice = create(:billing_machine_invoice, due_date: Time.zone.now.to_date-16, date: Time.zone.now.to_date-16, paid: false)
        expect(invoice.payment_status).to eq(:on_alert)
    end

    it "should be paid if paid" do
        invoice = create(:billing_machine_invoice, due_date: Time.zone.now.to_date-16, date: Time.zone.now.to_date-16, paid: true)
        expect(invoice.payment_status).to eq(:paid)
    end

    it "should be on_alert if no due date is defined" do
        invoice = create(:billing_machine_invoice, due_date: nil, date: Time.zone.now.to_date, paid: false)
        expect(invoice.payment_status).to eq(:on_alert)
    end

    it "should be on_alert if no due date is defined" do
        invoice = create(:billing_machine_invoice, due_date: nil, date: Time.zone.now.to_date, paid: true)
        expect(invoice.payment_status).to eq(:paid)
    end

    it "should work fine upon creation" do
      invoice = build(:billing_machine_invoice)
      invoice.lines << ::Dorsale::BillingMachine::InvoiceLine.new(quantity: 1, unit_price: 10)
      invoice.lines << ::Dorsale::BillingMachine::InvoiceLine.new(quantity: 1, unit_price: 10)
      invoice.save
    end
  end

  describe "paid" do
    it "should be false by default" do
      invoice = create(:billing_machine_invoice)
      expect(invoice.paid).to eq(false)
    end
  end

  describe "vat rate" do
    it "default vat rate should be 20" do
      expect(::Dorsale::BillingMachine::Invoice.new.vat_rate).to eq ::Dorsale::BillingMachine::DEFAULT_VAT_RATE
    end

    it "it should be specified vat rate" do
      expect(build(:billing_machine_invoice, vat_rate: 12).vat_rate).to eq 12
    end

    it "it should be first line vat rate" do
      invoice = create(:billing_machine_invoice)
      line1   = create(:billing_machine_invoice_line, invoice: invoice, vat_rate: 10)
      line2   = create(:billing_machine_invoice_line, invoice: invoice, vat_rate: 10)
      expect(invoice.vat_rate).to eq 10
    end

    it "it should raise if multiple vat_rates" do
      invoice = create(:billing_machine_invoice)
      line1   = create(:billing_machine_invoice_line, invoice: invoice, vat_rate: 10)

      expect{
        line2   = create(:billing_machine_invoice_line, invoice: invoice, vat_rate: 15)
      }.to raise_error(RuntimeError)
    end

    it "it should raise when vat mode is multiple" do
      ::Dorsale::BillingMachine.vat_mode = :multiple
      invoice = build(:billing_machine_invoice)
      expect{ invoice.vat_rate }.to raise_error(RuntimeError)
    end
  end

  describe "totals" do
    it "should be calculated upon saving with advance" do
      invoice = create(:billing_machine_invoice,
        :commercial_discount => 10,
        :advance             => 40,
      )

      create(:billing_machine_invoice_line,
        :quantity   => 10,
        :unit_price => 5,
        :vat_rate   => 20,
        :invoice    => invoice,
      ) #total 50

      create(:billing_machine_invoice_line,
        :quantity   => 10,
        :unit_price => 5,
        :vat_rate   => 20,
        :invoice    => invoice,
      ) # total 50

      expect(invoice.total_excluding_taxes).to eq(90.0)
      expect(invoice.vat_amount).to eq(18)
      expect(invoice.total_including_taxes).to eq(108)
      expect(invoice.balance).to eq(68)
    end

    it "should be calculated upon saving without advance" do
      invoice = create(:billing_machine_invoice,
        :commercial_discount => 10,
      )

      create(:billing_machine_invoice_line,
        :quantity   => 10,
        :unit_price => 5,
        :vat_rate   => 20,
        :invoice    => invoice,
      ) #total 50

      create(:billing_machine_invoice_line,
        :quantity   => 10,
        :unit_price => 5,
        :vat_rate   => 20,
        :invoice    => invoice,
      ) # total 50

      expect(invoice.total_excluding_taxes).to eq(90.0)
      expect(invoice.vat_amount).to eq(18)
      expect(invoice.total_including_taxes).to eq(108)
      expect(invoice.balance).to eq(108)
    end

    it "should work fine even with empty lines" do
      invoice = create(:billing_machine_invoice)

      create(:billing_machine_invoice_line, invoice: invoice, quantity: nil, unit_price: nil)

      expect(invoice.total_excluding_taxes).to eq(0.0)
      expect(invoice.vat_amount).to eq(0)
      expect(invoice.total_including_taxes).to eq(0)
      expect(invoice.balance).to eq(0)
    end
  end

end
