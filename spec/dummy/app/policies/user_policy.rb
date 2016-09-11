class UserPolicy < Dorsale::ApplicationPolicy
  prepend UserPolicyHelper
  define_dummy_policies!
end
