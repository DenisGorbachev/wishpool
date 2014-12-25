Meteor.users.before.insert (userId, user) ->
  _.defaults(user,
    isNew: true
  )
  true
