App = require 'app'

###*
  Model LinePrototype

  @class LinePrototype
  @namespace App
  @extends DS.Model
###
module.exports = App.LinePrototype = Ember.Object.extend
  A: "0"
  B: "0"
  C: "0"
  X1: "0"
  X2: "0"
  Y1: "0"
  Y2: "0"
  sign: '<='
  id: -1

  getNumberSign:(()->
    if @get('sign')?
      if @get('sign') is '<='
        return no
      else if @get('sign') is '>='
        return yes
      else
        return null
  )

  computeCoordinates:((A,B,C)->
    if A? and B? and A isnt 0 and B isnt 0
      @set 'X1', 5
      @set 'Y1', (-A / B * @get('X1') + C / B)
      @set 'X2', 0
      @set 'Y2', (-A / B * @get('X2') + C / B)
    else if A is 0
      @set 'X1', C/B
      @set 'Y1', 1
      @set 'X2', C/B
      @set 'Y2', 2
    else if B is 0
      @set 'X1', 1
      @set 'Y1', C/A
      @set 'X2', 2
      @set 'Y2', C/A
  )

  getIneq:(()->
    result = '(' + @get('id')+'). '
    if @get('A') is 0
      result += @get('B') + "x2" + @get('sign') + @get('C')
      result 
    else if @get('B') is 0
      result += @get('A') + "x1" + @get('sign') + @get('C')
      result
    else
      result += @get('A') + "x1"
      if @get('B') >= 0
        result += " + "
      else
        result += " - "
      if @get('B') >= 0
        result += @get('B')
      else
        result += -@get('B')
      result += "x2" + " " + @get('sign') + " " + @get('C')
      return result
  )
            