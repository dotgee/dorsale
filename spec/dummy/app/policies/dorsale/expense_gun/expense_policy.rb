class Dorsale::ExpenseGun::ExpensePolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::ExpenseGun::ExpensePolicyHelper
  define_dummy_policies!
end
