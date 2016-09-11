class Dorsale::Flyboy::FoldersController < ::Dorsale::Flyboy::ApplicationController
  before_action :set_objects, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :open,
    :close
  ]

  def index
    authorize model, :list?

    @folders ||= scope.all

    @order ||= sortable_column_order do |column, direction|
      case column
      when "name", "status"
        %(LOWER(dorsale_flyboy_folders.#{column}) #{direction})
      when "progress"
        %(dorsale_flyboy_folders.#{column} #{direction})
      else
        params["sort"] = "status"
        "status ASC"
      end
    end

    @filters ||= Dorsale::Flyboy::SmallData::FilterForFolders.new(cookies)

    @folders = @folders.order(@order)
    @folders = @filters.apply(@folders)
    @folders = @folders.search(params[:q])
    @folders = @folders.page(params[:page])
  end

  def show
    authorize @folder, :read?
  end

  def new
    @folder ||= scope.new

    authorize @folder, :create?
  end

  def create
    @folder ||= scope.new(folder_params_for_create)

    authorize @folder, :create?

    if @folder.save
      flash[:success] = t("messages.folders.create_ok")
      redirect_to @folder
    else
      render :new
    end
  end

  def edit
    authorize @folder, :update?
  end

  def update
    authorize @folder, :update?

    if @folder.update(folder_params_for_update)
      flash[:success] = t("messages.folders.update_ok")

      if @folder.closed?
        redirect_to dorsale.flyboy_folders_path
      else
        redirect_to @folder
      end
    else
      render :edit
    end
  end

  def destroy
    authorize @folder, :delete?

    @folder.destroy

    redirect_to url_for(action: :index, id: nil)
  end

  def open
    authorize @folder, :open?

    if @folder.open!
      flash[:success] = t("messages.folders.open_ok")
    else
      flash[:danger] = t("messages.folders.open_error")
    end

    redirect_to @folder
  end

  def close
    authorize @folder, :close?

    if @folder.close!
      flash[:success] = t("messages.folders.close_ok")
    else
      flash[:danger] = t("messages.folders.close_error")
    end

    redirect_to dorsale.flyboy_folders_path
  end

  private

  def model
    ::Dorsale::Flyboy::Folder
  end

  def scope
    policy_scope(model)
  end

  def set_objects
    @folder = scope.find(params[:id])
  end

  def permitted_params
    [
      :name,
      :description,
    ]
  end

  def folder_params
    params.fetch(:folder, {}).permit(permitted_params)
  end

  def folder_params_for_create
    folder_params
  end

  def folder_params_for_update
    folder_params
  end

end
