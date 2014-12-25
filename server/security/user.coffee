Meteor.users.allow({
  insert: (userId, user) ->
    true
  update: (userId, user, fieldNames, modifier, options) ->
    if user._id isnt userId
      return false
    return true
  remove: () ->
    false
  fetch: ['_id']
})
