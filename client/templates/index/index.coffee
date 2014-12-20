Template.index.helpers
#  helper: ->

Template.index.rendered = ->
  $(".masthead").height($(window).height())
  @$(".typed").typed(
    strings: ["Desires", "Thoughts", "Mind", "Soul"]
    startDelay: 0
    backDelay: 2500
    typeSpeed: 70
    backSpeed: 10
    loop: true
  )

Template.index.events
  "click .scrollto, click .gototop": (event, template) ->
    $anchor = $(event.currentTarget);
    $('html, body').stop().animate({
      scrollTop: $($anchor.attr('href')).offset().top
    }, 1500, 'easeInOutExpo');
    event.preventDefault();
