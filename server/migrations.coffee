version = 1

Migrations.add
  version: version++
  name: "Add emails.address"
  up: ->
    Meteor.users.find({}).forEach (user) ->
      google = user.services?.google
      if google
        if google.email
          Meteor.users.update(user._id, {$push: {"emails": { address: google.email.toLowerCase(), verified: !!google.verified_email }}})
        else
          throw new Error("gmail user must provide an email")

Meteor.startup ->
  version = Migrations._list.length - 1
  control = Migrations._collection.findOne("control")
  if not control or control.version < version # for suppressing redundant log messages
    Migrations.migrateTo("latest")
