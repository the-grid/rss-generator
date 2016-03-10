module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    webpack:
      dist:
        entry: './src/runner.coffee'
        output:
          path: './dist/'
          filename: 'rss-generator.js'
        node:
          fs: 'empty'
        module:
          loaders: [
            test: /\.coffee$/
            loader: 'coffee-loader'
          ,
            test: /\.json$/
            loader: 'json-loader'
          ]

    # BDD tests on Node.js
    mochaTest:
      nodejs:
        src: ['spec/*.coffee']
        options:
          reporter: 'spec'
          require: 'coffee-script/register'

    # Coding standards
    coffeelint:
      components:
        files:
          src: ['src/*.coffee']
        options:
          max_line_length:
            value: 80
            level: 'warn'

    connect:
      fixtures:
        options:
          port: 8001
          base: 'dist'

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-webpack'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-mocha-test'
  @loadNpmTasks 'grunt-coffeelint'
  @loadNpmTasks 'grunt-contrib-connect'

  # Our local tasks
  @registerTask 'build', ['webpack']
  @registerTask 'test', ['coffeelint', 'build', 'connect', 'mochaTest']
  @registerTask 'default', ['test']
