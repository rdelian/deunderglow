-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }
author '-del1an <-del1an#9999>'
-- description ''
version '1.0.0'
lua54 'yes'

dependencies {
    'warmenu'
}

client_scripts {
    '@warmenu/warmenu.lua',
    '@warmenu/warmenu_demo.lua',
    'config.lua',
    'src.lua',
}

server_scripts {
    'server.lua'
}

escrow_ignore {
    'config.lua',
    'tutorial.md'
}