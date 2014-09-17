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
    gauss = App.Gauss.create()
    matrix = [[1, -1, -5],[2, 1, -7]]
    result = gauss.solve(matrix)
    console.log "Solved: ", result
    Ember.A([])

  setupController: (controller, model) ->
    @_super arguments...
