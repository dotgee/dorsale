class Dorsale::BillingMachine::PaymentTermsController < ::Dorsale::BillingMachine::ApplicationController
  before_action :set_objects, only: [:edit, :update]

  def index
    authorize model, :list?

    @payment_terms ||= scope.all
  end

  def new
    @payment_term ||= scope.new

    authorize @payment_term, :create?
  end

  def create
    @payment_term ||= scope.new(payment_term_params_for_create)

    authorize @payment_term, :create?
    if @payment_term.save

      flash[:notice] = t("payment_terms.create_ok")
      redirect_to back_url
    else
      render action: :new
    end
  end

  def edit
    authorize @payment_term, :update?
  end

  def update
    authorize @payment_term, :update?

    if @payment_term.update(payment_term_params_for_update)
      flash[:notice] = t("payment_terms.update_ok")
      redirect_to back_url
    else
      render action: :edit
    end
  end

  private

  def set_objects
    @payment_term ||= scope.find(params[:id])
  end

  def model
    ::Dorsale::BillingMachine::PaymentTerm
  end

  def scope
    policy_scope(model)
  end

  def back_url
    url_for(action: :index, id: nil)
  end

  def permitted_params
    [
      :label,
    ]
  end

  def payment_term_params
    params.fetch(:billing_machine_payment_term, {}).permit(permitted_params)
  end

  def payment_term_params_for_create
    payment_term_params
  end

  def payment_term_params_for_update
    payment_term_params
  end

end
