fs = require 'fs'
$ = require 'jquery'
process = require 'child_process'

module.exports =
class PythonImportanize

  checkForPythonContext: ->
    editor = atom.workspace.getActiveTextEditor()
    if not editor?
      return false
    return editor.getGrammar().name == 'Python'

  removeStatusbarItem: =>
    @statusBarTile?.destroy()
    @statusBarTile = null

  updateNotification: (message, isError) =>
    if isError
      atom.notifications.addError 'importanize', {'detail': message, 'dismissable': true}
    else
      atom.notifications.addInfo 'importanize', {'detail': message, 'dismissable': true}

  getFilePath: ->
    editor = atom.workspace.getActiveTextEditor()
    return editor.getPath()

  getProjectRoot: ->
    return atom.project.rootDirectories[0].path

  sortImports: ->
    if not @checkForPythonContext()
      return

    params = [@getFilePath(), "-v"]
    importanizePath = atom.config.get "python-importanize.importanizePath"
    projectPath = @getProjectRoot()

    which = process.spawnSync('which', ['importanize']).status
    if which == 1 and not fs.existsSync(importanizePath)
      @updateNotification("unable to open " + importanizePath, true)
      return

    proc = process.spawn importanizePath, params, {'cwd': projectPath}
    @updateNotification("√", false)
    @reload
