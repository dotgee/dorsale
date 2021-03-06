module Dorsale::Flyboy::TaskPolicyHelper
  POLICY_METHODS = [
    :list?,
    :export?,
    :create?,
    :read?,
    :update?,
    :delete?,
    :complete?,
    :snooze?,
  ]

  def create?
    return false if folder_is_closed?
    return false if cannot_read_taskable?
    super
  end

  def update?
    return false if folder_is_closed?
    super
  end

  def delete?
    return false if folder_is_closed?
    super
  end

  def complete?
    return false if task.done?
    super
  end

  def snooze?
    return false unless task.snoozable?
    super
  end

  private

  def folder_is_closed?
    return false unless task.is_a?(::Dorsale::Flyboy::Task)
    return false unless task.taskable.is_a?(::Dorsale::Flyboy::Folder)

    task.taskable.closed?
  end

  def cannot_read_taskable?
    return false unless task.is_a?(::Dorsale::Flyboy::Task)
    return false unless task.taskable.present?

    ! policy(task.taskable).read?
  end
end
