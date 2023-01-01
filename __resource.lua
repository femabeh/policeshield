fx_version 'cerulean'

game 'gta5'

author 'Xander1998'

title 'Police Shield'

description 'Edited by: lenzh, femabeh'

version '1.3.0'

shared_scripts {
   '@es_extended/locale.lua',
   '@es_extended/imports.lua',
   'locales/*.lua',
   'config.lua',
}

client_scripts {
   "client.lua",
}

server_scripts {
   "server.lua",
}

dependencies {
	'es_extended',
}
