PythonImportanize = require './python-importanize'

module.exports =
  config:
    importanizePath:
      type: 'string'
      default: 'importanize'
    sortOnSave:
      type: 'boolean'
      default: false

  activate: ->
    pi = new PythonImportanize()

    atom.commands.add 'atom-workspace', 'pane:active-item-changed', ->
      pi.removeStatusbarItem()

    atom.commands.add 'atom-workspace', 'python-importanize:sortImports', ->
      pi.sortImports()

    atom.config.observe 'python-importanize.sortOnSave', (value) ->
      atom.workspace.observeTextEditors (editor) ->
        if value == true
          editor._importanizeSort = editor.onDidSave -> pi.sortImports()
        else
          editor._importanizeSort?.dispose()
