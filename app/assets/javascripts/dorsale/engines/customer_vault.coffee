$(document).on "ready turbolinks:load page:load", ->
  $(".customer_vault form:not([action*=filters]) select[name*=tag]").not(".select2-hidden-accessible").map ->
    placeholder = $(this).attr("placeholder")

    $(this).select2
      tags: true
      placeholder: placeholder


  $(".customer_vault .filters select[name*=tag]").not(".select2-hidden-accessible").map ->
    placeholder = $(this).attr("placeholder")

    $(this).select2
      tags: false
      placeholder: placeholder
