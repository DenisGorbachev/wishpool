Template.index.helpers
#  helper: ->

Template.index.rendered = ->
  @$('[data-typer-targets]').typer()

Template.index.events
  "click .scrollto, click .gototop": (event, template) ->
    $anchor = $(event.currentTarget);
    $('html, body').stop().animate({
      scrollTop: $($anchor.attr('href')).offset().top
    }, 1500, 'easeInOutExpo');
    event.preventDefault();
