Template.widget.helpers
#  helper: ->

Template.widget.rendered = ->
  client = new ZeroClipboard(@find(".copy-to-clipboard"))
  client.on("copy", (event) ->
    value = $("[name='code']").val()
    clipboard = event.clipboardData
    clipboard.setData("text/plain", value)
    clipboard.setData("text/html", value)
  )

Template.widget.events
#  'click .btn': (event, template) ->
