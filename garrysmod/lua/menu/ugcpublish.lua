
local PANEL = {}

function PANEL:Init()
	self:SetSize( 700, 200 )
	self:Center()
	self:DockPadding( 10, 24 + 10, 10, 10 )
	self:SetTitle( "#ugc_upload.frametitle" )
	self:SetBackgroundBlur( true ) -- Indicate that the background elements won't be usable
	--self:SetSizable( true )

	self.AddonList = self:Add( "DListView" )
	self.AddonList:Dock( RIGHT )
	self.AddonList:SetWide( 200 )
	self.AddonList:AddColumn( "#ugc_upload.existing" )
	self.AddonList:DockMargin( 10, 0, 0, 0 )
	self.AddonList:SetMultiSelect( false )
	self.AddonList:SetMouseInputEnabled( false )
	self.AddonList.OnRowSelected = function( s, ... ) self:OnRowSelected( ... ) end

	self.AddonListLabel = self.AddonList:Add( "DLabel" )
	self.AddonListLabel:Dock( FILL )
	self.AddonListLabel:SetTextColor( color_black )
	self.AddonListLabel:SetContentAlignment( 5 )
	self.AddonListLabel:SetZPos( 100 )
	self.AddonListLabel.Paint = function( s, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) ) end -- TODO: Prolly should be hooked to skin

	local topContainer = self:Add( "Panel" )
	topContainer:Dock( TOP )
	topContainer:SetTall( 200 )

	self.Image = topContainer:Add( "DImage" )
	self.Image:Dock( LEFT )
	self.Image:SetWide( 200 )
	self.Image:DockMargin( 0, 0, 5, 0 )

	local titleLabel = topContainer:Add( "DLabel" )
	titleLabel:Dock( TOP )
	titleLabel:SetText( "#ugc_upload.title" )

	self.Title = topContainer:Add( "DTextEntry" )
	self.Title:Dock( TOP )
	self.Title:SetUpdateOnType( true )
	self.Title.OnTextChanged = function( s ) self:CheckInput() end

	local descLabel = topContainer:Add( "DLabel" )
	descLabel:Dock( TOP )
	descLabel:SetText( "#ugc_upload.description" )

	self.Description = topContainer:Add( "DTextEntry" )
	self.Description:Dock( FILL )
	self.Description:SetMultiline( true )

	self.TagsLabel = self:Add( "DLabel" )
	self.TagsLabel:Dock( TOP )
	self.TagsLabel:SetText( "#ugc_upload.tags" )

	self.Tags = self:Add( "Panel" )
	self.Tags:Dock( TOP )

	self.ChangeNotesLabel = self:Add( "DLabel" )
	self.ChangeNotesLabel:Dock( TOP )
	self.ChangeNotesLabel:DockMargin( 0, 5, 0, 0 )
	self.ChangeNotesLabel:SetText( "#ugc_upload.changenotes" )

	self.ChangeNotes = self:Add( "DTextEntry" )
	self.ChangeNotes:Dock( TOP )
	self.ChangeNotes:SetPlaceholderText( "ugc_upload.changenotes.help" )
	self.ChangeNotes:SetVisible( false )
	self.ChangeNotes:SetUpdateOnType( true )
	self.ChangeNotes:SetMultiline( true )
	self.ChangeNotes:SetTall( 80 )

	self.Publish = self:Add( "DButton" )
	self.Publish:Dock( TOP )
	self.Publish:SetEnabled( false )
	self.Publish:SetText( "#ugc_upload.publish" )
	self.Publish:DockMargin( 0, 5, 0, 0 )
	self.Publish.DoClick = function( s ) self:DoPublish() end

	self.UpdateProgress = self:Add( "DLabel" )
	self.UpdateProgress:SetText( "Publising your content, please wait..." )
	self.UpdateProgress:SetTextColor( color_black )
	self.UpdateProgress:SetContentAlignment( 5 )
	self.UpdateProgress:SetZPos( 100 )
	self.UpdateProgress:SetVisible( false )
	self.UpdateProgress.Paint = function( s, w, h )
		s:StretchToParent( 4, 4, 4, 4 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 255 ) ) -- TODO: Prolly should be hooked to skin
	end


end

PANEL.TagsPerType = {
	save = {
		scenes = "#ugc_upload.tag_scenes_save",
		courses = "#ugc_upload.tag_courses",
		machines = "#ugc_upload.tag_machines",
		buildings = "#ugc_upload.tag_buildings",
		others = "#ugc_upload.tag_others"
	},
	dupe = {
		posed = "#ugc_upload.tag_posed",
		scenes = "#ugc_upload.tag_scenes",
		vehicles = "#ugc_upload.tag_vehicles",
		machines = "#ugc_upload.tag_machines",
		buildings = "#ugc_upload.tag_buildings",
		others = "#ugc_upload.tag_others"
	}
}

function PANEL:FitContents()
	-- Make this panel smaller, stuff below won't shrink it, only expand it
	self:SetTall( 200 )

	-- Set the window height to nicely fit everything, no extra space anywhere
	self:InvalidateLayout( true )
	self:SizeToChildren( false, true )
end

function PANEL:OnRowSelected( rowID, row )
	-- Create new node, reset the fields
	if ( !row.WorkshopData ) then
		self.Publish:SetText( "#ugc_upload.publish" )
		self.ChangeNotes:SetVisible( false )
		self.ChangeNotesLabel:SetVisible( false )
		self.Title:SetText( "" )
		self.Description:SetText( "" )
		for k, v in pairs( self.Tags:GetChildren() ) do v:SetChecked( false ) end -- SetChecked to not invoke OnChange
		self:FitContents()
		self:CheckInput()
		return
	end

	local dat = row.WorkshopData

	self.Title:SetText( dat.title )
	self.Description:SetText( dat.description )
	for k, v in pairs( self.Tags:GetChildren() ) do
		if ( dat.tags:find( v:GetName() ) ) then v:SetValue( true ) break end
	end

	self.Publish:SetText( "#ugc_upload.update" )
	self.ChangeNotes:SetVisible( true )
	self.ChangeNotesLabel:SetVisible( true )
	self:FitContents()
	self:CheckInput()
end

function PANEL:Setup( ugcType, file, imageFile, handler )
	self.ugcType = ugcType
	self.ugcFile = file
	self.ugcImage = imageFile
	self.ugcHandler = handler

	self.Image:SetImage( "../" .. self.ugcImage )

	if ( self.TagsPerType[ self.ugcType ] ) then
		for k, v in pairs( self.TagsPerType[ self.ugcType ] ) do
			local rb = self.Tags:Add( "DCheckBoxLabel" )
			rb:Dock( TOP )
			rb:SetText( v )
			rb:SetName( k )
			rb:DockMargin( 4, 0, 0, 2 )

			rb.OnChange = function( s, val )
				self:CheckInput()

				local num = 0
				for id, pnl in pairs( s:GetParent():GetChildren() ) do
					if ( pnl:GetChecked() ) then num = num + 1 end
					if ( pnl == s or !val ) then continue end
					pnl:SetValue( false ) -- Validate that only 1 is selected
				end
				if ( !val && num == 0 ) then s:SetValue( true ) end -- Don't allow to unselect the only 1 selected
			end

			Derma_Hook( rb.Button, "Paint", "Paint", "RadioButton" )
		end

		self.Tags:InvalidateChildren( false ) -- Update position of all the docked elements
		self.Tags:SizeToChildren( false, true ) -- Set nice size for the tags container
	else
		self.TagsLabel:SetVisible( false )
		self.Tags:SetVisible( false )
	end

	self:FitContents()

	self:UpdateWorkshopItems()
end

function PANEL:UpdateWorkshopItems()
	self.AddonListLabel:SetVisible( true )
	self.AddonListLabel:SetText( "#ugc_upload.loading" )

	self.AddonList:Clear()
	self.AddonList:AddLine( "#ugc_upload.createnew" )
	self.AddonList:SelectFirstItem()

	steamworks.GetList( "mine", { self.ugcType }, 0, 9999, 0, "1", function( data )
		for i, id in pairs( data.results ) do
			steamworks.FileInfo( id, function( info )
				local a = self.AddonList:AddLine( info.title )
				a:SetTooltip( "#ugc_upload.rightclickopen" )
				a.WorkshopID = id
				a.WorkshopData = info
				a.OnRightClick = function( s )
					if ( !s.WorkshopID ) then return end

					steamworks.ViewFile( s.WorkshopID )
				end

				self.AddonList:SetMouseInputEnabled( true )
				self.AddonListLabel:SetVisible( false )
			end )
		end

		if ( data.totalresults == 0 ) then
			self.AddonListLabel:SetText( "#ugc_upload.nothingfound" )
		end
	end )
end

function PANEL:GetChosenTag()
	for k, v in pairs( self.Tags:GetChildren() ) do
		if ( v:GetChecked() ) then
			return v:GetName()
		end
	end
end

function PANEL:CheckInput()
	if ( self.TagsPerType[ self.ugcType ] && !self:GetChosenTag() ) then return self.Publish:SetEnabled( false ) end
	if ( self.Title:GetText() == "" ) then return self.Publish:SetEnabled( false ) end

	self.Publish:SetEnabled( true )
end

local errors = {}
errors[ "badhandle" ] = "Generic error while trying to create item."
errors[ "createid" ] = "Generic error while trying to create workshop item ID."
errors[ "badupdatehandle" ] = "Generic error while trying to update item."
errors[ "badsubmitupdatehandle" ] = "Could not submit update to Steam."
errors[ "cantupdate" ] = "Failed to upload workshop files to Steam."
errors[ "badwords" ] = "Please refrain from uploading spam, vulgar, sexual or offensive content to Steam Workshop."

function PANEL:DisplayError( err )
	-- Unlock the UI and allow user to try again/make changes
	self.UpdateProgress:SetVisible( false )
	self:SetMouseInputEnabled( true )

	if ( err == "termsofservice" ) then
		err = "You must accept Steam Workshop Terms of Service before you can upload content!\nWould you like to open it right now?"
		Derma_Query( err, "Error while publishing content!", "Yes", function()
			gui.OpenURL( "http://steamcommunity.com/sharedfiles/workshoplegalagreement" )
		end, "Nah" )
		return
	end

	if ( errors[ err ] ) then err = errors[ err ] end

	Derma_Message( err or "UNKNOWN ERROR", "Error while publishing content!", "OK" )
end

function PANEL:OnPublishFinished( wsid, err )
	if ( !wsid ) then
		self:DisplayError( err )
		return
	end

	-- TODO: Show "View item"/"Close" buttons instead?

	steamworks.ViewFile( wsid )
	self:Remove()
end

function PANEL:DoPublish()
	local ChosenTag = self:GetChosenTag()

	if ( self.TagsPerType[ self.ugcType ] && ChosenTag == nil ) then
		self:DisplayError( "You must choose a tag!")
		return
	end

	if ( self.Title:GetText() == "" ) then
		self:DisplayError( "You must provide a title!" )
		return
	end

	local workshopUpdateID = nil
	local updateButtonID, updateButton = self.AddonList:GetSelectedLine()
	if ( IsValid( updateButton ) ) then
		workshopUpdateID = updateButton.WorkshopID
	end

	-- Lock down the UI
	self.UpdateProgress:SetVisible( true )
	self:SetMouseInputEnabled( false )

	-- TODO: Display update progress?
	-- TODO: Confirmation dialog?

	-- Start the process
	local err = self.ugcHandler:FinishPublish( self.ugcFile, self.ugcImage, self.Title:GetText(), self.Description:GetText(), ChosenTag, {
		WorkshopID = workshopUpdateID,
		ChangeNotes = self.ChangeNotes:GetText(),
		Callback = function( wsid, erro ) self:OnPublishFinished( wsid, erro ) end
	} )
	if ( err ) then self:DisplayError( err ) end

end

vgui.Register( "UGCPublishWindow", PANEL, "DFrame" )
