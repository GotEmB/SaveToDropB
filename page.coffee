require.config
	paths:
		jquery: "//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min"
		batman: "batmanjs/batman"
		bootstrap: "//netdna.bootstrapcdn.com/bootstrap/3.0.0-wip/js/bootstrap.min"
		dropbox: "//dropbox.com/static/api/1/dropins"
	shim:
		batman: deps: ["jquery"], exports: "Batman"
		bootstrap: deps: ["jquery"]
		dropbox: exports: "Dropbox"
	waitSeconds: 30

appContext = undefined

define "Batman", ["batman"], (Batman) -> Batman.DOM.readers.batmantarget = Batman.DOM.readers.target and delete Batman.DOM.readers.target and Batman

require ["jquery", "Batman", "dropbox", "bootstrap"], ($, Batman, Dropbox) ->

	class File extends Batman.Model

	class AppContext extends Batman.Model
		constructor: ->
			super
			Dropbox.appKey = "2nvimyu9eugsqm9"
			@set "files", new Batman.Set
			@set "pageLoaded", false
		addFile: ->
			thisFile = new File url: @get("newFileUrl"), css: "width: 0%;"
			@set "newFileUrl", ""
			Dropbox.save
				files: [url: thisFile.get "url"]
				success: =>
					thisFile.set "uploadSuccess", true
				progress: (progress) =>
					@get("files").add thisFile unless @get("files").has thisFile
					thisFile.set "css", "width: #{progress * 100}%;"
				cancel: =>
					@get("files").remove thisFile if @get("files").has thisFile
				error: (err) =>
					console.error err
					thisFile.set "uploadFailure", true

	class SavetoDropB extends Batman.App
		@appContext: appContext = new AppContext

	SavetoDropB.run()

	$ ->
		appContext.set "pageLoaded", true