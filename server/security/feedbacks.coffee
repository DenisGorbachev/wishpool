Feedbacks.allow
  update: share.securityRulesWrapper (userId, feedback, fieldNames, modifier, options) ->
    unless userId
      throw new Match.Error("Operation not allowed for unauthorized users")
    unless userId in feedback.accessibleBy
      throw new Match.Error("Operation not allowed for users without access")
    $set =
      isStarred: Match.Optional(Boolean)
      isArchived: Match.Optional(Boolean)
      updatedAt: Date
    check(modifier,
      $set: $set # updatedAt is non-optional
    )
    true
  remove: share.securityRulesWrapper (userId, feedback) ->
    unless userId
      throw new Match.Error("Operation not allowed for unauthorized users")
    widget = Widgets.findOne(feedback.widgetId)
    unless userId is widget.ownerId
      throw new Match.Error("Operation not allowed for non-owners of source widget")
    true