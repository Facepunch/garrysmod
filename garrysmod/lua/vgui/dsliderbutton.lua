
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

local function SetXY( mePanel, valX, keyX, valY, keyY, actFunc )

	local conX, conY = actFunc( valX ), actFunc( valY )

	if ( valX ~= nil ) then
		mePanel[ keyX ] = conX
	end

	if ( valY ~= nil ) then
		mePanel[ keyY ] = conY
	end

	return mePanel -- Return the panel itself

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

	local arBut = self.Array

	if ( not arBut ) then
		return nil
	end

	if ( not arBut.Size ) then
		return nil
	end

	if ( arBut.Size <= 0 ) then
		return nil
	end

	return arBut -- Collapse arguments

end

function PANEL:GetCount()

	local arBut = self:GetButtons()

	if ( not arBut ) then
		return 0
	end

	return arBut.Size -- Return buttons count

end

function PANEL:GetButtonID( iD )

	local btnSize = self:GetCount()

	if ( btnSize <= 0 ) then
		return 0
	end

	local floorIdx = math.floor( tonumber( iD ) or 0 )

	local isIdx = ( floorIdx > 0 and floorIdx <= btnSize )

	return ( isIdx and floorIdx or btnSize )

end

function PANEL:GetButton( iD )

	local iD = self:GetButtonID( iD )

	if ( iD == 0 ) then
		return nil
	end

	return self.Array[ iD ]

end

function PANEL:SetTall( sizePanel, sizeSlider, sizeButton )

	local sizePanel = tonumber( sizePanel )

	if ( sizePanel ) then -- Scale everything

		local arBut = self:GetButtons()

		if ( arBut ) then

			self.panelSizeY = sizePanel

			self.sizeSliderY = ( sizePanel - 2 * self.paddingY - self.elementDeltaY ) / 2

			self.sizeButtonY = self.sizeSliderY

		else

			self.panelSizeY = sizePanel

			self.sizeSliderY = sizePanel - 2 * self.paddingY

		end

	else -- Adjust elements only

		SetXY( self, sizeSlider, "sizeSliderY", sizeButton, "sizeButtonY", tonumber )

	end

	return self

end

function PANEL:GetTall()

	return self.panelSizeY, self.sizeSliderY, self.sizeButtonY

end

function PANEL:SetWide( sizePanel, sizeSlider, sizeButton )

	local sizePanel = tonumber( sizePanel )

	if ( sizePanel ) then -- Scale everything

		local arBut = self:GetButtons()

		if ( arBut ) then

			self.panelSizeX = sizePanel -- Use the new panel X

			self.sizeSliderX = self.panelSizeX - 2 * self.paddingX -- Scale slider

			self.sizeButtonX = self.sizeSliderX - ( ( arBut.Size - 1 ) * self.elementDeltaX )

		else

			self.panelSizeX = sizePanel

			self.sizeSliderX = sizePanel - 2 * self.paddingX

		end

	else -- Adjust elements only

		SetXY( self, sizeSlider, "sizeSliderX", sizeButton, "sizeButtonX", tonumber )

	end

	return self

end

function PANEL:GetWide()

	return self.panelSizeX, self.sizeSliderX, self.sizeButtonX

end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua

function PANEL:SetSlider( namVar, guiName, guiTip )

	local crSlider = vgui.Create( "DNumSlider", self )

	if ( not IsValid( crSlider ) ) then
		return self
	end

	crSlider:SetParent( self )
	crSlider:Dock( TOP )
	crSlider:SetDark( true )
	crSlider:SetTall( self.sizeSliderY )
	crSlider:SetText( guiName )
	crSlider:SetConVar( namVar )
	crSlider:SizeToContents()

	if ( guiTip ~= nil ) then
		crSlider:SetTooltip( tostring( guiTip ) )
	end

	self.Slider = crSlider

	return self

end

function PANEL:Configure( limMin, limMax, defValue, numDigits )

	local crSlider = self.Slider -- Slider reference

	if ( not IsValid( crSlider ) ) then
		return self
	end

	crSlider:SetMin( tonumber( limMin ) or -10 )
	crSlider:SetMax( tonumber( limMax ) or  10 )

	if ( numDigits ~= nil ) then
		crSlider:SetDecimals( numDigits )
	end

	if ( defValue ~= nil ) then
		crSlider:SetDefaultValue( defValue )
	end

	crSlider:UpdateNotches()

	return self

end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dbutton.lua

function PANEL:SetButton( guiName, guiTip )

	local crBut = vgui.Create( "DButton", self )

	local arBut = self.Array -- Read button array

	if ( not arBut ) then -- No button array. Create one
		arBut = { Size = 0 } -- Create button array
		self.Array = arBut -- Write down the array
	end -- Retrieve the buttons array

	local btnSize = ( arBut.Size + 1 )

	table.insert( arBut, crBut )

	crBut:SetParent( self )
	crBut:SetText( guiName )

	if ( guiTip ~= nil ) then
		crBut:SetTooltip( tostring( guiTip ) )
	end

	arBut.Size = btnSize

	return self

end

function PANEL:SetAction( funcLeft, funcRight, iD )

	local iD = self:GetButtonID( iD )

	if ( iD == 0 ) then
		return self
	end

	local crBut, crSlider = self.Array[ iD ], self.Slider

	if ( funcLeft ) then

		crBut.DoClick = function()

			local OK, ERR = pcall( funcLeft, crBut, crSlider, crSlider:GetValue() )

			if ( not OK ) then
				error( "[" .. crBut:GetText() .. "]: " .. ERR )
			end

		end

	else

		if ( not crBut.DoClick ) then

			crBut.DoClick = function()
				SetClipboardText( crBut:GetText() )
			end

		end

	end

	if ( funcRight ) then

		crBut.DoRightClick = function()

			local OK, ERR = pcall( funcRight, crBut, crSlider, crSlider:GetValue() )

			if ( not OK ) then
				error( "[" .. crBut:GetText() .. "]: " .. ERR )
			end

		end

	else

		if ( not crBut.DoRightClick ) then

			crBut.DoRightClick = function()

				SetClipboardText( crBut:GetText() )

			end

		end

	end

	return self

end

function PANEL:RemoveButton( iD )

	local iD = self:GetButtonID( iD )

	if ( iD == 0 ) then
		return self
	end

	local crBut = table.remove( arBut, iD )

	if ( IsValid( crBut ) ) then

		crBut:Remove()

		arBut.Size = arBut.Size - 1

	end

	return self

end

function PANEL:ClearButtons()

	local arBut = self:GetButtons()

	if ( not arBut ) then
		return self
	end

	for iD = 1, arBut.Size do

		local crBut = table.remove( arBut )

		if ( IsValid( crBut ) ) then
			crBut:Remove()
		end

	end

	table.Empty( arBut ) -- Clear array

	self.Array = nil -- Wipe table

	return self

end

function PANEL:UpdateView()

	local crSlider = self.Slider -- Retrieve slider reference

	local arBut = self:GetButtons() -- Validate buttons array

	self.panelSizeY = self.sizeSliderY + 2 * self.paddingY -- Panel size Y

	self.sizeSliderX = self.panelSizeX - 2 * self.paddingX -- Slider size X

	self.posSliderX = self.paddingX -- Slider position X

	self.posSliderY = self.paddingY -- Slider position Y

	crSlider:SetPos( self.posSliderX, self.posSliderY ) -- Apply position

	crSlider:SetSize( self.sizeSliderX, self.sizeSliderY ) -- Apply panel size

	if ( arBut ) then

		local btnSize = arBut.Size -- Read button array size

		self.posButtonX = self.posSliderX -- Store the current X for button position

		self.posButtonY = self.posSliderY + self.sizeSliderY + self.elementDeltaY -- Button position Y

		self.panelSizeY = self.sizeSliderY + self.sizeButtonY + 2 * self.paddingY + self.elementDeltaY

		self.sizeButtonX = ( self.panelSizeX - ( btnSize - 1 ) * self.elementDeltaX - 2 * self.paddingX ) / btnSize

		for iD = 1, btnSize do -- Trough all button panels in array

			arBut[ iD ]:SetPos( self.posButtonX, self.posButtonY )

			arBut[ iD ]:SetSize( self.sizeButtonX, self.sizeButtonY )

			self.posButtonX = self.posButtonX + self.sizeButtonX + self.elementDeltaX

		end

	end

	return self

end

local function Run( mePanel, callName, ... )

	local crSlider, arBut = mePanel.Slider, mePanel:GetButtons()

	if ( crSlider and crSlider[ callName ]) then
		crSlider[ callName ]( crSlider, ... )
	end

	if ( not arBut ) then
		return mePanel
	end

	for iD = 1, arBut.Size do

		local crBut = arBut[ iD ]

		if ( crBut and crBut[ callName ]) then
			crBut[ callName ]( crBut, ... )
		end

	end

	return mePanel

end

function PANEL:UpdateColours( guiSkin )

	return Run( self, "UpdateColours", guiSkin )

end

function PANEL:ApplySchemeSettings()

	return Run( self, "ApplySchemeSettings" )

end

function PANEL:Think()

	local rX, rY = self:IsAutoResize()

	if ( rX or rY ) then

		local parBase = self:GetParent()

		if ( IsValid( parBase )) then

			local guiUpdate = false
			local sX, sY = parBase:GetSize()
			local dX, dY = self:GetAutoResize()

			if ( rX and dX ~= sX ) then

				guiUpdate = true

				self:SetAutoResize( sX, nil )

				local slef, stop, srgh, sbot = self:GetDockMargin()
				local blef, btop, brgh, bbot = parBase:GetDockPadding()

				self:SetWide( sX - slef - srgh - blef - brgh )

			end

			if ( rY and dY ~= sY ) then

				guiUpdate = true

				self:SetAutoResize( nil, sY )

				local slef, stop, srgh, sbot = self:GetDockMargin()
				local blef, btop, brgh, bbot = parBase:GetDockPadding()

				self:SetTall( sY - stop - sbot - btop - bbot )

			end

			if ( guiUpdate ) then
				self:UpdateView()
			end

		end

	end

end

derma.DefineControl( "DSliderButton", "Button-interactive slider", PANEL, "DSizeToContents" )
