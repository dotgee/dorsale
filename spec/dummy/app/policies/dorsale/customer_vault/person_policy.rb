class Dorsale::CustomerVault::PersonPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::CustomerVault::PersonPolicyHelper
  define_dummy_policies!
end
