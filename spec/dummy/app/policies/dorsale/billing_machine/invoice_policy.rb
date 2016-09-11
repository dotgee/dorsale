class Dorsale::BillingMachine::InvoicePolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::BillingMachine::InvoicePolicyHelper
  define_dummy_policies!
end
