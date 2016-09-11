module Dorsale::CommentsHelper
  def comment_form_for(commentable)
    render partial: "dorsale/comments/form", locals: {commentable: commentable}
  end

  def comments_list_for(commentable)
    render partial: "dorsale/comments/list", locals: {commentable: commentable}
  end

  def comments_for(commentable)
    render partial: "dorsale/comments/comments", locals: {commentable: commentable}
  end
end
