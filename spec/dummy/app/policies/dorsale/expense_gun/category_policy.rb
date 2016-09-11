class Dorsale::ExpenseGun::CategoryPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::ExpenseGun::CategoryPolicyHelper
  define_dummy_policies!
end
