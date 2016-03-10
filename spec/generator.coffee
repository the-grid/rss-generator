jsjob = require 'jsjob'
chai = require 'chai'
path = require 'path'

describe 'RSS Generator', ->
  script = 'http://localhost:8001/rss-generator.js'
  runner = null
  before (done) ->
    runner = new jsjob.Runner {}
    runner.start done
  after (done) ->
    runner.stop done

  describe 'Running via Node.js', ->
    rss = require '../src/rss'
    describe 'Solving a c-base crew page', ->
      it 'should produce RSS feed', (done) ->
        @timeout 60*1000
        input = require path.resolve __dirname, './fixtures/c-base.json'
        options = {}
        rss.solveRss input, (err, solution, details) ->
          return done err if err
          chai.expect(solution).to.be.an 'object'
          chai.expect(solution.html).to.contain '<rss'
          done()
  describe 'Running via JsJob', ->
    describe 'Solving a c-base crew page', ->
      it 'should produce RSS feed', (done) ->
        @timeout 60*1000
        input = require path.resolve __dirname, './fixtures/c-base.json'
        options = {}
        runner.runJob script, input, options, (err, solution, details) ->
          return done err if err
          chai.expect(solution).to.be.an 'object'
          chai.expect(solution.html).to.contain '<rss'
          done()
