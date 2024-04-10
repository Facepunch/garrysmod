local PANEL = {}

function PANEL:Init()

	-- padding X and Y
	self.paddingX, self.paddingY = 0, 0

	-- Panel size X and Y
	self.panelSizeX, self.panelSizeY = 0, 0

	-- Element delta X and Y
	self.elementDeltaX, self.elementDeltaY = 2, 10

	-- Slider position and size
	self.posSliderX, self.posSliderY = 0, 0
	self.sizeSliderX, self.sizeSliderY = 0, 22

	-- Button position and size
	self.posButtonX, self.posButtonY = 0, 0
	self.sizeButtonX, self.sizeButtonY = 0, 22

	-- Parent current width
	self.autoResizeX, self.isResizeX = 0, false
	self.autoResizeY, self.isResizeY = 0, false

end

local function SetXY( oP, vX, kX, vY, kY, fA )

	local cX, cY = fA( vX ), fA( vY )

	if ( vX ~= nil ) then
		oP[ kX ] = cX
	end

	if ( vY ~= nil ) then
		oP[ kY ] = cY
	end

	return oP -- Return the panel itself

end

function PANEL:IsAutoResize( bX, bY )

	SetXY( self, bX, "isResizeX", bY, "isResizeY", tobool )

	return self.isResizeX, self.isResizeY

end

function PANEL:SetAutoResize( nX, nY )

	return SetXY( self, nX, "autoResizeX", nY, "autoResizeY", tonumber )

end

function PANEL:GetAutoResize()

	return self.autoResizeX, self.autoResizeY

end

function PANEL:SetPadding( nX, nY )

	return SetXY( self, nX, "paddingX", nY, "paddingY", tonumber )

end

function PANEL:GetPadding() return

	self.paddingX, self.paddingY

end

function PANEL:SetDelta( nX, nY )

	return SetXY( self, nX, "elementDeltaX", nY, "elementDeltaY", tonumber )

end

function PANEL:GetDelta() return

	self.elementDeltaX, self.elementDeltaY

end

function PANEL:GetButtons()

	local ArBut = self.Array

	if ( not ArBut ) then return nil end

	if ( not ArBut.Size ) then return nil end

	if ( ArBut.Size <= 0 ) then return nil end

	return ArBut -- Collapse arguments

end

function PANEL:GetCount()

	local ArBut = self:GetButtons()

	if ( not ArBut ) then return 0 end

	return ArBut.Size -- Return buttons count

end

function PANEL:GetButtonID( Idx )

	local iSiz = self:GetCount()

	if ( iSiz <= 0 ) then
		return 0
	end

	local nIdx = math.floor( tonumber( Idx ) or 0 )

	local bIdx = ( nIdx > 0 and nIdx <= iSiz )

	return ( bIdx and nIdx or iSiz )

end

function PANEL:GetButton( Idx )

	local Idx = self:GetButtonID( Idx )

	if ( Idx == 0 ) then
		return nil
	end

	return self.Array[ Idx ]

end

function PANEL:SetTall( Pos, Size, nB )

	local Pos = tonumber( Pos )

	if ( Pos ) then -- Scale everything

		local ArBut = self:GetButtons()

		if ( ArBut ) then

			self.panelSizeY = Pos

			self.sizeSliderY = ( Pos - 2 * self.paddingY - self.elementDeltaY ) / 2

			self.sizeButtonY = self.sizeSliderY

		else

			self.panelSizeY = Pos

			self.sizeSliderY = Pos - 2 * self.paddingY

		end

	else -- Adjust elements only

		SetXY( self, Size, "sizeSliderY", nB, "sizeButtonY", tonumber )

	end

	return self

end

function PANEL:GetTall()

	return self.panelSizeY, self.sizeSliderY, self.sizeButtonY

end

function PANEL:SetWide( Pos, Size, nB )

	local Pos = tonumber( Pos )

	if ( Pos ) then -- Scale everything

		local ArBut = self:GetButtons()

		if ( ArBut ) then

			self.panelSizeX = Pos -- Use the new panel X

			self.sizeSliderX = self.panelSizeX - 2 * self.paddingX -- Scale slider

			self.sizeButtonX = self.sizeSliderX - ( ( ArBut.Size - 1 ) * self.elementDeltaX )

		else

			self.panelSizeX = Pos

			self.sizeSliderX = Pos - 2 * self.paddingX

		end

	else -- Adjust elements only

		SetXY( self, Size, "sizeSliderX", nB, "sizeButtonX", tonumber )

	end

	return self

end

function PANEL:GetWide()

	return self.panelSizeX, self.sizeSliderX, self.sizeButtonX

end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua

function PANEL:SetSlider( Var, Name, Type )

	local slider = vgui.Create( "DNumSlider", self )

	if ( not IsValid( slider ) ) then
		return self
	end

	slider:SetParent( self )

	slider:Dock( TOP )

	slider:SetDark( true )

	slider:SetTall( self.sizeSliderY )

	slider:SetText( Name )

	slider:SetConVar( Var )

	slider:SizeToContents()

	if ( Type ~= nil ) then
		slider:SetTooltip( tostring( Type ) )
	end

	self.Slider = slider

	return self

end

function PANEL:Configure( Min, Max, Default, Digits )

	local slider = self.Slider -- Slider reference

	if ( not IsValid( slider ) ) then
		return self
	end

	slider:SetMin( tonumber( Min ) or - 10 )

	slider:SetMax( tonumber( Max ) or 10 )

	if ( Digits ~= nil ) then
		slider:SetDecimals( Digits )
	end

	if ( Default ~= nil ) then
		slider:SetDefaultValue( Default )
	end

	slider:UpdateNotches()

	return self

end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dbutton.lua

function PANEL:SetButton( Name, Type )

	local CrBut = vgui.Create( "DButton", self )

	local ArBut = self.Array -- Read button array

	if ( not ArBut ) then -- No button array. Create one
		ArBut = { Size = 0 } -- Create button array
		self.Array = ArBut -- Write down the array
	end -- Retrieve the buttons array

	local iSiz = ( ArBut.Size + 1 )

	table.insert( ArBut, CrBut )

	CrBut:SetParent( self )
	CrBut:SetText( Name )

	if ( Type ~= nil ) then
		CrBut:SetTooltip( tostring( Type ) )
	end

	ArBut.Size = iSiz

	return self

end

function PANEL:SetAction( Left, Right, Idx )

	local Idx = self:GetButtonID( Idx )

	if ( Idx == 0 ) then
		return self
	end

	local CrBut, slider = self.Array[ Idx ], self.Slider

	if ( Left ) then

		CrBut.DoClick = function()

			local pS, sE = pcall( Left, CrBut, slider, slider:GetValue() )

			if ( not pS ) then
				error( "[" .. CrBut:GetText() .. "]: " .. sE )
			end

		end

	else

		if ( not CrBut.DoClick ) then

			CrBut.DoClick = function()
				SetClipboardText( CrBut:GetText() )
			end

		end

	end

	if ( Right ) then

		CrBut.DoRightClick = function()

			local pS, sE = pcall( Right, CrBut, slider, slider:GetValue() )

			if ( not pS ) then
				error( "[" .. CrBut:GetText() .. "]: " .. sE )
			end

		end

	else

		if ( not CrBut.DoRightClick ) then

			CrBut.DoRightClick = function()
				SetClipboardText( CrBut:GetText() )
			end
		end

	end

	return self

end

function PANEL:RemoveButton( Idx )

	local Idx = self:GetButtonID( Idx )

	if ( Idx == 0 ) then return self end

	local CrBut = table.remove( ArBut, Idx )

	if ( IsValid( CrBut ) ) then

		CrBut:Remove()

		ArBut.Size = ArBut.Size - 1

	end

	return self

end

function PANEL:ClearButtons()

	local ArBut = self:GetButtons()

	if ( not ArBut ) then
		return self
	end

	for iD = 1, ArBut.Size do

		local CrBut = table.remove( ArBut )

		if ( IsValid( CrBut ) ) then
			CrBut:Remove()
		end

	end

	table.Empty( ArBut ) -- Clear array

	self.Array = nil -- Wipe table

	return self

end

function PANEL:UpdateView()

	local slider = self.Slider -- Retrieve slider reference

	local ArBut = self:GetButtons() -- Validate buttons array

	self.panelSizeY = self.sizeSliderY + 2 * self.paddingY -- Panel size Y

	self.sizeSliderX = self.panelSizeX - 2 * self.paddingX -- Slider size X

	self.posSliderX = self.paddingX -- Slider position X

	self.posSliderY = self.paddingY -- Slider position Y

	slider:SetPos( self.posSliderX, self.posSliderY ) -- Apply position

	slider:SetSize( self.sizeSliderX, self.sizeSliderY ) -- Apply panel size

	if ( ArBut ) then

		local iSiz = ArBut.Size -- Read button array size

		self.posButtonX = self.posSliderX -- Store the current X for button position

		self.posButtonY = self.posSliderY + self.sizeSliderY + self.elementDeltaY -- Button position Y

		self.panelSizeY = self.sizeSliderY + self.sizeButtonY + 2 * self.paddingY + self.elementDeltaY

		self.sizeButtonX = ( self.panelSizeX - ( iSiz - 1 ) * self.elementDeltaX - 2 * self.paddingX ) / iSiz

		for iD = 1, iSiz do -- Trough all button panels in array

			ArBut[ iD ]:SetPos( self.posButtonX, self.posButtonY )

			ArBut[ iD ]:SetSize( self.sizeButtonX, self.sizeButtonY )

			self.posButtonX = self.posButtonX + self.sizeButtonX + self.elementDeltaX

		end

	end

	return self

end

local function Run( oP, sN, ... )

	local slider, ArBut = oP.Slider, oP:GetButtons()

	if ( slider and slider[ sN ]) then slider[ sN ]( slider, ... ) end

	if ( not ArBut ) then return oP end

	for iD = 1, ArBut.Size do

		local CrBut = ArBut[ iD ]

		if ( CrBut and CrBut[ sN ]) then CrBut[ sN ]( CrBut, ... ) end

	end

	return oP

end

function PANEL:UpdateColours( tSkin )

	return Run( self, "UpdateColours", tSkin )

end

function PANEL:ApplySchemeSettings()

	return Run( self, "ApplySchemeSettings" )

end

function PANEL:Think()

	local rX, rY = self:IsAutoResize()

	if ( rX or rY ) then

		local pBase = self:GetParent()

		if ( IsValid( pBase )) then

			local dX, dY = self:GetAutoResize()

			local rU, sX, sY = false, pBase:GetSize()

			if ( rX and dX ~= sX ) then

				self:SetAutoResize( sX, nil )

				rU = true

				local slef, stop, srgh, sbot = self:GetDockMargin()

				local blef, btop, brgh, bbot = pBase:GetDockPadding()

				self:SetWide( sX - slef - srgh - blef - brgh )

			end

			if ( rY and dY ~= sY ) then

				self:SetAutoResize( nil, sY )

				rU = true

				local slef, stop, srgh, sbot = self:GetDockMargin()

				local blef, btop, brgh, bbot = pBase:GetDockPadding()

				self:SetTall( sY - stop - sbot - btop - bbot )

			end

			if ( rU ) then
				self:UpdateView()
			end

		end

	end

end

derma.DefineControl( "DSliderButton", "Button-interactive slider", PANEL, "DSizeToContents" )
