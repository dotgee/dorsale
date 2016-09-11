module Dorsale::BackUrlConcern
  extend ActiveSupport::Concern

  private

  def default_back_url; end

  def back_url
    [
      params[:back_url],
      request.referer,
      default_back_url,
      main_app.root_path,
      "/",
    ].select(&:present?).first
  end

end
