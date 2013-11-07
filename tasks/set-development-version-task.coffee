path = require 'path'

module.exports = (grunt) ->
  {spawn} = require('./task-helpers')(grunt)

  grunt.registerTask 'set-development-version', 'Sets version to current SHA-1', ->
    done = @async()

    if process.platform is 'darwin'
      cmd = 'script/set-version'
      args = [grunt.config.get('atom.buildDir')]
      spawn {cmd, args}, (error, result, code) -> done(error)
    else if process.platform is 'win32'
      shellAppDir = grunt.config.get('atom.shellAppDir')
      shellExePath = path.join(shellAppDir, 'atom.exe')

      cmd = 'git'
      args = ['rev-parse', '--short', 'HEAD']
      spawn {cmd, args}, (error, result, code) ->
        if error?
          done(error)
        else
          version = result.stdout.trim()
          strings =
            CompanyName: 'GitHub, Inc.'
            FileDescription: 'The hackable, collaborative editor of tomorrow!'
            LegalCopyright: 'Copyright (C) 2013 GitHub, Inc. All rights reserved'
            ProductName: 'Atom'
            ProductVersion: version

          rcedit = require('rcedit')
          rcedit(shellExePath, {'version-string': strings}, done)
