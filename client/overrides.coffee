Template._loginButtonsLoggedOutDropdown.rendered = ->
  $a = @$("a.dropdown-toggle")
  $a.addClass("button")
  $a.find(".caret").remove()
  $a.text("Sign up free")
  $dropdown = $a.closest(".dropdown")
  $dropdown.find(".btn-Google").addClass("btn-lg")
  $dropdown.on("click", (event) ->
    $target = $(event.target)
    if $target.is(".dropdown-menu")
      event.stopPropagation()
      event.stopImmediatePropagation()
  )
  $(".col-sm-12").addClass("col-xs-12").removeClass("col-sm-12")

#Blaze._reportException = (e, msg) ->
#  console.log(msg)
#  throw e
