class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper ::Dorsale::AllHelpers

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError do |e|
    raise e if Rails.env.test?
    flash[:alert] = "Not authorized."
    redirect_to "/"
  end
end
