express = require "express"
http = require "http"

expressServer = express()
expressServer.configure ->

	expressServer.use express.compress()
	expressServer.use express.bodyParser()
	expressServer.use (req, res, next) ->
		req.url =
			switch req.url
				when "/" then "/page.html"
				else req.url
		next()
	expressServer.use express.static "#{__dirname}/public", maxAge: 0, (err) -> console.log "Static: #{err}"
	expressServer.use expressServer.router

server = http.createServer expressServer
server.listen (port = process.env.PORT ? 5080), -> console.log "Listening on port #{port}"