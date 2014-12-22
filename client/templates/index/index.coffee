Template.index.helpers
  noDomains: ->
    not share.Domains.findOne()

Template.index.rendered = ->

Template.index.events
#  "click .selector": (event, template) ->
