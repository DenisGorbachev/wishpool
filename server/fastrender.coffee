FastRender.onAllRoutes (path) ->
  @subscribe("meteor.loginServiceConfiguration")
  @subscribe("currentUser")
  @subscribe("domains")
  @subscribe("members")
  @subscribe("styles")
