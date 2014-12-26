Template.header.helpers
  widgets: ->
    Widgets.find({}, {sort: {createdAt: 1}})

Template.header.rendered = ->

Template.header.events
#  "click .selector": (event, template) ->
