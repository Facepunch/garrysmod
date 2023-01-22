local PANEL = {}

function PANEL:Init()
	-- Padding buttons and slider
	self.PDMself.PDM = 0
	-- Padding X and Y
	self.PDX, self.PDY = 0, 0
	-- Panel size X and Y
	self.SPX, self.SPY = 260, 0
	-- Emement delta X and Y
	self.EDX, self.EDY = 2, 2
	-- Slider position and size
	self.PSX, self.PSY = 0, 0
	self.SSX, self.SSY = 0, 22
	-- Button position and size
	self.PBX, self.PBY = 0, 0
	self.SBX, self.SBY = 0, 22
	-- Parent current width
	self.iAutoWidth = 0
	-- Autoresize in think hook
	self.bAutoResz = true
end

function PANEL:IsAutoResize( bR )
	if ( bR ~= nil ) then -- Update
		self.bAutoResz = tobool( bR )
	end; return self.bAutoResz
end

function PANEL:SetPadding( eX, eY, eM )
	local iX = ( tonumber( eX ) or 2 )
	if ( iX >= 0 ) then self.PDX = iX end
	local iY = ( tonumber( eY ) or 2 )
	if ( iY >= 0 ) then self.PDY = iY end
	local iM = ( tonumber( eM ) or 2 )
	if ( iM >= 0 ) then self.PDM = iM end
	return self
end

function PANEL:GetPadding()
	return self.PDX, self.PDY, self.PDM
end

function PANEL:SetDelta( eX, eY )
	local iX = ( tonumber( eX ) or 2 )
	if ( iX >= 0 ) then self.EDX = iX end
	local iY = ( tonumber( eY ) or 2 )
	if ( iY >= 0 ) then self.EDY = iY end
	return self
end

function PANEL:GetDelta()
	return self.EDX, self.EDY
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua
function PANEL:SetSlider( sVar, sNam, sTyp )
	self.Slider = vgui.Create( "DNumSlider", self )
	self.Slider:SetParent( self )
	self.Slider:Dock( TOP )
	self.Slider:SetTall( self.SSY )
	self.Slider:SetText( sNam )
	self.Slider:SetConVar( sVar )
	self.Slider:SizeToContents()
	if ( sTyp ~= nil ) then self.Slider:SetTooltip() end
	return self
end

function PANEL:GetSlider()
	return self.Slider
end

function PANEL:Configure( nMin, nMax, nDef, iDig )
	self.Slider:SetMin( tonumber( nMin ) or -10 )
	self.Slider:SetMax( tonumber( nMax ) or  10 )
	if ( iDig ~= nil ) then self.Slider:SetDecimals( iDig ) end
	if ( nDef ~= nil ) then self.Slider:SetDefaultValue( nDef ) end
	self.Slider:UpdateNotches(); return self
end

function PANEL:SetTall( nP, nS, nB )
	if ( nP ) then self.SPY = nP end
	if ( nS ) then self.SSY = nS end
	if ( nB ) then self.SBY = nB end
	return self
end

function PANEL:GetTall()
	return self.SPY, self.SSY, self.SBY
end

function PANEL:SetWide( vW )
	local nW, tBut = tonumber( vW ), self.Array
	if ( nW and nW >= 0 ) then self.SPX = nW end
	self.SPY = self.SSY + 2 * self.PDY
	self.SSX = self.SPX - 2 * self.PDX
	self.PSX = self.PDX -- Slider position X
	self.PSY = self.PDY -- Slider position Y
	self.Slider:SetPos( self.PSX, self.PSY )
	self.Slider:SetSize( self.SSX, self.SSY )
	if ( tBut and tBut.Size and tBut.Size > 0 ) then
		self.PBX = self.PSX -- Store the current X for button position
		self.PBY = self.PSY + self.SSY + self.PDM -- Button position Y
		self.SPY = self.SSY + self.SBY + 2 * self.PDY + self.PDM
		self.SBX = (self.SPX - (tBut.Size - 1) * self.EDX - 2 * self.PDX) / tBut.Size
		for iD = 1, tBut.Size do
			tBut[iD]:SetPos( self.PBX, self.PBY )
			tBut[iD]:SetSize( self.SBX, self.SBY )
			self.PBX = self.PBX + self.SBX + self.EDX
		end
	end; return self
end

function PANEL:GetWide()
	return self.SPX, self.SSX, self.SBX
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dbutton.lua
function PANEL:SetButton( sNam, sTyp )
	local pBut = vgui.Create( "DButton", self )
	local tBut = self.Array
	if ( not tBut ) then -- No button table. Create one
		tBut = {Size = 0} -- Create button array
		self.Array = tBut -- Write down the array
	else -- Attempt to fix arror in the sequence
		if ( not tBut.Size ) then tBut.Size = 0 end
		if ( tBut.Size < 0 ) then
			table.Empty( tBut ); tBut.Size = 0
		end
	end -- Retrieve the buttons array
	local iSiz = ( tBut.Size + 1 ); table.insert( tBut, pBut )
	pBut:SetParent( self ); pBut:SetText( sNam )
	if ( sTyp ~= nil ) then pBut:SetTooltip( tostring(sTyp) ) end
	self.Array.Size = iSiz
	return self
end

function PANEL:SetAction(fLef, fRgh, vIdx)
	local tBut = self.Array
	local nIdx = math.floor( tonumber(vD) or 0 )
	if ( not tBut ) then return self end
	if ( not tBut.Size ) then return self end
	if ( tBut.Size <= 0 ) then return self end
	local bIdx = ( nIdx > 0 and nIdx <= tBut.Size )
	local iIdx = ( bIdx and nIdx or tBut.Size )
	local pBut, pSer = tBut[tBut.Size], self.Slider
	pBut.DoClick = function()
		local pS, sE = pcall( fLef, pBut, pSer, pSer:GetValue() )
		if ( not pS ) then error( "["..pBut:GetText().."]: "..sE ) end
	end
	if ( fRgh ) then
		pBut.DoRightClick = function()
			local pS, sE = pcall( fRgh, pBut, pSer, pSer:GetValue() )
			if ( not pS ) then error( "["..pBut:GetText().."]: "..sE ) end
		end
	else
		pBut.DoRightClick = function() SetClipboardText( pBut:GetText() ) end
	end; return self
end

function PANEL:GetButton(vD)
	local iD = math.floor( tonumber( vD ) or 0 )
	if ( iD < 0 ) then return nil end
	local tBut = self.Array
	if ( not tBut ) then return nil end
	local iB = ( (iD > 0) and iD or tBut.Size )
	return tBut[ iB ]
end

function PANEL:RemoveButton(vD)
	local iD = math.floor(tonumber(vD) or 0)
	if ( iD < 0 ) then return self end
	local tBut = self.Array
	if ( not tBut ) then return self end
	local iB = ((iD > 0) and iD or nil)
	local pBut = table.remove( tBut, iB )
	if ( pBut ) then
		pBut:Remove()
		tBut.Size = tBut.Size - 1
	end; return self
end

function PANEL:ClearButtons()
  local tBut = self.Array
  if ( not tBut ) then return self end
  for iD = 1, tBut.Size do
    local pBut = table.remove( tBut )
    if ( IsValid(pBut) ) then pBut:Remove() end
  end; tBut.Size = 0
  self.SPY = self.SSY + 2 * self.PDY
  return self
end

function PANEL:UpdateColours(tSkin)
	if ( self.Slider.UpdateColours ) then
		self.Slider:UpdateColours(tSkin)
	end; local tBut = self.Array
	if ( tBut and tBut.Size > 0 ) then
		for iD = 1, self.Array.Size do pBut = self.Array[iD]
			if ( pBut.UpdateColours ) then
				pBut:UpdateColours( tSkin )
			end
		end
	end
end

function PANEL:ApplySchemeSettings()
	self.Slider:ApplySchemeSettings()
	local tBut = self.Array
	if ( not tBut ) then return self end
	if ( not tBut.Size ) then return self end
	if ( tBut.Size <= 0 ) then return self end
	for iD = 1, tBut.Size do
		local vBut = tBut[iD]
		if ( vBut.ApplySchemeSettings ) then
			vBut:ApplySchemeSettings() end
	end; return self
end

function PANEL:Think()
	if ( self.bAutoResz ) then
		local pBase = self:GetParent()
		if ( not IsValid(pBase) ) then return end
		local sX, sY = pBase:GetSize()
		if ( self.iAutoWidth ~= sX ) then self.iAutoWidth = sX
			local slef, stop, srgh, sbot = self:GetDockMargin()
			local blef, btop, brgh, bbot = pBase:GetDockPadding()
			self:SetWide(sX - slef - srgh - blef - brgh)
		end
	end
end

derma.DefineControl( "DSliderButton", "Button-interactive slider", PANEL, "DSizeToContents" )
