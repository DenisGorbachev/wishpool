Widgets.before.insert (userId, widget) ->
  if not widget.name
    prefix = "New widget" # i18n.t("defaults.board.name")
    count = Widgets.find({ name: { $regex: "^" + prefix, $options: "i" } }).count()
    widget.name = prefix
    if count
      widget.name += " (" + count + ")"
