class Widget
  constructor: (doc) ->
    _.extend(@, doc)
  path: -> "/widget/" + @_id

share.Transformations.widget = _.partial(share.transform, Widget)

@Widgets = new Mongo.Collection("widgets",
  transform: if Meteor.isClient then share.Transformations.widget else null
)

widgetPreSave = (userId, changes) ->

Widgets.before.insert (userId, widget) ->
  widget._id ||= Random.id()
  now = new Date()
  _.defaults(widget,
    name: ""
    label: "I wish this page"
    placeholder: "had better graphics"
    css: ""
    accessibleBy: []
    friendUserIds: []
    isNew: true
    ownerId: userId
    updatedAt: now
    createdAt: now
  )
  widgetPreSave.call(@, userId, widget)
  true

Widgets.before.update (userId, widget, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  widgetPreSave.call(@, userId, modifier.$set || {})
  true
