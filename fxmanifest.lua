fx_version 'cerulean'

game 'gta5'

author 'github.com/AdrianCeku'

description 'ultimate5-ui'

version '1.0'

lua54 'yes'

ui_page {
	'ui/dist/index.html',
}

files {
	'ui/dist/*',
	'ui/dist/**/*'
}

shared_scripts{

}

client_scripts{
	"client/main.lua",
	"client/functions.lua",
	"client/distanceChecker.lua",
}

server_scripts{
	"server/*"
}
