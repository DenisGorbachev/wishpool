Template.index.helpers
  widgetTemplateContext: ->
    {
      widget: Widgets.findOne({}, {sort: {createdAt: 1}})
    }

Template.index.rendered = ->

Template.index.events
#  "click .selector": (event, template) ->
