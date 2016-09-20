class Dorsale::BillingMachine::Invoice::Statistics
  attr_accessor :invoice

  def initialize(invoices)
    @invoices = invoices
  end

  def total_excluding_taxes
    @total_excluding_taxes ||= @invoices
      .pluck(:total_excluding_taxes)
      .delete_if(&:blank?)
      .sum
  end

  def vat_amount
    @vat_amount ||= @invoices
      .pluck(:vat_amount)
      .delete_if(&:blank?)
      .sum
  end

  def total_including_taxes
    @total_including_taxes ||= @invoices
      .pluck(:total_including_taxes)
      .delete_if(&:blank?)
      .sum
  end

  def t(*args)
    ::Dorsale::BillingMachine::Invoice.t(*args)
  end
end
