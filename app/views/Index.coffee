App = require 'app'

###*
  View IndexView

  @class IndexView
  @namespace App
  @extends Ember.View
###
module.exports = App.IndexView = Ember.View.extend
  ###*
    Remove this if you don't need to override it

    @inheritDoc
  ###
  templateName: 'index'

  didInsertElement: ->
    @_super()
    Ember.run.scheduleOnce "afterRender", this, @afterRenderEvent
    return

  afterRenderEvent: ->
    @get('controller').generatePreview()
    return
    
  change:(event, view)->
    @_super arguments...
    event = event or window.event
    clickedElem = event.target or event.srcElement
    @checkLineTypeChange(clickedElem.id)
    

  generatePreview: () ->
    board = JXG.JSXGraph.initBoard 'box', {boundingbox: [-0.5, 10, 10, -0.5], axis: false}
    window.board = board
    x = board.create 'line', [[1.0, 0.0], [2.0, 0.0]],{lastArrow:true, strokeColor:'black', strokeWidth:1}
    y = board.create 'line', [[0.0, 1.0], [0.0, 2.0]],{lastArrow:true, strokeColor:'black', strokeWidth:1}

  checkLineTypeChange:((id)->
    if id is 'line_type_1'
      $('#type_1').show()
      $('#type_2').hide()
      $('#type_3').hide()
      @get('controller').clearTemporyValues()
    else if id is 'line_type_2'
      $('#type_1').hide()
      $('#type_2').show()
      $('#type_3').hide()
      @get('controller').clearTemporyValues()
    else if id is 'line_type_3'
      $('#type_1').hide()
      $('#type_2').hide()
      $('#type_3').show()
      @get('controller').clearTemporyValues()
  )