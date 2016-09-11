class Dorsale::BillingMachine::SmallData::FilterStrategyByCustomer < ::Dorsale::SmallData::FilterStrategy
  def apply(query, value)
    type, id = value.split("-")
    query.where(customer_type: type, customer_id: id)
  end
end
