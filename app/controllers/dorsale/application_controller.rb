class Dorsale::ApplicationController < ::ApplicationController
  include Pundit
  include Dorsale::BackUrlConcern

  after_action :verify_authorized
  after_action :verify_policy_scoped

  layout -> {
    if request.xhr?
      false
    else
      "application"
    end
  }

end
