Router.map ->
  @route "users",
    where: "server"
    path: "/4765e8ad1777b97fa87dd1f96027e131f95cfc01"
    action: ->
      response = @response
      response.writeHead(200, {"Content-Type": "text/json; charset=UTF-8"})
      Meteor.users.find({}, {fields: {"emails.address": 1, "profile.name": 1}}).forEach (user) ->
        email = user.emails[0].address
        name = user.profile.name
        response.write('"' + email + '","' + name + '"\n')
      response.end()
