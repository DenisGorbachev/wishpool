Template._loginButtonsLoggedOutDropdown.rendered = ->
  Accounts._loginButtonsSession.set("inSignupFlow", true)
  $a = @$("a.dropdown-toggle")
  $dropdown = $a.closest(".dropdown")
  $dropdown.find(".btn-Google").addClass("btn-lg")
  $dropdown.on("click", (event) ->
    $target = $(event.target)
    if $target.is(".dropdown-menu")
      event.stopPropagation()
      event.stopImmediatePropagation()
  )
  switch @data.type
    when "HeroButton"
      $a.addClass("button")
      $a.find(".caret").remove()
      $a.text("Sign up free")
    when "NavbarButton"
      $a.addClass("button")
      $a.find(".caret").remove()
      $a.text("Sign up free")
    when "SmallButton"
      $a.addClass("button small-button")
      $a.find(".caret").remove()
      $a.text("Sign up free")
    when "NavbarLink"
      $a.text("Login")
    else
      throw "Unknown button type #{@data.type}"

#Blaze._reportException = (e, msg) ->
#  console.log(msg)
#  throw e

