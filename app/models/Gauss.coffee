App = require 'app'

###*
  Model Gauss

  @class Gauss
  @namespace App
  @extends DS.Model
###
module.exports = App.Gauss = Ember.Object.extend
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
