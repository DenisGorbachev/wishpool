class Domain
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.domain = _.partial(share.transform, Domain)

@Domains = new Mongo.Collection("domains",
  transform: if Meteor.isClient then share.Transformations.domain else null
)

domainPreSave = (userId, changes) ->

Domains.before.insert (userId, domain) ->
  domain._id ||= Random.id()
  now = new Date()
  _.defaults(domain,
    name: ""
    accessibleBy: []
    ownerId: userId
    updatedAt: now
    createdAt: now
  )
  domainPreSave.call(@, userId, domain)
  true

Domains.before.update (userId, domain, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  domainPreSave.call(@, userId, modifier.$set || {})
  true
