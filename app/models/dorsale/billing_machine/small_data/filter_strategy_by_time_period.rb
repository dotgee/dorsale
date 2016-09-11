class Dorsale::BillingMachine::SmallData::FilterStrategyByTimePeriod < ::Dorsale::SmallData::FilterStrategyByKeyValue
  def apply(query, value)
    criteria = "#{query.model.table_name}.#{key}"

    if value == "today"
      return query.where("#{criteria} >= ?", Time.zone.now.to_date)
    elsif value == "week"
      return query.where("#{criteria} >= ?", Time.zone.now.to_date.at_beginning_of_week)
    elsif value == "month"
      return query.where("#{criteria} >= ?", Time.zone.now.to_date.at_beginning_of_month)
    else
      return query
    end
  end
end
