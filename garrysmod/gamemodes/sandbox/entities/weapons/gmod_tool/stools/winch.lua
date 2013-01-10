
TOOL.Category		= "Constraints"
TOOL.Name			= "#tool.winch.name"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "rope_material" ] = "cable/rope"
TOOL.ClientConVar[ "rope_width" ] = "3"
TOOL.ClientConVar[ "fwd_speed" ] = "64"
TOOL.ClientConVar[ "bwd_speed" ] = "64"
TOOL.ClientConVar[ "fwd_group" ] = "8"
TOOL.ClientConVar[ "bwd_group" ] = "5"

function TOOL:LeftClick( trace )

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local iNum = self:NumObjects()
	
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( iNum > 0 ) then
	
		if ( CLIENT ) then
			self:ClearObjects()
			return true
		end
		
		-- Get client's CVars
		local material		= self:GetClientInfo( "rope_material" ) or "cable/rope"
		local width		= self:GetClientNumber( "rope_width" )  or 3
		local fwd_bind		= self:GetClientNumber( "fwd_group" )  or 1
		local bwd_bind		= self:GetClientNumber( "bwd_group" ) or 1
		local fwd_speed		= self:GetClientNumber( "fwd_speed" ) or 64
		local bwd_speed		= self:GetClientNumber( "bwd_speed" ) or 64
		local toggle		= false

		-- Get information we're about to use
		local Ent1,  Ent2  = self:GetEnt(1),	 self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),	 self:GetBone(2)
		local LPos1, LPos2 = self:GetLocalPos(1),self:GetLocalPos(2)

		local constraint,rope,controller = constraint.Winch( self:GetOwner(), Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, fwd_bind, bwd_bind, fwd_speed, bwd_speed, material, toggle )

		undo.Create("Winch")
		if constraint then undo.AddEntity( constraint ) end
		if rope   then undo.AddEntity( rope ) end
		if controller then undo.AddEntity( controller ) end
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		
		if constraint then	self:GetOwner():AddCleanup( "ropeconstraints", constraint ) end
		if rope then		self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
		if controller then	self:GetOwner():AddCleanup( "ropeconstraints", controller ) end
		
		-- Clear the objects so we're ready to go again
		self:ClearObjects()
		
	else
	
		self:SetStage( iNum+1 )
		
	end
	
	return true

end

function TOOL:RightClick( trace )

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	local tr = {}
	tr.start = trace.HitPos
	tr.endpos = tr.start + (trace.HitNormal * 16384)
	tr.filter = {} 
	tr.filter[1] = self:GetOwner()
	if (trace.Entity:IsValid()) then
		tr.filter[2] = trace.Entity
	end
	
	local tr = util.TraceLine( tr )
		
	if ( !tr.Hit ) then
		self:ClearObjects()
		return
	end
	
	-- Don't try to constrain world to world
	if ( trace.HitWorld && tr.HitWorld ) then
		self:ClearObjects()
		return 
	end
	
	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then
		self:ClearObjects()
		return
	end
	if ( tr.Entity:IsValid() && tr.Entity:IsPlayer() ) then
		self:ClearObjects()
		return
	end

	local Phys2 = tr.Entity:GetPhysicsObjectNum( tr.PhysicsBone )
	self:SetObject( 2, tr.Entity, tr.HitPos, Phys2, tr.PhysicsBone, trace.HitNormal )
	
	if ( CLIENT ) then
		self:ClearObjects()
		return true
	end
	
	-- Get client's CVars
	local material		= self:GetClientInfo( "rope_material" ) or "cable/rope"
	local width			= self:GetClientNumber( "rope_width" ) or 3
	local fwd_bind		= self:GetClientNumber( "fwd_group" ) or 1
	local bwd_bind		= self:GetClientNumber( "bwd_group" ) or 1
	local fwd_speed		= self:GetClientNumber( "fwd_speed" ) or 64
	local bwd_speed		= self:GetClientNumber( "bwd_speed" ) or 64
		
	-- Get information we're about to use
	local Ent1,  Ent2  = self:GetEnt(1),	 self:GetEnt(2)
	local Bone1, Bone2 = self:GetBone(1),	 self:GetBone(2)
	local LPos1, LPos2 = self:GetLocalPos(1),self:GetLocalPos(2)

	local constraint,rope,controller = constraint.Winch( self:GetOwner(), Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, fwd_bind, bwd_bind, fwd_speed, bwd_speed, material )

	undo.Create("Winch")
	if constraint then undo.AddEntity( constraint ) end
	if rope   then undo.AddEntity( rope ) end
	if controller then undo.AddEntity( controller ) end
	undo.SetPlayer( self:GetOwner() )
	undo.Finish()
	
	if constraint then	self:GetOwner():AddCleanup( "ropeconstraints", constraint ) end
	if rope then		self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
	if controller then	self:GetOwner():AddCleanup( "ropeconstraints", controller ) end

	-- Clear the objects so we're ready to go again
	self:ClearObjects()
	
	return true
	
end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Winch" )
	return bool
	
end


function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#tool.winch.name", Description	= "#tool.winch.help" }  )
	
	CPanel:AddControl( "ComboBox", 
	{ 
		Label = "#tool.presets",
		MenuButton = 1,
		Folder = "winch",
		Options =	{ Default = {	winch_rope_width = '1',		winch_fwd_speed='64',	winch_bwd_speed='64',		winch_rope_rigid='0',		winch_rope_material='cable/cable' } },
		CVars =		{				"winch_rope_width",			"winch_fwd_speed",		"winch_bwd_speed",			"winch_rope_rigid",			"winch_rope_material" } 
	})

	CPanel:AddControl( "Numpad",		{ Label = "#tool.winch.forward",	Command = "winch_fwd_group", Label2 = "#tool.winch.backward",	Command2 = "winch_bwd_group" } )
	
	CPanel:AddControl( "Slider", 		{ Label = "#tool.winch.fspeed",		Type = "Float", 	Command = "winch_fwd_speed", 	Min = "0", 	Max = "1000", Help=true }  )
	CPanel:AddControl( "Slider", 		{ Label = "#tool.winch.bspeed",		Type = "Float", 	Command = "winch_bwd_speed", 	Min = "0", 	Max = "1000", Help=true }  )

	CPanel:AddControl( "Slider", 		{ Label = "#tool.winch.width",		Type = "Float", 	Command = "winch_rope_width", 		Min = "0", 	Max = "10" }  )
	CPanel:AddControl( "RopeMaterial", 	{ Label = "#tool.winch.material",	convar	= "winch_rope_material" }  )
									
end