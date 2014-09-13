App = require 'app'

###*
  Route EditInequalitiesRoute

  @class EditInequalitiesRoute
  @namespace App
  @extends Ember.Route
###
module.exports = App.EditInequalitiesRoute = Ember.Route.extend
  ###*
    Override this if needed, else remove it

    @inheritDoc
  ###
  model: (params) ->
    @_super arguments...
    Ember.A(params.inequalityIdList.split(','))

  ###*
    Override this if needed, else remove it

    @inheritDoc
  ###
  setupController: (controller, model) ->
    @_super arguments...
    controller.set 'inequalityIdList', model
