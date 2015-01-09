class Ping
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.ping = _.partial(share.transform, Ping)

@Pings = new Mongo.Collection("pings",
  transform: if Meteor.isClient then share.Transformations.ping else null
)

pingPreSave = (userId, changes) ->

Pings.before.insert (userId, ping) ->
  ping._id = ping._id || Random.id()
  now = new Date()
  _.defaults(ping,
    hostname: ""
    updatedAt: now
    createdAt: now
  )
  pingPreSave.call(@, userId, ping)
  if ping.isNew isnt false
    Email.send(
      to: "denis.d.gorbachev@gmail.com",
      from: "\"Wishpool\" <hello@mail.wishpool.me>",
      subject: "Ping from " + ping.hostname,
      text: "Ping from " + ping.hostname
    )
  true

Pings.before.update (userId, ping, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  pingPreSave.call(@, userId, modifier.$set || {})
  true
