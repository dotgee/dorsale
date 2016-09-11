class Dorsale::BillingMachine::InvoicesController < ::Dorsale::BillingMachine::ApplicationController
  before_action :set_objects, only: [
    :show,
    :edit,
    :update,
    :copy,
    :pay,
    :email,
  ]

  def index
    # callback in BillingMachine::ApplicationController
    authorize model, :list?

    @invoices ||= scope.all
    @filters  ||= ::Dorsale::BillingMachine::SmallData::FilterForInvoices.new(cookies)
    @order    ||= {unique_index: :desc}

    @invoices = @filters.apply(@invoices)
    @invoices = @invoices.order(@order)
    @invoices_without_pagination = @invoices
    @invoices = @invoices.page(params[:page]).per(50)

    @total_excluding_taxes = @invoices_without_pagination.to_a
      .map(&:total_excluding_taxes)
      .delete_if(&:blank?)
      .sum

    @vat_amount = @invoices_without_pagination.to_a
      .map(&:vat_amount)
      .delete_if(&:blank?)
      .sum

    @total_including_taxes = @invoices_without_pagination.to_a
      .map(&:total_including_taxes)
      .delete_if(&:blank?)
      .sum
  end

  def new
    # callback in BillingMachine::ApplicationController
    @invoice ||= scope.new

    @invoice.lines.build               if @invoice.lines.empty?
    @invoice.id_card = @id_cards.first if @id_cards.one?

    authorize @invoice, :create?
  end

  def create
    # callback in BillingMachine::ApplicationController
    @invoice ||= scope.new(invoice_params_for_create)

    authorize model, :create?

    if @invoice.save
      flash[:notice] = t("messages.invoices.create_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def show
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :read?
    authorize @invoice, :download? if request.format.pdf?
  end

  def copy
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :copy?

    @original = @invoice
    @invoice  = Dorsale::BillingMachine::Invoice::Copy.(@original)

    render :new
  end

  def edit
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :update?

    if ::Dorsale::BillingMachine.vat_mode == :single
      @invoice.lines.build(vat_rate: @invoice.vat_rate) if @invoice.lines.empty?
    else
      @invoice.lines.build if @invoice.lines.empty?
    end
  end

  def update
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :update?

    if @invoice.update(invoice_params_for_update)
      flash[:notice] = t("messages.invoices.update_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def pay
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :update?

    if @invoice.update(paid: true)
      flash[:notice] = t("messages.invoices.pay_ok")
    else
      flash[:alert] = t("messages.invoices.pay_error")
    end

    redirect_to back_url
  end

  def email
    authorize @invoice, :email?

    @subject =
    begin
      params[:email][:subject]
    rescue
      "#{model.t} #{@invoice.tracking_id} : #{@invoice.label}"
    end

    @body =
    begin
      params[:email][:body]
    rescue
      t("emails.invoices.send_invoice_to_customer",
        :from => current_user.to_s,
        :to   => @invoice.customer.to_s,
      )
    end

    if request.get?
      return
    end

    email = ::Dorsale::BillingMachine::InvoiceMailer
      .send_invoice_to_customer(@invoice, @subject, @body, current_user)

    if email.deliver_later
      flash[:notice] = t("messages.invoices.email_ok")
      redirect_to back_url
    else
      flash.now[:alert] = t("messages.invoices.email_error")
      render
    end
  end

  private

  def model
    ::Dorsale::BillingMachine::Invoice
  end

  def scope
    policy_scope(model)
  end

  def default_back_url
    if @invoice
      url_for(action: :show, id: @invoice.to_param)
    else
      url_for(action: :index, id: nil)
    end
  end

  def set_objects
    @invoice ||= scope.find(params[:id])
  end

  def permitted_params
    [
      :id_card_id,
      :customer_guid,
      :payment_term_id,
      :label,
      :paid,
      :date,
      :commercial_discount,
      :vat_rate,
      :advance,
      :due_date,
      :comments,
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

  def invoice_params
    params.fetch(:invoice, {}).permit(permitted_params)
  end

  def invoice_params_for_create
    invoice_params
  end

  def invoice_params_for_update
    invoice_params
  end

end
