
local PANEL = {}

function PANEL:Init()

	self:SetTextInset( 32, 0 )
	self:SetContentAlignment( 4 )

end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "TreeNodeButton", self, w, h )

	--
	-- Draw the button text
	--
	return false

end

function PANEL:UpdateColours( skin )

	if ( self:IsSelected() ) then return self:SetTextStyleColor( skin.Colours.Tree.Selected ) end
	if ( self.Hovered ) then return self:SetTextStyleColor( skin.Colours.Tree.Hover ) end

	return self:SetTextStyleColor( skin.Colours.Tree.Normal )

end

function PANEL:GenerateExample()

	-- Do nothing!

end

derma.DefineControl( "DTree_Node_Button", "Tree Node Button", PANEL, "DButton" )
