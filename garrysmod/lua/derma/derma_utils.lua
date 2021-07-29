
local matBlurScreen = Material( "pp/blurscreen" )

--[[
	This is designed for Paint functions..
--]]
function Derma_DrawBackgroundBlur( panel, starttime )

	local Fraction = 1

	if ( starttime ) then
		Fraction = math.Clamp( (SysTime() - starttime) / 1, 0, 1 )
	end

	local x, y = panel:LocalToScreen( 0, 0 )

	local wasEnabled = DisableClipping( true )

	-- Menu cannot do blur
	if ( !MENU_DLL ) then
		surface.SetMaterial( matBlurScreen )
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i=0.33, 1, 0.33 do
			matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
			matBlurScreen:Recompute()
			if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
		end
	end

	surface.SetDrawColor( 10, 10, 10, 200 * Fraction )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )

	DisableClipping( wasEnabled )

end

--[[
	Display a simple message box.

	Derma_Message( "Hey Some Text Here!!!", "Message Title (Optional)", "Button Text (Optional)" )
--]]

function Derma_Message( strText, strTitle, strButtonText )

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( strTitle or "Message" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )

	local InnerPanel = vgui.Create( "Panel", Window )

	local Text = vgui.Create( "DLabel", InnerPanel )
	Text:SetText( strText or "Message Text" )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetPaintBackground( false )

	local Button = vgui.Create( "DButton", ButtonPanel )
	Button:SetText( strButtonText or "OK" )
	Button:SizeToContents()
	Button:SetTall( 20 )
	Button:SetWide( Button:GetWide() + 20 )
	Button:SetPos( 5, 5 )
	Button.DoClick = function() Window:Close() end

	ButtonPanel:SetWide( Button:GetWide() + 10 )

	local w, h = Text:GetSize()

	Window:SetSize( w + 50, h + 25 + 45 + 10 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	Text:StretchToParent( 5, 5, 5, 5 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()
	return Window

end

--[[
	Ask a question with multiple answers..

	Derma_Query( "Would you like me to punch you right in the face?", "Question!",
						"Yesss",	function() MsgN( "Pressed YES!") end,
						"Nope!",	function() MsgN( "Pressed Nope!") end,
						"Cancel",	function() MsgN( "Cancelled!") end )

--]]

function Derma_Query( strText, strTitle, ... )

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( strTitle or "Message Title (First Parameter)" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )

	local InnerPanel = vgui.Create( "DPanel", Window )
	InnerPanel:SetPaintBackground( false )

	local Text = vgui.Create( "DLabel", InnerPanel )
	Text:SetText( strText or "Message Text (Second Parameter)" )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetPaintBackground( false )

	-- Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5

	for k=1, 8, 2 do

		local Text = select( k, ... )
		if Text == nil then break end

		local Func = select( k+1, ... ) or function() end

		local Button = vgui.Create( "DButton", ButtonPanel )
		Button:SetText( Text )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button.DoClick = function() Window:Close() Func() end
		Button:SetPos( x, 5 )

		x = x + Button:GetWide() + 5

		ButtonPanel:SetWide( x )
		NumOptions = NumOptions + 1

	end

	local w, h = Text:GetSize()

	w = math.max( w, ButtonPanel:GetWide() )

	Window:SetSize( w + 50, h + 25 + 45 + 10 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	Text:StretchToParent( 5, 5, 5, 5 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()

	if ( NumOptions == 0 ) then

		Window:Close()
		Error( "Derma_Query: Created Query with no Options!?" )
		return nil

	end

	return Window

end

--[[
	Request a string from the user

	Derma_StringRequest( "Question",
					"What Is Your Favourite Color?",
					"Type your answer here!",
					function( strTextOut ) Derma_Message( "Your Favourite Color Is: " .. strTextOut ) end,
					function( strTextOut ) Derma_Message( "You pressed Cancel!" ) end,
					"Okey Dokey",
					"Cancel" )

--]]

local function Derma_StringRequest( strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText )

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( strTitle or "Message Title (First Parameter)" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )

	Window.InnerPanel = vgui.Create( "DPanel", Window )
	Window.InnerPanel:SetPaintBackground( false )

    	Window.Text = vgui.Create( "DLabel", Window.InnerPanel )
	Window.Text:SetText( strText or "Message Text (Second Parameter)" )
	Window.Text:SizeToContents()
	Window.Text:SetContentAlignment( 5 )
	Window.Text:SetTextColor( color_white )

	Window.TextEntry = vgui.Create( "DTextEntry", Window.InnerPanel )
	Window.TextEntry:SetText( strDefaultText or "" )
	Window.TextEntry.OnEnter = function() Window:Close() fnEnter( Window.TextEntry:GetValue() ) end

	Window.ButtonPanel = vgui.Create( "DPanel", Window )
	Window.ButtonPanel:SetTall( 30 )
	Window.ButtonPanel:SetPaintBackground( false )

	Window.Button = vgui.Create( "DButton", Window.ButtonPanel )
	Window.Button:SetText( strButtonText or "OK" )
	Window.Button:SizeToContents()
	Window.Button:SetTall( 20 )
	Window.Button:SetWide( Window.Button:GetWide() + 20 )
	Window.Button:SetPos( 5, 5 )
	Window.Button.DoClick = function() Window:Close() fnEnter( Window.TextEntry:GetValue() ) end

	Window.ButtonCancel = vgui.Create( "DButton", Window.ButtonPanel )
	Window.ButtonCancel:SetText( strButtonCancelText or "Cancel" )
	Window.ButtonCancel:SizeToContents()
	Window.ButtonCancel:SetTall( 20 )
	Window.ButtonCancel:SetWide( Window.Button:GetWide() + 20 )
	Window.ButtonCancel:SetPos( 5, 5 )
	Window.ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( Window.TextEntry:GetValue() ) end end
	Window.ButtonCancel:MoveRightOf( Window.Button, 5 )

	Window.ButtonPanel:SetWide( Window.Button:GetWide() + 5 + Window.ButtonCancel:GetWide() + 10 )

	local w, h = Window.Text:GetSize()
	w = math.max( w, 400 )

	Window:SetSize( w + 50, h + 25 + 75 + 10 )
	Window:Center()

	Window.InnerPanel:StretchToParent( 5, 25, 5, 45 )

	Window.Text:StretchToParent( 5, 5, 5, 35 )

	Window.TextEntry:StretchToParent( 5, nil, 5, nil )
	Window.TextEntry:AlignBottom( 5 )

	Window.TextEntry:RequestFocus()
	Window.TextEntry:SelectAllText( true )

	Window.ButtonPanel:CenterHorizontal()
	Window.ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()

	return Window

end
