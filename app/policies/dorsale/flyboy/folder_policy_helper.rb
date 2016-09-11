module Dorsale::Flyboy::FolderPolicyHelper
  POLICY_METHODS = [
    :list?,
    :create?,
    :read?,
    :update?,
    :delete?,
    :open?,
    :close?,
  ]

  def update?
    return false if folder.closed?
    super
  end

  def close?
    return false unless folder.may_close?
    super
  end

  def open?
    return false unless folder.may_open?
    super
  end
end
