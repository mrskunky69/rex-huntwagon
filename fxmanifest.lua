fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'rex-huntwagon'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@rsg-core/shared/locale.lua',
    'locales/en.lua', -- preferred language
    'config.lua',
}

client_scripts {
    'client/client.lua',
    'client/npcs.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/versioncheck.lua'
}

dependencies {
    'rsg-core',
    'ox_lib',
}

escrow_ignore {
    'client',
    'locales',
    'server',
    'config.lua',
    'README.md',
    'rex-huntwagon.sql'
}

lua54 'yes'
