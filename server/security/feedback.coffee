Feedbacks.allow
  insert: share.securityRulesWrapper (userId, feedback) ->
    if feedback.email
      check(feedback,
        text: String
        parentUrl: Match.Url
        sourceUrl: Match.Url
        email: Match.Email
      )
    else
      check(feedback,
        text: String
        parentUrl: Match.Url
        sourceUrl: Match.Url,
        sourceUserToken: String
      )
    true
  update: share.securityRulesWrapper (userId, feedback, fieldNames, modifier, options) ->
    if fieldNames.length is 1 and fieldNames[0] is 'sourceUserEmail'
      $set =
        sourceUserEmail: Match.Email
      check(modifier,
        $set: $set
      )
      true
    else
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