Template.domainAdd.helpers
#  helper: ->

Template.domainAdd.rendered = ->
  @$("input, select, textarea").not("[type=submit]").jqBootstrapValidation()

Template.domainAdd.events
  'submit form': grab encapsulate (event, template) ->
    name = template.$("input[name='name']").val()
#    domainName = getHostName(domain)
#    cl "parsed value = " + domainName
    _id = Domains.insert(
      name: name
    )
    Router.go("/domain/" + _id)

#getHostName = (domain) ->
#  if domain.indexOf("http") isnt 0
#    domain = "http://" + domain
#  parser = document.createElement("a")
#  cl domain
#  parser.href = domain
#  return parser.hostname
