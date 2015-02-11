Meteor.methods(
  "ping": (url, widgetId) ->
    check(url, String)
    check(widgetId, String)
    @unblock()
    ping = Pings.findOne({url: url, widgetId: widgetId})
    if not ping
      Pings.insert({url: url, widgetId: widgetId})
    true
)
