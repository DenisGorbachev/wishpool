Widgets.allow
  insert: share.securityRulesWrapper (userId, widget) ->
    widget.ownerId = userId
    check(widget,
      _id: Match.Id
      name: String
      label: String
      placeholder: String
      buttonIcon: String
      buttonText: String
      css: String
      code: String
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
      label: Match.Optional(String)
      placeholder: Match.Optional(String)
      buttonIcon: Match.Optional(String)
      buttonText: Match.Optional(String)
      css: Match.Optional(String)
      code: Match.Optional(String)
      updatedAt: Date
    check(modifier,
      $set: $set # updatedAt is non-optional
    )
    true
  remove: share.securityRulesWrapper (userId, widget) ->
    unless userId
      throw new Match.Error("Operation not allowed for unauthorized users")
    unless userId is widget.ownerId
      throw new Match.Error("Operation not allowed for non-owners")
    true