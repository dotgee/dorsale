module Dorsale::BillingMachine::ApplicationHelper
  def billing_machine_quotation_states_for_select
    ::Dorsale::BillingMachine::Quotation::STATES.map do |e|
      [
        ::Dorsale::BillingMachine::Quotation.t("state.#{e}"),
        e,
      ]
    end
  end

  def billing_machine_quotation_states_for_filter_select
      [
        [::Dorsale::BillingMachine::Quotation.t("state.all"), ""],
        [::Dorsale::BillingMachine::Quotation.t("state.not_canceled"), "not_canceled"],
      ] + billing_machine_quotation_states_for_select
  end

  def billing_machine_payment_status_for_filter_select
    {
      ::Dorsale::BillingMachine::Invoice.t("payment_status.all")     => "",
      ::Dorsale::BillingMachine::Invoice.t("payment_status.unpaid")  => "unpaid",
      ::Dorsale::BillingMachine::Invoice.t("payment_status.pending") => "pending",
      ::Dorsale::BillingMachine::Invoice.t("payment_status.late")    => "late",
      ::Dorsale::BillingMachine::Invoice.t("payment_status.paid")    => "paid",
    }
  end

  def quotation_state_classes(quotation)
    if quotation.state == "pending" && quotation.date < 1.month.ago
      return "pending late"
    else
      return quotation.state
    end
  end

end
