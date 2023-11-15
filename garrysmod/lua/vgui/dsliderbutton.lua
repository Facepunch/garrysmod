local PANEL = {}

function PANEL:Init()
	-- Padding X and Y
	self.PDX, self.PDY = 0, 0
	-- Panel size X and Y
	self.SPX, self.SPY = 0, 0
	-- Emement delta X and Y
	self.EDX, self.EDY = 2, 10
	-- Slider position and size
	self.PSX, self.PSY = 0, 0
	self.SSX, self.SSY = 0, 22
	-- Button position and size
	self.PBX, self.PBY = 0, 0
	self.SBX, self.SBY = 0, 22
	-- Parent current width
	self.ADX, self.BDX = 0, false
	self.ADY, self.BDY = 0, false
end

local function SetXY(oP, vX, kX, vY, kY, fA)
	local cX, cY = fA(vX), fA(vY)
	if(vX ~= nil) then oP[kX] = cX end
	if(vY ~= nil) then oP[kY] = cY end
	return oP -- Return the panel itself
end

function PANEL:IsAutoResize(bX, bY)
	SetXY(self, bX, "BDX", bY, "BDY", tobool)
	return self.BDX, self.BDY
end

function PANEL:SetAutoResize(nX, nY)
	return SetXY(self, nX, "ADX", nY, "ADY", tonumber)
end

function PANEL:GetAutoResize()
	return self.ADX, self.ADY
end

function PANEL:SetPadding(nX, nY)
	return SetXY(self, nX, "PDX", nY, "PDY", tonumber)
end

function PANEL:GetPadding()
	return self.PDX, self.PDY
end

function PANEL:SetDelta(nX, nY)
	return SetXY(self, nX, "EDX", nY, "EDY", tonumber)
end

function PANEL:GetDelta()
	return self.EDX, self.EDY
end

function PANEL:GetButtons()
	local tBut = self.Array
	if(not tBut) then return nil end
	if(not tBut.Size) then return nil end
	if(tBut.Size <= 0) then return nil end
	return tBut -- Collapse arguments
end

function PANEL:GetCount()
	local tBut = self:GetButtons()
	if(not tBut) then return 0 end
	return tBut.Size -- Return buttons count
end

function PANEL:GetButtonID(vIdx)
	local iSiz = self:GetCount()
	if(iSiz <= 0) then return 0 end
	local nIdx = math.floor(tonumber(vIdx) or 0)
	local bIdx = (nIdx > 0 and nIdx <= iSiz)
	return (bIdx and nIdx or iSiz)
end

function PANEL:GetButton(vIdx)
	local iIdx = self:GetButtonID(vIdx)
	if(iIdx == 0) then return nil end
	return self.Array[iIdx]
end

function PANEL:SetTall(nP, nS, nB)
	local nP = tonumber(nP)
	if(nP) then -- Scale everything
		local tBut = self:GetButtons()
		if(tBut) then
			self.SPY = nP
			self.SSY = (nP - 2 * self.PDY - self.EDY) / 2
			self.SBY = self.SSY
		else
			self.SPY = nP
			self.SSY = nP - 2 * self.PDY
		end
	else -- Adjust elements only
		SetXY(self, nS, "SSY", nB, "SBY", tonumber)
	end; return self
end

function PANEL:GetTall()
	return self.SPY, self.SSY, self.SBY
end

function PANEL:SetWide(nP, nS, nB)
	local nP = tonumber(nP)
	if(nP) then -- Scale everything
		local tBut = self:GetButtons()
		if(tBut) then
			self.SPX = nP -- Use the new panel X
			self.SSX = self.SPX - 2 * self.PDX -- Scale slider
			self.SBX = self.SSX - ((tBut.Size - 1) * self.EDX)
		else
			self.SPX = nP
			self.SSX = nP - 2 * self.PDX
		end
	else -- Adjust elements only
		SetXY(self, nS, "SSX", nB, "SBX", tonumber)
	end; return self
end

function PANEL:GetWide()
	return self.SPX, self.SSX, self.SBX
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua
function PANEL:SetSlider(sVar, sNam, sTyp)
	local pSer = vgui.Create("DNumSlider", self)
	if(not IsValid(pSer)) then return self end
	pSer:SetParent(self)
	pSer:Dock(TOP)
	pSer:SetDark(true)
	pSer:SetTall(self.SSY)
	pSer:SetText(sNam)
	pSer:SetConVar(sVar)
	pSer:SizeToContents()
	if(sTyp ~= nil) then pSer:SetTooltip(tostring(sTyp)) end
	self.Slider = pSer; return self
end

function PANEL:Configure(nMin, nMax, nDef, iDig)
	local pSer = self.Slider -- Slider reference
	if(not IsValid(pSer)) then return self end
	pSer:SetMin(tonumber(nMin) or -10)
	pSer:SetMax(tonumber(nMax) or  10)
	if(iDig ~= nil) then pSer:SetDecimals(iDig) end
	if(nDef ~= nil) then pSer:SetDefaultValue(nDef) end
	pSer:UpdateNotches(); return self
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dbutton.lua
function PANEL:SetButton(sNam, sTyp)
	local pBut = vgui.Create("DButton", self)
	local tBut = self.Array -- Read button array
	if(not tBut) then -- No button array. Create one
		tBut = {Size = 0} -- Create button array
		self.Array = tBut -- Write down the array
	end -- Retrieve the buttons array
	local iSiz = (tBut.Size + 1); table.insert(tBut, pBut)
	pBut:SetParent(self); pBut:SetText(sNam)
	if(sTyp ~= nil) then pBut:SetTooltip(tostring(sTyp)) end
	tBut.Size = iSiz; return self
end

function PANEL:SetAction(fLef, fRgh, vIdx)
	local iIdx = self:GetButtonID(vIdx)
	if(iIdx == 0) then return self end
	local pBut, pSer = self.Array[iIdx], self.Slider
	if(fLef) then
		pBut.DoClick = function()
			local pS, sE = pcall(fLef, pBut, pSer, pSer:GetValue())
			if(not pS) then error("["..pBut:GetText().."]: "..sE) end
		end
	else
		if(not pBut.DoClick) then
			pBut.DoClick = function() SetClipboardText(pBut:GetText()) end
		end
	end
	if(fRgh) then
		pBut.DoRightClick = function()
			local pS, sE = pcall(fRgh, pBut, pSer, pSer:GetValue())
			if(not pS) then error("["..pBut:GetText().."]: "..sE) end
		end
	else
		if(not pBut.DoRightClick) then
			pBut.DoRightClick = function() SetClipboardText(pBut:GetText()) end
		end
	end; return self
end

function PANEL:RemoveButton(vIdx)
	local iIdx = self:GetButtonID(vIdx)
	if(iIdx == 0) then return self end
	local pBut = table.remove(tBut, iIdx)
	if(IsValid(pBut)) then pBut:Remove()
		tBut.Size = tBut.Size - 1
	end; return self
end

function PANEL:ClearButtons()
	local tBut = self:GetButtons()
	if(not tBut) then return self end
	for iD = 1, tBut.Size do
		local pBut = table.remove(tBut)
		if(IsValid(pBut)) then pBut:Remove() end
	end; table.Empty(tBut) -- Clear array
	self.Array = nil -- Wipe table
	return self
end

function PANEL:UpdateView()
	local pSer = self.Slider -- Retrieve slider reference
	local tBut = self:GetButtons() -- Validate buttons array
	self.SPY = self.SSY + 2 * self.PDY -- Panel size Y
	self.SSX = self.SPX - 2 * self.PDX -- Slider size X
	self.PSX = self.PDX -- Slider position X
	self.PSY = self.PDY -- Slider position Y
	pSer:SetPos(self.PSX, self.PSY) -- Apply position
	pSer:SetSize(self.SSX, self.SSY) -- Apply panel size
	if(tBut) then local iSiz = tBut.Size -- Read button array size
		self.PBX = self.PSX -- Store the current X for button position
		self.PBY = self.PSY + self.SSY + self.EDY -- Button position Y
		self.SPY = self.SSY + self.SBY + 2 * self.PDY + self.EDY
		self.SBX = (self.SPX - (iSiz - 1) * self.EDX - 2 * self.PDX) / iSiz
		for iD = 1, iSiz do -- Trough all button panels in array
			tBut[iD]:SetPos(self.PBX, self.PBY)
			tBut[iD]:SetSize(self.SBX, self.SBY)
			self.PBX = self.PBX + self.SBX + self.EDX
		end
	end; return self
end

local function Run(oP, sN, ...)
	local pSer, tBut = oP.Slider, oP:GetButtons()
	if(pSer and pSer[sN]) then pSer[sN](pSer, ...) end
	if(not tBut) then return oP end
	for iD = 1, tBut.Size do local pBut = tBut[iD]
		if(pBut and pBut[sN]) then pBut[sN](pBut, ...) end
	end; return oP
end

function PANEL:UpdateColours(tSkin)
	return Run(self, "UpdateColours", tSkin)
end

function PANEL:ApplySchemeSettings()
	return Run(self, "ApplySchemeSettings")
end

function PANEL:Think()
	local rX, rY = self:IsAutoResize()
	if(rX or rY) then
		local pBase = self:GetParent()
		if(IsValid(pBase)) then
			local dX, dY = self:GetAutoResize()
			local rU, sX, sY = false, pBase:GetSize()
			if(rX and dX ~= sX) then
				self:SetAutoResize(sX, nil); rU = true
				local slef, stop, srgh, sbot = self:GetDockMargin()
				local blef, btop, brgh, bbot = pBase:GetDockPadding()
				self:SetWide(sX - slef - srgh - blef - brgh)
			end
			if(rY and dY ~= sY) then
				self:SetAutoResize(nil, sY); rU = true
				local slef, stop, srgh, sbot = self:GetDockMargin()
				local blef, btop, brgh, bbot = pBase:GetDockPadding()
				self:SetTall(sY - stop - sbot - btop - bbot)
			end
			if(rU) then self:UpdateView() end
		end
	end
end

derma.DefineControl("DSliderButton", "Button-interactive slider", PANEL, "DSizeToContents")
