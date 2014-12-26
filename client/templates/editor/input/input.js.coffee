Template.input.helpers
  placeholder: ->
    @placeholder or i18n.t(@placeholderI18n)
  disabled: ->
    not (if _.isBoolean(@enabled) then @enabled else true)

Template.input.rendered = ->
  _id = @data._id
  property = @data.property
  element = @firstNode
  $element = $(element)
  editor = EditorCache.editors[@data.family]
  @autorun ->
    if element isnt document.activeElement
      object = editor.collection.findOne(_id)
      value = object[property]
      $element.val(value)
  if editor.isEditedProperty(@data._id, @data.property)
    $activeElement = $(document.activeElement)
    if $element.get(0) isnt document.activeElement and (not $activeElement.closest("textarea, input").length or $activeElement.attr("data-family") and $activeElement.attr("data-family") is $element.attr("data-family"))
      if @data.isNew
        $element.select()
      else
        $element.focusToEnd()

Template.input.events
  "focus .property-editor": encapsulate (event, template) ->
    editor = EditorCache.editors[template.data.family]
    editor.setEditingProperty(template.data._id, template.data.property)
  "keydown .property-editor": encapsulate (event, template) ->
    $editor = $(event.target)
    editor = EditorCache.editors[template.data.family]
    data = template.data
    switch event.keyCode
      when 13 # Enter
        editor.saveProperty(template.data._id, template.data.property, $editor.val())
      when 27 # Escape
        event.preventDefault()
        editor.stopEditing(data._id)
      else
      # noop
  "keyup .property-editor, paste .property-editor": (event, template) ->
    $editor = $(event.target)
    editor = EditorCache.editors[template.data.family]
    switch event.keyCode
      when 13 # Enter
        # handled in keydown
      else
        editor.debouncedSaveProperty(template.data._id, template.data.property, $editor.val())
