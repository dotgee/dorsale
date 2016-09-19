window.dorsaleComments =
  load: ->
    $("#dorsale-comments").map ->
      container = $(this)
      url       = this.dataset.url

      $.ajax
        url: url
        success: (data) ->
          container.html(data)
          dorsaleComments.setupCreateForm()
          dorsaleComments.setupEditButtons()
          dorsaleComments.setupDeleteButtons()

  reload: ->
    dorsaleComments.load()

  setupCreateForm: ->
    $("#dorsale-comments form[id*=new]").on("ajax:success", dorsaleComments.reload)

  setupEditForm: ->
    $("#dorsale-comments form[id*=edit]").on("ajax:success", dorsaleComments.reload)

  setupEditButtons: ->
    $("#dorsale-comments [href$=edit]").click ->
      container = $(this).parents(".comment")
      url       = this.href

      $.ajax
        url: url
        success: (data) ->
          container.replaceWith(data)
          dorsaleComments.setupEditForm()

      return false

  setupDeleteButtons: ->
    $("#dorsale-comments [data-method=delete]").on("ajax:success", dorsaleComments.reload)
