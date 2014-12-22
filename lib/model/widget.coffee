class Widget
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.widget = _.partial(share.transform, Widget)

share.Widgets = new Mongo.Collection("widgets",
  transform: if Meteor.isClient then share.Transformations.widget else null
)

widgetPreSave = (userId, changes) ->

share.Widgets.before.insert (userId, widget) ->
  widget._id = widget._id || Random.id()
  now = new Date()
  _.defaults(widget,
    url: ""
    updatedAt: now
    createdAt: now
  )
  widgetPreSave.call(@, userId, widget)
  true

share.Widgets.before.update (userId, widget, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  widgetPreSave.call(@, userId, modifier.$set || {})
  true
