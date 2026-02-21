
AddCSLuaFile()

properties.Add( "skin", {
	MenuLabel = "#skin",
	Order = 601,
	MenuIcon = "icon16/picture_edit.png",

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "skin", ent ) ) then return false end
		if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end  -- If our ent has an attached entity, we want to modify its skin instead
		if ( !ent:SkinCount() ) then return false end

		return ent:SkinCount() > 1

	end,

	MenuOpen = function( self, option, ent, tr )

		--
		-- Add a submenu to our automatically created menu option
		--
		local submenu = option:AddSubMenu()

		--
		-- Create a check item for each skin
		--
		local target = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent

		local num = target:SkinCount()

		for i = 0, num - 1 do

			local opt = submenu:AddOption( "Skin " .. i )
			opt:SetRadio( true )
			opt:SetChecked( target:GetSkin() == i )
			opt:SetIsCheckable( true )
			opt.OnChecked = function( s, checked ) if ( checked ) then self:SetSkin( ent, i ) end end

		end

	end,

	Action = function( self, ent )

		-- Nothing - we use SetSkin below

	end,

	SetSkin = function( self, ent, id )

		self:MsgStart()
			net.WriteEntity( ent )
			net.WriteUInt( id, 8 )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )

		local ent = net.ReadEntity()
		local skinid = net.ReadUInt( 8 )

		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

		ent = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent
		ent:SetSkin( skinid )

	end

} )
