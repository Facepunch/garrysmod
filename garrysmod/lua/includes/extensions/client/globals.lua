

if ( SERVER ) then return end


function ScreenScale( width )
	return width * ( ScrW() / 640.0 )
end

function ScreenScaleH( height )
	return height * ( ScrH() / 480.0 )
end

SScale = ScreenScale

local localPly = nil
C_LocalPlayer = LocalPlayer
function LocalPlayer()
	if ( not localPly ) then
		localPly = C_LocalPlayer()
		if ( not localPly:IsValid() ) then localPly = nil end
	end
	return localPly or NULL
end
