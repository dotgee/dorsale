class Dorsale::BillingMachine::QuotationsController < ::Dorsale::BillingMachine::ApplicationController
  before_action :set_objects, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :copy,
    :create_invoice,
  ]

  def index
    # callback in BillingMachine::ApplicationController
    authorize model, :list?

    @quotations ||= scope.all
    @filters    ||= ::Dorsale::BillingMachine::SmallData::FilterForQuotations.new(cookies)
    @order      ||= {unique_index: :desc}

    @quotations = @filters.apply(@quotations)
    @quotations = @quotations.order(@order)
    @quotations_without_pagination = @quotations # All filtered quotations (not paginated)
    @quotations = @quotations.page(params[:page]).per(50)

    @total_excluding_taxes = @quotations_without_pagination.to_a
      .select{ |q| q.state != "canceled" }
      .map(&:total_excluding_taxes)
      .delete_if(&:blank?)
      .sum

    @vat_amount = @quotations_without_pagination.to_a
      .select{ |q| q.state != "canceled" }
      .map(&:vat_amount)
      .delete_if(&:blank?)
      .sum

    @total_including_taxes = @quotations_without_pagination.to_a
      .select{ |q| q.state != "canceled" }
      .map(&:total_including_taxes)
      .delete_if(&:blank?)
      .sum
  end

  def new
    # callback in BillingMachine::ApplicationController
    @quotation ||= scope.new

    @quotation.lines.build               if @quotation.lines.empty?
    @quotation.id_card = @id_cards.first if @id_cards.one?

    authorize @quotation, :create?
  end

  def create
    # callback in BillingMachine::ApplicationController
    @quotation ||= scope.new(quotation_params_for_create)

    authorize @quotation, :create?

    if @quotation.save
      flash[:notice] = t("messages.quotations.create_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def show
    # callback in BillingMachine::ApplicationController
    authorize @quotation, :read?
    authorize @quotation, :download? if request.format.pdf?
  end

  def edit
    # callback in BillingMachine::ApplicationController
    authorize @quotation, :update?
    if ::Dorsale::BillingMachine.vat_mode == :single
      @quotation.lines.build(vat_rate: @quotation.vat_rate) if @quotation.lines.empty?
    else
      @quotation.lines.build if @quotation.lines.empty?
    end
  end

  def update
    # callback in BillingMachine::ApplicationController
    authorize @quotation, :update?

    if @quotation.update(quotation_params_for_update)
      flash[:notice] = t("messages.quotations.update_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def destroy
    # callback in BillingMachine::ApplicationController
    authorize @quotation, :delete?

    if @quotation.destroy
      flash[:notice] = t("messages.quotations.update_ok")
    else
      flash[:alert] = t("messages.quotations.update_error")
    end

    redirect_to url_for(action: :index, id: nil)
  end

  def copy
    authorize @quotation, :copy?

    @original  = @quotation
    @quotation = Dorsale::BillingMachine::Quotation::Copy.(@original)

    flash[:notice] = t("messages.quotations.copy_ok")

    redirect_to dorsale.edit_billing_machine_quotation_path(@quotation)
  end

  def create_invoice
    authorize @quotation, :read?
    authorize ::Dorsale::BillingMachine::Invoice, :create?

    @invoice = Dorsale::BillingMachine::Quotation::ToInvoice.(@quotation)

    render "dorsale/billing_machine/invoices/new"
  end

  private

  def model
    ::Dorsale::BillingMachine::Quotation
  end

  def scope
    policy_scope(model)
  end

  def default_back_url
    if @quotation
      url_for(action: :show, id: @quotation.to_param)
    else
      url_for(action: :index, id: nil)
    end
  end

  def set_objects
    @quotation ||= scope.find(params[:id])
  end

  def permitted_params
    [
      :label,
      :state,
      :customer_guid,
      :payment_term_id,
      :id_card_id,
      :date,
      :expires_at,
      :comments,
      :vat_rate,
      :commercial_discount,
      :lines_attributes => [
        :_destroy,
        :id,
        :label,
        :quantity,
        :unit,
        :unit_price,
        :vat_rate,
      ],
    ]
  end

  def quotation_params
    params.fetch(:quotation, {}).permit(permitted_params)
  end

  def quotation_params_for_create
    quotation_params
  end

  def quotation_params_for_update
    quotation_params
  end

end
