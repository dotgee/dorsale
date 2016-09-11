require "rails_helper"

describe ::Dorsale::BillingMachine::InvoiceMultipleVatPdf, pdfs: true do
  before :each do
    ::Dorsale::BillingMachine.vat_mode = :multiple
  end

  let(:invoice) {
    i = create(:billing_machine_invoice)

    create(:billing_machine_invoice_line,
      :invoice  => i,
      :vat_rate => 19.6,
    )

    i
  }

  let(:content) {
    tempfile = Tempfile.new("pdf")
    tempfile.binmode
    tempfile.write(invoice.to_pdf)
    tempfile.flush
    Yomu.new(tempfile.path).text
  }

  it "should not display global vat rate" do
    expect(content).to_not include "TVA 19,60 %"
    expect(content).to include "MONTANT TVA"
    expect(content).to include "TVA %"
  end

  it "should work with empty invoice" do
    id_card = Dorsale::BillingMachine::IdCard.new
    invoice = ::Dorsale::BillingMachine::Invoice.new(id_card: id_card)

    expect {
      invoice.to_pdf
    }.to_not raise_error
  end

end
