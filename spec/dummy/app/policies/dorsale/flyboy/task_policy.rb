class Dorsale::Flyboy::TaskPolicy < Dorsale::ApplicationPolicy
  prepend ::Dorsale::Flyboy::TaskPolicyHelper
  define_dummy_policies!
end
