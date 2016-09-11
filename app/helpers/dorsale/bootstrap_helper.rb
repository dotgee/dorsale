module Dorsale::BootstrapHelper
  def icon(id)
    id = id.to_s.gsub("_", "-")
    content_tag(:span, class: "icon fa fa-#{id}"){}
  end
end
