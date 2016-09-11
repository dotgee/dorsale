class Dorsale::BillingMachine::IdCardsController < ::Dorsale::BillingMachine::ApplicationController
  before_action :set_objects, only: [:edit, :update]

  def index
    authorize model, :list?

    @id_cards ||= scope.all
  end

  def new
    @id_card ||= scope.new

    authorize @id_card, :create?
  end

  def create
    @id_card ||= scope.new(id_card_params_for_create)

    authorize @id_card, :create?

    if @id_card.save
      flash[:notice] = t("id_cards.create_ok")
      redirect_to back_url
    else
      render action: :new
    end
  end

  def edit
    authorize @id_card, :update?
  end

  def update
    authorize @id_card, :update?

    if @id_card.update(id_card_params_for_update)
      flash[:notice] = t("id_cards.update_ok")
      redirect_to back_url
    else
      render action: :edit
    end
  end

  private

  def set_objects
    @id_card ||= scope.find(params[:id])
  end

  def model
    ::Dorsale::BillingMachine::IdCard
  end

  def scope
    policy_scope(model)
  end

  def back_url
    url_for(action: :index, id: nil)
  end

  def permitted_params
    [
      :id,
      :id_card_name,
      :entity_name,
      :siret,
      :legal_form,
      :capital,
      :registration_number,
      :intracommunity_vat,
      :address1,
      :address2,
      :zip,
      :city,
      :phone,
      :contact_full_name,
      :contact_phone,
      :contact_address_1,
      :contact_address_2,
      :contact_zip,
      :contact_city,
      :iban,
      :bic_swift,
      :bank_name,
      :bank_address,
      :ape_naf,
      :custom_info_1,
      :custom_info_2,
      :custom_info_3,
      :contact_fax,
      :contact_email,
      :logo,
      :registration_city,
    ]
  end

  def id_card_params
    params.fetch(:billing_machine_id_card, {}).permit(permitted_params)
  end

  def id_card_params_for_create
    id_card_params
  end

  def id_card_params_for_update
    id_card_params
  end

end
