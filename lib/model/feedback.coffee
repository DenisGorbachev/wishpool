class Feedback
  constructor: (doc) ->
    _.extend(@, doc)
  widget: ->
    Widgets.findOne(@widgetId)
  replyTo: ->
    if @sourceUserEmail
      '"' + @sourceUserName + '"' + ' <' + @sourceUserEmail + '>'
    else
      '"Wishpool" <hello@mail.wishpool.me>'


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
  feedback.parentUrl = sourceParameters.url or feedback.parentUrl
  _.defaults(feedback,
    text: ""
    label: widget.label
    placeholder: widget.placeholder
    parentUrl: "" # parent page
    sourceUrl: "" # iframe src
    sourceUserName: sourceParameters.userName or ""
    sourceUserEmail: sourceParameters.userEmail or ""
    sourceUserAvatarUrl: (sourceParameters.userAvatarUrl not in ["undefined"] and sourceParameters.userAvatarUrl) or ""
    sourceUserIsPaying: sourceParameters.userIsPaying in ["true", "1", "yes", "of course"]
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

Feedbacks.after.insert (userId, feedback) ->
  if feedback.isFixture or feedback.widgetId in ["BigBrother"]
    return
  transformedFeedback = share.Transformations.feedback(feedback)
  for accessibleByUserId in transformedFeedback.accessibleBy
    user = Meteor.users.findOne(accessibleByUserId)
    Email.send(
      to: user.emails[0].address,
      from: '"Wishpool" <hello@mail.wishpool.me>',
      replyTo: transformedFeedback.replyTo()
      subject: feedback.text,
      html: Spacebars.toHTML({feedback: transformedFeedback, settings: Meteor.settings}, Assets.getText("emails/newFeedback.html"))
    )

Feedbacks.before.update (userId, feedback, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  feedbackPreSave.call(@, userId, modifier.$set || {})
  true
