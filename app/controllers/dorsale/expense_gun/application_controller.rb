class Dorsale::ExpenseGun::ApplicationController < ::Dorsale::ApplicationController
  before_action :set_form_variables

  def set_form_variables
    @categories ||= policy_scope(::Dorsale::ExpenseGun::Category).all
  end
end
