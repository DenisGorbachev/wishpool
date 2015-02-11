window.olarkOnReady = ->
  Meteor.startup ->
    Deps.autorun ->
      user = Meteor.user()
      if not user
        return
      olark('api.visitor.updateEmailAddress', {emailAddress: user.emails[0].address})
      olark('api.visitor.updateFullName', {fullName: user.profile.name})
