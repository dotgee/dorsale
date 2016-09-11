module Dorsale::FormHelper
  def form_buttons(opts = {})
   back_url = opts[:back_url]
   back_url = url_for(:back).html_safe if back_url.blank?
   back_url = URI(back_url).path       if back_url.include?("://")

    if opts[:obj].present?
      if opts[:obj].new_record?
        submit_action = :create
      else
        submit_action = :update
      end
    else
      submit_action = :save
    end

    content_tag("div", class: "actions") do
      submit = content_tag(:button, type: :submit, class: "btn btn-sm btn-success") do
        content_tag(:span, class: "fa fa-save") {} + " " + t("actions.#{submit_action}")
      end

      cancel = content_tag("a", href: back_url, class: "btn btn-primary btn-sm") do
        content_tag(:span, class: "fa fa-times"){} + " " + t("actions.cancel")
      end

      cancel = "" if back_url == false

      submit + cancel
    end
  end

  def horizontal_form_for(obj, opts={}, &block)
    opts = {
      :wrapper => "horizontal_form",
      :html => {
        :class => "form-horizontal"
      }
    }.deep_merge(opts)

    simple_form_for(obj, opts, &block)
  end

  def search_form(opts = {})
    action = opts.delete(:action) || request.fullpath

    render "dorsale/search/form", action: action
  end

end
