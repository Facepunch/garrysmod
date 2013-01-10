
TOOL.Category		= "Constraints"
TOOL.Name			= "#tool.muscle.name"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "group" ] = "1"
TOOL.ClientConVar[ "width" ] = "2"
TOOL.ClientConVar[ "addlength" ] = "100"
TOOL.ClientConVar[ "fixed" ] = "1"
TOOL.ClientConVar[ "period" ] = "1"
TOOL.ClientConVar[ "material" ] = "cable/rope"
TOOL.ClientConVar[ "starton" ] = "0"

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
		
		if ( ( !self:GetEnt(1):IsValid() && !self:GetEnt(2):IsValid() ) || iNum > 1 ) then 

			self:ClearObjects()
			return true
			
		end
		
		-- Get client's CVars
		local width			= self:GetClientNumber( "width", 3 )
		local bind			= self:GetClientNumber( "group", 1 )
		local AddLength		= self:GetClientNumber( "addlength", 0 )
		local fixed			= self:GetClientNumber( "fixed", 1 )
		local period		= self:GetClientNumber( "period", 1 )
		local material		= self:GetClientInfo( "material" )
		local starton		= self:GetClientNumber( "starton" )
		
		-- If AddLength is 0 then what's the point.
		if ( AddLength == 0 ) then
			self:ClearObjects()
			return true 
		end
		
		if ( period <= 0 ) then period = 0.1 end
		
		AddLength = math.Clamp( AddLength, -1000, 1000 )
		
		-- Get information we're about to use
		local Ent1,  Ent2  = self:GetEnt(1),	 self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),	 self:GetBone(2)
		local LPos1, LPos2 = self:GetLocalPos(1),self:GetLocalPos(2)
		local WPos1, WPos2 = self:GetPos(1),     self:GetPos(2)

		local Length1 = (WPos1 - WPos2):Length()
		local Length2 = Length1 + AddLength	
		
		local amp = Length2 - Length1
	
		local constraint,rope,controller,slider = constraint.Muscle( self:GetOwner(), Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, bind, fixed, period, amp, starton, material )

		undo.Create("Muscle")
		if constraint then undo.AddEntity( constraint ) end
		if rope   then undo.AddEntity( rope ) end
		if slider then undo.AddEntity( slider ) end
		if controller then undo.AddEntity( controller ) end
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		if constraint then	self:GetOwner():AddCleanup( "ropeconstraints", constraint ) end
		if rope   then		self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
		if slider then		self:GetOwner():AddCleanup( "ropeconstraints", slider ) end
		if controller then	self:GetOwner():AddCleanup( "ropeconstraints", controller ) end
		
		-- Clear the objects so we're ready to go again
		self:ClearObjects()
		
	else
	
		self:SetStage( iNum+1 )
		
	end
	
	return true

end

function TOOL:RightClick( trace )

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
	self:SetObject( 2, tr.Entity, tr.HitPos, Phys2, tr.PhysicsBone, tr.HitNormal )
	
	if ( CLIENT ) then
		self:ClearObjects()
		return true
	end
	
	-- Get client's CVars
	local width			= self:GetClientNumber( "width", 3 )
	local bind			= self:GetClientNumber( "group", 1 )
	local AddLength		= self:GetClientNumber( "addlength", 0 )
	local fixed			= self:GetClientNumber( "fixed", 1 )
	local period		= self:GetClientNumber( "period", 64 )
	local material		= self:GetClientInfo( "material" )
	local starton		= self:GetClientNumber( "starton" )
	
	-- Get information we're about to use
	local Ent1,  Ent2  = self:GetEnt(1),	 self:GetEnt(2)
	local Bone1, Bone2 = self:GetBone(1),	 self:GetBone(2)
	local LPos1, LPos2 = self:GetLocalPos(1),self:GetLocalPos(2)
	local WPos1, WPos2 = self:GetPos(1),     self:GetPos(2)

	local Length1 = (WPos1 - WPos2):Length()
	local Length2 = Length1 + AddLength	

	local amp = Length2 - Length1

	local constraint,rope,controller,slider = constraint.Muscle( self:GetOwner(), Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, bind, fixed, period, amp, starton, material )

	undo.Create("Muscle")
	if constraint then undo.AddEntity( constraint ) end
	if rope   then undo.AddEntity( rope ) end
	if slider then undo.AddEntity( slider ) end
	if controller then undo.AddEntity( controller ) end
	undo.SetPlayer( self:GetOwner() )
	undo.Finish()

	if constraint then	self:GetOwner():AddCleanup( "ropeconstraints", constraint ) end
	if rope   then		self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
	if slider then		self:GetOwner():AddCleanup( "ropeconstraints", slider ) end
	if controller then	self:GetOwner():AddCleanup( "ropeconstraints", controller ) end

	-- Clear the objects so we're ready to go again
	self:ClearObjects()
	
	return true

end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Muscle" )
	return bool
	
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#tool.muscle.name", Description	= "#tool.muscle.help" }  )
	
	CPanel:AddControl( "ComboBox", { Label = "#tool.presets",
									 MenuButton = 1,
									 Folder = "muscle",
									 Options = { Default = { muscle_width = '2',	muscle_group='1',	muscle_addlength='100',		muscle_fixed='1',		muscle_period="1" } },
									 CVars =				{ "muscle_width",		"muscle_group",		"muscle_addlength",			"muscle_fixed",			"muscle_period", "muscle_material" } } )

	CPanel:AddControl( "Numpad",		{ Label = "#tool.muscle.numpad",	Command = "muscle_group" } )
	CPanel:AddControl( "Slider", 		{ Label = "#tool.muscle.length",	Type = "Float", 	Command = "muscle_addlength", 	Min = "-1000", 	Max = "1000", Help=true }  )
	CPanel:AddControl( "Slider", 		{ Label = "#tool.muscle.period",	Type = "Float", 	Command = "muscle_period", 	Min = "0", 	Max = "10", Help=true }  )
	CPanel:AddControl( "CheckBox",		{ Label = "#tool.muscle.fixed",		Command = "muscle_fixed", Help=true }  )
	CPanel:AddControl( "CheckBox",		{ Label = "#tool.muscle.starton",	Command = "muscle_starton", Help=true }  )

	CPanel:AddControl( "Slider", 		{ Label = "#tool.muscle.width",			Type = "Float", 	Command = "muscle_width", 	Min = "0", 	Max = "5" }  )
	CPanel:AddControl( "RopeMaterial", 	{ Label = "#tool.muscle.material",		convar	= "muscle_material" }  )

end