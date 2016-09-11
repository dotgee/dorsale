class Dorsale::ExpenseGun::ExpensesController < Dorsale::ExpenseGun::ApplicationController
  before_action :set_expense, only: [
    :show,
    :edit,
    :update,
    :copy,
    :submit,
    :accept,
    :refuse,
    :cancel,
  ]

  def index
    authorize model, :list?

    if params[:state].blank?
      redirect_to state: "all"
      return
    end

    @all_expenses ||= scope.all

    if params[:state] == "all"
      @expenses ||= @all_expenses
    else
      @expenses ||= @all_expenses.where(state: params[:state])
    end

    @expenses = @expenses.page(params[:page]).per(25)
  end

  def new
    authorize model, :create?

    @expense ||= scope.new
    @expense.expense_lines.build if @expense.expense_lines.empty?
  end

  def create
    authorize model, :create?

    @expense ||= scope.new(expense_params_for_create)

    if @expense.save
      flash[:success] = t("expense_gun.expense.messages.created")
      redirect_to dorsale.expense_gun_expense_path(@expense)
    else
      render :new
    end
  end

  def show
    authorize @expense, :read?
  end

  def edit
    authorize @expense, :update?

    @expense.expense_lines.build if @expense.expense_lines.empty?
  end

  def update
    authorize @expense, :update?

    if @expense.update(expense_params_for_update)
      flash[:success] = t("expense_gun.expense.messages.updated")
      redirect_to dorsale.expense_gun_expense_path(@expense)
    else
      render :edit
    end
  end

  def copy
    authorize @expense, :copy?

    @original = @expense
    @expense  = ::Dorsale::ExpenseGun::Expense::Copy.(@original)

    render :new
  end

  def submit
    authorize @expense, :submit?

    @expense.go_to_submited!
    flash[:success] = t("expense_gun.expense.messages.submited")
    redirect_to dorsale.expense_gun_expenses_path
  end

  def accept
    authorize @expense, :accept?

    @expense.go_to_accepted!
    flash[:success] = t("expense_gun.expense.messages.accepted")
    redirect_to dorsale.expense_gun_expense_path(@expense)
  end

  def refuse
    authorize @expense, :refuse?

    @expense.go_to_refused!
    flash[:success] = t("expense_gun.expense.messages.refused")
    redirect_to dorsale.expense_gun_expenses_path
  end

  def cancel
    authorize @expense, :cancel?

    @expense.go_to_canceled!
    flash[:success] = t("expense_gun.expense.messages.canceled")
    redirect_to dorsale.expense_gun_expenses_path
  end

  private

  def model
    ::Dorsale::ExpenseGun::Expense
  end

  def scope
    policy_scope(model)
  end

  def set_expense
    @expense = scope.find(params[:id])
  end

  def permitted_params
    [
      :name,
      :date,
      :expense_lines_attributes => [
        :id,
        :_destroy,
        :name,
        :date,
        :category_id,
        :total_all_taxes,
        :vat,
        :company_part,
      ],
    ]
  end

  def expense_params
    params.fetch(:expense, {}).permit(permitted_params)
  end

  def expense_params_for_create
    expense_params.merge(user: current_user)
  end

  def expense_params_for_update
    expense_params
  end

end
