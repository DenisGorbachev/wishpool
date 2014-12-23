Template.domainAdd.helpers
#  helper: ->

Template.domainAdd.rendered = ->
  @$("input, select, textarea").not("[type=submit]").jqBootstrapValidation()

Template.domainAdd.events
  'submit form': grab encapsulate (event, template) ->
    domain = $(template.find("input[name='name']")).val()
#    domainName = getHostName(domain)
#    cl "parsed value = " + domainName
    Domains.insert(
      name: domain
    )
    newlyCreatedDomain = Domains.findOne({name:domain})
    cl newlyCreatedDomain
    cl newlyCreatedDomain._id
    Router.go("/domain/"+newlyCreatedDomain._id)

#getHostName = (domain) ->
#  if domain.indexOf("http") isnt 0
#    domain = "http://" + domain
#  parser = document.createElement("a")
#  cl domain
#  parser.href = domain
#  return parser.hostname
