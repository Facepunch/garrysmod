
AddCSLuaFile()

properties.Add( "bone_manipulate", {
	MenuLabel = "#edit_bones",
	Order = 500,
	MenuIcon = "icon16/vector.png",

	Filter = function( self, ent, ply )

		if ( !gamemode.Call( "CanProperty", ply, "bonemanipulate", ent ) ) then return false end
		if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end -- If our ent has an attached entity, we want to use and modify its bones instead

		local bonecount = ent:GetBoneCount()
		if ( bonecount <= 1 ) then return false end

		return ents.FindByClassAndParent( "widget_bones", ent ) == nil

	end,

	Action = function( self, ent )

		if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )

		local ent = net.ReadEntity()
		if ( !IsValid( ent ) ) then return end
		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

		ent.widget = ents.Create( "widget_bones" )
		ent.widget:Setup( ent )
		ent.widget:Spawn()
		ent.widget.LastBonePress = 0
		ent.widget.BonePressCount = 0

		-- What happens when we click on a bone?
		ent.widget.OnBoneClick = function( w, boneid, pl )

			-- If we have an old axis, remove it
			if ( IsValid( w.axis ) ) then w.axis:Remove() end

			-- We clicked on the same bone
			if ( w.LastBonePress == boneid ) then
				w.BonePressCount = w.BonePressCount + 1
				if ( w.BonePressCount >= 3 ) then w.BonePressCount = 0 end
			-- We clicked on a new bone!
			else
				w.BonePressCount = 0
				w.LastBonePress = boneid
			end

			local EntityCycle = { "widget_bonemanip_move", "widget_bonemanip_rotate", "widget_bonemanip_scale" }

			w.axis = ents.Create( EntityCycle[ w.BonePressCount + 1 ] )
			w.axis:Setup( ent, boneid, w.BonePressCount == 1 )
			w.axis:Spawn()
			w.axis:SetPriority( 0.5 )
			w:DeleteOnRemove( w.axis )

		end
	end

} )

properties.Add( "bone_manipulate_end", {
	MenuLabel = "#stop_editing_bones",
	Order = 500,
	MenuIcon = "icon16/vector_delete.png",

	Filter = function( self, ent )

		if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end -- If our ent has an attached entity, we want to use and modify its bones instead

		return ents.FindByClassAndParent( "widget_bones", ent ) != nil

	end,

	Action = function( self, ent )

		if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )

		local ent = net.ReadEntity()
		if ( !IsValid( ent ) ) then return end
		if ( !IsValid( ent.widget ) ) then return end

		ent.widget:Remove()

	end
} )

local widget_bonemanip_move = {
	Base = "widget_axis",

	OnArrowDragged = function( self, num, dist, pl, mv )

		-- Prediction doesn't work properly yet.. because of the confusion with the bone moving, and the parenting, Agh.
		if ( CLIENT ) then return end

		local ent = self:GetParent()
		if ( !IsValid( ent ) ) then return end

		local bone = self:GetParentAttachment()
		if ( bone <= 0 ) then return end

		local v = Vector( 0, 0, 0 )

		if ( num == 1 ) then v.x = dist end
		if ( num == 2 ) then v.y = dist end
		if ( num == 3 ) then v.z = dist end

		ent:ManipulateBonePosition( bone, ent:GetManipulateBonePosition( bone ) + v )

	end,

	--
	-- Although we use the position from our bone, we want to use the angles from the
	-- parent bone - because that's the direction our bone goes
	--
	CalcAbsolutePosition = function( self, v, a )

		local ent = self:GetParent()
		if ( !IsValid( ent ) ) then return end

		local bone = ent:GetBoneParent( self:GetParentAttachment() )
		if ( bone <= 0 ) then return end

		local _, ang = ent:GetBonePosition( bone )
		local pos, _ = ent:GetBonePosition( self:GetParentAttachment() )
		return pos, ang

	end
}

scripted_ents.Register( widget_bonemanip_move, "widget_bonemanip_move" )

local widget_bonemanip_rotate = {
	Base = "widget_axis",

	OnArrowDragged = function( self, num, dist, pl, mv )

		-- Prediction doesn't work properly yet.. because of the confusion with the bone moving, and the parenting, Agh.
		if ( CLIENT ) then return end

		local ent = self:GetParent()
		if ( !IsValid( ent ) ) then return end

		local bone = self:GetParentAttachment()
		if ( bone <= 0 ) then return end

		local v = Angle( 0, 0, 0 )

		if ( num == 2 ) then v.x = dist end
		if ( num == 3 ) then v.y = dist end
		if ( num == 1 ) then v.z = dist end

		ent:ManipulateBoneAngles( bone, ent:GetManipulateBoneAngles( bone ) + v )

	end
}
scripted_ents.Register( widget_bonemanip_rotate, "widget_bonemanip_rotate" )

local widget_bonemanip_scale = {
	Base = "widget_axis",
	IsScaleArrow = true,

	OnArrowDragged = function( self, num, dist, pl, mv )

		-- Prediction doesn't work properly yet.. because of the confusion with the bone moving, and the parenting, Agh.
		if ( CLIENT ) then return end

		local ent = self:GetParent()
		if ( !IsValid( ent ) ) then return end

		local bone = self:GetParentAttachment()
		if ( bone <= 0 ) then return end

		local v = Vector( 0, 0, 0 )

		if ( num == 1 ) then v.x = dist end
		if ( num == 2 ) then v.y = dist end
		if ( num == 3 ) then v.z = dist end

		ent:ManipulateBoneScale( bone, ent:GetManipulateBoneScale( bone ) + v * 0.1 )
		ent:ManipulateBoneScale( ent:GetBoneParent( bone ), ent:GetManipulateBoneScale( ent:GetBoneParent( bone ) ) + v )

	end,

	--
	-- Although we use the position from our bone, we want to use the angles from the
	-- parent bone - because that's the direction our bone goes
	--
	CalcAbsolutePosition = function( self, v, a )

		local ent = self:GetParent()
		if ( !IsValid( ent ) ) then return end

		local bone = self:GetParentAttachment()
		if ( bone <= 0 ) then return end

		local pbone = ent:GetBoneParent( bone )
		if ( pbone <= 0 ) then return end

		local pos, ang = ent:GetBonePosition( bone )
		local pos2, _ = ent:GetBonePosition( pbone )

		return pos + ( pos2 - pos ) * 0.5, ang

	end
}
scripted_ents.Register( widget_bonemanip_scale, "widget_bonemanip_scale" )
