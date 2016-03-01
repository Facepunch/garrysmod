--[[__                                       _
 / _| __ _  ___ ___ _ __  _   _ _ __   ___| |__
| |_ / _` |/ __/ _ \ '_ \| | | | '_ \ / __| '_ \
|  _| (_| | (_|  __/ |_) | |_| | | | | (__| | | |
|_|  \__,_|\___\___| .__/ \__,_|_| |_|\___|_| |_|
                   |_| 2010 --]]

local PANEL = {}

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

	local ButtonSize = 32
	local Margins = 2
	local Spacing = 0

	self.BackButton = vgui.Create( "DImageButton", self )
	self.BackButton:SetSize( ButtonSize, ButtonSize )
	self.BackButton:SetMaterial( "gui/HTML/back" )
	self.BackButton:Dock( LEFT )
	self.BackButton:DockMargin( Spacing*3, Margins, Spacing, Margins )
	self.BackButton.DoClick = function()
		self.BackButton:SetDisabled( true )
		self.Cur = self.Cur - 1
		self.Navigating = true
		self.HTML:GoBack()
	end

	self.ForwardButton = vgui.Create( "DImageButton", self )
	self.ForwardButton:SetSize( ButtonSize, ButtonSize )
	self.ForwardButton:SetMaterial( "gui/HTML/forward" )
	self.ForwardButton:Dock( LEFT )
	self.ForwardButton:DockMargin( Spacing, Margins, Spacing, Margins )
	self.ForwardButton.DoClick = function()
		self.ForwardButton:SetDisabled( true )
		self.Cur = self.Cur + 1
		self.Navigating = true
		self.HTML:GoForward()
	end

	self.RefreshStopButton = vgui.Create( "DImageButton", self )
	self.RefreshStopButton:SetSize( ButtonSize, ButtonSize )
	self.RefreshStopButton:SetMaterial( "gui/HTML/refresh" )
	self.RefreshStopButton:Dock( LEFT )
	self.RefreshStopButton:DockMargin( Spacing, Margins, Spacing, Margins )

	self.HomeButton = vgui.Create( "DImageButton", self )
	self.HomeButton:SetSize( ButtonSize, ButtonSize )
	self.HomeButton:SetMaterial( "gui/HTML/home" )
	self.HomeButton:Dock( LEFT )
	self.HomeButton:DockMargin( Spacing, Margins, Spacing*3, Margins )
	self.HomeButton.DoClick = function()
		if ( self.HTML.URL == self.HomeURL ) then return end
		self.HTML:StopLoading()
		self.HTML:OpenURL( self.HomeURL )
	end

	self.AddressBar = vgui.Create( "DTextEntry", self )
	self.AddressBar:Dock( FILL )
	self.AddressBar:DockMargin( Spacing, Margins * 3, Margins * 3, Margins * 3 )
	self.AddressBar.OnEnter = function()
		self.HTML:StopLoading()
		self.HTML:OpenURL( self.AddressBar:GetValue() )
	end

	self:SetHeight( ButtonSize + Margins * 2 )

	self.History = {}
	self.Cur = 1

	-- This is the default look, feel free to change it on your created control :)
	self:SetButtonColor( Color( 250, 250, 250, 200 ) )
	self.BorderSize = 4
	self.BackgroundColor = Color( 40, 40, 40, 255 )
	self.HomeURL = "http://www.google.com"

end

function PANEL:SetHTML( html )

	self.HTML = html

	if ( html.URL ) then
		self.HomeURL = self.HTML.URL
	end

	self.AddressBar:SetText( self.HomeURL )
	self:UpdateHistory( self.HomeURL )
	self:FinishedLoading() -- in case dev adds controls AFTER load

	local OldFunc = self.HTML.OnBeginLoadingDocument
	self.HTML.OnBeginLoadingDocument = function( panel, url )

		self.AddressBar:SetText( url )
		self:StartedLoading()

		if ( OldFunc ) then
			OldFunc( panel, url )
		end

		self:UpdateHistory( url )

	end

	local OldFunc = self.HTML.OnFinishLoadingDocument
	self.HTML.OnFinishLoadingDocument = function( panel, url )

		self:FinishedLoading()

		if ( OldFunc ) then
			OldFunc( panel, url )
		end

	end

end

function PANEL:UpdateHistory( url )

	self.Cur = math.Clamp( self.Cur, 1, table.Count( self.History ) )

	if ( self.Navigating ) then

		self.Navigating = false
		self:UpdateNavButtonStatus()
		return

	end

	-- Check if we refreshed or hooked into the panel just after creation.
	if self.History[ self.Cur ] == url then return end

	-- We were back in the history queue, but now we're navigating
	-- So clear the front out so we can re-write history!!
	if ( self.Cur < table.Count( self.History ) ) then

		for i=self.Cur+1, table.Count( self.History ) do
			self.History[i] = nil
		end

	end

	self.Cur = table.insert( self.History, url )

	self:UpdateNavButtonStatus()

end

function PANEL:FinishedLoading()

	self.RefreshStopButton:SetDisabled( false )
	self.RefreshStopButton:SetMaterial( "gui/HTML/refresh" )
	self.RefreshStopButton.DoClick = function() self.HTML:Refresh() end

end

function PANEL:StartedLoading()

	self.RefreshStopButton:SetMaterial( "gui/HTML/stop" )
	self.RefreshStopButton.DoClick = function()
		self.RefreshStopButton:SetDisabled( true ) -- Awesomium can be slow, let's give some user feedback
		self.HTML:StopLoading()
	end

end

function PANEL:UpdateNavButtonStatus()

	self.ForwardButton:SetDisabled( self.Cur >= table.Count( self.History ) )
	self.BackButton:SetDisabled( self.Cur == 1 )

end

function PANEL:SetButtonColor( col )

	self.BackButton:SetColor( col )
	self.ForwardButton:SetColor( col )
	self.RefreshStopButton:SetColor( col )
	self.HomeButton:SetColor( col )

end

function PANEL:Paint()

	draw.RoundedBoxEx( self.BorderSize, 0, 0, self:GetWide(), self:GetTall(), self.BackgroundColor, true, true, false, false )

end

derma.DefineControl( "DHTMLControls", "", PANEL, "Panel" )
