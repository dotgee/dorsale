module Dorsale
  module Alexandrie
    class AttachmentsController < ::Dorsale::ApplicationController
      def create
        @attachment = ::Dorsale::Alexandrie::Attachment.new(attachment_params)

        authorize! :create, @attachment

        if @attachment.save
          flash[:notice] = t("dorsale.messages.attachment.create_ok")
        else
          flash[:alert] = t("dorsale.messages.attachment.create_error")
        end

        redirect_to_back_url
      end

      def destroy
        @attachment = ::Dorsale::Alexandrie::Attachment.find params[:id]

        authorize! :delete, @attachment

        if @attachment.destroy
          flash[:notice] = t("dorsale.messages.attachment.delete_ok")
        else
          flash[:alert] = t("dorsale.messages.attachment.delete_error")
        end

        redirect_to_back_url
      end

      private

      def permitted_params_for_attachment
        [
          :attachable_id,
          :attachable_type,
          :file,
        ]
      end

      def attachment_params
        params.require(:attachment).permit(permitted_params_for_attachment)
      end

      def redirect_to_back_url
        redirect_to params[:back_url] || request.referer
      end
    end
  end
end
