share.fixtureIds = []

insertData = (data, collection) ->
  for _id of data when _id not in share.fixtureIds
    share.fixtureIds.push(_id)
  if collection.find().count() is 0
    for _id, object of data
      object._id = _id
      object.isNew = false
      object.isFixture = true
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

  widgets =
    "BigBrother":
      name: "Wishpool: Main Page"
      label: "I wish this page"
      placeholder: "were mobile-friendly"
      css: """
        .btn-success {
          background-color: #2ecc71;
        }
        .btn-success:hover, .btn-success:active {
          background-color: #29c36a;
        }
      """
      ownerId: "DenisGorbachev"
    "PintaskLandingPage":
      name: "Pintask: Main Page"
      label: "I wish this page"
      placeholder: "had better graphics"
      buttonIcon: "fa fa-paper-plane"
      buttonText: "Send me"
      ownerId: "DenisGorbachev"
    "PintaskApp":
      name: "Pintask: App"
      label: "I wish Pintask"
      placeholder: "..."
      buttonIcon: "fa fa-rocket"
      buttonText: "Up we go!"
      ownerId: "DenisGorbachev"
  insertData(widgets, Widgets)

  feedbacks =
    IWishThisPageHadBetterGraphics:
      text: "I wish this page had better graphics"
      parentUrl: "http://wishpool.me/"
      sourceUrl: new URI("http://widget.wishpool.me/BigBrother").toString()
    IWishYouHadBetterMarketing:
      text: "I wish you had better marketing"
      parentUrl: "http://wishpool.me/"
      sourceUrl: new URI("http://widget.wishpool.me/BigBrother").toString()
    IWishPintaskHadMobileVersion:
      text: "I wish Pintask had mobile version"
      parentUrl: "https://pintask.me/board/joJjt3kusPuiTtxjk"
      sourceUrl: new URI("http://widget.wishpool.me/PintaskLandingPage").setQuery(
        userName: "Анастасия Хохлова"
        userEmail: "honastena@pintask.me"
        userAvatarUrl: "/images/woman.png"
        userIsPaying: true
        userId: "m5wg4cHCrF4myZMg3"
      ).toString()
      isArchived: true
      isStarred: true
    IWishPintaskHadMobileApp:
      text: "I wish Pintask had mobile app"
      parentUrl: "https://pintask.me/settings"
      sourceUrl: new URI("http://widget.wishpool.me/PintaskLandingPage").setQuery(
        userName: "Алена Виноградова"
        userEmail: "alena.vinogradova@pintask.me"
        userId:  "R9L5Eh6armZGtTdur"
      ).toString()
      isArchived: true
  insertData(feedbacks, Feedbacks)

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
