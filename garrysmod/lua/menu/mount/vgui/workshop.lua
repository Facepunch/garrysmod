
PANEL.Base = "DPanel"

local wsFont

if ( system.IsLinux() ) then
	wsFont = "DejaVu Sans"
elseif ( system.IsWindows() ) then
	wsFont = "Tahoma"
else
	wsFont = "Helvetica"
end

surface.CreateFont( "WorkshopLarge", {
	font		= wsFont,
	size		= 19,
	antialias	= true,
	weight		= 800
})

local pnlRocket			= vgui.RegisterFile( "addon_rocket.lua" )
local matProgressCog	= Material( "gui/progress_cog.png", "nocull smooth" )
local matHeader			= Material( "gui/steamworks_header.png" )

AccessorFunc( PANEL, "m_bDrawProgress", "DrawProgress", FORCE_BOOL )

function PANEL:Init()

	self.Label = self:Add( "DLabel" )
	self.Label:SetText( "..." )
	self.Label:SetFont( "WorkshopLarge" )
	self.Label:SetTextColor( Color( 255, 255, 255, 200 ) )
	self.Label:Dock( TOP )
	self.Label:DockMargin( 16, 10, 16, 8 )
	self.Label:SetContentAlignment( 5 )

	self.ProgressLabel = self:Add( "DLabel" )
	self.ProgressLabel:SetText( "" )
	self.ProgressLabel:SetContentAlignment( 7 )
	self.ProgressLabel:SetVisible( false )
	self.ProgressLabel:SetTextColor( Color( 255, 255, 255, 50 ) )

	self.TotalsLabel = self:Add( "DLabel" )
	self.TotalsLabel:SetText( "" )
	self.TotalsLabel:SetContentAlignment( 7 )
	self.TotalsLabel:SetVisible( false )
	self.TotalsLabel:SetTextColor( Color( 255, 255, 255, 50 ) )

	self.Progress = 0
	self.TotalProgress = 0

	self:SetDrawProgress( false )

end

function PANEL:PerformLayout( wide )

	self:SetSize( 500, 80 )
	self:Center()
	self:AlignBottom( 16 )

	self.ProgressLabel:SetSize( 100, 20 )
	self.ProgressLabel:SetPos( wide - 100, 40 )

	self.TotalsLabel:SetSize( 100, 20 )
	self.TotalsLabel:SetPos( wide - 100, 60 )

end

function PANEL:Spawn()

	self:InvalidateLayout( true )

end

function PANEL:PrepareDownloading()

	if ( IsValid( self.Rocket ) ) then self.Rocket:Remove() end

	self.Rocket = self:Add( pnlRocket )
	self.Rocket:Dock( LEFT )
	self.Rocket:MoveToBack()
	self.Rocket:DockMargin( 8, 0, 8, 0 )

end

function PANEL:StartDownloading( id, iImageID, title, iSize )

	self.Label:SetText( language.GetPhrase( "ugc.downloadingX" ):format( title ) )

	self.Rocket:Charging( id, iImageID )

	self.ProgressLabel:Show()
	self.ProgressLabel:SetText( "" )

	self.TotalsLabel:Show()

	self:SetDrawProgress( true )
	self:UpdateProgress( 0, iSize )

end

function PANEL:FinishedDownloading( id )

	self.Progress = -1
	--self:SetDrawProgress( false )
	--self.ProgressLabel:Hide()
	--self.TotalsLabel:Hide()
	--self.Rocket:Blast()

end

function PANEL:SetMessage( msg )

	self.Label:SetText( msg )

	self:SetDrawProgress( false )

end

local boxColor = Color( 50, 50, 50, 255 )
local progressBarColor = Color( 255, 255, 255, 200 )
local progressBarOutlineColor = Color( 0, 0, 0, 150 )

function PANEL:Paint( wide, tall )

	DisableClipping( true )
		draw.RoundedBox( 4, -1, -1, wide + 2, tall + 2, color_black )
	DisableClipping( false )

	draw.RoundedBox( 4, 0, 0, wide, tall, boxColor )

	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.SetMaterial( matProgressCog )
	surface.DrawTexturedRectRotated( 0, 32, 256, 256, SysTime() * -20 )

	if ( self:GetDrawProgress() ) then

		-- Overall progress
		local w = wide - 228
		local x = 80

		draw.RoundedBox( 4, x + 32, 62, w, 10, progressBarOutlineColor )
		draw.RoundedBox( 4, x + 33, 63, w * math.Clamp( self.TotalProgress, 0.05, 1 ) - 2, 8, progressBarColor )

		-- Current file Progress
		local currentProgress = self.Progress

		if ( currentProgress >= 0 ) then
			draw.RoundedBox( 4, x + 32, 40, w, 15, progressBarOutlineColor )
			draw.RoundedBox( 4, x + 33, 41, w * math.Clamp( currentProgress, 0.05, 1 ) - 2, 13, progressBarColor )
		end

	end

	-- Workshop LOGO
	DisableClipping( true )

		local x = -8

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( matHeader )
		surface.DrawTexturedRect( x, -22, 128, 32 )

		surface.SetDrawColor( 255, 255, 255, math.random( 0, 255 ) )
		surface.DrawTexturedRect( x, -22, 128, 32 )

	DisableClipping( false )

end

function PANEL:UpdateProgress( downloaded, expected )

	if ( expected <= 0 ) then
		self.Progress = 0
		self.ProgressLabel:SetText( "" )
		return
	end

	self.Progress = downloaded / expected

	if ( self.Progress > 0 ) then
		self.ProgressLabel:SetText( language.GetPhrase( "ugc.XoutofY" ):format( Format( "%.0f%%", self.Progress * 100 ), string.NiceSize( expected ) ) )
	else
		self.ProgressLabel:SetText( string.NiceSize( expected ) )
	end

end

function PANEL:ExtractProgress( title, percent )

	self.Label:SetText( language.GetPhrase( "ugc.extractingX" ):format( title ) )
	self.Progress = percent / 100

	if ( self.Progress > 0 ) then
		self.ProgressLabel:SetText( Format( "%.0f%%", percent ) )
	else
		self.ProgressLabel:SetText( "0%" )
	end

end

function PANEL:UpdateTotalProgress( iCurrent, iTotal )

	self.TotalsLabel:SetText( language.GetPhrase( "ugc.addonXofY" ):format( iCurrent, iTotal ) )
	self.TotalProgress = iCurrent / iTotal

end

function PANEL:SubscriptionsProgress( iCurrent, iTotal )

	self.Label:SetText( "#ugc.fetching" )
	self:SetDrawProgress( true )

	self.Progress = iCurrent / iTotal

	self.ProgressLabel:Show()
	self.ProgressLabel:SetText( language.GetPhrase( "ugc.XofY" ):format( iCurrent, iTotal ) )

end
