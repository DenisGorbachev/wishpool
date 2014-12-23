Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"
  yieldTemplates:
    "header": {to: "header"}

Router.map ->
  @route "index",
    path: "/"
#    data: ->
#      {
#        domains: Domains.findAll({ownerId : Meteor.userId()})
#      }
  @route "domainAdd",
    path: "/domain/add"
  @route "domain",
    path: "/domain/:_id"
    data: ->
      {
        domain: Domains.findOne(@params._id)
      }
  @route "styleAdd",
    path: "/style/add"
  @route "style",
    path: "/style/:_id"
    data: ->
      {
        style: share.Styles.findOne(@params._id)
      }

Router.onBeforeAction ->
  if Meteor.userId()
    if not Domains.findOne()
      Router.go("/domain/add")
    @next()
  else
    @render(null, {to: "header"})
    @render("welcome")

Router.onAfterAction ->
  share.setPageTitle("Wishpool = Instant customer feedback with ♥", false)

Router.onAfterAction ->
  share.debouncedSendPageview()

share.setPageTitle = (title, appendSiteName = true) ->
  if appendSiteName
    title += " - Wishpool"
  if Meteor.settings.public.isDebug
    title = "(D) " + title
  document.title = title
