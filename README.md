# Dry Routes

Experiment - Sharing routes between front and backend

#### tl;dr

This is a proof of concept node app that reuses the same definition of **routes** to define the routes for the Backbone.js Router on the frontend, and the corresponding Express.js routes on the backend (necessary for when using pushState which again is necessary for bootstrapping data.)

------

### Why have the same routes on the frontend and backend?

When serving a single page app, you cannot bootstrap the needed data unless using [HTML5 Push State](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Manipulating_the_browser_history#The_pushState().C2.A0method). Basically using push state allows your single page app to use real URLs instead of anchor urls. The main benefit from that is your server can see what you are requesting, since anchors are not sent to the server.

Since they are real URLs though, your server needs to be able to respond to them. That is why you want to define the same routes on your backend as frontend.

======

This defines the routes hash used by **Backbone.js**, and stores them on the backend. It maps them to **Express.js** routes and the router methods to *lookup* methods for boostrapping the correct data. It finally sends them to the front end to be injected into the Backbone router.

At this point, you still aren't saving much because you still need to define a corresponding lookup method for each route, so you may as well just define the routes manually.

This isn't intended as production level code. Just a hack I am playing with.