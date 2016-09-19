class Dorsale::ExpenseGun::SmallData::FilterForExpenses < ::Dorsale::SmallData::Filter
  STRATEGIES = {
    "expense_state"   => ::Dorsale::SmallData::FilterStrategyByKeyValue.new("state"),
    "expense_user_id" => ::Dorsale::SmallData::FilterStrategyByKeyValue.new("user_id"),
  }
end
