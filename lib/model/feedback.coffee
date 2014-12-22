class Feedback
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.feedback = _.partial(share.transform, Feedback)

share.Feedbacks = new Mongo.Collection("feedbacks",
  transform: if Meteor.isClient then share.Transformations.feedback else null
)

feedbackPreSave = (userId, changes) ->

share.Feedbacks.before.insert (userId, feedback) ->
  feedback._id = feedback._id || Random.id()
  now = new Date()
  _.defaults(feedback,
    text: ""
    updatedAt: now
    createdAt: now
  )
  feedbackPreSave.call(@, userId, feedback)
  true

share.Feedbacks.before.update (userId, feedback, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  feedbackPreSave.call(@, userId, modifier.$set || {})
  true
