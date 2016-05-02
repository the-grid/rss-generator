generator = require './rss.coffee'

if not window.jsJobRun
  window.jsJobRun = (data, options, callback) ->
    generator.solveRss data, callback

window.polySolvePage = (page, options, callback) ->
  generator.solveRss page, (err, out) ->
    details = {}
    return callback err, null, details if err
    return callback null, out.html, details
