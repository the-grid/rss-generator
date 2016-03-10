generator = require './rss.coffee'
window.jsJobRun = (data, options, callback) ->
  generator.solveRss data, callback
