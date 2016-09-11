class Dorsale::CustomerVault::ApplicationController < ::Dorsale::ApplicationController
  handles_sortable_columns

  helper ::Dorsale::Flyboy::ApplicationHelper

  before_action :set_form_variables, only: [
    :new,
    :create,
    :edit,
    :update,
  ]

  private

  def customer_vault_tag_list
    ActsAsTaggableOn::Tag.order(:name).map(&:to_s)
  end

  def set_form_variables
    @tags ||= customer_vault_tag_list
  end

end
