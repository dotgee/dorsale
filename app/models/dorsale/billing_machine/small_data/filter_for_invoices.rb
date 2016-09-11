class Dorsale::BillingMachine::SmallData::FilterForInvoices < ::Dorsale::SmallData::Filter
  STRATEGIES = {
    "customer_guid"     => ::Dorsale::BillingMachine::SmallData::FilterStrategyByCustomer.new,
    "bm_time_period"    => ::Dorsale::BillingMachine::SmallData::FilterStrategyByTimePeriod.new(:date),
    "bm_payment_status" => ::Dorsale::BillingMachine::SmallData::FilterStrategyByPaymentStatus.new,
  }
end
