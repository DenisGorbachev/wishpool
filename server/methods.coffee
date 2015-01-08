Meteor.methods(
  "ping": (url) ->
    check(url, String)
    @unblock()
    uri = new URI(url)
    hostname = uri.hostname()
    ping = Pings.findOne({hostname: hostname})
    if not ping
      Pings.insert({hostname: hostname})
    true
)