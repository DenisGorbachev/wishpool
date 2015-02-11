Meteor.startup ->
  userId = Meteor.userId()
  if Meteor.settings.public.isDebug
    if (!userId && (location.host == "localhost:3000" || location.host.indexOf("192.168") != -1) && document.cookie.indexOf("autologin=false") == -1)
      if jQuery.browser.mozilla
        Meteor.loginWithToken("ArunodaSusiripala")
      else
        Meteor.loginWithToken("DenisGorbachev")

window.fbAsyncInit = ->
  FB.init(
    appId: Meteor.settings.public.facebook.appId
    xfbml: true
  )

ZeroClipboard.config(
  swfPath: "/ZeroClipboard.swf"
)

share.autologinDetected = false
share.isAutologin = ->
  share.autologinDetected or location.href.indexOf("/autologin") isnt -1
