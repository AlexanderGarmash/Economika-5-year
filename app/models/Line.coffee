App = require 'app'

###*
  Model Line

  @class Line
  @namespace App
  @extends DS.Model
###
module.exports = App.Line = DS.Model.extend
  _id: DS.attr('number'),
  A: DS.attr('number'),
  B: DS.attr('number'),
  C: DS.attr('number'),
  sign: DS.attr('string')


### If any special serializer or adapter is needed for this model, use this code:

App.LineAdapter = DS.RESTAdapter.extend
  # your adapter code here

App.LineSerializer = DS.RESTSerializer.extend
  # your serializer code here

###
