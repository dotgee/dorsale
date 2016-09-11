class Dorsale::Flyboy::SmallData::FilterStrategyByDone < ::Dorsale::SmallData::FilterStrategy
  def apply(query, value)
    value = (value == "closed")
    query.where(done: value)
  end
end
