local gmod_oldtextsize = gmod_oldtextsize or surface.GetTextSize
local gmod_oldsetfont = gmod_oldsetfont or surface.SetFont
local MAX_BUFFER_SIZE = 64

local contextFont = 'DermaDefaut'
local sizeCache = {}
local bufferSize = 0

function surface.SetFont( font )
    contextFont = font
    gmod_oldsetfont( font )
end

function surface.GetTextSize( text )
    if ( not sizeCache[ contextFont ] ) then sizeCache[ contextFont ] = {} end

    local data = sizeCache[ contextFont ][ text ]

    if ( data ) then
        return data.width, data.height
    else
        local w, h = gmod_oldtextsize( text )

        if ( bufferSize < MAX_BUFFER_SIZE ) then
            sizeCache[ contextFont ][ text ] = {
                width = w,
                height = h,
                called = SysTime()
            }
    
            bufferSize = bufferSize + 1
        end
    
        return w, h
    end
end

hook.Add( 'Tick', 'Gmod.util.HandleFontCache', function()
    for font, cache in pairs( sizeCache ) do
        for text, data in pairs( cache ) do
            local timeSinceLastCall = SysTime() - data.called
            if ( timeSinceLastCall > 1 ) then
                cache[ text ] = nil
                bufferSize = bufferSize - 1
            end
        end

        if ( table.IsEmpty( cache ) ) then
            sizeCache[ font ] = nil
        end
    end
end )

hook.Add( 'OnScreenSizeChanged', 'jlib.util.ResetFontCache', function()
    sizeCache = {}
end )
