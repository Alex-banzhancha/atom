fs = require 'fs'
_ = require 'underscore'
EventEmitter = require 'event-emitter'

module.exports =
class Config
  constructor: ->
    @configDirPath = fs.absolute("~/.atom")
    @configJsonPath = fs.join(@configDirPath, "config.json")
    @userInitScriptPath = fs.join(@configDirPath, "atom.coffee")

    @core = {}
    @editor = {}

  load: ->
    if fs.exists(@configJsonPath)
      userConfig = JSON.parse(fs.read(@configJsonPath))
      _.extend(this, userConfig)
    @requireUserInitScript()

  update: ->
    @trigger 'update'


  requireUserInitScript: ->
    try
      require @userInitScriptPath if fs.exists(@userInitScriptPath)
    catch error
      console.error "Failed to load `#{@userInitScriptPath}`", error.stack, error

_.extend Config.prototype, EventEmitter
