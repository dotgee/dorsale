module Dorsale
  module ContextHelper
    def context_icon(id)
      icon(id)
    end

    def context_title(title)
      content_tag(:h2){ title }
    end

    def context_info(name, info)
      return if info.blank?
      %(<p class="infos"><strong>#{name} : </strong>#{info}</p>).html_safe
    end

    def actions_for(obj, opts={})
      url        = opts[:url]
      edit_url   = opts[:edit_url]
      delete_url = opts[:delete_url]

      url        = polymorphic_path(obj) if url.nil?
      edit_url   = url + "/edit"         if edit_url.nil?
      delete_url = url                   if delete_url.nil?

      render partial: "dorsale/actions", locals: {
        :obj        => obj,
        :url        => url,
        :edit_url   => edit_url,
        :delete_url => delete_url,
      }
    end

    def render_contextual
      render "dorsale/contextual"
    end
  end
end