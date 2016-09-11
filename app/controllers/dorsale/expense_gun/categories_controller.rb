class Dorsale::ExpenseGun::CategoriesController < ::Dorsale::ExpenseGun::ApplicationController
  before_action :set_objects, only: [:edit, :update]

  def index
    authorize model, :list?

    @categories ||= scope.all
  end

  def new
    @category ||= scope.new

    authorize @category, :create?
  end

  def create
    @category ||= scope.new(category_params_for_create)

    authorize @category, :create?

    if @category.save
      flash[:notice] = t("categories.create_ok")
      redirect_to back_url
    else
      render action: :new
    end
  end

  def edit
    authorize @category, :update?
  end

  def update
    authorize @category, :update?

    if @category.update(category_params_for_update)
      flash[:notice] = t("categories.update_ok")
      redirect_to back_url
    else
      render action: :edit
    end
  end

  private

  def set_objects
    @category ||= scope.find(params[:id])
  end

  def model
    ::Dorsale::ExpenseGun::Category
  end

  def scope
    policy_scope(model)
  end

  def back_url
    expense_gun_categories_path
  end

  def permitted_params
    [
      :name,
      :code,
      :vat_deductible,
    ]
  end

  def category_params
    params.fetch(:category, {}).permit(permitted_params)
  end

  def category_params_for_create
    category_params
  end

  def category_params_for_update
    category_params
  end

end
