class Dorsale::CustomerVault::LinksController < ::Dorsale::CustomerVault::ApplicationController
  before_action :set_objects

  def new
    authorize @person, :update?

    @link ||= scope.new
  end

  def create
    authorize @person, :update?

    @link ||= scope.new(link_params_for_create)

    if @link.save
      flash[:notice] = t("messages.links.create_ok")
      redirect_to back_url
    else
      render :new
    end
  end

  def edit
    authorize @person, :update?
  end

  def update
    authorize @person, :update?

    if @link.update(link_params_for_update)
      flash[:notice] = t("messages.links.update_ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    authorize @person, :update?

    if @link.destroy
      flash[:notice] = t("messages.links.delete_ok")
    else
      flash[:alert] = t("messages.links.delete_error")
    end

    redirect_to back_url
  end

  private

  def model
    ::Dorsale::CustomerVault::Link
  end

  def back_url
    customer_vault_person_path(@person) + "#links"
  end

  def scope
    policy_scope(model)
  end

  def person_scope
    policy_scope(::Dorsale::CustomerVault::Person)
  end

  def set_objects
    @people ||= person_scope.all
    @person ||= person_scope.find(params[:person_id])

    if params.key?(:id)
      @link ||= scope.find(params[:id])

      if @person == @link.alice
        @link.person       = @link.alice
        @link.other_person = @link.bob
      end

      if @person == @link.bob
        @link.person       = @link.bob
        @link.other_person = @link.alice
      end
    end
  end

  def permitted_params
    [
      :title,
    ]
  end

  def link_params
    params.fetch(:link, {}).permit(permitted_params)
  end

  def link_params_for_create
    link_params.merge(
      :alice  => @person,
      :bob_id => params.dig(:link, :bob_id)
    )
  end

  def link_params_for_update
    link_params
  end

end
