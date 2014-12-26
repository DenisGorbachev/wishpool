share.WidgetEditor = new Editor(
  collection: Widgets
  family: "widget"
  isSingleLine: (property) ->
    property not in ["css"]
)
