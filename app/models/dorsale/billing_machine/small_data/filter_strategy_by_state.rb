class Dorsale::BillingMachine::SmallData::FilterStrategyByState < ::Dorsale::SmallData::FilterStrategy
  def apply(query, value)
    if value.to_s.match(/not_(.+)/)
      query.where("state != ?", $~[1])
    else
      query.where(state: value)
    end
  end
end
