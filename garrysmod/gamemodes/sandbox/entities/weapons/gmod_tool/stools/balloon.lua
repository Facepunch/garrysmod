
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.balloon.name"

TOOL.ClientConVar[ "ropelength" ]	= "64"
TOOL.ClientConVar[ "force" ]		= "500"
TOOL.ClientConVar[ "r" ]			= "255"
TOOL.ClientConVar[ "g" ]			= "255"
TOOL.ClientConVar[ "b" ]			= "0"
TOOL.ClientConVar[ "model" ]		= "models/MaxOfS2D/balloon_classic.mdl"

cleanup.Register( "balloons" )

function TOOL:LeftClick( trace, attach )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	--
	-- Right click calls this with attach = false
	--
	if ( attach == nil ) then 
		attach = true 
	end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && attach && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then 
		return false 
	end
	
	local ply = self:GetOwner()
	local length 			= self:GetClientNumber( "ropelength", 64 )
	local material 			= "cable/rope"
	local force 			= self:GetClientNumber( "force", 500 )
	local r 				= self:GetClientNumber( "r", 255 )
	local g 				= self:GetClientNumber( "g", 0 )
	local b 				= self:GetClientNumber( "b", 0 )
	local model 			= self:GetClientInfo( "model" )

	local modeltable		= list.Get( "BalloonModels" )[model]

	--
	-- Model is a table index on BalloonModels
	-- If the model isn't defined then it can't be spawned.
	--
	if ( !modeltable ) then return false end

	--
	-- The model table can disable colouring for its model
	--
	if ( modeltable.nocolor ) then
		r = 255
		g = 255
		b = 255
	end

	--
	-- Clicked on a balloon - modify the force/color/whatever
	--
	if	( IsValid( trace.Entity) && trace.Entity:GetClass() == "gmod_balloon" && trace.Entity.Player == ply )then

		local force 	= self:GetClientNumber( "force", 500 )
		trace.Entity:GetPhysicsObject():Wake()
		trace.Entity:SetColor( Color( r, g, b, 255 ) )
		trace.Entity:SetForce( force )
		trace.Entity.force = force
		return true

	end

	--
	-- Hit the balloon limit, bail
	--
	if ( !self:GetSWEP():CheckLimit( "balloons" ) ) then return false end

	local Pos = trace.HitPos + trace.HitNormal * 10
	local balloon = MakeBalloon( ply, r, g, b, force, { Pos = Pos, Model = modeltable.model, Skin = modeltable.skin } )

	undo.Create("Balloon")
	undo.AddEntity( balloon )

	if ( attach ) then
	
		-- The real model should have an attachment!
		local attachpoint = Pos + Vector( 0, 0, 0 )
			
		local LPos1 = balloon:WorldToLocal( attachpoint )
		local LPos2 = trace.Entity:WorldToLocal( trace.HitPos )
		
		if ( IsValid( trace.Entity) ) then
			
			local phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
			if ( IsValid( phys ) ) then LPos2 = phys:WorldToLocal( trace.HitPos ) end
		
		end
		
		local constraint, rope = constraint.Rope( balloon, trace.Entity, 0, trace.PhysicsBone, LPos1, LPos2, 0, length, 0, 0.5, material, nil )

		undo.AddEntity( rope )
		undo.AddEntity( constraint )
		ply:AddCleanup( "balloons", rope )
		ply:AddCleanup( "balloons", constraint )

	end
	
	undo.SetPlayer( ply )
	undo.Finish()
	
	ply:AddCleanup( "balloons", balloon )

	return true

end

function TOOL:RightClick( trace )

	return self:LeftClick( trace, false )

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#tool.balloon.name", Description	= "#tool.balloon.help" }  )
	
	CPanel:AddControl( "ComboBox", { Label = "#tool.presets",
									 MenuButton = 1,
									 Folder = "balloon",
									 CVars = { "balloon_ropelength", "balloon_force", "balloon_r", "balloon_g", "balloon_b", "balloon_skin" } } )

	CPanel:AddControl( "Slider", 	{ Label = "#tool.balloon.ropelength", Type = "Float", 	Command = "balloon_ropelength", 	Min = "5", 	Max = "1000" }  )
	CPanel:AddControl( "Slider", 	{ Label = "#tool.balloon.force", Type = "Float", 	Command = "balloon_force", 	Min = "-1000", 	Max = "2000", Help = true }  )
	CPanel:AddControl( "Color", { Label = "#tool.balloon.color", Red = "balloon_r", Green = "balloon_g", Blue = "balloon_b", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1" }  )			

	CPanel:AddControl( "PropSelect", { Label = "#tool.balloon.model",
										ConVar = "balloon_model",
										Height = 6,
										ModelsTable = list.Get( "BalloonModels" ) } )
						
end

function MakeBalloon( pl, r, g, b, force, Data )

	if ( IsValid( pl ) && !pl:CheckLimit( "balloons" ) ) then return nil end

	local balloon = ents.Create( "gmod_balloon" )

		if ( !balloon:IsValid() ) then return end

		duplicator.DoGeneric( balloon, Data )

	balloon:Spawn()

	duplicator.DoGenericPhysics( balloon, pl, Data )

	balloon:SetRenderMode( RENDERMODE_TRANSALPHA )
	balloon:SetColor( Color( r, g, b, 255 ) )
	balloon:SetForce( force )
	balloon:SetPlayer( pl )

	balloon:SetMaterial( skin )
	
	balloon.Player = pl
	balloon.r = r
	balloon.g = g
	balloon.b = b
	balloon.force = force
	
	if ( IsValid( pl ) ) then
		pl:AddCount( "balloons", balloon )
	end
	
	return balloon

end

duplicator.RegisterEntityClass( "gmod_balloon", MakeBalloon, "r", "g", "b", "force", "Data" )


list.Set( "BalloonModels", "normal", 
{ 
	model = "models/MaxOfS2D/balloon_classic.mdl", 
	skin = 0,
})

list.Set( "BalloonModels", "normal_skin1", 
{ 
	model = "models/MaxOfS2D/balloon_classic.mdl", 
	skin = 1,
})

list.Set( "BalloonModels", "normal_skin2", 
{ 
	model = "models/MaxOfS2D/balloon_classic.mdl", 
	skin = 2,
})

list.Set( "BalloonModels", "normal_skin3", 
{ 
	model = "models/MaxOfS2D/balloon_classic.mdl", 
	skin = 3,
})

list.Set( "BalloonModels", "gman", 
{ 
	model = "models/MaxOfS2D/balloon_gman.mdl",
	nocolor = true,
})

list.Set( "BalloonModels", "mossman", 
{ 
	model = "models/MaxOfS2D/balloon_mossman.mdl", 
	nocolor = true,	
})