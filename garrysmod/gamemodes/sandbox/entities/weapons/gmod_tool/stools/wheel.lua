
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.wheel.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar[ "torque" ] 		= "3000"
TOOL.ClientConVar[ "friction" ] 	= "1"
TOOL.ClientConVar[ "nocollide" ] 	= "1"
TOOL.ClientConVar[ "forcelimit" ] 	= "0"
TOOL.ClientConVar[ "fwd" ] 			= "8"	-- Forward key
TOOL.ClientConVar[ "bck" ] 			= "5"	-- Back key
TOOL.ClientConVar[ "toggle" ] 		= "0"	-- Togglable
TOOL.ClientConVar[ "model" ] 		= "models/props_vehicles/carparts_wheel01a.mdl"
TOOL.ClientConVar[ "rx" ] 			= "90"
TOOL.ClientConVar[ "ry" ] 			= "0"
TOOL.ClientConVar[ "rz" ] 			= "90"

cleanup.Register( "wheels" )

--[[---------------------------------------------------------
   Places a wheel
-----------------------------------------------------------]]
function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()

	if ( !self:GetSWEP():CheckLimit( "wheels" ) ) then return false end

	local targetPhys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	
	-- Get client's CVars
	local torque		= self:GetClientNumber( "torque" )
	local friction 		= self:GetClientNumber( "friction" )
	local nocollide		= self:GetClientNumber( "nocollide" )
	local limit			= self:GetClientNumber( "forcelimit" )
	local toggle		= self:GetClientNumber( "toggle" ) != 0
	local model			= self:GetClientInfo( "model" )
	
	local fwd			= self:GetClientNumber( "fwd" )
	local bck			= self:GetClientNumber( "bck" )
	
	if ( !util.IsValidModel( model ) ) then return false end
	if ( !util.IsValidProp( model ) ) then return false end

	-- Create the wheel
	local wheelEnt = MakeWheel( ply, trace.HitPos, Angle(0,0,0), model, fwd, bck, nil, nil, toggle, torque )
	
	-- Make sure we have our wheel angle
	self.wheelAngle = Angle( tonumber(self:GetClientInfo( "rx" )), tonumber(self:GetClientInfo( "ry" )), tonumber(self:GetClientInfo( "rz" )) )
	
	local TargetAngle = trace.HitNormal:Angle() + self.wheelAngle	
	wheelEnt:SetAngles( TargetAngle )
	
	local CurPos = wheelEnt:GetPos()
	local NearestPoint = wheelEnt:NearestPoint( CurPos - (trace.HitNormal * 512) )
	local wheelOffset = CurPos - NearestPoint
		
	wheelEnt:SetPos( trace.HitPos + wheelOffset + trace.HitNormal )
	
	-- Wake up the physics object so that the entity updates
	wheelEnt:GetPhysicsObject():Wake()
	
	local TargetPos = wheelEnt:GetPos()
			
	-- Set the hinge Axis perpendicular to the trace hit surface
	local LPos1 = wheelEnt:GetPhysicsObject():WorldToLocal( TargetPos + trace.HitNormal )
	local LPos2 = targetPhys:WorldToLocal( trace.HitPos )
	
	local constraint, axis = constraint.Motor( wheelEnt, trace.Entity, 0, trace.PhysicsBone, LPos1,	LPos2, friction, torque, 0, nocollide, toggle, ply, limit )
	
	undo.Create("Wheel")
	undo.AddEntity( axis )
	undo.AddEntity( constraint )
	undo.AddEntity( wheelEnt )
	undo.SetPlayer( ply )
	undo.Finish()

	ply:AddCleanup( "wheels", axis )
	ply:AddCleanup( "wheels", constraint )
	ply:AddCleanup( "wheels", wheelEnt )
	
	wheelEnt:SetMotor( constraint )
	wheelEnt:SetDirection( constraint.direction )
	wheelEnt:SetAxis( trace.HitNormal )
	wheelEnt:SetToggle( toggle )
	wheelEnt:DoDirectionEffect()
	wheelEnt:SetBaseTorque( torque )

	return true

end


--[[---------------------------------------------------------
   Apply new values to the wheel
-----------------------------------------------------------]]
function TOOL:RightClick( trace )

	if ( trace.Entity && trace.Entity:GetClass() != "gmod_wheel" ) then return false end
	if (CLIENT) then return true end
	
	local wheelEnt = trace.Entity
	
	-- Only change your own wheels..
	if ( wheelEnt:GetPlayer():IsValid() && 
	     wheelEnt:GetPlayer() != self:GetOwner() ) then 
		 
		 return false 
		 
	end

	-- Get client's CVars
	local torque		= self:GetClientNumber( "torque" )
	local toggle		= self:GetClientNumber( "toggle" ) != 0
	local fwd			= self:GetClientNumber( "fwd" )
	local bck			= self:GetClientNumber( "bck" )
		
	wheelEnt.BaseTorque = torque
	wheelEnt:SetTorque( torque )
	wheelEnt:SetToggle( toggle )
	
	-- Make sure the table exists!
	wheelEnt.KeyBinds = wheelEnt.KeyBinds or {}
	
	wheelEnt.key_f = fwd
	wheelEnt.key_r = bck
	
	-- Remove old binds
	numpad.Remove( wheelEnt.KeyBinds[1] )
	numpad.Remove( wheelEnt.KeyBinds[2] )
	numpad.Remove( wheelEnt.KeyBinds[3] )
	numpad.Remove( wheelEnt.KeyBinds[4] )
	
	-- Add new binds
	wheelEnt.KeyBinds[1] = numpad.OnDown( 	self:GetOwner(), 	fwd, 	"WheelForward", 	wheelEnt, 	true )
	wheelEnt.KeyBinds[2] = numpad.OnUp( 		self:GetOwner(), 	fwd, 	"WheelForward", 	wheelEnt, 	false )
	wheelEnt.KeyBinds[3] = numpad.OnDown( 	self:GetOwner(), 	bck, 	"WheelReverse", 	wheelEnt, 	true )
	wheelEnt.KeyBinds[4] = numpad.OnUp( 		self:GetOwner(), 	bck, 	"WheelReverse", 	wheelEnt, 	false )
	
	return true

end

if ( SERVER ) then

	--[[---------------------------------------------------------
	   For duplicator, creates the wheel.
	-----------------------------------------------------------]]
	function MakeWheel( pl, Pos, Ang, Model, key_f, key_r, axis, direction, toggle, BaseTorque, Data )

		if ( IsValid( pl ) ) then
			if ( !pl:CheckLimit( "wheels" ) ) then return false end
		end
	
		local wheel = ents.Create( "gmod_wheel" )
		if ( !wheel:IsValid() ) then return end
		
		wheel:SetModel( Model )
		wheel:SetPos( Pos )
		wheel:SetAngles( Ang )
		wheel:Spawn()
		
		wheel:SetPlayer( pl )

		duplicator.DoGenericPhysics( wheel, pl, Data )
	
		wheel.key_f = key_f
		wheel.key_r = key_r
		
		if ( axis ) then
			wheel.Axis = axis
		end
		
		direction = direction or 1
		wheel:SetDirection( direction )
		
		toggle = toggle or false
		wheel:SetToggle( toggle )
		
		wheel:SetBaseTorque( BaseTorque )
		wheel:UpdateOverlayText()
		
		wheel.KeyBinds = {}
		
		-- Bind to keypad
		wheel.KeyBinds[1] = numpad.OnDown( 	pl, 	key_f, 	"WheelForward", 	wheel, 	true )
		wheel.KeyBinds[2] = numpad.OnUp( 	pl, 	key_f, 	"WheelForward", 	wheel, 	false )
		wheel.KeyBinds[3] = numpad.OnDown( 	pl, 	key_r, 	"WheelReverse", 	wheel, 	true )
		wheel.KeyBinds[4] = numpad.OnUp( 	pl, 	key_r, 	"WheelReverse", 	wheel, 	false )

		if ( IsValid( pl ) ) then

			pl:AddCount( "wheels", wheel )

		end
		
		return wheel
		
	end

	duplicator.RegisterEntityClass( "gmod_wheel", MakeWheel, "Pos", "Ang", "Model", "key_f", "key_r", "Axis", "Direction", "Toggle", "BaseTorque", "Data" )

end

function TOOL:UpdateGhostWheel( ent, player )

	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end
	
	local tr 	= util.GetPlayerTrace( player )
	local trace 	= util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	if ( trace.Entity:IsPlayer() ) then
	
		ent:SetNoDraw( true )
		return
		
	end
	
	local Ang = trace.HitNormal:Angle() + self.wheelAngle
	local CurPos = ent:GetPos()
	local NearestPoint = ent:NearestPoint( CurPos - (trace.HitNormal * 512) )
	local WheelOffset = CurPos - NearestPoint
	
	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos + trace.HitNormal + WheelOffset )
	ent:SetAngles( Ang )
	
	ent:SetNoDraw( false )
	
end

--[[---------------------------------------------------------
   Maintains the ghost wheel
-----------------------------------------------------------]]
function TOOL:Think()

	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self:GetClientInfo( "model" )) then
		self.wheelAngle = Angle( tonumber(self:GetClientInfo( "rx" )), tonumber(self:GetClientInfo( "ry" )), tonumber(self:GetClientInfo( "rz" )) )
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector(0,0,0), Angle(0,0,0) )
	end
	
	self:UpdateGhostWheel( self.GhostEntity, self:GetOwner() )
	
end



function TOOL.BuildCPanel( CPanel )

	-- HEADER
	CPanel:AddControl( "Header", { Text = "#tool.wheel.name", Description	= "#tool.wheel.desc" }  )
	
	local Options = { Default = { wheel_torque = "3000",
									wheel_friction = "0",
									wheel_nocollide = "1",
									wheel_forcelimit = "0" } }
									
	local CVars = { "wheel_torque", "wheel_friction", "wheel_nocollide", "wheel_forcelimit" }
	
	CPanel:AddControl( "ComboBox", { Label = "#tool.presets",
									 MenuButton = 1,
									 Folder = "wheel",
									 Options = Options,
									 CVars = CVars } )
									 
									 
	CPanel:AddControl( "Numpad", { Label = "#tool.wheel.forward",
									 Label2 = "#tool.wheel.reverse",
									 Command = "wheel_fwd",
									 Command2 = "wheel_bck",
									 ButtonSize = "22" } )
									 
	CPanel:AddControl( "PropSelect", { Label = "#tool.wheel.model",
									 ConVar = "wheel_model",
									 Category = "Wheels",
									 Height = 6,
									 Models = list.Get( "WheelModels" ) } )
									 
	CPanel:AddControl( "Slider", { Label = "#tool.wheel.torque",
									 Type = "Float",
									 Min = 10,
									 Max = 10000,
									 Command = "wheel_torque" } )
									 
									 
	CPanel:AddControl( "Slider", { Label = "#tool.wheel.forcelimit",
									 Type = "Float",
									 Min = 0,
									 Max = 50000,
									 Command = "wheel_forcelimit" } )
									 
	CPanel:AddControl( "Slider", { Label = "#tool.wheel.friction",
									 Type = "Float",
									 Min = 0,
									 Max = 100,
									 Command = "wheel_friction" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#tool.wheel.nocollide",
									 Command = "wheel_nocollide" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#tool.wheel.toggle",
									 Description = "#WheelTool_toggle_desc",
									 Command = "wheel_toggle" } )
									
end

list.Set( "WheelModels", "models/props_junk/sawblade001a.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_vehicles/carparts_wheel01a.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 90} )
list.Set( "WheelModels", "models/props_vehicles/apc_tire001.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_vehicles/tire001a_tractor.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_vehicles/tire001b_truck.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_vehicles/tire001c_car.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_wasteland/controlroom_filecabinet002a.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_borealis/bluebarrel001.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_c17/oildrum001.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_c17/playground_carousel01.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_c17/chair_office01a.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_c17/TrapPropeller_Blade.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_wasteland/wheel01.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 90} )
list.Set( "WheelModels", "models/props_trainstation/trainstation_clock001.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_junk/metal_paintcan001a.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_c17/pulleywheels_large01.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )

list.Set( "WheelModels", "models/props_phx/oildrum001_explosive.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/breakable_tire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gibs/tire1_gib.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/normal_tire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/mechanics/medgear.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/mechanics/biggear.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel9.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel90_24.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel12.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel24.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel36.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur9.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur12.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur24.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur36.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/smallwheel.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/747wheel.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/trucktire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/trucktire2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/metal_wheel1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/metal_wheel2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/wooden_wheel1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/wooden_wheel2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/metal_plate_curve360.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/metal_plate_curve360x2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/wood/wood_curve360x1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/wood/wood_curve360x2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/windows/window_curve360x1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/windows/window_curve360x2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/wheel_medium.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/medium_wheel_2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/double_wheels.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/double_wheels2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/drugster_back.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/drugster_front.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/monster_truck.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/propeller2x_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/propeller3x_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/paddle_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/paddle_small2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_small_base.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_medium.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_med_base.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_large.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_large_base.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/moped_tire.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )

--Tile Model Pack Wheels

list.Set( "WheelModels", "models/hunter/misc/cone1x05.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/hunter/tubes/circle2x2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/hunter/tubes/circle4x4.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )

--Primitive Mechanics

list.Set( "WheelModels", "models/mechanics/wheels/bmw.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/bmwl.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/rim_1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/tractor.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_2l.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_extruded_48.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_race.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_smooth2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_12t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_18t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_24t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_36t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_48t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_60t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_12t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_18t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_24t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_36t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )

--XQM Model Pack Wheels

list.Set( "WheelModels", "models/NatesWheel/nateswheel.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/NatesWheel/nateswheelwide.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropeller.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerMedium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerBig.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerHuge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerLarge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotor.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorMedium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorBig.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorHuge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorLarge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Medium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Big.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Huge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Large.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Medium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Big.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Huge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Large.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )

--Xeon133's Wheels

list.Set( "WheelModels", "models/xeon133/offroad/Off-road-20.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-30.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-40.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-50.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-60.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-70.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-80.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )

