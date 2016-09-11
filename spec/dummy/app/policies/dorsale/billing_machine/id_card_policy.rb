class Dorsale::BillingMachine::IdCardPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::BillingMachine::IdCardPolicyHelper
  define_dummy_policies!
end
