class Dorsale::Flyboy::SmallData::FilterStrategyByStatus < ::Dorsale::SmallData::FilterStrategy
  def apply(query, value)
    if value == "closed"
      query.where(status: "closed")
    else
      query.where.not(status: "closed")
    end
  end
end
