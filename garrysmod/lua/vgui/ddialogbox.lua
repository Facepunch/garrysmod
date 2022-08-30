
local PANEL = {}

-- See: https://en.wikipedia.org/wiki/Dialog_box

function PANEL:Init()
	self:SetTitle( "Untitled Dialog Box" )
	self:SetSize( 400, 200 )
	self:MakePopup()
	self:Center()
	self:SetDrawOnTop( true )
	
	self.children = {}
	
	---
	
	self:SetLabelText( "This is a dialog box.\n\nUse SetLabelText to change this label." )
	self:SetLabelEnabled( true )
	
	self:SetAcceptButtonText( "#GameUI_OK" )
	self:SetAcceptButtonEnabled( true )
	
	self:SetRejectButtonText( "#GameUI_Cancel" )
	self:SetRejectButtonEnabled( true )
end

-- No mercy
function PANEL:KillChildren()
	for _, child in pairs( self.children ) do
		child:Remove()
	end
end

-- Resize dialog frame to fit children
function PANEL:Invalidate()
	self.primaryPanel:InvalidateLayout( true )
	self.primaryPanel:SizeToChildren( false, true )
	
	self:InvalidateLayout( true )
	self:SizeToChildren( false, true )
end

-- Reinitializes dialog contents (content label, input boxes, button choices)
function PANEL:RebuildContents()
	-- Delete all the previous VGUI child elements in this panel
	self:KillChildren()
	
	self.primaryPanel = self:Add( "DPanel" )
	self.primaryPanel:DockMargin( 0, 0, 0, 0 ) -- Outer
	self.primaryPanel:DockPadding( 4, 4, 4, 4 ) -- Inner
	self.primaryPanel:Dock( TOP )
	self.primaryPanel:SetBackgroundColor( Color( 255, 0, 0, 0 ) )
	table.insert( self.children, self.primaryPanel )
	
	-- Main read-only text content of the dialog
	if self:GetLabelEnabled() then
		-- Create the primary label, set text, and resize to fit content
		self.label = self.primaryPanel:Add( "DLabel" )
		self.label:Dock( TOP )
		self.label:DockMargin( 0, 0, 0, 4 ) -- Outer
		self.label:SetText( self:GetLabelText() )
		self.label:SizeToContents()
		self.label:SetWrap( true )
		self.label:SetAutoStretchVertical( true )
	end
	
	self.secondaryPanel = self:Add( "DPanel" )
	self.secondaryPanel:DockMargin( 0, 0, 0, 0 ) -- Outer
	self.secondaryPanel:DockPadding( 0, 0, 0, 0 ) -- Inner
	self.secondaryPanel:Dock( TOP )
	self.secondaryPanel:SetTall( 30 )
	self.secondaryPanel:SetBackgroundColor( Color( 0, 255, 0, 0 ) )
	table.insert( self.children, self.secondaryPanel )
	
	if self:GetRejectButtonEnabled() then
		self.rejectButton = self.secondaryPanel:Add( "DButton" )
		self.rejectButton:SetText( self:GetRejectButtonText() )
		self.rejectButton:SizeToContents()
		local width = self.rejectButton:GetWide()
		width = math.max( width + 20, 66 )
		self.rejectButton:SetWide( width )
		self.rejectButton:Dock( RIGHT )
		self.rejectButton:DockMargin( 0, 4, 4, 4 ) -- Outer
		self.rejectButton.DoClick = function()
			self:OnReject()
			self:Close()
		end
	end
	
	if self:GetAcceptButtonEnabled() then
		self.acceptButton = self.secondaryPanel:Add( "DButton" )
		self.acceptButton:SetText( self:GetAcceptButtonText() )
		self.acceptButton:SizeToContents()
		local width = self.acceptButton:GetWide()
		width = math.max( width + 20, 66 )
		self.acceptButton:SetWide( width )
		self.acceptButton:Dock( RIGHT )
		self.acceptButton:DockMargin( 0, 4, 4, 4 ) -- Outer
		self.acceptButton.DoClick = function()
			self:OnAccept()
			self:Close()
		end
	end
	
	-- Resize dialog frame to fit children
	self:Invalidate()
end

-- The primary label is the label shown inside the dialog box
function PANEL:GetLabelEnabled()
	return self.isLabelEnabled
end

function PANEL:SetLabelEnabled( value )
	self.isLabelEnabled = value
	self:RebuildContents()
end

function PANEL:GetLabelText()
	return self.labelText
end

function PANEL:SetLabelText( value )
	self.labelText = value
	self:RebuildContents()
end

-- The accept button is the choice button that confirms the requested action
function PANEL:GetAcceptButtonEnabled()
	return self.isAcceptButtonEnabled
end

function PANEL:SetAcceptButtonEnabled( value )
	self.isAcceptButtonEnabled = value
	self:RebuildContents()
end

function PANEL:GetAcceptButtonText()
	return self.acceptButtonText
end

function PANEL:SetAcceptButtonText( value )
	self.acceptButtonText = value
	self:RebuildContents()
end

-- The reject button is the choice button that denies the requested action
function PANEL:GetRejectButtonEnabled()
	return self.isRejectButtonEnabled
end

function PANEL:SetRejectButtonEnabled( value )
	self.isRejectButtonEnabled = value
	self:RebuildContents()
end

function PANEL:GetRejectButtonText()
	return self.rejectButtonText
end

function PANEL:SetRejectButtonText( value )
	self.rejectButtonText = value
	self:RebuildContents()
end

function PANEL:AddPanel( newPanelName )
	return self.primaryPanel:Add( newPanelName )
end


-- Callback is fired when the dialog is accepted
function PANEL:OnAccept()
end

-- Callback fired when the dialog is rejected
function PANEL:OnReject()
end

derma.DefineControl( "DDialogBox", "A customizable dialog box", PANEL, "DFrame" )
