class Dorsale::UsersController < ::Dorsale::ApplicationController
  before_action :set_objects, only: [
    :show,
    :edit,
    :update,
  ]

  def show
  end

  def index
    authorize User, :list?

    @users ||= scope.all
  end

  def new
    @user ||= scope.new

    authorize @user, :create?
  end

  def edit
    authorize @user, :update?
  end

  def create
    @user ||= scope.new(user_params_for_create)

    authorize @user, :create?

    if @user.save
      flash[:notice] = t("messages.users.create_ok")
      redirect_to dorsale.users_path
    else
      flash.now[:error] = t("messages.users.create_error")
      render :new
    end
  end

  def update
    authorize @user, :update?

    if @user.update(user_params_for_update)
      flash[:notice] = t("messages.users.update_ok")
      redirect_to dorsale.users_path
    else
      flash.now[:error] = t("messages.users.update_error")
      render :edit
    end
  end

  private

  def model
    User
  end

  def scope
    policy_scope(model)
  end

  def set_objects
    @user = scope.find(params[:id])
  end

  def permitted_params
    [
      :email,
      :password,
      :password_confirmation,
      :is_active,
      :avatar,
    ]
  end

  def user_params
    params.fetch(:user, {}).permit(permitted_params)
  end

  def user_params_for_create
    user_params
  end

  def user_params_for_update
    user_params
  end

end
