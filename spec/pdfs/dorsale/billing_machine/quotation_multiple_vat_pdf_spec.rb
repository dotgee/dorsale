require "rails_helper"

describe ::Dorsale::BillingMachine::QuotationMultipleVatPdf, pdfs: true do
  before :each do
    ::Dorsale::BillingMachine.vat_mode = :multiple
  end

  let(:quotation) {
    q = create(:billing_machine_quotation)

    create(:billing_machine_quotation_line,
      :quotation => q,
      :vat_rate  => 19.6,
    )

    q
  }

  let(:content) {
    tempfile = Tempfile.new("pdf")
    tempfile.binmode
    tempfile.write(quotation.to_pdf)
    tempfile.flush
    Yomu.new(tempfile.path).text
  }

  it "should not display global vat rate" do
    expect(content).to_not include "TVA 19,60 %"
    expect(content).to include "MONTANT TVA"
    expect(content).to include "TVA %"
  end

  it "should work with empty quotation" do
    id_card = Dorsale::BillingMachine::IdCard.new
    quotation = ::Dorsale::BillingMachine::Quotation.new(id_card: id_card)

    expect {
      quotation.to_pdf
    }.to_not raise_error
  end

end
