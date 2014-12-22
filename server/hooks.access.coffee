Domains.before.insert (userId, domain) ->
  accessibleBy = share.getDomainAccessibleBy(domain)
  domain.accessibleBy = accessibleBy
  domain.friendUserIds = accessibleBy
  domain

Members.before.insert (userId, member) ->
  domain = Domains.findOne(member.domainId)
  member.accessibleBy = domain.accessibleBy
  member

Styles.before.insert (userId, style) ->
  domain = Domains.findOne(style.domainId)
  style.accessibleBy = domain.accessibleBy
  style

Domains.after.insert (userId, domain) ->
  Meteor.users.update({_id: {$in: domain.friendUserIds}}, {$addToSet: {friendUserIds: {$each: domain.friendUserIds}}}, {multi: true})
  Members.insert(
    userId: domain.ownerId
    domainId: domain._id
    role: "admin"
  )

Domains.after.update (userId, domain, fieldNames, modifier, options) ->
  if modifier.$set?.friendUserIds or modifier.$addToSet?.friendUserIds
    Meteor.users.update({_id: {$in: domain.friendUserIds}}, {$addToSet: {friendUserIds: {$each: domain.friendUserIds}}}, {multi: true})

Members.after.insert (userId, member) ->
  domain = Domains.findOne(member.domainId)
  Domains.update(domain._id, {$addToSet: {friendUserIds: member.userId}})
  Meteor.users.update(member.userId, {$addToSet: {"profile.domainPositions": domain._id}})
  share.recalculateDomainAccessibleBy(domain)

Members.after.remove (userId, member) ->
  domain = Domains.findOne(member.domainId)
  if domain # domain way not exist on cascade remove hooks
    share.recalculateDomainAccessibleBy(domain)

share.getDomainAccessibleBy = (domain) ->
  _.pluck(Members.find(domainId: domain._id).fetch(), "userId")

share.recalculateDomainAccessibleBy = (domain) ->
  accessibleBy = share.getDomainAccessibleBy(domain)
  Domains.update(domain._id, {$set: {accessibleBy: accessibleBy, friendUserIds: accessibleBy}})
  Members.update({domainId: domain._id}, {$set: {accessibleBy: accessibleBy}}, {multi: true})
  Styles.update({domainId: domain._id}, {$set: {accessibleBy: accessibleBy}}, {multi: true})