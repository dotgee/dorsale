$(document).on "ready turbolinks:load page:load", ->
  $(".comment a.edit").click ->
    $(this).parents(".comment").find(".text").load(this.href)
    return false
