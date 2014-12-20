Meteor.startup ->
  if Meteor.settings.public.ga.disabled
    window["ga-disable-" + Meteor.settings.public.ga.property] = true
  ga("create", Meteor.settings.public.ga.property, if Meteor.settings.public.isDebug then "none" else "auto");

share.debouncedSendPageview = _.debounce(->
  ga("send", "pageview", Router.current({reactive: false}).path)
, 300)
