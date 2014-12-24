FastRender.onAllRoutes (path) ->
  @subscribe("meteor.loginServiceConfiguration")
  @subscribe("currentUser")
  @subscribe("members")
  @subscribe("widgets")
  @subscribe("feedbacks")
  @subscribe("domains")
