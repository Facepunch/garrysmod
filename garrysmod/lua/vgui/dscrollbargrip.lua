
local PANEL = {}

function PANEL:Init()
end

function PANEL:OnMousePressed()

	self:GetParent():Grip( 1 )

end

function PANEL:Paint( w, h )

	derma.SkinHook( "PaintScrollBarGrip", self, w, h )
	return true

end

derma.DefineControl( "DScrollBarGrip", "A Scrollbar Grip", PANEL, "DPanel" )
