class Dorsale::BillingMachine::SmallData::FilterForQuotations < ::Dorsale::SmallData::Filter
  STRATEGIES = {
    "customer_guid"      => ::Dorsale::BillingMachine::SmallData::FilterStrategyByCustomer.new,
    "bm_time_period"     => ::Dorsale::BillingMachine::SmallData::FilterStrategyByTimePeriod.new(:date),
    "bm_quotation_state" => ::Dorsale::BillingMachine::SmallData::FilterStrategyByState.new,
  }
end
