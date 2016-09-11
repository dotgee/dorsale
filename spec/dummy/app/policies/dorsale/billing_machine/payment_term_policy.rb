class Dorsale::BillingMachine::PaymentTermPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::BillingMachine::PaymentTermPolicyHelper
  define_dummy_policies!
end
