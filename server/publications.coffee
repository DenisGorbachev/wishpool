Meteor.publish("currentUser", ->
  Meteor.users.find({_id: @userId},
    fields:
      "username": 1
      "isAliasedByMixpanel": 1
      "group": 1
      "profile": 1
      "createdAt": 1
      "isNew": 1
  )
)

Meteor.publish("widgets", ->
  if not @userId then return []
  Widgets.find({accessibleBy: @userId}, {fields: {accessibleBy: 0, friendUserIds: 0}})
)

Meteor.publish("members", ->
  if not @userId then return []
  Members.find({accessibleBy: @userId}, {fields: {accessibleBy: 0}})
)

Meteor.publish("feedbacks", ->
  if not @userId then return []
  Feedbacks.find({accessibleBy: @userId}, {fields: {accessibleBy: 0}})
)

Meteor.publish("domains", ->
  if not @userId then return []
  Domains.find({accessibleBy: @userId}, {fields: {accessibleBy: 0}})
)
