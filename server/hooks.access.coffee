share.Domains.before.insert (userId, domain) ->
  accessibleBy = share.getDomainAccessibleBy(domain)
  domain.accessibleBy = accessibleBy
  domain.friendUserIds = accessibleBy
  domain

share.Members.before.insert (userId, member) ->
  domain = share.Domains.findOne(member.domainId)
  member.accessibleBy = domain.accessibleBy
  member

share.Styles.before.insert (userId, style) ->
  domain = share.Domains.findOne(style.domainId)
  style.accessibleBy = domain.accessibleBy
  style

share.Domains.after.insert (userId, domain) ->
  Meteor.users.update({_id: {$in: domain.friendUserIds}}, {$addToSet: {friendUserIds: {$each: domain.friendUserIds}}}, {multi: true})
  share.Members.insert(
    userId: domain.ownerId
    domainId: domain._id
    role: "admin"
  )

share.Domains.after.update (userId, domain, fieldNames, modifier, options) ->
  if modifier.$set?.friendUserIds or modifier.$addToSet?.friendUserIds
    Meteor.users.update({_id: {$in: domain.friendUserIds}}, {$addToSet: {friendUserIds: {$each: domain.friendUserIds}}}, {multi: true})

share.Members.after.insert (userId, member) ->
  domain = share.Domains.findOne(member.domainId)
  share.Domains.update(domain._id, {$addToSet: {friendUserIds: member.userId}})
  Meteor.users.update(member.userId, {$addToSet: {"profile.domainPositions": domain._id}})
  share.recalculateDomainAccessibleBy(domain)

share.Members.after.remove (userId, member) ->
  domain = share.Domains.findOne(member.domainId)
  if domain # domain way not exist on cascade remove hooks
    share.recalculateDomainAccessibleBy(domain)

share.getDomainAccessibleBy = (domain) ->
  _.pluck(share.Members.find(domainId: domain._id).fetch(), "userId")

share.recalculateDomainAccessibleBy = (domain) ->
  accessibleBy = share.getDomainAccessibleBy(domain)
  share.Domains.update(domain._id, {$set: {accessibleBy: accessibleBy, friendUserIds: accessibleBy}})
  share.Members.update({domainId: domain._id}, {$set: {accessibleBy: accessibleBy}}, {multi: true})
  share.Styles.update({domainId: domain._id}, {$set: {accessibleBy: accessibleBy}}, {multi: true})