Meteor.startup ->
  Tracker.autorun ->
    user = Meteor.user()
    if not user or not user.isNew
      return
    $(window).scrollTop(0) # cause, you know, that's the most logical thing to do after logging the user in
    modifier = {}
    $set = {}
    # locale needs to be set here, so that we have access to browser default locale
    #    if not user.profile.locale
    #      $set["profile.locale"] = user.services?.google?.locale || i18n.lng()
    #    i18n.setLng($set["profile.locale"] or i18n.lng())
    #    moment.locale($set["profile.locale"] or i18n.lng())
    #    $.datepicker.setDefaults($.datepicker.regional[i18n.lng()] or $.datepicker.regional[""])
    if not _.isEmpty($set)
      modifier.$set = $set
    if not _.isEmpty(modifier)
      Meteor.users.update({_id: user._id}, modifier)
    _.defer ->
      if user.isNew
        _id = Widgets.insert({name: "My first widget"}, (error) ->
          if error then throw error
          Meteor.users.update(Meteor.userId(), {$set: {isNew: false}})
        )
        Router.go("/widget/" + _id)
