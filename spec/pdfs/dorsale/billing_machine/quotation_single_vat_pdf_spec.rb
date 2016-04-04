require "rails_helper"

describe ::Dorsale::BillingMachine::QuotationSingleVatPdf, pdfs: true do
  before :each do
    ::Dorsale::BillingMachine.vat_mode = :single
  end

  let(:quotation) {
    q = create(:billing_machine_quotation)

    create(:billing_machine_quotation_line,
      :quotation => q,
      :vat_rate  => 19.6,
    )

    q
  }

  let(:pdf) {
    quotation.pdf
  }

  let(:content) {
    tempfile = Tempfile.new("pdf")
    tempfile.binmode
    tempfile.write(pdf.render)
    tempfile.flush
    Yomu.new(tempfile.path).text
  }

  it "should display global vat rate" do
    expect(content).to include "TVA 19,60 %"
    expect(content).to_not include "MONTANT TVA"
    expect(content).to_not include "TVA %"
  end

  it "should work with empty quotation" do
    id_card = Dorsale::BillingMachine::IdCard.new
    quotation = ::Dorsale::BillingMachine::Quotation.new(id_card: id_card)

    expect {
      quotation.pdf.render
    }.to_not raise_error
  end

  describe "attachment" do
    it "should build attachments" do
      quotation  = create(:billing_machine_quotation)
      attachment = create(:alexandrie_attachment, attachable: quotation)
      pdf = quotation.pdf
      pdf.build

      text = Yomu.read(:text, pdf.render_with_attachments).split("\n")
      expect(text).to include "page 1"
      expect(text).to include "page 2"
    end
  end

end



