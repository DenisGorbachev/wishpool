class TokenEmail
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.TokenEmail = _.partial(share.transform, TokenEmail)

@TokenEmails = new Mongo.Collection("token_emails",
  transform: if Meteor.isClient then share.Transformations.TokenEmail else null
)

@TokenEmailPreSave = (userId, changes) ->
  now = new Date()
  changes.wishpoolUpdatedAt = changes.wishpoolUpdatedAt or now

TokenEmails.before.insert (userId, TokenEmail) ->
  TokenEmail._id ||= Random.id()
  now = new Date()
  _.defaults(TokenEmail,
    email: TokenEmail.email or ""
    wishpoolOwnerToken: TokenEmail.wishpoolOwnerToken or null
    wishpoolUpdatedAt: now
    wishpoolCreatedAt: now
  )
  TokenEmailPreSave.call(@, userId, TokenEmail)
  true

TokenEmails.before.update (userId, TokenEmail, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  TokenEmailPreSave.call(@, userId, modifier.$set)
  true
