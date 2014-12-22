class Member
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.member = _.partial(share.transform, Member)

share.Members = new Mongo.Collection("members",
  transform: if Meteor.isClient then share.Transformations.member else null
)

memberPreSave = (userId, changes) ->

share.Members.before.insert (userId, member) ->
  member._id ||= Random.id()
  now = new Date()
  _.defaults(member,
    userId: ""
    domainId: ""
    role: "observer"
    accessibleBy: []
    updatedAt: now
    createdAt: now
  )
  memberPreSave.call(@, userId, member)
  true

share.Members.before.update (userId, member, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  memberPreSave.call(@, userId, modifier.$set || {})
  true
