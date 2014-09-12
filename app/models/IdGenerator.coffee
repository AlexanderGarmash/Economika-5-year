App = require 'app'

###*
  Model IdGenerator

  @class IdGenerator
  @namespace App
  @extends DS.Model
###
module.exports = App.IdGenerator = Ember.Object.extend
  id: 1

  getIdWithInrement:()->
    result = @get 'id'
    @set('id', @get('id') + 1)
    result
    