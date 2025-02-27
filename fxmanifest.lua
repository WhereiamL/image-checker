fx_version 'cerulean'
game 'gta5'

name 'Item checker'
description 'Tool to check for missing item images in ox_inventory'
author 'STIFLER akak WhereiamL'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

server_scripts {
    's_checkimages.lua'
}

dependencies {
    'ox_inventory',
    'ox_lib'
}

lua54 'yes'