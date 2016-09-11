class Dorsale::Alexandrie::AttachmentPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::Alexandrie::AttachmentPolicyHelper
  define_dummy_policies!
end
