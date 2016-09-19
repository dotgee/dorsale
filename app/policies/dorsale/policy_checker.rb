class Dorsale::PolicyChecker
  def errors
    @errors ||= []
  end

  def check!
    errors.clear

    check_policy! "Dorsale::Alexandrie::AttachmentPolicy"
    check_policy! "Dorsale::BillingMachine::IdCardPolicy"
    check_policy! "Dorsale::BillingMachine::InvoicePolicy"
    check_policy! "Dorsale::BillingMachine::PaymentTermPolicy"
    check_policy! "Dorsale::BillingMachine::QuotationPolicy"
    check_policy! "Dorsale::CommentPolicy"
    check_policy! "Dorsale::CustomerVault::PersonPolicy"
    check_policy! "Dorsale::CustomerVault::LinkPolicy"
    check_policy! "Dorsale::ExpenseGun::CategoryPolicy"
    check_policy! "Dorsale::ExpenseGun::ExpensePolicy"
    check_policy! "Dorsale::Flyboy::FolderPolicy"
    check_policy! "Dorsale::Flyboy::TaskPolicy"
    check_policy! "UserPolicy"

    errors.each do |error|
      warn error
    end

    errors.empty?
  end

  def self.check!
    new.check!
  end

  private

  def check_policy!(policy)
    begin
      policy_klass = policy.constantize
    rescue NameError
      errors << "#{policy} does not exist"
      return
    end

    begin
      helper_klass = "#{policy}Helper".constantize
    rescue NameError
      errors << "#{policy}Helper does not exist"
      return
    end

    begin
      scope_klass = "#{policy}::Scope".constantize

      unless scope_klass.public_instance_methods.include?(:resolve)
        errors << "#{policy}::Scope#resolve is not defined"
      end
    rescue NameError
      errors << "#{policy}::Scope does not exist"
    end

    unless policy_klass < helper_klass
      errors << "#{policy_klass} does not prepend #{helper_klass}"
      return
    end

    helper_klass::POLICY_METHODS.each do |method|
      unless policy_klass.public_instance_methods(false).include?(method)
        errors << "#{policy_klass}##{method} is not defined"
        next
      end
    end
  end

end
