class Dorsale::CustomerVault::LinkPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::CustomerVault::LinkPolicyHelper
  define_dummy_policies!
end
