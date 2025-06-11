

if ( SERVER ) then return end

local scrW, scrH = ScrW(), ScrH()

function ScreenScale( width )
	return width * ( scrW / 640.0 )
end

function ScreenScaleH( height )
	return height * ( scrH / 480.0 )
end

SScale = ScreenScale