
TOOL.Category = "Constraints"
TOOL.Name = "#tool.ballsocket.name"

TOOL.ClientConVar[ "forcelimit" ] = "0"
--TOOL.ClientConVar[ "torquelimit" ] = "0"
TOOL.ClientConVar[ "nocollide" ] = "0"

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "left_1", stage = 1 },
	{ name = "reload" }
}

function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return end

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
		local nocollide = self:GetClientNumber( "nocollide", 0 )
		local forcelimit = self:GetClientNumber( "forcelimit", 0 )
		
		-- Force this to 0 for now, it does not do anything, and if we fix it in the future, this way existing contraptions won't break
		local torquelimit = 0 --self:GetClientNumber( "torquelimit", 0 )

		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local LPos = self:GetLocalPos( 2 )

		local constr = constraint.Ballsocket( Ent1, Ent2, Bone1, Bone2, LPos, forcelimit, torquelimit, nocollide )
		if ( IsValid( constr ) ) then
			undo.Create( "BallSocket" )
				undo.AddEntity( constr )
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()

			self:GetOwner():AddCleanup( "constraints", constr )
		end

		-- Clear the objects so we're ready to go again
		self:ClearObjects()

	else

		self:SetStage( iNum + 1 )

	end

	return true

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Ballsocket" )

end

function TOOL:Holster()

	self:ClearObjects()

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.ballsocket.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "ballsocket", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Slider", { Label = "#tool.forcelimit", Command = "ballsocket_forcelimit", Type = "Float", Min = 0, Max = 50000, Help = true } )
	--CPanel:AddControl( "Slider", { Label = "#tool.torquelimit", Command = "ballsocket_torquelimit", Type = "Float", Min = 0, Max = 50000, Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.nocollide", Command = "ballsocket_nocollide", Help = true } )

end
