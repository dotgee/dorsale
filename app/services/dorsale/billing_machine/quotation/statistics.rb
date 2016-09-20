class Dorsale::BillingMachine::Quotation::Statistics
  attr_accessor :quotation

  def initialize(quotations)
    @quotations = quotations
  end

  def total_excluding_taxes
    @total_excluding_taxes ||= @quotations
      .where.not(state: "canceled")
      .pluck(:total_excluding_taxes)
      .delete_if(&:blank?)
      .sum
  end

  def vat_amount
    @vat_amount ||= @quotations
      .where.not(state: "canceled")
      .pluck(:vat_amount)
      .delete_if(&:blank?)
      .sum
  end

  def total_including_taxes
    @total_including_taxes ||= @quotations
      .where.not(state: "canceled")
      .pluck(:total_including_taxes)
      .delete_if(&:blank?)
      .sum
  end

  def t(*args)
    ::Dorsale::BillingMachine::Quotation.t(*args)
  end
end
