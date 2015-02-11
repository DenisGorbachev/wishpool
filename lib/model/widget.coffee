class Widget
  constructor: (doc) ->
    _.extend(@, doc)
  path: -> "/widget/" + @_id

share.Transformations.widget = _.partial(share.transform, Widget)

@Widgets = new Mongo.Collection("widgets",
  transform: if Meteor.isClient then share.Transformations.widget else null
)

generateQuery = ->
  "?userName=&userEmail=&userAvatarUrl=&userIsPaying=&userId="

generateUrl = (_id) ->
  Meteor.settings.public.widgetUrl + '/' + _id

generateCode = (src) ->
  '<iframe src="' + src + '" frameborder="0" scrolling="no" allowtransparency="yes" style="display: block; margin: 0 auto; width: 100%; height: 40px;"></iframe>'

widgetPreSave = (userId, changes) ->

Widgets.before.insert (userId, widget) ->
  widget._id ||= Random.id()
  now = new Date()
  _.defaults(widget,
    name: ""
    label: "I wish this page"
    placeholder: "had better graphics"
    buttonIcon: ""
    buttonText: "Send"
    css: """
      /* Add your brand colors */
      .btn-success {
        
      }
      .btn-success:hover, .btn-success:active {

      }
    """
    code: generateCode(generateUrl(widget._id) + generateQuery())
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

Widgets.after.update (userId, widget, fieldNames, modifier, options) ->
  $set = {}
  url = generateUrl(widget._id)
  if widget.code.indexOf(url) is -1
    src = url + generateQuery()
    codeWithSrc = widget.code.replace(/src=\"[^\"]*\"/, 'src="' + src + '"')
    if codeWithSrc is widget.code # no replacement took place (e.g. src attribute not found in code)
      codeWithSrc = generateCode(src) # regenerate from scratch
    $set.code = codeWithSrc
    if Meteor.isClient then $("[name='code']").val($set.code) # Meteor doesn't reactively update focused textarea
  if not widget.name
    $set.name = "Lovely midget"
    if Meteor.isClient then $("[name='name']").val($set.name) # Meteor doesn't reactively update focused input
  if not _.isEmpty($set)
    Widgets.update(widget._id, {$set: $set})
  true
