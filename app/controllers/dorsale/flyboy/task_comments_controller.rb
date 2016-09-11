class Dorsale::Flyboy::TaskCommentsController < ::Dorsale::Flyboy::ApplicationController
  def create
    skip_policy_scope

    @task_comment ||= model.new(task_comment_params_for_create)
    @task         ||= @task_comment.task

    authorize @task, :update?

    if @task_comment.save
      redirect_to @task
    else
      render "dorsale/flyboy/tasks/show"
    end
  end

  private

  def model
    ::Dorsale::Flyboy::TaskComment
  end

  def permitted_params
    [
      :task_id,
      :progress,
      :description,
    ]
  end

  def task_comment_params
    params.fetch(:task_comment, {}).permit(permitted_params)
  end

  def task_comment_params_for_create
    task_comment_params.merge(author: current_user)
  end

end
