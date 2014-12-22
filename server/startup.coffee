Meteor.startup ->
  try
    Meteor.users._dropIndex("emails.address_1")
  catch error
    Meteor._debug(error.toString())
  Meteor.users._ensureIndex({"emails.address": 1}, {unique: true, sparse: 1, background: true, name: "emails.address_1"})

  Meteor.users._ensureIndex({username: 1}, {unique: true, background: true})
  Meteor.users._ensureIndex({friendUserIds: 1}, {background: true})
#  share.Wikis._ensureIndex({accessibleBy: 1}, {background: true})
#  share.Wikis._ensureIndex({slug: 1}, {unique: true, background: true})
#  TODO: when collection is ready: share.Files._ensureIndex({accessibleBy: 1}, {background: true})
  share.loadFixtures()
  if Meteor.settings.public.isDebug
    Meteor.setInterval(share.loadFixtures, 300)
  else
    # noop
