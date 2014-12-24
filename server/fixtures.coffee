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

  widgets =
    "BigBrother":
      name: "Landing Page"
      label: "I wish this page"
      placeholder: "had a quick search button"
      iframeCss: """
        height: 36px;
        width: 400px;
        margin: 0 auto;
        display: block;
      """
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
      name: "Landing Page"
      ownerId: "DenisGorbachev"
    "PintaskApp":
      name: "App"
      ownerId: "DenisGorbachev"
  insertData(widgets, Widgets)

  feedbacks =
    IWishThisPageHadBetterGraphics:
      text: "I wish this page had better graphics"
      label: "I wish this page"
      placeholder: "had better graphics"
      sourceUrl: "https://wishpool.meteor.com/"
      widgetId: "BigBrother"
    IWishYouHadBetterMarketing:
      text: "I wish you had better marketing"
      label: "I wish this page"
      placeholder: "had better graphics"
      sourceUrl: "https://wishpool.meteor.com/"
      widgetId: "BigBrother"
    IWishPintaskHadMobileVersion:
      text: "I wish Pintask had mobile version"
      label: "I wish Pintask"
      placeholder: "..."
      sourceUrl: "https://pintask.me/board/joJjt3kusPuiTtxjk"
      sourceUserName: "Анастасия Хохлова"
      sourceUserEmail: "honastena@pintask.me"
      sourceUserAvatarUrl: "https://www.filepicker.io/api/file/XJkV1GpKQ3KcIBbRrG4B"
      sourceUserId: "m5wg4cHCrF4myZMg3"
      isRead: true
      isStarred: true
      widgetId: "PintaskLandingPage"
    IWishPintaskHadMobileApp:
      text: "I wish Pintask had mobile app"
      label: "I wish Pintask"
      placeholder: "..."
      sourceUrl: "https://pintask.me/settings"
      sourceUserName: "Алена Виноградова"
      sourceUserEmail: "alena.vinogradova@pintask.me"
      sourceUserId: "R9L5Eh6armZGtTdur"
      isRead: true
      widgetId: "PintaskLandingPage"
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
