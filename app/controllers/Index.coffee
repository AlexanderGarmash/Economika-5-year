App = require 'app'

###*
  Controller IndexController

  @class IndexController
  @namespace App
  @extends Ember.ObjectController
###
module.exports = App.IndexController = Ember.ObjectController.extend
  ###*
    Holds our model

    @property content
    @type Object
  ###
  needs: ["application"]
  content: null
  newLine: App.LinePrototype.create()
  signTypeList: Ember.A(['<=', '>=', '='])
  lines: Ember.A([])
  jsxLines: Ember.A([])
  points: Ember.A([])
  axies: Ember.Object.create({x: null, y: null})
  isFilled: no
  generator: App.IdGenerator.create()
  historyInequalities: Ember.A([])
  workInequalities: Ember.A([])
  selectedInequalities: null
  targetFunction: null
  targetFunctionLine: null

  linesObserver:(()->
    if this.get('controllers.application.currentPath') is "index"
      @plotLines()
    return
  ).observes('lines.@each')

  selectedInequalitiesProperty: (()->
    if @get('selectedInequalities') and @get('selectedInequalities')? and @get('selectedInequalities').length and @get('selectedInequalities').length? and @get('selectedInequalities').length > 0
      return yes
    return no  
  ).property('selectedInequalities.@each')

  isTargetFunctionApplied:(()->
    if @get('targetFunction')?
      @plotTargetFunction()
      return yes
    @removeTargetFunction()
    return no
  ).property('targetFunction', 'targetFunction.C', 'targetFunction.A', 'targetFunction.B')

  actions:
    addLine:((type)->
      A = parseFloat(@get('newLine.A')) or 0
      B = parseFloat(@get('newLine.B')) or 0
      C = parseFloat(@get('newLine.C')) or 0
      sign = @get('newLine.sign')
      @get('newLine').computeCoordinates(A, B, C)
      @set 'newLine.id', @get('generator').getIdWithInrement()
      @get('lines').pushObject(@get('newLine'))
      @clearTemporyValues()
    )

    deleteInequality:(()->
      self = @
      resultLines = Ember.A([])
      resultInequalities = Ember.A([])
      @get('selectedInequalities').forEach (obj)->
        resultInequalities.pushObject(self.get('workInequalities').findBy('id', obj.id))
        resultLines.pushObject(self.get('lines').findBy('id', obj.id))
      @get('workInequalities').removeObjects(resultInequalities)
      @get('lines').removeObjects(resultLines)
    )

    editInequalities:()->
      self = @
      @transitionToRoute 'editInequalities', {queryParams:{inequalityIdList:@get('selectedInequalities').mapBy('id')}}


    clearAll:()->
      window.location = '/'

    applyTargetFunction:()->
      self = @
      targetFunction = App.LinePrototype.create()
      targetFunction.set 'A', 1
      targetFunction.set 'B', 1
      targetFunction.set 'C', 1
      targetFunction.computeCoordinates(1,1,1)
      @set('targetFunction', targetFunction)

    deleteTargetFunction:()->
      self = @
      @set('targetFunction', null)
      @get('points').forEach (obj)->
        obj.remove()
      @get('points').clear()

    findOptimalSolution: ()->
      self = @
      gauss = App.Gauss.create()
      gauss.findOptimalSolutionUsingLine(@get('jsxLines'), @get('targetFunctionLine'), @get('axies.x'), @get('axies.y'), @get('lines'), @get('targetFunction'), @get('points'))
      # gauss.findOptimalSolution(@get('lines'), @get('targetFunction'))



  clearTemporyValues: ()->
    @set 'newLine', null
    @set 'newLine', App.LinePrototype.create()

  plotLines: (()->
    self = @
    @clearBoard()
    board = window.board
    i = 0
    @get('jsxLines').clear()
    while i < @get('lines').length
      p = board.create("point", [
        @get('lines')[i].get('X1')
        @get('lines')[i].get('Y1')
      ],
        visible: false
      )
      q = board.create("point", [
        @get('lines')[i].get('X2')
        @get('lines')[i].get('Y2')
      ],
        visible: false
      )
      l = board.create("line", [
        p
        q
      ],
        fixed: true
        strokeWidth: 1
      )
      @get('jsxLines').pushObject(l)
      board.update()
      ineq = null
      if @get('lines')[i].getNumberSign()?
        if not @get('isFilled')
          ineq = board.create("inequality", [l],
            inverse: @get('lines')[i].getNumberSign()
          )
          @set('isFilled', yes)
        else
          ineq = board.create("inequality", [l],
            inverse: @get('lines')[i].getNumberSign()
            fillOpacity: 0
          )
      i++
      # self.get('workInequalities').clear()
      @get('lines').forEach (obj) ->
        p = board.create("point", [
          obj.get('X1')
          obj.get('Y1')
        ],
          visible: false
        )
        q = board.create("point", [
          obj.get('X2')
          obj.get('Y2')
        ],
          visible: false
        )
        l = board.create("line", [
          p
          q
        ],
          fixed: true
          strokeWidth: 1
        )
        board.update()
        if obj.getNumberSign()?
          ineq = board.create("inequality", [l],
            inverse: not obj.getNumberSign()
            fillColor: "white"
            fillOpacity: 100
          )
        
        #Add inequalities to select's
        if not self.get('workInequalities').findBy 'id', obj.get('id')
          self.get('workInequalities').pushObject({id:obj.get('id'), inequality:obj.getIneq()})
        if not self.get('historyInequalities').findBy 'id', obj.get('id')
          self.get('historyInequalities').pushObject({id:obj.get('id'), inequality:obj.getIneq()})
        return

      x = board.create("line", [
        [
          1.0
          0.0
        ]
        [
          2.0
          0.0
        ]
      ],
        lastArrow: true
        strokeColor: "black"
        strokeWidth: 1
      )
      y = board.create("line", [
        [
          0.0
          1.0
        ]
        [
          0.0
          2.0
        ]
      ],
        lastArrow: true
        strokeColor: "black"
        strokeWidth: 1
      )
      @set 'axies.x', x
      @set 'axies.y', y
      ineq = board.create("inequality", [x],
        fillColor: "white"
        fillOpacity: 100
      )
      ineq = board.create("inequality", [y],
        fillColor: "white"
        fillOpacity: 100
      )
      @plotLyaout()
  )

  plotTargetFunction: (()->
    self = @
    # @plotLines()
    @removeTargetFunction()
    A = @get 'targetFunction.A'
    B = @get 'targetFunction.B'
    C = @get 'targetFunction.C'
    @get('targetFunction').computeCoordinates(A, B, C)
    p = board.create("point", [
        @get('targetFunction').get('X1')
        @get('targetFunction').get('Y1')
      ],
      visible: false
    )
    q = board.create("point", [
      @get('targetFunction').get('X2')
      @get('targetFunction').get('Y2')
    ],
      visible: false
    )
    l = board.create("line", [
      p
      q
    ],
      fixed: true
      strokeWidth: 1
    )
    @set 'targetFunctionLine', l
    board.update()
  )

  removeTargetFunction: (()->
    self = @
    targetLine = @get 'targetFunctionLine'
    if targetLine? and targetLine.remove?
      targetLine.remove()
      self.set 'targetFunctionLine', null
  )

  generatePreview: () ->
    board = JXG.JSXGraph.initBoard 'box', {boundingbox: [-0.5, 10, 10, -0.5], axis: false}
    window.board = board
    x = board.create 'line', [[1.0, 0.0], [2.0, 0.0]],{lastArrow:true, strokeColor:'black', strokeWidth:1}
    y = board.create 'line', [[0.0, 1.0], [0.0, 2.0]],{lastArrow:true, strokeColor:'black', strokeWidth:1}

  clearBoard :() ->
    board = window.board
    JXG.JSXGraph.freeBoard board
    board = JXG.JSXGraph.initBoard("box",
      boundingbox: [
        -0.5
        10
        10
        -0.5
      ]
      axis: false
    )
    window.board = board
    @set 'isFilled', no
    board

  plotLyaout: ()->
    board = window.board
    i = 1
    while i <= 10
      board.create "line", [
        [
          i
          -0.05
        ]
        [
          i
          0.05
        ]
      ],
        straightFirst: false
        straightLast: false
        strokeWidth: 1
      i++
    i = 1
    while i <= 10
      board.create "line", [
        [
          -0.05
          i
        ]
        [
          0.05
          i
        ]
      ],
        straightFirst: false
        straightLast: false
        strokeWidth: 1
        strokeColor: "black"
      i++

