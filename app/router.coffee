App = require 'app'


App.Router.map ->
  @route 'editInequalities', { queryParams: ['inequalityIdList']}, () ->