class Dorsale::SmallData::FilterStrategyByDate < ::Dorsale::SmallData::FilterStrategyByKeyValue
  def apply(query, value)
    value = Date.parse(value)
    super(query, value)
  end
end
