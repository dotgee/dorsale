class Dorsale::BillingMachine::Invoice::Copy < ::Dorsale::Service
  attr_accessor :invoice, :copy

  def initialize(invoice)
    @invoice = invoice
  end

  def call
    @copy = invoice.dup

    @invoice.lines.each do |line|
      @copy.lines << line.dup
    end

    @copy.date         = Time.zone.now.to_date
    @copy.due_date     = Time.zone.now.to_date + 30.days
    @copy.unique_index = nil
    @copy.paid         = false

    @copy
  end
end
