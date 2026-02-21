
local PANEL = {}

function PANEL:Init()

	self:EnableVerticalScrollbar()
	self:SetHeight( 2 )

end

function PANEL:SetHeight( numHeight )

	self:SetTall( 66 * ( numHeight or 2 ) + 2 )

end

function PANEL:SetModelList( modelList, conVar, dontSort, dontCallListConVars )

	for model, v in pairs( modelList ) do

		local icon = vgui.Create( "SpawnIcon" )
		icon:SetModel( model )
		icon:SetSize( 64, 64 )
		icon:SetTooltip( model )
		icon.Model = model
		icon.ConVars = v

		local convars = {}

		-- some model lists, like from wheels, have extra convars in the ModelList
		-- we'll need to add those too
		if ( !dontCallListConVars && istable( v ) ) then
			table.Merge( convars, v ) -- copy them in to new list
		end

		-- make strConVar optional so we can have everything in the ModelList instead, if we want to
		if ( conVar ) then
			convars[ conVar ] = model
		end

		self:AddPanel( icon, convars )

	end

	if ( !dontSort ) then
		self:SortByMember( "Model", false )
	end

end

derma.DefineControl( "DModelSelect", "", PANEL, "DPanelSelect" )
