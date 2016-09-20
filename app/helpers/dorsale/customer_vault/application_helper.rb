module Dorsale::CustomerVault::ApplicationHelper
  def person_tags(person)
    return "" if person.tag_list.empty?

    person.tag_list.map { |tag|
      content_tag(:span, class: "tag label label-primary"){
        "#{icon :tag} #{tag}".html_safe
      }
    }.join(" ").html_safe
  end

  def customer_vault_link_form_path(person = @person, link = @link)
    if link.new_record?
      customer_vault_person_links_path(person, link)
    else
      customer_vault_person_link_path(person)
    end
  end

  def person_types_for_filter_select
    [
      [Dorsale::CustomerVault::Corporation.t, "Dorsale::CustomerVault::Corporation"],
      [Dorsale::CustomerVault::Individual.t,  "Dorsale::CustomerVault::Individual"],
    ]
  end
end
