class Dorsale::Flyboy::ApplicationController < ::Dorsale::ApplicationController
  handles_sortable_columns

  helper ::Dorsale::CustomerVault::ApplicationHelper
end
