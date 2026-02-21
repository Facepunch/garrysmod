
local Panels = {}

hook.Add( "DrawOverlay", "VGUIShowLayoutPaint", function()

	for panel, data in pairs( Panels ) do

		if ( panel:IsValid() ) then

			local x, y = panel:LocalToScreen( 0, 0 )

			local Alpha = math.Clamp( (data.Time - SysTime()) / 0.3, 0, 1 ) * 100

			surface.SetDrawColor( 255, 0, 0, Alpha )
			surface.DrawRect( x, y, panel:GetWide(), panel:GetTall() )

			surface.SetDrawColor( 0, 255, 0, Alpha )
			surface.DrawOutlinedRect( x, y, panel:GetWide(), panel:GetTall() )

			-- vgui_visualizelayout 2?
			-- draw.SimpleText( panel:GetZPos(), "Default", x + 3, y, color_white )

		end

		if ( !panel:IsValid() || data.Time < SysTime() ) then
			Panels[ panel ] = nil
		end

	end

end )

-- Called from the engine
function VisualizeLayout( panel )

	local tab = {}
	tab.Time = SysTime() + 0.3

	Panels[ panel ] = tab

end
