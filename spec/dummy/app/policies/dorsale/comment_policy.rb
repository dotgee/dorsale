class Dorsale::CommentPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::CommentPolicyHelper
  define_dummy_policies!
end
