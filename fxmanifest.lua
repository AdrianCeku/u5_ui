fx_version "cerulean"

game "gta5"

author "github.com/AdrianCeku"

description "ultimate5-ui"

version "0.1b"

lua54 "yes"

ui_page {
	"ui/dist/index.html",
}

files {
	"ui/dist/*",
	"ui/dist/**/*"
}

shared_scripts{
	"config.lua"
}

client_scripts{
	"client/functions.lua",
	"client/main.lua",
	"client/sections.lua",
	"client/components.lua",
}

server_scripts{
	"server/*"
}

dependencies {
	"u5_utils"
}