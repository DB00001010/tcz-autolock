fx_version 'cerulean'
game 'gta5'

description 'TCZ-Auto-Lock'
author 'TCZ'
version '1.0.0'

shared_script 'config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'qb-core',
    'qb-vehiclekeys'
}
