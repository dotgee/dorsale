class Dorsale::CommentsController < ::Dorsale::ApplicationController
  before_action :set_objects, only: [
    :edit,
    :update,
    :destroy,
  ]

  def create
    @comment ||= scope.new(comment_params_for_create)

    authorize @comment, :create?

    if @comment.save
      flash[:success] = t("messages.comments.create_ok")
    else
      flash[:danger] = t("messages.comments.create_error")
    end

    redirect_to back_url
  end

  def edit
    authorize @comment, :update?

    render layout: false
  end

  def update
    authorize @comment, :update?

    if @comment.update(comment_params_for_update)
      flash[:notice] = t("messages.comments.update_ok")
    else
      flash[:alert] = t("messages.comments.update_error")
    end

    redirect_to back_url
  end

  def destroy
    authorize @comment, :delete?

    if @comment.destroy
      flash[:notice] = t("messages.comments.delete_ok")
    else
      flash[:alert] = t("messages.comments.delete_error")
    end

    redirect_to back_url
  end

  private

  def back_url
    [
      params[:form_url],
      request.referer,
      (main_app.root_path rescue "/"),
    ].select(&:present?).first
  end

  def model
    ::Dorsale::Comment
  end

  def scope
    policy_scope(model)
  end

  def set_objects
    @comment ||= scope.find(params[:id])
  end

  def permitted_params_for_comment
    if params[:action] == "create"
      [
        :commentable_id,
        :commentable_type,
        :text,
      ]
    else
      [
        :text,
      ]
    end
  end

  def comment_params
    params.fetch(:comment, {}).permit(permitted_params_for_comment)
  end

  def comment_params_for_create
    comment_params.merge(author: current_user)
  end

  def comment_params_for_update
    comment_params
  end

end
