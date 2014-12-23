share.fixtureIds = []

insertData = (data, collection) ->
  for _id of data when _id not in share.fixtureIds
    share.fixtureIds.push(_id)
  if collection.find().count() is 0
    for _id, object of data
      object._id = _id
      object.isNew = false
      collection.insert(object)
    return true

share.loadFixtures = ->
  now = new Date()
  lastWeek = new Date(now.getTime() - 7 * 24 * 3600 * 1000)

  users =
    DenisGorbachev:
      profile:
        name: "Denis Gorbachev"
    ArunodaSusiripala:
      profile:
        name: "Arunoda Susiripala"
  for _id, user of users
    _.defaults(user,
      username: _id
      isAliasedByMixpanel: true
      emails: [
        {
          address: _id.toLowerCase() + "@wishpool.com"
          verified: true
        }
      ]
      createdAt: lastWeek
    )
  usersInserted = insertData(users, Meteor.users)
  if usersInserted
    for _id, user of users
      Accounts.setPassword(_id, "123123")
      Meteor.users.update(_id, {$push: {"services.resume.loginTokens": {
        "hashedToken": Accounts._hashLoginToken(_id),
        "when": now
      }}})

  domains =
    "Pintask":
      name: "pintask.me"
      ownerId: "DenisGorbachev"
  insertData(domains, Domains)

  styles =
    "PintaskLandingPage":
      name: "Landing Page"
      domainId: "Pintask"
      ownerId: "DenisGorbachev"
    "PintaskApp":
      name: "App"
      domainId: "Pintask"
      ownerId: "DenisGorbachev"
  insertData(styles, Styles)

  pings =
    "pintask.me":
      url: "https://pintask.me/board/gzbEShDhtf7Hz4qGM"
  insertData(pings, Pings)

  serviceConfigurations =
    Google:
      service: "google",
      clientId: Meteor.settings.public.google.clientId,
      secret: Meteor.settings.google.secret
  insertData(serviceConfigurations, ServiceConfiguration.configurations)
