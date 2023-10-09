
TOOL.Category = "Construction"
TOOL.Name = "#tool.wheel.name"

TOOL.ClientConVar[ "torque" ] = "3000"
TOOL.ClientConVar[ "friction" ] = "1"
TOOL.ClientConVar[ "nocollide" ] = "1"
TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "fwd" ] = "45"
TOOL.ClientConVar[ "bck" ] = "42"
TOOL.ClientConVar[ "toggle" ] = "0"
TOOL.ClientConVar[ "model" ] = "models/props_vehicles/carparts_wheel01a.mdl"
TOOL.ClientConVar[ "rx" ] = "90"
TOOL.ClientConVar[ "ry" ] = "0"
TOOL.ClientConVar[ "rz" ] = "90"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "use" }
}

cleanup.Register( "wheels" )

local function IsValidWheelModel( model )
	for mdl, _ in pairs( list.Get( "WheelModels" ) ) do
		if ( mdl:lower() == model:lower() ) then return true end
	end
	return false
end

-- Places a wheel
function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	if ( CLIENT ) then return true end

	if ( !self:GetSWEP():CheckLimit( "wheels" ) ) then return false end

	-- Check the model's validity
	local model = self:GetClientInfo( "model" )
	if ( !util.IsValidModel( model ) || !util.IsValidProp( model ) || !IsValidWheelModel( model ) ) then return false end

	-- Get client's CVars
	local torque = self:GetClientNumber( "torque" )
	local friction = self:GetClientNumber( "friction" )
	local nocollide = self:GetClientNumber( "nocollide" )
	local limit = self:GetClientNumber( "forcelimit" )
	local toggle = self:GetClientNumber( "toggle" ) != 0

	local fwd = self:GetClientNumber( "fwd" )
	local bck = self:GetClientNumber( "bck" )

	local ply = self:GetOwner()

	-- Make sure we have our wheel angle
	self.wheelAngle = Angle( math.NormalizeAngle( self:GetClientNumber( "rx" ) ), math.NormalizeAngle( self:GetClientNumber( "ry" ) ), math.NormalizeAngle( self:GetClientNumber( "rz" ) ) )

	-- Create the wheel
	local wheelEnt = MakeWheel( ply, trace.HitPos, trace.HitNormal:Angle() + self.wheelAngle, model, fwd, bck, nil, nil, toggle, torque )
	if ( !IsValid( wheelEnt ) ) then return false end

	-- Position
	local CurPos = wheelEnt:GetPos()
	local NearestPoint = wheelEnt:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local wheelOffset = CurPos - NearestPoint

	wheelEnt:SetPos( trace.HitPos + wheelOffset )

	-- Wake up the physics object so that the entity updates
	if ( IsValid( wheelEnt:GetPhysicsObject() ) ) then wheelEnt:GetPhysicsObject():Wake() end

	-- Set the hinge Axis perpendicular to the trace hit surface
	local targetPhys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	local LPos1 = wheelEnt:GetPhysicsObject():WorldToLocal( wheelEnt:GetPos() + trace.HitNormal )
	local LPos2 = targetPhys:WorldToLocal( trace.HitPos )

	local constr, axis = constraint.Motor( wheelEnt, trace.Entity, 0, trace.PhysicsBone, LPos1, LPos2, friction, torque, 0, nocollide, toggle, ply, limit )

	undo.Create( "Wheel" )
		if ( IsValid( constr ) ) then
			undo.AddEntity( constr )
			ply:AddCleanup( "wheels", constr )
		end
		if ( IsValid( axis ) ) then
			undo.AddEntity( axis )
			ply:AddCleanup( "wheels", axis )
		end
		undo.AddEntity( wheelEnt )
		undo.SetPlayer( ply )
	undo.Finish()

	wheelEnt:SetMotor( constr )
	wheelEnt:SetDirection( constr.direction )
	wheelEnt:SetAxis( trace.HitNormal )
	wheelEnt:DoDirectionEffect()

	return true

end

-- Apply new values to the wheel
function TOOL:RightClick( trace )

	if ( trace.Entity && trace.Entity:GetClass() != "gmod_wheel" ) then return false end
	if ( CLIENT ) then return true end

	local wheelEnt = trace.Entity

	-- Only change your own wheels..
	if ( IsValid( wheelEnt:GetPlayer() ) && wheelEnt:GetPlayer() != self:GetOwner() ) then
		return false
	end

	-- Get client's CVars
	local torque = self:GetClientNumber( "torque" )
	local toggle = self:GetClientNumber( "toggle" ) != 0
	local fwd = self:GetClientNumber( "fwd" )
	local bck = self:GetClientNumber( "bck" )

	wheelEnt.BaseTorque = torque
	wheelEnt:SetTorque( torque )
	wheelEnt:SetToggle( toggle )

	-- Make sure the table exists!
	wheelEnt.KeyBinds = wheelEnt.KeyBinds or {}

	wheelEnt.key_f = fwd
	wheelEnt.key_r = bck

	-- Remove old binds
	numpad.Remove( wheelEnt.KeyBinds[ 1 ] )
	numpad.Remove( wheelEnt.KeyBinds[ 2 ] )
	numpad.Remove( wheelEnt.KeyBinds[ 3 ] )
	numpad.Remove( wheelEnt.KeyBinds[ 4 ] )

	-- Add new binds
	wheelEnt.KeyBinds[ 1 ] = numpad.OnDown( self:GetOwner(), fwd, "WheelForward", wheelEnt, true )
	wheelEnt.KeyBinds[ 2 ] = numpad.OnUp( self:GetOwner(), fwd, "WheelForward", wheelEnt, false )
	wheelEnt.KeyBinds[ 3 ] = numpad.OnDown( self:GetOwner(), bck, "WheelReverse", wheelEnt, true )
	wheelEnt.KeyBinds[ 4 ] = numpad.OnUp( self:GetOwner(), bck, "WheelReverse", wheelEnt, false )

	return true

end

if ( SERVER ) then

	-- For duplicator, creates the wheel.
	function MakeWheel( pl, pos, ang, model, key_f, key_r, axis, direction, toggle, BaseTorque, Data )

		if ( IsValid( pl ) && !pl:CheckLimit( "wheels" ) ) then return false end
		if ( !IsValidWheelModel( model ) ) then return false end

		local wheel = ents.Create( "gmod_wheel" )
		if ( !IsValid( wheel ) ) then return end

		wheel:SetModel( model )
		wheel:SetPos( pos )
		wheel:SetAngles( ang )
		wheel:Spawn()

		DoPropSpawnedEffect( wheel )

		wheel:SetPlayer( pl )

		duplicator.DoGenericPhysics( wheel, pl, Data )

		wheel.key_f = key_f
		wheel.key_r = key_r

		if ( axis ) then
			wheel.Axis = axis
		end

		wheel:SetDirection( direction or 1 )
		wheel:SetToggle( toggle or false )

		wheel:SetBaseTorque( BaseTorque )
		wheel:UpdateOverlayText()

		wheel.KeyBinds = {}

		-- Bind to keypad
		wheel.KeyBinds[ 1 ] = numpad.OnDown( pl, key_f, "WheelForward", wheel, true )
		wheel.KeyBinds[ 2 ] = numpad.OnUp( pl, key_f, "WheelForward", wheel, false )
		wheel.KeyBinds[ 3 ] = numpad.OnDown( pl, key_r, "WheelReverse", wheel, true )
		wheel.KeyBinds[ 4 ] = numpad.OnUp( pl, key_r, "WheelReverse", wheel, false )

		if ( IsValid( pl ) ) then
			pl:AddCount( "wheels", wheel )
			pl:AddCleanup( "wheels", wheel )
		end

		return wheel

	end
	duplicator.RegisterEntityClass( "gmod_wheel", MakeWheel, "Pos", "Ang", "Model", "key_f", "key_r", "Axis", "Direction", "Toggle", "BaseTorque", "Data" )

end

function TOOL:UpdateGhostWheel( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) && ( trace.Entity:IsPlayer() /*|| trace.Entity:GetClass() == "gmod_wheel"*/ ) ) then

		ent:SetNoDraw( true )
		return

	end

	local Ang = trace.HitNormal:Angle() + self.wheelAngle
	ent:SetAngles( Ang )

	local CurPos = ent:GetPos()
	local NearestPoint = ent:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local WheelOffset = CurPos - NearestPoint
	ent:SetPos( trace.HitPos + WheelOffset )

	ent:SetNoDraw( false )

end

-- Maintains the ghost wheel
function TOOL:Think()

	local mdl = self:GetClientInfo( "model" )
	if ( !IsValidWheelModel( mdl ) ) then self:ReleaseGhostEntity() return end

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != mdl ) then
		self.wheelAngle = Angle( math.NormalizeAngle( self:GetClientNumber( "rx" ) ), math.NormalizeAngle( self:GetClientNumber( "ry" ) ), math.NormalizeAngle( self:GetClientNumber( "rz" ) ) )
		self:MakeGhostEntity( mdl, vector_origin, angle_zero )
	end

	self:UpdateGhostWheel( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.wheel.desc" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "wheel", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.wheel.forward", Command = "wheel_fwd", Label2 = "#tool.wheel.reverse", Command2 = "wheel_bck" } )

	CPanel:AddControl( "Slider", { Label = "#tool.wheel.torque", Command = "wheel_torque", Type = "Float", Min = 10, Max = 10000 } )
	CPanel:AddControl( "Slider", { Label = "#tool.wheel.forcelimit", Command = "wheel_forcelimit", Type = "Float", Min = 0, Max = 50000 } )
	CPanel:AddControl( "Slider", { Label = "#tool.wheel.friction", Command = "wheel_friction", Type = "Float", Min = 0, Max = 100 } )

	CPanel:AddControl( "CheckBox", { Label = "#tool.wheel.nocollide", Command = "wheel_nocollide" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.wheel.toggle", Command = "wheel_toggle" } )

	CPanel:AddControl( "PropSelect", { Label = "#tool.wheel.model", ConVar = "wheel_model", Height = 0, Models = list.Get( "WheelModels" ) } )

end

// Don't copy paste all of those ridiculous angles, just use one variable for all of them
local zero = { wheel_rx = 0, wheel_ry = 0, wheel_rz = 0 }
local one = { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 }
local two = { wheel_rx = 90, wheel_ry = 0, wheel_rz = 90 }

list.Set( "WheelModels", "models/props_junk/sawblade001a.mdl", one )
list.Set( "WheelModels", "models/props_vehicles/carparts_wheel01a.mdl", two )
list.Set( "WheelModels", "models/props_vehicles/apc_tire001.mdl", zero )
list.Set( "WheelModels", "models/props_vehicles/tire001a_tractor.mdl", zero )
list.Set( "WheelModels", "models/props_vehicles/tire001b_truck.mdl", zero )
list.Set( "WheelModels", "models/props_vehicles/tire001c_car.mdl", zero )
list.Set( "WheelModels", "models/props_wasteland/controlroom_filecabinet002a.mdl", one )
list.Set( "WheelModels", "models/props_borealis/bluebarrel001.mdl", one )
list.Set( "WheelModels", "models/props_c17/oildrum001.mdl", one )
list.Set( "WheelModels", "models/props_c17/playground_carousel01.mdl", one )
list.Set( "WheelModels", "models/props_c17/chair_office01a.mdl", one )
list.Set( "WheelModels", "models/props_c17/TrapPropeller_Blade.mdl", one )
list.Set( "WheelModels", "models/props_wasteland/wheel01.mdl", two )
list.Set( "WheelModels", "models/props_trainstation/trainstation_clock001.mdl", zero )
list.Set( "WheelModels", "models/props_junk/metal_paintcan001a.mdl", one )
list.Set( "WheelModels", "models/props_c17/pulleywheels_large01.mdl", zero )

list.Set( "WheelModels", "models/props_phx/oildrum001_explosive.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/breakable_tire.mdl", one )
list.Set( "WheelModels", "models/props_phx/gibs/tire1_gib.mdl", one )
list.Set( "WheelModels", "models/props_phx/normal_tire.mdl", one )
list.Set( "WheelModels", "models/props_phx/mechanics/medgear.mdl", one )
list.Set( "WheelModels", "models/props_phx/mechanics/biggear.mdl", one )
list.Set( "WheelModels", "models/props_phx/gears/bevel9.mdl", one )
list.Set( "WheelModels", "models/props_phx/gears/bevel90_24.mdl", one )
list.Set( "WheelModels", "models/props_phx/gears/bevel12.mdl", one )
list.Set( "WheelModels", "models/props_phx/gears/bevel24.mdl", one )
list.Set( "WheelModels", "models/props_phx/gears/bevel36.mdl", one )
list.Set( "WheelModels", "models/props_phx/gears/spur9.mdl", one )
list.Set( "WheelModels", "models/props_phx/gears/spur12.mdl", one )
list.Set( "WheelModels", "models/props_phx/gears/spur24.mdl", one )
list.Set( "WheelModels", "models/props_phx/gears/spur36.mdl", one )
list.Set( "WheelModels", "models/props_phx/smallwheel.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/747wheel.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/trucktire.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/trucktire2.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/metal_wheel1.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/metal_wheel2.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/wooden_wheel1.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/wooden_wheel2.mdl", one )
list.Set( "WheelModels", "models/props_phx/construct/metal_plate_curve360.mdl", one )
list.Set( "WheelModels", "models/props_phx/construct/metal_plate_curve360x2.mdl", one )
list.Set( "WheelModels", "models/props_phx/construct/wood/wood_curve360x1.mdl", one )
list.Set( "WheelModels", "models/props_phx/construct/wood/wood_curve360x2.mdl", one )
list.Set( "WheelModels", "models/props_phx/construct/windows/window_curve360x1.mdl", one )
list.Set( "WheelModels", "models/props_phx/construct/windows/window_curve360x2.mdl", one )
list.Set( "WheelModels", "models/props_phx/trains/wheel_medium.mdl", one )
list.Set( "WheelModels", "models/props_phx/trains/medium_wheel_2.mdl", one )
list.Set( "WheelModels", "models/props_phx/trains/double_wheels.mdl", one )
list.Set( "WheelModels", "models/props_phx/trains/double_wheels2.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/drugster_back.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/drugster_front.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/monster_truck.mdl", one )
list.Set( "WheelModels", "models/props_phx/misc/propeller2x_small.mdl", one )
list.Set( "WheelModels", "models/props_phx/misc/propeller3x_small.mdl", one )
list.Set( "WheelModels", "models/props_phx/misc/paddle_small.mdl", one )
list.Set( "WheelModels", "models/props_phx/misc/paddle_small2.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_small.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_small_base.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_medium.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_med_base.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_large.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_large_base.mdl", one )
list.Set( "WheelModels", "models/props_phx/wheels/moped_tire.mdl", one )

--Tile Model Pack Wheels
list.Set( "WheelModels", "models/hunter/misc/cone1x05.mdl", one )
list.Set( "WheelModels", "models/hunter/tubes/circle2x2.mdl", one )
list.Set( "WheelModels", "models/hunter/tubes/circle4x4.mdl", one )

--Primitive Mechanics
list.Set( "WheelModels", "models/mechanics/wheels/bmw.mdl", one )
list.Set( "WheelModels", "models/mechanics/wheels/bmwl.mdl", one )
list.Set( "WheelModels", "models/mechanics/wheels/rim_1.mdl", one )
list.Set( "WheelModels", "models/mechanics/wheels/tractor.mdl", one )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_2.mdl", one )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_2l.mdl", one )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_extruded_48.mdl", one )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_race.mdl", one )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_smooth2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12_large.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12_small.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24_large.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24_small.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6_large.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6_small.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12_large.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12_small.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24_large.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24_small.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6_large.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6_small.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12_large.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12_small.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24_large.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24_small.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6_large.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6_small.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t3.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t3.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t3.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t3.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t3.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t3.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_12t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_18t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_24t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_36t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_48t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_60t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_12t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_18t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_24t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_36t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t1.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t2.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t3.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t3.mdl", one )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t3.mdl", one )

--XQM Model Pack Wheels
list.Set( "WheelModels", "models/NatesWheel/nateswheel.mdl", zero )
list.Set( "WheelModels", "models/NatesWheel/nateswheelwide.mdl", zero )
list.Set( "WheelModels", "models/XQM/JetEnginePropeller.mdl", zero )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerMedium.mdl", zero )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerBig.mdl", zero )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerHuge.mdl", zero )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerLarge.mdl", zero )
list.Set( "WheelModels", "models/XQM/HelicopterRotor.mdl", zero )
list.Set( "WheelModels", "models/XQM/HelicopterRotorMedium.mdl", zero )
list.Set( "WheelModels", "models/XQM/HelicopterRotorBig.mdl", zero )
list.Set( "WheelModels", "models/XQM/HelicopterRotorHuge.mdl", zero )
list.Set( "WheelModels", "models/XQM/HelicopterRotorLarge.mdl", zero )
list.Set( "WheelModels", "models/XQM/Propeller1.mdl", zero )
list.Set( "WheelModels", "models/XQM/Propeller1Medium.mdl", zero )
list.Set( "WheelModels", "models/XQM/Propeller1Big.mdl", zero )
list.Set( "WheelModels", "models/XQM/Propeller1Huge.mdl", zero )
list.Set( "WheelModels", "models/XQM/Propeller1Large.mdl", zero )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1.mdl", zero )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Medium.mdl", zero )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Big.mdl", zero )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Huge.mdl", zero )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Large.mdl", zero )

--Xeon133's Wheels
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-20.mdl", zero )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-30.mdl", zero )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-40.mdl", zero )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-50.mdl", zero )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-60.mdl", zero )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-70.mdl", zero )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-80.mdl", zero )
