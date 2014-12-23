Template.domain.helpers
  domainName: ->
    Session.get("domainName")
#  styles: ->
#    Styles.find({domainId: @data.domain._id})

Template.domain.rendered = ->
  domain = @data.domain
  Session.set("domainName", domain.name)

Template.domain.events
#  "click .selector": (event, template) ->
