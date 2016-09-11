module Dorsale::FiltersHelper
  def filter_submit_button(options = {})
    options[:class] ||= "btn submit filter-submit"
    options[:type]  ||= "submit"
    options[:value] ||= "submit"

    text = options.delete(:text) || t("actions.filter")
    icon = options.delete(:icon) || "filter"

    content_tag(:button, options) do
      icon(icon) + " " + text
    end
  end

  def filter_reset_button(options = {})
    options[:class] ||= "btn reset filter-reset"
    options[:type]  ||= "submit"
    options[:value] ||= "reset"

    text = options.delete(:text) || t("actions.reset")
    icon = options.delete(:icon) || "rotate-left"

    content_tag(:button, options) do
      icon(icon) + " " + text
    end
  end

  def filter_buttons
    filter_reset_button + filter_submit_button
  end

  def filters_form(options = {}, &block)
    if options.key?(:buttons)
      buttons = optins.delete(:buttons)
    else
      buttons = true
    end

    options = {
      :url     => dorsale.small_data_filters_path,
      :wrapper => :inline_form,
    }.merge(options)

    html = simple_form_for(:filters, options, &block)

    if buttons
      html = html.gsub("</form>", "#{filter_buttons}</form>").html_safe
    end

    html
  end

  def dorsale_time_periods_for_select
    {
      t("time_periods.all_time") => "",
      t("time_periods.today")    => "today",
      t("time_periods.week")     => "week" ,
      t("time_periods.month")    => "month",
    }
  end

end
