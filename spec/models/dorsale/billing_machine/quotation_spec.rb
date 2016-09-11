require "rails_helper"

describe ::Dorsale::BillingMachine::Quotation do
  it { is_expected.to belong_to :customer }
  it { is_expected.to belong_to :payment_term }
  it { is_expected.to have_many(:lines).dependent(:destroy) }

  it { is_expected.to validate_presence_of :id_card }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :state }
  it { is_expected.to ensure_inclusion_of(:state).in_array(::Dorsale::BillingMachine::Quotation::STATES) }
  it { is_expected.to respond_to :date }
  it { is_expected.to respond_to :label }
  it { is_expected.to respond_to :vat_amount }
  it { is_expected.to respond_to :comments }
  it { is_expected.to respond_to :unique_index }
  it { is_expected.to respond_to :commercial_discount }
  it { is_expected.to respond_to :total_excluding_taxes }
  it { is_expected.to respond_to :total_including_taxes }

  it "should have a valid factory" do
    expect(create(:billing_machine_quotation)).to be_valid
  end

  describe "default values" do
    it "default date should be today" do
      expect(::Dorsale::BillingMachine::Quotation.new.date).to eq Time.zone.now.to_date
    end

    it "default expires_at should be date + 1 month" do
      quotation = ::Dorsale::BillingMachine::Quotation.new(date: "21/12/2012")
      expect(quotation.expires_at).to eq Date.parse("21/01/2013")
    end

    it "default state should be pending" do
      expect(::Dorsale::BillingMachine::Quotation.new.state).to eq "pending"
    end
  end

  it "should work fine upon creation" do
    quotation = build(:billing_machine_quotation)
    quotation.lines << ::Dorsale::BillingMachine::QuotationLine.new(quantity: 1, unit_price: 10)
    quotation.lines << ::Dorsale::BillingMachine::QuotationLine.new(quantity: 1, unit_price: 10)
    quotation.save
  end

  describe 'unique_index' do
    context 'when unique index is 69' do
      it 'should be assigned upon creation' do
        quotation1 = create(:billing_machine_quotation, date: '2014-02-01', unique_index: 69)
        quotation2 = create(:billing_machine_quotation, date: '2014-02-01')
        expect(quotation2.unique_index).to eq(70)
      end
    end

    context 'when unique index is nil' do
      it 'should be assigned upon creation' do
        ::Dorsale::BillingMachine::Quotation.destroy_all
        quotation1 = create(:billing_machine_quotation, date: '2014-02-01')
        expect(quotation1.unique_index).to eq(1)
      end
    end
  end

  describe 'tracking_id' do
    it 'should return correct tracking_id' do
      quotation = create(:billing_machine_quotation, date: '2014-02-01')
      expect(quotation.tracking_id).to eq('2014-01')
    end
  end

  describe "vat rate" do
    it "default vat rate should be 20" do
      expect(::Dorsale::BillingMachine::Quotation.new.vat_rate).to eq ::Dorsale::BillingMachine::DEFAULT_VAT_RATE
    end

    it "it should be specified vat rate" do
      expect(build(:billing_machine_quotation, vat_rate: 12).vat_rate).to eq 12
    end

    it "it should be first line vat rate" do
      quotation = create(:billing_machine_quotation)
      line1   = create(:billing_machine_quotation_line, quotation: quotation, vat_rate: 10)
      line2   = create(:billing_machine_quotation_line, quotation: quotation, vat_rate: 10)
      expect(quotation.vat_rate).to eq 10
    end

    it "it should raise if multiple vat_rates" do
      quotation = create(:billing_machine_quotation)
      line1   = create(:billing_machine_quotation_line, quotation: quotation, vat_rate: 10)

      expect{
        line2   = create(:billing_machine_quotation_line, quotation: quotation, vat_rate: 15)
      }.to raise_error(RuntimeError)
    end

    it "it should raise when vat mode is multiple" do
      ::Dorsale::BillingMachine.vat_mode = :multiple
      quotation = build(:billing_machine_quotation)
      expect{ quotation.vat_rate }.to raise_error(RuntimeError)
    end
  end

  describe "totals" do
    it "should be calculated upon saving" do
      quotation = create(:billing_machine_quotation, commercial_discount: 10)

      create(:billing_machine_quotation_line,
        :vat_rate   => 20,
        :quantity   => 10,
        :unit_price => 5,
        :quotation  => quotation,
      )

      create(:billing_machine_quotation_line,
        :vat_rate   => 20,
        :quantity   => 10,
        :unit_price => 5,
        :quotation  => quotation
      )

      expect(quotation.total_excluding_taxes).to eq(90.0)
      expect(quotation.vat_amount).to eq(18)
      expect(quotation.total_including_taxes).to eq(108)
      expect(quotation.balance).to eq(108)
    end

    it "should be calculated upon saving with different vat rates" do
      Dorsale::BillingMachine.vat_mode = :multiple
      quotation = create(:billing_machine_quotation, commercial_discount: 20)
      create(:billing_machine_quotation_line,
        :quantity   => 10,
        :vat_rate   => 10,
        :unit_price => 5,
        :quotation  => quotation,
      )

      create(:billing_machine_quotation_line,
        :quantity   => 10,
        :vat_rate   => 20,
        :unit_price => 5,
        :quotation  => quotation,
      )

      expect(quotation.total_excluding_taxes).to eq(80)
      expect(quotation.vat_amount).to eq(12)
      expect(quotation.total_including_taxes).to eq(92)
      expect(quotation.balance).to eq(92)
      Dorsale::BillingMachine.vat_mode = :single
    end

    it "should work fine even with empty lines" do
      quotation = create(:billing_machine_quotation, commercial_discount: nil)

      create(:billing_machine_quotation_line,
        :quantity   => nil,
        :unit_price => nil,
        :vat_rate   => nil,
        :quotation  => quotation,
      )

      expect(quotation.total_excluding_taxes).to eq(0.0)
      expect(quotation.vat_amount).to eq(0.0)
      expect(quotation.total_including_taxes).to eq(0.0)
      expect(quotation.balance).to eq(0.0)
    end
  end

end
