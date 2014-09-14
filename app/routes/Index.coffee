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
    console.log "S;LDGVJNLSNF"
    Ember.A([])

  setupController: (controller, model) ->
    @_super arguments...
    # lines = controller.get('lines')
    # controller.set 'lines', null
    # controller.set 'lines', Ember.A([])
    # controller.get('lines').pushObjects(lines)
