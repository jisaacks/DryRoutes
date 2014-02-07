express = require "express"
Mincer  = require "mincer"
hamlc   = require "haml-coffee"
fs      = require "fs"
_       = require "underscore"

@app = express()
@app.set "views", __dirname + "/views"
@app.set "view engine", "hamlc"
@app.engine '.hamlc', hamlc.__express

mincer = new Mincer.Environment()
mincer.appendPath __dirname + "/assets/js"
mincer.appendPath __dirname + "/assets/css"
mincer.appendPath __dirname + "/assets/images"

@app.use('/assets', Mincer.createServer(mincer))

# These routes are used to both define our backend
# and our frontend routes. 
#
# * On the frontend, they are backbone routes, 
#   the is key is the route template and the
#   value is the method to call on the router
#
# * On the backend, the key also defines the
#   route template, and the value is the
#   method to call that returns the data to
#   either be bootstraped for html requests
#   or to sent as json for json requests.
routes =
  ""                    : "root"
  "home"                : "home"
  "what"                : "what"
  "article/:article_id" : "article"

# Methods used to retrieving data
lookup =
  article: (params) ->
    # Mock database lookup
    articles =
      "23" : "This one time was cool"
      "42" : "All of those things"
      "17" : "When I was young.."
    {
      id: params.article_id
      msg: articles[params.article_id]
    }

# Define the routes
_.each routes, (name, route) =>
  @app.get "/#{route}", (req, res) ->
    # Build the data we are sending, we need
    # to send the routes, so our router on
    # the front end can reuse them.
    data = routes:routes
    data[name] = lookup[name]?(req.params)
    # Determine the type of request
    type = req.accepts("html, json")
    if type is "html"
      # Render our app with the built up data
      res.render "app", data
    else if type is "json"
      # Just render the data for the route
      res.json data[name]

port = 8025
console.log "Listening on port #{port}"
@app.listen port