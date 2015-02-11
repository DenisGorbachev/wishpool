UI.registerHelper("share", ->
  share
)

UI.registerHelper("Settings", ->
  Meteor.settings
)

UI.registerHelper("Router", ->
  Router
)

UI.registerHelper "currentUserId", ->
  Meteor.userId()

UI.registerHelper("condition", (v1, operator, v2, options) ->
  switch operator
    when "==", "eq", "is"
      v1 is v2
    when "!=", "neq", "isnt"
      v1 isnt v2
    when "===", "ideq"
      v1 is v2
    when "!==", "nideq"
      v1 isnt v2
    when "&&", "and"
      v1 and v2
    when "||", "or"
      v1 or v2
    when "<", "lt"
      v1 < v2
    when "<=", "lte"
      v1 <= v2
    when ">", "gt"
      v1 > v2
    when ">=", "gte"
      v1 >= v2
    else
      throw "Undefined operator \"" + operator + "\""
)

UI.registerHelper("not", (value) ->
  not value
)

UI.registerHelper("momentFromNow", (date) ->
  moment(date).fromNow()
)

UI.registerHelper("encodeURIComponent", (value) ->
  encodeURIComponent(value)
)

UI.registerHelper("currentUserEmail", ->
  Meteor.user().emails[0].address
)

UI.registerHelper("currentUrl", ->
  location.protocol + "//" + location.hostname + (if location.port then ':' + location.port else '') + Iron.Location.get().path
)
