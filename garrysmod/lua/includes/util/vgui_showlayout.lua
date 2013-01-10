--=============================================================================--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
--										 
--=============================================================================--

local Panels = {}


local function VGUIShowLayoutPaint()


	for panel, data in pairs( Panels ) do
	
		if ( panel:IsValid() ) then
		
			local x, y = panel:LocalToScreen( 0, 0 )
			
			local Alpha = math.Clamp( (data.Time - SysTime()) / 0.3, 0, 1 ) * 100
		
			surface.SetDrawColor( 255, 0, 0, Alpha )
			surface.DrawRect( x, y, panel:GetWide(), panel:GetTall() )
			
			surface.SetDrawColor( 0, 255, 0, Alpha )
			surface.DrawOutlinedRect( x, y, panel:GetWide(), panel:GetTall() )
			
		end
	
		if ( !panel:IsValid() || data.Time < SysTime() ) then
			Panels[ panel ] = nil
		end
	
	end

end

hook.Add( "DrawOverlay", "VGUIShowLayoutPaint", VGUIShowLayoutPaint )


function VisualizeLayout( panel )

	local tab = {}
	tab.Time = SysTime() + 0.3
	
	Panels[ panel ] = tab

end