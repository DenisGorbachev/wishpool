Widgets.allow
  insert: share.securityRulesWrapper (userId, widget) ->
    widget.ownerId = userId
    check(widget,
      _id: Match.Id
      name: String
      label: String
      placeholder: String
      css: String
      ownerId: Match.UserId
      updatedAt: Date
      createdAt: Date
    )
    true
  update: share.securityRulesWrapper (userId, widget, fieldNames, modifier, options) ->
    unless userId
      throw new Match.Error("Operation not allowed for unauthorized users")
    unless userId in widget.accessibleBy
      throw new Match.Error("Operation not allowed for users without access")
    $set =
      name: Match.Optional(String)
      updatedAt: Date
    check(modifier,
      $set: $set # updatedAt is non-optional
    )
    true
  remove: share.securityRulesWrapper (userId, widget) ->
    unless userId
      throw new Match.Error("Operation not allowed for unauthorized users")
    widget = Widgets.findOne(widget.widgetId)
    unless userId is widget.ownerId
      throw new Match.Error("Operation not allowed for non-owners")
    true