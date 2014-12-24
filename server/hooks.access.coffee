Widgets.before.insert (userId, widget) ->
  accessibleBy = share.getWidgetAccessibleBy(widget)
  widget.accessibleBy = accessibleBy
  widget.friendUserIds = accessibleBy
  widget

Members.before.insert (userId, member) ->
  widget = Widgets.findOne(member.widgetId)
  member.accessibleBy = widget.accessibleBy
  member

Feedbacks.before.insert (userId, feedback) ->
  widget = Widgets.findOne(feedback.widgetId)
  feedback.accessibleBy = widget.accessibleBy
  feedback

Widgets.after.insert (userId, widget) ->
  Meteor.users.update({_id: {$in: widget.friendUserIds}}, {$addToSet: {friendUserIds: {$each: widget.friendUserIds}}}, {multi: true})
  Members.insert(
    userId: widget.ownerId
    widgetId: widget._id
    role: "admin"
  )

Widgets.after.update (userId, widget, fieldNames, modifier, options) ->
  if modifier.$set?.friendUserIds or modifier.$addToSet?.friendUserIds
    Meteor.users.update({_id: {$in: widget.friendUserIds}}, {$addToSet: {friendUserIds: {$each: widget.friendUserIds}}}, {multi: true})

Members.after.insert (userId, member) ->
  widget = Widgets.findOne(member.widgetId)
  Widgets.update(widget._id, {$addToSet: {friendUserIds: member.userId}})
  Meteor.users.update(member.userId, {$addToSet: {"profile.widgetPositions": widget._id}})
  share.recalculateWidgetAccessibleBy(widget)

Members.after.remove (userId, member) ->
  widget = Widgets.findOne(member.widgetId)
  if widget # widget way not exist on cascade remove hooks
    share.recalculateWidgetAccessibleBy(widget)

share.getWidgetAccessibleBy = (widget) ->
  _.pluck(Members.find(widgetId: widget._id).fetch(), "userId")

share.recalculateWidgetAccessibleBy = (widget) ->
  accessibleBy = share.getWidgetAccessibleBy(widget)
  Widgets.update(widget._id, {$set: {accessibleBy: accessibleBy, friendUserIds: accessibleBy}})
  Members.update({widgetId: widget._id}, {$set: {accessibleBy: accessibleBy}}, {multi: true})
  Feedbacks.update({widgetId: widget._id}, {$set: {accessibleBy: accessibleBy}}, {multi: true})