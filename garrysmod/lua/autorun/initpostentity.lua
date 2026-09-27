
local function LoadFolder()

    local sharedFiles = file.Find( "lua/initpostentity/*.lua", "GAME" )

    for _, fileName in ipairs( sharedFiles ) do

        local path = "initpostentity/" .. fileName

        AddCSLuaFile( path )
        include( path )

    end

    local clientFiles = file.Find( "lua/initpostentity/client/*.lua", "GAME" )

    if SERVER then

        local serverFiles = file.Find( "lua/initpostentity/server/*.lua", "GAME" )

        for _, fileName in ipairs( serverFiles ) do
            include( "initpostentity/server/" .. fileName )
        end

        for _, fileName in ipairs( clientFiles ) do
            AddCSLuaFile( "initpostentity/client/" .. fileName )
        end

    else

        for _, fileName in ipairs( clientFiles ) do
            include( "initpostentity/client/" .. fileName )
        end

    end

end

hook.Add( "InitPostEntity", "GMod_Load_InitPostEntity_Folder", LoadFolder )
