App = require 'app'

###*
  Controller EditInequalitiesController

  @class EditInequalitiesController
  @namespace App
  @extends Ember.Controller
###
module.exports = App.EditInequalitiesController = Ember.ObjectController.extend
  needs:["index"]
  queryParams: ['inequalityIdList']
  inequalityIdList: null
  targetInequalities: null

  inequalityIdListObserver: (()->
    if @get('inequalityIdList')? and @get('inequalityIdList.length')? and typeof @get('inequalityIdList') isnt "string"
      result = Ember.A([])
      lines = @get('controllers.index').get('lines')
      @get('inequalityIdList').forEach (obj)->
        result.pushObject(lines.findBy 'id', parseInt(obj))
      @set 'targetInequalities', result
  ).observes('inequalityIdList')

  # targetInequalitiesObserver: (()->
  #   @get 'targetInequalities'
  # ).observes('targetInequalities')

  actions:
    save: ()->
      self = @
      @get('targetInequalities').forEach (obj)->
        target = self.get('controllers.index.lines').findBy('id', obj.id)
        self.get('controllers.index.lines').removeObject(target)
        target.set 'A', obj.get('A')
        target.set 'B', obj.get('B')
        target.set 'C', obj.get('C')
        target.computeCoordinates(obj.get('A'), obj.get('B'), obj.get('C'))
        self.get('controllers.index.lines').pushObject(target)

        target1 = self.get('controllers.index.workInequalities').findBy('id', obj.id)
        target1.inequality = target.getIneq()

        target1 = self.get('controllers.index.historyInequalities').findBy('id', obj.id)
        target1.inequality =  target.getIneq()
      @transitionToRoute 'index', {queryParams:{cacheBreacker: '123'}}
