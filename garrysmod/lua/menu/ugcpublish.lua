
concommand.Add( "test", function() include("menu/ugcpublish.lua") end )

local PANEL = {}

function PANEL:Init()
	self:SetTitle( "#ugc_upload.frametitle" )
	self:SetBackgroundBlur( true ) -- Indicate that the background elements won't be usable

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

	self.Publish = self:Add( "DButton" )
	self.Publish:Dock( TOP )
	self.Publish:SetEnabled( false )
	self.Publish:SetText( "#ugc_upload.publish" )
	self.Publish:DockMargin( 0, 5, 0, 0 )
	self.Publish.DoClick = function( s ) self:DoPublish() end
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
				for k, v in pairs( s:GetParent():GetChildren() ) do
					if ( v:GetChecked() ) then num = num + 1 end
					if ( v == s || !val ) then continue end
					v:SetValue( false ) -- Validate that only 1 is selected
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

	-- Set the window height to nicely fit everything, no extra space anywhere
	self:InvalidateLayout( true )
	self:SizeToChildren( false, true )
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

function PANEL:DoPublish()
	local ChosenTag = self:GetChosenTag()

	if ( self.TagsPerType[ self.ugcType ] && ChosenTag == nil ) then
		Derma_Message( "You must choose a tag!", "Error!", "OK" )
		return
	end

	if ( self.Title:GetText() == "" ) then
		Derma_Message( "You must provide a title!", "Error!", "OK" )
		return
	end

	local err = self.ugcHandler:FinishPublish( self.ugcFile, self.ugcImage, self.Title:GetText(), self.Description:GetText(), ChosenTag )
	if ( err ) then
		Derma_Message( err, "Error!", "OK" )
		return
	end

	self:Remove()

end

vgui.Register( "UGCPublishWindow", PANEL, "DFrame" )
