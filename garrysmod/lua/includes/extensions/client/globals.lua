

if ( SERVER ) then return end


function ScreenScale( width )
	return width * ( ScrW() / 640.0 )
end

function ScreenScaleH( height )
	return height * ( ScrH() / 480.0 )
end

SScale = ScreenScale
