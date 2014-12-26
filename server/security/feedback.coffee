Feedbacks.allow
  insert: share.securityRulesWrapper (userId, feedback) ->
    check(feedback,
      text: String
      parentUrl: Match.Url
      sourceUrl: Match.Url
    )
    true
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
    unless userId in feedback.accessibleBy
      throw new Match.Error("Operation not allowed for users without access to object")
    true