module Dorsale::RoutesHelper
  def engine_polymorphic_path(obj, opts = {})
    engine = obj.class.parents[-2]

    if engine.nil?
      routes = main_app
    else
      routes = engine::Engine.routes
    end

    opts = {
      :controller => "/#{obj.class.to_s.tableize}",
      :action     => :show,
      :id         => obj.to_param,
      :only_path  => true
    }.merge(opts)

    routes.url_for(opts)
  end
end
