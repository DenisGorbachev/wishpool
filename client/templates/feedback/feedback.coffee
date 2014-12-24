Template.feedback.helpers
  isOpen: ->
    Session.equals("feedback-" + @_id + "-is-open", true)
  sourceUrlCast: ->
    @sourceUrl.replace(/^[^:]+:\/\//, "").replace(/\/$/, "")
  sourceUserEmailSubject: ->
    encodeURIComponent("RE: " + @text)

Template.feedback.rendered = ->

Template.feedback.events
  "click .feedback": encapsulate (event, template) ->
    if $(event.target).closest(".passthru").length
      return
    event.preventDefault()
    Session.set("feedback-" + @_id + "-is-open", not Session.get("feedback-" + @_id + "-is-open"))
  "click .toggle-is-starred": encapsulate (event, template) ->
    Feedbacks.update(@_id, {$set: {isStarred: not @isStarred}})
  "click .toggle-is-archived": encapsulate (event, template) ->
    Feedbacks.update(@_id, {$set: {isArchived: not @isArchived}})