fx_version 'cerulean'
games { 'gta5' }
author '-del1an <-del1an#9999>'
version '1.0.0'
lua54 'yes'

dependencies {
    'warmenu'
}

client_scripts {
    '@warmenu/warmenu.lua',
    'config/*.lua',
    'src/*.lua',
}

exports {
    'AnimVehicleNeonsColor',
    'AnimVehicleNeonsToggle',
    'ToggleVehicleNeons',
    'ToggleMenu'
}

escrow_ignore {
    'config/*.lua',
}