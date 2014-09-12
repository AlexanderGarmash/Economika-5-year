App = require 'app'


###*
  Route IndexRoute

  @class IndexRoute
  @namespace App
  @extends Ember.Route
###
module.exports = App.IndexRoute = Ember.Route.extend
  ###*
    Our model, just some info message as of example and all the font awesome icons

    @inheritDoc
  ###
  model: (params) ->
    Ember.A([])
