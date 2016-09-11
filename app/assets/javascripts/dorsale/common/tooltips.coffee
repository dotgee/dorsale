$(document).on "ready turbolinks:load page:load", ->
  $(".title-tooltip").map ->
    $(this).tooltip(html: this.title)
