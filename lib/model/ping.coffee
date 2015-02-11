class Ping
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.ping = _.partial(share.transform, Ping)

@Pings = new Mongo.Collection("pings",
  transform: if Meteor.isClient then share.Transformations.ping else null
)

pingPreSave = (userId, changes) ->
  if changes.url
    uri = new URI(changes.url)
    fullHostname = uri.hostname() or changes.hostname or ""
    rootHostname = fullHostname.split(".").slice(-2).join(".")
    changes.hostname = rootHostname

Pings.before.insert (userId, ping) ->
  ping._id = ping._id || Random.id()
  now = new Date()
  _.defaults(ping,
    url: ""
    hostname: ""
    updatedAt: now
    createdAt: now
  )
  pingPreSave.call(@, userId, ping)
  true

Pings.after.insert (userId, ping) ->
  if ping.isFixture
    return
  pingsWithSameHostnameCount = Pings.find({hostname: ping.hostname, widgetId: ping.widgetId}).count()
  if pingsWithSameHostnameCount <= 1
    widget = Widgets.findOne(ping.widgetId)
    mixpanel.track("Install", _.defaults({distinct_id: widget.ownerId}, ping))
    Email.send(
      to: "denis.d.gorbachev@gmail.com",
      from: "\"Wishpool\" <hello@mail.wishpool.me>",
      subject: "Ping from " + ping.hostname,
      text: "Ping from " + ping.hostname
    )

Pings.before.update (userId, ping, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  pingPreSave.call(@, userId, modifier.$set || {})
  true
