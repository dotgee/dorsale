class Dorsale::BillingMachine::Quotation::ToInvoice < ::Dorsale::Service
  attr_accessor :quotation, :invoice

  def initialize(quotation)
    @quotation = quotation
  end

  def call
    @invoice = Dorsale::BillingMachine::Invoice.new

    quotation.attributes.each do |k, v|
      next if k.to_s == "id"
      next if k.to_s.match /index|tracking|state/
      next if k.to_s.end_with?("_at")

      if invoice.respond_to?("#{k}=")
        invoice.public_send("#{k}=", v)
      end
    end

    quotation.lines.each do |quotation_line|
      invoice_line = invoice.lines.new

      quotation_line.attributes.each do |k, v|
        next if k.to_s == "id"
        next if k.to_s.match /index|tracking|state/
        next if k.to_s.end_with?("_at")

        if invoice_line.respond_to?("#{k}=")
          invoice_line.public_send("#{k}=", v)
        end
      end
    end

    invoice.date = Time.zone.now.to_date

    invoice
  end
end
