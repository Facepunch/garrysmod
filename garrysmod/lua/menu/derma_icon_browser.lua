
function Derma_OpenIconBrowser()
	-- Because the icon browser will be part of the menu, activate the menu so that it definitely shows up otherwise a derma_icon_browser bind does nothing
	gui.ActivateGameUI()

	if ( IsValid( Derma_IconBrowser ) ) then
		Derma_IconBrowser:SetVisible( true )
		Derma_IconBrowser:MakePopup()
		return
	end

	Derma_IconBrowser = vgui.Create( "DFrame" )
	Derma_IconBrowser:SetTitle( "Derma Icon Browser" )
	Derma_IconBrowser:SetIcon( "icon16/pictures.png" )
	Derma_IconBrowser:SetScreenLock( true ) -- Don't let the icon browser out of the screen bounds, we don't want it to get lost
	Derma_IconBrowser:SetSizable( true )

	-- Minimum size the user can resize the icon browser to
	local minFrameW, minFrameH = 250, 200

	-- Remember the user's custom size for the icon browser
	-- If any dimension of the custom size is bigger than the screen bounds, or smaller than the minimum bounds, forget about it
	local frameW, frameH = cookie.GetNumber( "Derma_IconBrowser_W", 400 ), cookie.GetNumber( "Derma_IconBrowser_H", 400 )
	if ( frameW > ScrW() || frameH > ScrH() ) then
		frameW, frameH = 400, 400
		cookie.Delete( "Derma_IconBrowser_W" )
		cookie.Delete( "Derma_IconBrowser_H" )
	end

	Derma_IconBrowser.OnScreenSizeChanged = function( self )
		-- Make sure if the screen resolution changes we keep the icon browser within its bounds
		self:SetSize( math.min( self:GetWide(), ScrW() ), math.min( self:GetTall(), ScrH() ) )

		-- Store changes
		cookie.Set( "Derma_IconBrowser_W", self:GetWide() )
		cookie.Set( "Derma_IconBrowser_H", self:GetTall() )

		-- Prevent changes being stored twice
		self.m_bStoreResize = false
	end
	Derma_IconBrowser.OnSizeChanged = function( self )
		-- Don't store the custom size in the database yet, we don't want to spam it
		if ( self.m_bStoreResize != false ) then
			self.m_bStoreResize = true
		else
			-- The screen resolution just changed, we already stored that in the database
			self.m_bStoreResize = nil
		end
	end
	Derma_IconBrowser.OnMouseReleased = function( self )
		if ( self.m_bStoreResize ) then
			self.m_bStoreResize = nil
			-- Now we can store it - the user has finished dragging
			cookie.Set( "Derma_IconBrowser_W", self:GetWide() )
			cookie.Set( "Derma_IconBrowser_H", self:GetTall() )
		end

		-- Call the function we had overridden
		DFrame.OnMouseReleased( self )
	end

	-- Set the size of the icon browser and pop it up on the screen
	Derma_IconBrowser:SetSize( frameW, frameH )
	Derma_IconBrowser:SetMinimumSize( minFrameW, minFrameH )
	Derma_IconBrowser:Center()
	Derma_IconBrowser:MakePopup()

	-- Some variables for our "copied" icon
	local copyIconSize = 16
	local copyIconSpacing = 5
	local matCopyIcon = Material( "icon16/page_copy.png" )
	Derma_IconBrowser.PaintOver = function( self )
		-- Nice animation for feedback when copying an icon
		if ( self.m_nCopiedTime && SysTime() <= self.m_nCopiedTime ) then
			local wasEnabled = DisableClipping( true )

			-- Animation lasts 1 second (the fade starts after .25 seconds)
			local slideAnimFrac = 1 - math.TimeFraction( self.m_nCopiedTime - 1, self.m_nCopiedTime, SysTime() )
			local fadeAnimFrac = 1 - math.max( math.TimeFraction( self.m_nCopiedTime - .75, self.m_nCopiedTime, SysTime() ), 0 )

			-- Draw a small label underneath the mouse cursor that gradually slides down and fades away
			surface.SetFont( "BudgetLabel" )
			surface.SetTextColor( 255, 255, 255, fadeAnimFrac * 255 )

			local mouseX, mouseY = self:ScreenToLocal( input.GetCursorPos() )
			local textW, textH = surface.GetTextSize( self.m_strCopiedIcon )

			local textX = mouseX - ( ( textW - copyIconSize - copyIconSpacing ) / 2 ) -- Draw it center-aligned at the cursor, subtract 16px for the page_copy icon and 5px for its spacing
			local textY = mouseY + textH + ( ( 1 - slideAnimFrac ) * textH ) + 5 -- Animate it to slide down plus a further 5px for spacing
			surface.SetTextPos( textX, textY )

			surface.DrawText( self.m_strCopiedIcon )

			-- Draw a small page_copy icon next to the label
			local copyIconX = textX - copyIconSize - copyIconSpacing
			local copyIconY = textY - ( ( math.max( textH, copyIconSize ) - math.min( textH, copyIconSize ) ) / 2 ) -- Center align the icon to the text (ambigious to whether the text or the icon is bigger)
			surface.SetDrawColor( 255, 255, 255, fadeAnimFrac * 255 )
			surface.SetMaterial( matCopyIcon )
			surface.DrawTexturedRect( copyIconX, copyIconY, copyIconSize, copyIconSize )

			DisableClipping( wasEnabled )
		end
	end

	local IconBrowser = Derma_IconBrowser:Add( "DIconBrowser" )
	IconBrowser:Dock( FILL )
	IconBrowser.OnChange = function( self )
		-- Label animation data
		Derma_IconBrowser.m_nCopiedTime = SysTime() + 1
		Derma_IconBrowser.m_strCopiedIcon = self:GetSelectedIcon()

		-- Set the clipboard text to the icon path
		SetClipboardText( Derma_IconBrowser.m_strCopiedIcon )

		-- Play a nice sound
		surface.PlaySound( "garrysmod/content_downloaded.wav" )
	end

	-- Create our search box
	local Search = Derma_IconBrowser:Add( "DTextEntry" )
	Search:MoveToBefore( IconBrowser ) -- We need it to be above the icon browser itself
	Search:Dock( TOP )
	Search:DockMargin( 0, 0, 0, 5 )
	Search:SetPlaceholderText( "#spawnmenu.search" )
	Search:SetTall( 24 )
	Search:SetUpdateOnType( true )
	Search.OnValueChange = function( self )
		local str = Search:GetValue():Trim():gsub( "^icon16/(.+)", "%1" )
		IconBrowser:FilterByText( str ) -- If the user typed icon16/ at the start, get rid of it for them and trim any whitespace
	end

	-- Add a little magnifying glass icon in the right corner of the search box
	local SearchIcon = Search:Add( "DImage" )
	SearchIcon:SetImage( "icon16/magnifier.png" )
	SearchIcon:Dock( RIGHT )
	SearchIcon:DockMargin( 4, 4, 4, 4 )
	SearchIcon:SetSize( 16, 16 )

	-- Keep this line at the bottom otherwise an error could zombify the icon browser
	Derma_IconBrowser:SetDeleteOnClose( false )
end

concommand.Add( "derma_icon_browser", Derma_OpenIconBrowser, nil, "Opens the Derma Icon Browser", FCVAR_DONTRECORD )