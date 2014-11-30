App = require 'app'

###*
  Model Gauss

  @class Gauss
  @namespace App
  @extends DS.Model
###
module.exports = App.Gauss = Ember.Object.extend

  pointOptimalSolution: null

  solve: (A) ->
    n = A.length
    i = 0

    while i < n
      
      # Search for maximum in this column
      maxEl = Math.abs(A[i][i])
      maxRow = i
      k = i + 1

      while k < n
        if Math.abs(A[k][i]) > maxEl
          maxEl = Math.abs(A[k][i])
          maxRow = k
        k++
      
      # Swap maximum row with current row (column by column)
      k = i

      while k < n + 1
        tmp = A[maxRow][k]
        A[maxRow][k] = A[i][k]
        A[i][k] = tmp
        k++
      
      # Make all rows below this one 0 in current column
      k = i + 1
      while k < n
        c = -A[k][i] / A[i][i]
        j = i

        while j < n + 1
          if i is j
            A[k][j] = 0
          else
            A[k][j] += c * A[i][j]
          j++
        k++
      i++
    
    # Solve equation Ax=b for an upper triangular matrix A
    x = new Array(n)
    i = n - 1

    while i > -1
      x[i] = A[i][n] / A[i][i]
      k = i - 1

      while k > -1
        A[k][n] -= A[k][i] * x[i]
        k--
      i--
    x

  findOptimalSolutionOld: (inequalityList, targetFunction)->
    inequalityList = Ember.A(inequalityList)
    self = @
    result = Ember.A([])
    # A = targetFunction.get 'A'
    # B = targetFunction.get 'B'
    # C = targetFunction.get 'C'

    i = 0
    while i < inequalityList.length
      current = inequalityList[i++]
      A = parseFloat(current.get 'A')
      B = parseFloat(current.get 'B')
      C = parseFloat(current.get 'C')
      inequalityList.forEach (obj)->
        objA = parseFloat(obj.get 'A')
        objB = parseFloat(obj.get 'B')
        objC = parseFloat(obj.get 'C')
        if not ((A is objA) and (B is objB) and (C is objC))
          res = self.solve([
            [
              objA
              objB
              objC
            ]
            [
              A
              B
              C
            ]
          ])
          if (res[0] > 0 and res[1] > 0)
            result.pushObject(Ember.Object.create({x: res[0], y:res[1]}))

  findOptimalSolutionUsingLine: (lineList, targetFunctionLine, x, y, inequalities, targetFunctionInequality, points, type)->
    lineList = Ember.A(lineList)
    lineList.pushObject(x)
    lineList.pushObject(y)
    self = @
    intersections = Ember.A([])
    i = 0
    while i < lineList.length
      current = lineList[i++]
      lineList.forEach (obj)->
        intersection = board.create('intersection', [current, obj, 0])
        if intersection.X() >= 0 and intersection.Y() >= 0
          intersections.pushObject(intersection)
          points.pushObject(intersection)
        else
          intersection.remove()
          window.board.removeObject(intersection)
    @removeRepeated(intersections)
    @checkPointsInInequalities(intersections, inequalities)
    tf = @findOptimalSolution(inequalities, targetFunctionInequality, intersections, lineList)
    console.log "End"
    return tf

  checkPointsInInequalities: (points, inequalities)->
    i = 0
    toRemove = Ember.A([])
    while i < points.length
      point = points[i]
      x = parseFloat(point.X().toFixed(6))
      y = parseFloat(point.Y().toFixed(6))
      j = 0
      while j < inequalities.length
        inequality = inequalities[j]
        sign = inequality.get 'sign'
        A = parseFloat(inequality.get 'A')
        B = parseFloat(inequality.get 'B')
        C = parseFloat(inequality.get 'C')
        left = 0
        right = 0
        # left = A * x + B * y
        # right = C
        toPrecision = ((x, y)->
          if sign is ">="
            x += 0.000001
            y += 0.000001
          else
            x -= 0.000001
            y -= 0.000001
        )
        if A isnt 0 and B isnt 0
          # toPrecision(x, y)
          left = A * x + B * y
          right = C
        else if B is 0
          # toPrecision(x, y)
          left = y
          right = C / A
        else if A is 0
          # toPrecision(x, y)
          left = x
          right = C / B
        
        compare = no
        if(sign is '<=')
          left = parseFloat(left.toFixed(5))
          if left <= right
            compare = yes
        else if (sign is '>=')
          if left >= right
            compare = yes
        if compare is no
          point.remove()
          window.board.removeObject(point)
          toRemove.pushObject(point)
          # points.removeObject(point)
        j++
      i++
    points.removeObjects(toRemove)
    @removeRepeated(points)
    console.log "Points: ", points
    i = 0
    while i < points.length
      x = parseFloat(points[i].X().toFixed(6))
      y = parseFloat(points[i].X().toFixed(6))
      name = points[i].name
      i++

  removeRepeated: (pointList)->
    i = 0
    while i < pointList.length
      current = pointList[i++]
      j = 0
      while j < pointList.length
        obj = pointList[j++]
        if ((current.id isnt obj.id) and (current.X() is obj.X()) and (current.Y() is obj.Y()))
          window.board.removeObject(obj)
          pointList.removeObject(obj)
    toRemove = Ember.A([])
    i = 0
    while i < pointList.length
      if pointList[i].isReal is no
        toRemove.pushObject(pointList[i])
      i++
    pointList.removeObjects(toRemove)

  checkTargetFunctionOnOptimalMax: (targetFunction, pointList)->
    pointList = Ember.A(pointList)
    isOptimal = yes
    tfA = targetFunction.get 'A'
    tfB = targetFunction.get 'B'
    tfC = targetFunction.get 'C'
    pointList.forEach (point) ->
      if(isOptimal)
        pointX = point.X()
        tfY = ((-tfA / tfB * pointX) + (tfC / tfB))
        tfY += 0.000001
        if point.Y() > tfY
          isOptimal = no
        return
      return
    isOptimal

  checkTargetFunctionOnOptimalMin: (targetFunction, pointList)->
    pointList = Ember.A(pointList)
    isOptimal = yes
    tfA = targetFunction.get 'A'
    tfB = targetFunction.get 'B'
    tfC = targetFunction.get 'C'
    pointList.forEach (point) ->
      if(isOptimal)
        pointX = point.X()
        tfY = ((-tfA / tfB * pointX) + (tfC / tfB))
        tfY += 0.000001
        if point.Y() < tfY
          isOptimal = no
        return
      return
    isOptimal

  findOptimalSolution: (inequalities, targetFunctionInequality, points, lineList)->
    self = @
    isOptimal = yes
    targetFunction = null
    tfA = parseFloat(targetFunctionInequality.get 'A')
    tfB = parseFloat(targetFunctionInequality.get 'B')
    tfC = 0
    intersections = Ember.A([])
    lines = Ember.A([])
    i = 0
    while i < points.length
      tfC = 0
      point = points[i]
      x = parseFloat(point.X().toFixed(6))
      y = parseFloat(point.Y().toFixed(6))
      tfC = tfA * x + tfB * y
      tf = App.LinePrototype.create()
      tf.set 'A', tfA
      tf.set 'B', tfB
      tf.set 'C', tfC
      tf.computeCoordinates(tfA, tfB, tfC)
      isOptimal = self.checkTargetFunctionOnOptimalMax(tf, points)
      if(isOptimal)
        @set 'pointOptimalSolution', point
        return tf
      i++
    console.log "End getIntersectionWithTargetFunctionAndOtherLines"
    return

  


      

