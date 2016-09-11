class Dorsale::Flyboy::FolderPolicy < Dorsale::ApplicationPolicy
  prepend ::Dorsale::Flyboy::FolderPolicyHelper
  define_dummy_policies!
end
