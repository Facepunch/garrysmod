
AddCSLuaFile()

properties.Add( "bodygroups", {
	MenuLabel = "#bodygroups",
	Order = 600,
	MenuIcon = "icon16/link_edit.png",

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "bodygroups", ent ) ) then return false end
		if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end  -- If our ent has an attached entity, we want to use and modify its bodygroups instead

		--
		-- Get a list of bodygroups
		--
		local options = ent:GetBodyGroups()
		if ( !options ) then return false end

		--
		-- If a bodygroup has more than one state - then we can configure it
		--
		for k, v in pairs( options ) do
			if ( v.num > 1 ) then return true end
		end

		return false

	end,

	MenuOpen = function( self, option, ent, tr )

		local target = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent

		--
		-- Get a list of bodygroups
		--
		local options = target:GetBodyGroups()

		--
		-- Add a submenu to our automatically created menu option
		--
		local submenu = option:AddSubMenu()

		--
		-- For each body group - add a menu or checkbox
		--
		for k, v in pairs( options ) do

			if ( v.num <= 1 ) then continue end

			--
			-- If there's only 2 options, add it as a checkbox instead of a submenu
			--
			if ( v.num == 2 ) then

				local current = target:GetBodygroup( v.id )
				local opposite = 1
				if ( current == opposite ) then opposite = 0 end

				local opt = submenu:AddOption( string.NiceName( v.name ) )
				opt:SetChecked( current == 1 )
				opt:SetIsCheckable( true )
				opt.OnChecked = function( s, checked ) self:SetBodyGroup( ent, v.id, checked and 1 or 0 ) end

			--
			-- More than 2 options we add our own submenu
			--
			else

				local groups = submenu:AddSubMenu( string.NiceName( v.name ) )

				for i = 1, v.num do
					local modelname = "Model #" .. i
					if ( v.submodels and v.submodels[ i - 1 ] != "" ) then modelname = v.submodels[ i - 1 ] end
					modelname = string.Trim( modelname, "." )
					modelname = string.Trim( modelname, "/" )
					modelname = string.Trim( modelname, "\\" )
					modelname = string.StripExtension( modelname )
					modelname = string.GetFileFromFilename( modelname )
				
					local opt = groups:AddOption( string.NiceName( modelname ) )
					opt:SetRadio( true )
					opt:SetChecked( target:GetBodygroup( v.id ) == i - 1 )
					opt:SetIsCheckable( true )
					opt.OnChecked = function( s, checked ) if ( checked ) then self:SetBodyGroup( ent, v.id, i - 1 ) end end
				end

			end

		end

	end,

	Action = function( self, ent )

		-- Nothing - we use SetBodyGroup below

	end,

	SetBodyGroup = function( self, ent, body, id )

		self:MsgStart()
			net.WriteEntity( ent )
			net.WriteUInt( body, 8 )
			net.WriteUInt( id, 8 )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )

		local ent = net.ReadEntity()
		local body = net.ReadUInt( 8 )
		local id = net.ReadUInt( 8 )

		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

		ent = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent

		ent:SetBodygroup( body, id )

	end

} )
