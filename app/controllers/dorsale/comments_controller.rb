# encoding: utf-8

module Dorsale
  class CommentsController < ApplicationController
    def create
      if defined?(current_user) && current_user.present?
        @comment = current_user.comments.new(comment_params)
      else
        @comment = Comment.new(comment_params)
      end

      authorize! :create, @comment

      if @comment.save
        flash[:success] = "Comment was successfully created."
      else
        flash[:danger] = "Error : comment not saved."
      end

      redirect_to_back_url
    end

    def update
        @comment = ::Dorsale::Comment.find params[:id]

        authorize! :update, @comment

        if @comment.update_attributes(comment_params)
          flash[:notice] = t("messages.comment.update_ok")
        else
          flash[:alert] = t("messages.comment.update_error")
        end

        redirect_to_back_url
      end

      def destroy
        @comment = ::Dorsale::Comment.find params[:id]

        authorize! :delete, @comment

        if @comment.destroy
          flash[:notice] = t("messages.comment.delete_ok")
        else
          flash[:alert] = t("messages.comment.delete_error")
        end

        redirect_to_back_url
      end

    private

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
      params.require(:comment).permit(permitted_params_for_comment)
    end

    def redirect_to_back_url
      redirect_to params[:back_url] || request.referer
    end
  end
end
