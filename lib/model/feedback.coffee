class Feedback
  constructor: (doc) ->
    _.extend(@, doc)
  widget: ->
    Widgets.findOne(@widgetId)

share.Transformations.feedback = _.partial(share.transform, Feedback)

@Feedbacks = new Mongo.Collection("feedbacks",
  transform: if Meteor.isClient then share.Transformations.feedback else null
)

feedbackPreSave = (userId, changes) ->

Feedbacks.before.insert (userId, feedback) ->
  feedback._id ||= Random.id()
  now = new Date()
  parsedSourceUrl = URI.parse(feedback.sourceUrl)
  sourceParameters = URI.parseQuery(parsedSourceUrl.query)
  widgetId = parsedSourceUrl.path.replace("/" , "")
  widget = Widgets.findOne(widgetId)
  if not widget
    throw new Match.Error("Can't find widget #" + widgetId)
  _.defaults(feedback,
    text: ""
    label: widget.label
    placeholder: widget.placeholder
    parentUrl: "" # parent page
    sourceUrl: "" # iframe src
    sourceUserName: sourceParameters.userName or ""
    sourceUserEmail: sourceParameters.userEmail or ""
    sourceUserAvatarUrl: sourceParameters.userAvatarUrl or ""
    sourceUserIsPaying: sourceParameters.userIsPaying is "true"
    sourceUserId: sourceParameters.userId or ""
    widgetId: widget._id
    ownerId: widget.ownerId
    domainId: null
    isStarred: false
    isArchived: false
    updatedAt: now
    createdAt: now
  )
  feedbackPreSave.call(@, userId, feedback)
  true

Feedbacks.before.update (userId, feedback, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  feedbackPreSave.call(@, userId, modifier.$set || {})
  true
