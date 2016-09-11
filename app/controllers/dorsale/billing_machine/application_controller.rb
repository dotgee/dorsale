class Dorsale::BillingMachine::ApplicationController < ::Dorsale::ApplicationController
  before_action :set_common_variables

  private

  def euros(*)
    raise "#euros is not available in BillingMachine, please use #bm_currency instead"
  end

  def bm_currency(n)
    DH.currency(n, ::Dorsale::BillingMachine.default_currency)
  end

  helper_method :euros
  helper_method :bm_currency

  def set_common_variables
    @payment_terms ||= policy_scope(::Dorsale::BillingMachine::PaymentTerm)
    @id_cards      ||= policy_scope(::Dorsale::BillingMachine::IdCard)
    @people        ||= policy_scope(::Dorsale::CustomerVault::Person)
  end

end
