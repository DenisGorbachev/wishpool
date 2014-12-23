Template.welcome.helpers
#  helper: ->

Template.welcome.rendered = ->
  $(".masthead").height($(window).height())
  @$(".typed").typed(
    strings: ["issues", "wishes", "concerns"]
    showCursor: false
    startDelay: 0
    backDelay: 2500
    typeSpeed: 70
    backSpeed: 10
    loop: true
  )

Template.welcome.events
  "click .login-with-google": (event, template) ->
    Meteor.loginWithGoogle()
  "click .scrollto, click .gototop": (event, template) ->
    $anchor = $(event.currentTarget);
    $('html, body').stop().animate({
      scrollTop: $($anchor.attr('href')).offset().top
    }, 1500, 'easeInOutExpo');
    event.preventDefault();
