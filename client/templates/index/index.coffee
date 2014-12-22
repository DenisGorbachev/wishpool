Template.index.helpers
  noDomains: ->
    not Domains.findOne()

Template.index.rendered = ->

Template.index.events
#  "click .selector": (event, template) ->
