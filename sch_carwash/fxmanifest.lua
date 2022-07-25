fx_version 'adamant'
game 'gta5'

description 'Carwash UI'

ui_page "html/html.html"
files {
	"html/html.html",
	"html/*.js",
	"html/*.svg",
	"html/*.ttf",
	"html/*.png",
	"html/*.css",
	"html/img/*.png"
}

shared_scripts {
	"config.lua",
}
client_scripts {
	"client.lua",
}
server_scripts {
	"server.lua",
}