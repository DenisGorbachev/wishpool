class Style
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.style = _.partial(share.transform, Style)

share.Styles = new Mongo.Collection("styles",
  transform: if Meteor.isClient then share.Transformations.style else null
)

stylePreSave = (userId, changes) ->

share.Styles.before.insert (userId, style) ->
  style._id ||= Random.id()
  now = new Date()
  _.defaults(style,
    css: ""
    accessibleBy: []
    updatedAt: now
    createdAt: now
  )
  stylePreSave.call(@, userId, style)
  true

share.Styles.before.update (userId, style, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  stylePreSave.call(@, userId, modifier.$set || {})
  true
