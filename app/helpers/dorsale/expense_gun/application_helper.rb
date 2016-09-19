module Dorsale::ExpenseGun::ApplicationHelper
  def expense_states_for_filters_select
    Dorsale::ExpenseGun::Expense.aasm.states.map do |state|
      [
        Dorsale::ExpenseGun::Expense.t("state.#{state}"),
        state,
      ]
    end
  end
end
