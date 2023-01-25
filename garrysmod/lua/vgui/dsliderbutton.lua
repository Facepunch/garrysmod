
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

function PANEL:IsAutoResize( bX, bY )

    if ( bX ~= nil ) then self.BDX = tobool( bX ) end
    if ( bY ~= nil ) then self.BDY = tobool( bY ) end
    return self.BDX, self.BDY

end

function PANEL:AutoResize( nX, nY )

    if ( nX ) then self.ADX = tonumber( nX ) or 0 end
    if ( nY ) then self.ADY = tonumber( nY ) or 0 end
    return self.ADX, self.ADY

end

function PANEL:HasButtons()

    local tBut = self.Array
    if ( not tBut ) then return false end
    if ( not tBut.Size ) then return false end
    if ( tBut.Size <= 0 ) then return false end
    return true

end

function PANEL:GetCount()

    local tBut = self.Array
    if ( not tBut ) then return 0 end
    if ( not tBut.Size ) then return 0 end
    if ( tBut.Size <= 0 ) then return 0 end
    return tBut.Size

end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua
function PANEL:SetSlider( sVar, sNam, sTyp )

    self.Slider = vgui.Create( "DNumSlider", self )
    self.Slider:SetParent( self )
    self.Slider:Dock( TOP )
    self.Slider:SetDark( true )
    self.Slider:SetTall( self.SSY )
    self.Slider:SetText( sNam )
    self.Slider:SetConVar( sVar )
    self.Slider:SizeToContents()
    if ( sTyp ~= nil ) then self.Slider:SetTooltip( tostring( sTyp ) ) end
    return self

end

function PANEL:GetSlider()
    return self.Slider
end

function PANEL:Configure( nMin, nMax, nDef, iDig )

    self.Slider:SetMin( tonumber( nMin ) or - 10 )
    self.Slider:SetMax( tonumber( nMax ) or 10 )
    if ( iDig ~= nil ) then self.Slider:SetDecimals( iDig ) end
    if ( nDef ~= nil ) then self.Slider:SetDefaultValue( nDef ) end
    self.Slider:UpdateNotches(); return self

end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dbutton.lua
function PANEL:SetButton( sNam, sTyp )

    local pBut = vgui.Create( "DButton", self )
    local tBut = self.Array
    if ( not tBut ) then -- No button table. Create one
        tBut = { Size = 0 } -- Create button array
        self.Array = tBut -- Write down the array
    else -- Attempt to fix arror in the sequence
        if ( not tBut.Size ) then tBut.Size = 0 end
        if ( tBut.Size < 0 ) then table.Empty( tBut ); tBut.Size = 0 end
    end -- Retrieve the buttons array
    local iSiz = ( tBut.Size + 1 ); table.insert( tBut, pBut )
    pBut:SetParent( self ); pBut:SetText( sNam )
    if ( sTyp ~= nil ) then pBut:SetTooltip( tostring( sTyp ) ) end
    self.Array.Size = iSiz
    return self

end

function PANEL:SetAction( fLef, fRgh, vIdx )

    local tBut = self.Array
    local nIdx = math.floor( tonumber( vIdx ) or 0 )
    if ( not tBut ) then return self end
    if ( not tBut.Size ) then return self end
    if ( tBut.Size <= 0 ) then return self end
    local bIdx = ( nIdx > 0 and nIdx <= tBut.Size )
    local iIdx = ( bIdx and nIdx or tBut.Size )
    local pBut, pSer = tBut[ tBut.Size ], self.Slider
    pBut.DoClick = function()
        local pS, sE = pcall( fLef, pBut, pSer, pSer:GetValue() )
        if ( not pS ) then error( "["..pBut:GetText() .. "]: "..sE ) end
    end
    if ( fRgh ) then
        pBut.DoRightClick = function()
            local pS, sE = pcall( fRgh, pBut, pSer, pSer:GetValue() )
            if ( not pS ) then error( "["..pBut:GetText() .. "]: "..sE ) end
        end
    else
        pBut.DoRightClick = function() SetClipboardText( pBut:GetText() ) end
    end; return self

end

function PANEL:GetButton( vD )

    local iD = math.floor( tonumber( vD ) or 0 )
    if ( iD < 0 ) then return nil end
    local tBut = self.Array
    if ( not tBut ) then return nil end
    local iB = ( ( iD > 0 ) and iD or tBut.Size )
    return tBut[ iB ] -- Last button by default

end

function PANEL:RemoveButton( vD )

    local iD = math.floor( tonumber( vD ) or 0 )
    if ( iD < 0 ) then return self end
    local tBut = self.Array
    if ( not tBut ) then return self end
    local iB = (( iD > 0 ) and iD or nil )
    local pBut = table.remove( tBut, iB )
    if ( IsValid( pBut ) ) then pBut:Remove()
        tBut.Size = tBut.Size - 1
    end; self:SetWide()
    return self

end

function PANEL:ClearButtons()

    local tBut = self.Array
    if ( not tBut ) then return self end
    for iD = 1, tBut.Size do
        local pBut = table.remove( tBut )
        if ( IsValid( pBut ) ) then pBut:Remove() end
    end
    table.Empty( tBut ) -- Clear array
    self.Array = nil -- Wipe table
    self.SPY = self.SSY + 2 * self.PDY
    return self

end

function PANEL:UpdateColours( tSkin )

    if ( self.Slider and self.Slider.UpdateColours ) then
        self.Slider:UpdateColours( tSkin )
    end; local tBut = self.Array
    if ( not tBut ) then return self end
    if ( not tBut.Size ) then return self end
    if ( tBut.Size <= 0 ) then return self end
    for iD = 1, tBut.Size do pBut = tBut[ iD ]
        if ( pBut.UpdateColours ) then pBut:UpdateColours( tSkin ) end
    end

end

function PANEL:ApplySchemeSettings()

    if ( self.Slider and self.Slider.ApplySchemeSettings ) then
        self.Slider:ApplySchemeSettings()
    end; local tBut = self.Array
    if ( not tBut ) then return self end
    if ( not tBut.Size ) then return self end
    if ( tBut.Size <= 0 ) then return self end
    for iD = 1, tBut.Size do
        local pBut = tBut[ iD ]
        if ( pBut.ApplySchemeSettings ) then
        pBut:ApplySchemeSettings() end
    end; return self

end

function PANEL:UpdateView()

    local tBut = self.Array -- Buttons
    self.SPY = self.SSY + 2 * self.PDY
    self.SSX = self.SPX - 2 * self.PDX
    self.PSX = self.PDX -- Slider position X
    self.PSY = self.PDY -- Slider position Y
    self.Slider:SetPos( self.PSX, self.PSY )
    self.Slider:SetSize( self.SSX, self.SSY )
    if ( tBut and tBut.Size and tBut.Size > 0 ) then
        self.PBX = self.PSX -- Store the current X for button position
        self.PBY = self.PSY + self.SSY + self.EDY -- Button position Y
        self.SPY = self.SSY + self.SBY + 2 * self.PDY + self.EDY
        self.SBX = ( self.SPX - ( tBut.Size - 1 ) * self.EDX - 2 * self.PDX ) / tBut.Size
        for iD = 1, tBut.Size do
            tBut[ iD ]:SetPos( self.PBX, self.PBY )
            tBut[ iD ]:SetSize( self.SBX, self.SBY )
            self.PBX = self.PBX + self.SBX + self.EDX
        end
    end; return self

end

function PANEL:SetPadding( nX, nY )

    local nX = tonumber( nX )
    local nY = tonumber( nY )
    if ( nX ) then self.PDX = nX end
    if ( nY ) then self.PDY = nY end
    return self

end

function PANEL:GetPadding()
    return self.PDX, self.PDY
end

function PANEL:SetDelta( nX, nY )

    local nX = tonumber( nX )
    local nY = tonumber( nY )
    if ( nX ) then self.EDX = nX end
    if ( nY ) then self.EDY = nY end
    return self

end

function PANEL:GetDelta()
    return self.EDX, self.EDY
end

function PANEL:SetTall( nP, nS, nB )

    local nP = tonumber( nP )
    if ( nP ) then -- Scale everything
        if ( self:HasButtons() ) then
            self.SPY = nP
            self.SSY = ( nP - 2 * self.PDY - self.EDY ) / 2
            self.SBY = self.SSY
        else
            self.SPY = nP
            self.SSY = nP - 2 * self.PDY
        end
    else -- Adjust elements only
        local nS = tonumber( nS )
        local nB = tonumber( nB )
        if ( nS ) then self.SSY = nS end
        if ( nB ) then self.SBY = nB end
    end; return self

end

function PANEL:GetTall()
    return self.SPY, self.SSY, self.SBY
end

function PANEL:SetWide( nP, nS, nB )

    local nP = tonumber( nP )
    if ( nP ) then -- Scale everything
        if ( self:HasButtons() ) then
            local nC = self:GetCount()
            self.SPX = nP -- Use the new panel X
            self.SSX = self.SPX - 2 * self.PDX -- Scale slider
            self.SBX = self.SSX - (( nC - 1 ) * self.EDX )
        else
            self.SPX = nP
            self.SSX = nP - 2 * self.PDX
        end
    else -- Adjust elements only
        local nS = tonumber( nS )
        local nB = tonumber( nB )
        if ( nS ) then self.SSX = nS end
        if ( nB ) then self.SBX = nB end
    end; return self

end

function PANEL:GetWide()
    return self.SPX, self.SSX, self.SBX
end

function PANEL:Think()

    local rX, rY = self:IsAutoResize()
    if ( rX or rY ) then
        local pBase = self:GetParent()
        if ( IsValid( pBase ) ) then
            local dX, dY = self:AutoResize()
            local rU, sX, sY = false, pBase:GetSize()
            if ( rX and dX ~= sX ) then
                self:AutoResize( sX, nil ); rU = true
                local slef, stop, srgh, sbot = self:GetDockMargin()
                local blef, btop, brgh, bbot = pBase:GetDockPadding()
                self:SetWide( sX - slef - srgh - blef - brgh )
            end
            if ( rY and dY ~= sY ) then
                self:AutoResize( nil, sY ); rU = true
                local slef, stop, srgh, sbot = self:GetDockMargin()
                local blef, btop, brgh, bbot = pBase:GetDockPadding()
                self:SetTall( sY - stop - sbot - btop - bbot )
            end
            if ( rU ) then self:UpdateView() end
        end
    end

end

derma.DefineControl( "DSliderButton", "Button-interactive slider", PANEL, "DSizeToContents" )
