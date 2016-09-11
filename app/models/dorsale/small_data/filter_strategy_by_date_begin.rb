class Dorsale::SmallData::FilterStrategyByDateBegin < ::Dorsale::SmallData::FilterStrategyByKeyValue
  def apply(query, value)
    value = Time.parse(value).beginning_of_day
    query.where("#{key} >= ?", value)
  end
end
