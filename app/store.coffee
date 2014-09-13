App = require 'app'

###
# Remove this return to enable a store with a REST adapter on your app
# if you're migrating, https://github.com/emberjs/data/blob/master/TRANSITION.md is a good help
###
return

###*
  The application adapter

  @class ApplicationAdapter
  @namespace App
  @extends DS.RESTAdapter
###
App.ApplicationAdapter = DS.LSAdapter.extend
  namespace: 'stories'

# App.ApplicationSerializer = DS.LSAdapter.extend
#   primaryKey: '_id'