# Doc : http://bootstrap-datepicker.readthedocs.io/en/stable/index.html

window.setupDatepickers = ->
  $("input[type*=date], input[name*=date], input[name$=_at]").map ->
    return if this.type == "hidden"

    this.type = "text"

    # 2015-06-12 to 15/06/2015
    if this.value.match("-")
      this.value = this.value.split("-").reverse().join("/")

    $(this).datepicker
      language: "fr"
      format: "dd/mm/yyyy"
      todayBtn: "linked"
      autoclose: true

$(document).on "ready turbolinks:load page:load", ->
  setupDatepickers()
