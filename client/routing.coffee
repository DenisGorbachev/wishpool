Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"
  yieldTemplates:
    "header": {to: "header"}

Router.map ->
  @route "index",
    path: "/"
    data: ->
      {
        starred: Feedbacks.find({isStarred: true}, {sort: {isArchived: -1}})
        new: Feedbacks.find({isArchived: false, isStarred: false})
        archived: Feedbacks.find({isArchived: true, isStarred: false})
      }
  @route "domainAdd",
    path: "/domain/add"
  @route "domain",
    path: "/domain/:_id"
    data: ->
      {
        domain: Domains.findOne(@params._id)
      }
  @route "widgetAdd",
    path: "/widget/add"
  @route "widget",
    path: "/widget/:_id"
    data: ->
      {
        widget: Widgets.findOne(@params._id)
      }

Router.onBeforeAction ->
  if Meteor.userId()
    if not Widgets.findOne({isNew: false})
      _id = Widgets.insert({name: "My first widget"})
      Router.go("/widget/" + _id)
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
