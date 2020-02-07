

if ( SERVER ) then return end


function ScreenScaleX( width )
	return width * ( ScrW() / 640.0 )
end

function ScreenScaleY( height )
	return height * ( ScrH() / 480.0 )
end

ScreenScale = ScreenScaleX
SScale = ScreenScaleX
