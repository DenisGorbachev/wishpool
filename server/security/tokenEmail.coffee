TokenEmails.allow
  insert: share.securityRulesWrapper (userId, TokenEmail) ->
    true
  update: share.securityRulesWrapper (userId, TokenEmail, fieldNames, modifier, options) ->
    false
  remove: share.securityRulesWrapper (userId, TokenEmail) ->
    false
