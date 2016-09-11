module Dorsale::ExpenseGun::ExpensePolicyHelper
  POLICY_METHODS = [
    :list?,
    :create?,
    :read?,
    :update?,
    :copy?,
    :submit?,
    :accept?,
    :refuse?,
    :cancel?,
  ]

  def update?
    return false unless expense.may_edit?
    super
  end

  def submit?
    return false unless expense.may_go_to_submited?
    super
  end

  def accept?
    return false unless expense.may_go_to_accepted?
    super
  end

  def refuse?
    return false unless expense.may_go_to_refused?
    super
  end

  def cancel?
    return false unless expense.may_go_to_canceled?
    super
  end

end
