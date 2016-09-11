class Dorsale::BillingMachine::QuotationPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::BillingMachine::QuotationPolicyHelper
  define_dummy_policies!
end
