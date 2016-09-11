class Dorsale::Alexandrie::AttachmentsController < ::Dorsale::ApplicationController
  layout false

  before_action :set_objects, only: [
    :edit,
    :update,
    :destroy,
  ]

  def index
    @attachable = find_attachable
    skip_policy_scope

    authorize @attachable, :read?
  end

  def create
    @attachment = scope.new(attachment_params_for_create)

    authorize @attachment, :create?

    if @attachment.save
      flash[:notice] = t("messages.attachments.create_ok")
    else
      flash[:alert] = t("messages.attachments.create_error")
    end

    render_or_redirect
  end

  def edit
    authorize @attachment, :update?
  end

  def update
    authorize @attachment, :update?

    if @attachment.update(attachment_params_for_update)
      flash[:notice] = t("messages.attachments.update_ok")
    else
      flash[:alert] = t("messages.attachments.update_error")
    end

    render_or_redirect
  end

  def destroy
    authorize @attachment, :delete?

    if @attachment.destroy
      flash[:notice] = t("messages.attachments.delete_ok")
    else
      flash[:alert] = t("messages.attachments.delete_error")
    end

    render_or_redirect
  end

  private

  def model
    ::Dorsale::Alexandrie::Attachment
  end

  def scope
    policy_scope(model)
  end

  def set_objects
    @attachment = scope.find(params[:id])
  end

  def attachable_type
    params[:attachable_type] || @attachment.attachable_type
  end

  def attachable_id
    params[:attachable_id] || @attachment.attachable_id
  end

  def find_attachable
    attachable_type.to_s.constantize.find(attachable_id)
  rescue NameError
    raise ActiveRecord::RecordNotFound
  end

  def permitted_params_for_create
    [
      :attachable_id,
      :attachable_type,
      :file,
      :name
    ]
  end

  def attachment_params_for_create
    params
      .require(:attachment)
      .permit(permitted_params_for_create)
      .merge(sender: current_user)
  end

  def permitted_params_for_update
    [
      :name,
    ]
  end

  def attachment_params_for_update
    params
      .require(:attachment)
      .permit(permitted_params_for_update)
  end

  def render_or_redirect
    if request.xhr?
      head :ok
    else
      redirect_to back_url
    end
  end

end
