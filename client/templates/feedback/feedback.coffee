Template.feedback.helpers
  isActive: ->
    location.hash is "#" + @_id
  isOpen: ->
    Session.equals("feedback-" + @_id + "-is-open", true)
  parentUrlCast: ->
    @parentUrl.replace(/^[^:]+:\/\//, "").replace(/\/$/, "")
  sourceUserEmailSubject: ->
    encodeURIComponent("RE: " + @text)

Template.feedback.rendered = ->
  if location.hash is "#" + @data._id
    Session.set("feedback-" + @data._id + "-is-open", true)

Template.feedback.events
  "click .feedback": encapsulate (event, template) ->
    if $(event.target).closest(".passthru").length
      return
    event.preventDefault()
    Session.set("feedback-" + @_id + "-is-open", not Session.get("feedback-" + @_id + "-is-open"))
  "click .toggle-is-starred": grab encapsulate (event, template) ->
    Feedbacks.update(@_id, {$set: {isStarred: not @isStarred}})
  "click .toggle-is-archived": grab encapsulate (event, template) ->
    Feedbacks.update(@_id, {$set: {isArchived: not @isArchived}})
  "click .remove": grab encapsulate (event, template) ->
    $link = $(event.currentTarget)
    if (confirm($link.attr("data-confirm")))
      Feedbacks.remove(@_id)