module Dorsale::CommentsHelper
  def comments_for(commentable)
    render partial: "dorsale/comments/loader", locals: {commentable: commentable}
  end
end
