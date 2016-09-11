class Dorsale::BillingMachine::QuotationLine < ActiveRecord::Base
  self.table_name = "dorsale_billing_machine_quotation_lines"

  belongs_to :quotation, inverse_of: :lines

  validates :quotation, presence: true

  default_scope -> {
    order(:created_at => :asc)
  }

  def initialize(*)
    super
    assign_default_values
  end

  before_validation :update_total

  def assign_default_values
      self.quantity   ||= 0
      self.unit_price ||= 0
      self.vat_rate ||= ::Dorsale::BillingMachine::DEFAULT_VAT_RATE
  end

  def update_total
    assign_default_values
    self.total = self.quantity * self.unit_price
  end

  after_save :update_quotation_total

  def update_quotation_total
    self.quotation.reload.save!
  end

end
