Template.widget.helpers
#  helper: ->

Template.widget.rendered = ->

Template.widget.events
  'click .set-button-icon': (event, template) ->
    event.currentTarget.blur()
    Widgets.update(@_id, {$set: {buttonIcon: $(event.currentTarget).attr('data-button-icon')}})
