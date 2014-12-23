Template.domainAdd.helpers
#  helper: ->

Template.domainAdd.rendered = ->
  @$("input, select, textarea").not("[type=submit]").jqBootstrapValidation()

Template.domainAdd.events
#  "click .selector": (event, template) ->
