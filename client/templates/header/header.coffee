Template.header.helpers
  widgets: ->
    Widgets.find({}, {sort: {createdAt: 1}})

Template.header.rendered = ->

Template.header.events
  "click .add-widget": grab encapsulate (event, template) ->
    _id = Widgets.insert({})
    widget = Widgets.findOne(_id)
    $(event.currentTarget).closest(".dropdown-menu").prev(".dropdown-toggle").dropdown("toggle")
    Router.go(widget.path())
