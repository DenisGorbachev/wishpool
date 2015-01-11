Meteor.methods(
  "ping": (url) ->
    check(url, String)
    @unblock()
    ping = Pings.findOne({url: url})
    if not ping
      Pings.insert({url: url})
    true
)