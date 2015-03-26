--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DFrame
	
	A window.

--]]

local PANEL = {}

AccessorFunc( PANEL, "m_bIsMenuComponent", 		"IsMenu", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bDraggable", 			"Draggable", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable", 				"Sizable", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock", 			"ScreenLock", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose", 		"DeleteOnClose", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_bPaintShadow", 			"PaintShadow", 		FORCE_BOOL )

AccessorFunc( PANEL, "minWidth", 			"MinWidth" )
AccessorFunc( PANEL, "minHeight", 			"MinHeight" )
AccessorFunc( PANEL, "maxWidth", 			"MaxWidth" )
AccessorFunc( PANEL, "maxHeight", 			"MaxHeight" )

AccessorFunc( PANEL, "borderThreshold", 			"BorderThreshold" )
AccessorFunc( PANEL, "m_bBackgroundBlur", 		"BackgroundBlur", 	FORCE_BOOL )

function PANEL:Init()

	self:SetFocusTopLevel( true )

	self:SetPaintShadow( true )

	self.btnClose = vgui.Create( "DButton", self )
	self.btnClose:SetText( "" )
	self.btnClose.DoClick = function ( button ) self:Close() end
	self.btnClose.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowCloseButton", panel, w, h ) end

	self.btnMaxim = vgui.Create( "DButton", self )
	self.btnMaxim:SetText( "" )
	self.btnMaxim.DoClick = function ( button ) self:Close() end
	self.btnMaxim.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowMaximizeButton", panel, w, h ) end
	self.btnMaxim:SetDisabled( true )

	self.btnMinim = vgui.Create( "DButton", self )
	self.btnMinim:SetText( "" )
	self.btnMinim.DoClick = function ( button ) self:Close() end
	self.btnMinim.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowMinimizeButton", panel, w, h ) end
	self.btnMinim:SetDisabled( true )

	self.lblTitle = vgui.Create( "DLabel", self )
	self.lblTitle.UpdateColours = function( label, skin )

		if ( self:IsActive() ) then return label:SetTextStyleColor( skin.Colours.Window.TitleActive ) end

		return label:SetTextStyleColor( skin.Colours.Window.TitleInactive )

	end

	self:SetDraggable( true )
	self:SetDeleteOnClose( true )
	self:SetTitle( "Window" )

	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )
	
	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )
	self:SetMaxWidth(ScrW())
	self:SetMaxHeight(ScrH())
	
	self:SetBorderThreshold(4)

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()

	self:DockPadding( 5, 24 + 5, 5, 5 )

end

function PANEL:ShowCloseButton( bShow )

	self.btnClose:SetVisible( bShow )
	self.btnMaxim:SetVisible( bShow )
	self.btnMinim:SetVisible( bShow )

end

function PANEL:SetTitle( strTitle )

	self.lblTitle:SetText( strTitle )

end

function PANEL:Close()

	self:SetVisible( false )

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end

	self:OnClose()

end
function PANEL:OnClose()

end

function PANEL:Center()

	local parent = self:GetParent()
	
	local w, h = self:GetSize()
	local pw, ph
	
	if IsValid(parent) then
		pw, ph = parent:GetSize()
	else
		pw, ph = ScrW(), ScrH()
	end
	
	self:SetPos( pw/2 - w/2, ph/2 - h/2 )
	
	self:InvalidateLayout( true )

end

function PANEL:IsActive()

	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false

end

function PANEL:SetIcon( str )

	if ( !str && IsValid( self.imgIcon ) ) then
		return self.imgIcon:Remove() -- We are instructed to get rid of the icon, do it and bail.
	end

	if ( !IsValid( self.imgIcon ) ) then
		self.imgIcon = vgui.Create( "DImage", self )
	end

	if ( IsValid( self.imgIcon ) ) then
		self.imgIcon:SetMaterial( Material( str ) )
	end

end

local function setX(self, newX)
	if self.m_bScreenLock then
		self.x = math.Clamp(newX, 0, self:GetParent():GetWide() - self:GetWide())
		return
	end
	self.x = newX
end

local function setY(self, newY)
	if self.m_bScreenLock then
		self.y = math.Clamp(newY, 0, self:GetParent():GetTall() - self:GetTall())
		return
	end
	self.y = math.max(newY, 0)
end


function PANEL:Think()
	local localMouseX, localMouseY = self:CursorPos()
	local width, height = self:GetSize()
	if self.scalingData or self.draggingData then
		if self.scalingData then
			if self.scalingData.left then
				local newWidth = math.Clamp(width - (localMouseX - self.scalingData.dragX), self.minWidth, self.maxWidth)
				if newWidth > self.minWidth then
					setX(self, self.x + (localMouseX - self.scalingData.dragX))
					self:SetWidth(newWidth)
				end
			end
			if self.scalingData.top then
				local newHeight = math.Clamp(height - (localMouseY - self.scalingData.dragY), self.minHeight, self.maxHeight)
				if newHeight > self.minHeight then
					setY(self, self.y + (localMouseY - self.scalingData.dragY))
					self:SetHeight(newHeight)
				end
			end
			if self.scalingData.right then
				self:SetWidth(math.Clamp(self.scalingData.startWidth + (localMouseX - self.scalingData.dragX), self.minWidth, self.maxWidth))
			end
			if self.scalingData.bottom then
				self:SetHeight(math.Clamp(self.scalingData.startHeight + (localMouseY - self.scalingData.dragY), self.minHeight, self.maxHeight))
			end
		end
		if self.draggingData then
			setX(self, self.x + (localMouseX - self.draggingData.dragX))
			setY(self, self.y + (localMouseY - self.draggingData.dragY))
		end
		return
	end
	
	local threshold = self.borderThreshold
	
	local atUpperBorder = localMouseY < threshold
	local atLowerBorder = localMouseY > height - threshold
	local atLeftBorder = localMouseX < threshold
	local atRightBorder = localMouseX > width - threshold
	local atDragBorder = localMouseY < 25
	
	if self.m_bSizable then
		if (atUpperBorder and atLeftBorder) or (atLowerBorder and atRightBorder) then
			self:SetCursor("sizenwse")
			return
		end
		
		if (atUpperBorder and atRightBorder) or (atLowerBorder and atLeftBorder) then
			self:SetCursor("sizenesw")
			return
		end
		
		if atUpperBorder or atLowerBorder then
			self:SetCursor("sizens")
			return
		end
		
		if atLeftBorder or atRightBorder then
			self:SetCursor("sizewe")
			return
		end
	end
	if atDragBorder then
		self:SetCursor("sizeall")
		return
	end
	if self.m_bDraggable then
		self:SetCursor("arrow")
	end
end

function PANEL:Paint( w, h )

	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	derma.SkinHook( "Paint", "Frame", self, w, h )
	return true

end

function PANEL:OnMousePressed()
	if self.m_bSizable or self.m_bDraggable then
		local localMouseX, localMouseY = self:CursorPos()
		
		
		if self.m_bSizable then
			local width, height = self:GetSize()
		
			local threshold = self.borderThreshold
			
			local atUpperBorder = localMouseY < threshold
			local atLowerBorder = localMouseY > height - threshold
			local atLeftBorder = localMouseX < threshold
			local atRightBorder = localMouseX > width - threshold
			
			if atUpperBorder or atLowerBorder or atLeftBorder or atRightBorder then
				self.scalingData = {
					left = localMouseX < threshold,
					top = localMouseY < threshold,
					right = localMouseX > width - threshold,
					bottom = localMouseY > height - threshold,
					dragX = localMouseX,
					dragY = localMouseY,
					startWidth = width,
					startHeight = height
				}
				self:MouseCapture(true)
				return
			end
		end
		if self.m_bDraggable and localMouseY < 25 then
			self.draggingData = {
				dragX = localMouseX,
				dragY = localMouseY
			}
			self:MouseCapture(true)
		end
	end
end

function PANEL:OnMouseReleased()
	self.draggingData = nil
	self.scalingData = nil
	self:MouseCapture(false)
end

function PANEL:PerformLayout(w, h)

	local titlePush = 0

	if ( IsValid( self.imgIcon ) ) then

		self.imgIcon:SetPos( 5, 5 )
		self.imgIcon:SetSize( 16, 16 )
		titlePush = 16

	end

	self.btnClose:SetPos( w - 31 - 4, 0 )
	self.btnClose:SetSize( 31, 31 )

	self.btnMaxim:SetPos( w - 31*2 - 4, 0 )
	self.btnMaxim:SetSize( 31, 31 )

	self.btnMinim:SetPos( w - 31*3 - 4, 0 )
	self.btnMinim:SetSize( 31, 31 )
	
	self.lblTitle:SetPos( 8, 2 )
	self.lblTitle:SetSize( w - 25, 20 )

end

function PANEL:IsActive()

	self.lblTitle:SetPos( 8 + titlePush, 2 )
	self.lblTitle:SetSize( self:GetWide() - 25 - titlePush, 20 )

end

derma.DefineControl( "DFrame", "A simpe window", PANEL, "EditablePanel" )
