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