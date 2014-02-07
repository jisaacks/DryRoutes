class App extends Backbone.View
  el: "body"
  events:
    "click button" : "navi"
  template: JST["templates/app"]
  initialize: (args) ->
    # Pass the routes defined on the backbend
    # to our router before we initialize it
    App.Router.prototype.routes = args.routes
    @router = new App.Router()

    # Create a collection to store our cached articles
    @cachedArticles = new App.Articles()
    
    # If we have a bootstrapped article, cache it
    if args.article
      # You will noticed if you load an article directly
      # It bootstraps the data, and fetches others
      @cachedArticles.reset([args.article])
    
    # Just simulate a simple page
    @router.on "reached", (txt) =>
      @$("p").text "On page #{txt}"
    
    # Article page requested
    @router.on "article", (id) =>
      # Check for cached article
      if article = @cachedArticles.get(id)
        @$("p").text "Cached: " + article.get("msg")
      # Fetch and cache article
      else
        @$("p").text "Fetching..."
        article = new App.Article id:id
        article.fetch success:=>
          @$("p").text "Fetched: " + article.get("msg")
          @cachedArticles.add(article)

    @render()
    Backbone.history.start pushState: true

  render: ->
    @$el.html @template()

  navi: (e) ->
    e.preventDefault()
    rt = @$(e.currentTarget).data("route")
    @router.navigate rt, true

  class @Router extends Backbone.Router
    root: -> @reached "root"
    home: -> @reached "home"
    what: -> @reached "what"
    
    article: (id) -> @trigger "article", id

    reached: (res) -> @trigger "reached", res

  class @Article extends Backbone.Model
    url: -> "/article/#{@id}"

  class @Articles extends Backbone.Collection
    model: App.Article
