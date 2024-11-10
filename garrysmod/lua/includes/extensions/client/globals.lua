

if ( SERVER ) then return end


function ScreenScale( width, screenWidth )
	screenWidth = screenWidth or 640.0
	return width * ( ScrW() / screenWidth )
end

function ScreenScaleH( height, screenHeight )
	screenHeight = screenHeight or 480.0
	return height * ( ScrH() / screenHeight )
end

SScale = ScreenScale
