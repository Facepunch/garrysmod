

if ( SERVER ) then return end

local cached = {
    width = {},
    height = {},
}

local scrW, scrH = ScrW() / 640, ScrH() / 480

function ScreenScale( width )
    cached.width[ width ] = cached.width[ width ] or width * scrW

    return cached.width[ width ]
end

function ScreenScaleH( height )
    cached.height[ height ] = cached.height[ height ] or height * scrH

    return cached.height[ height ]
end

SScale = ScreenScale

hook.Add( "OnScreenSizeChanged", "CachedScreenScale", function( oldWidth, oldHeight, newWidth, newHeight )
    scrW, scrH = newWidth / 640, newHeight / 480

    cached = {
        width = {},
        height = {},
    }
end )