
--[[---------------------------------------------------------
   Starts up the ghost entity
   The most important part of this is making sure it gets deleted properly
-----------------------------------------------------------]]
function ToolObj:MakeGhostEntity( model, pos, angle )

	util.PrecacheModel( model )
	
	-- We do ghosting serverside in single player
	-- It's done clientside in multiplayer
	if (SERVER && !game.SinglePlayer()) then return end
	if (CLIENT && game.SinglePlayer()) then return end
	
	-- Release the old ghost entity
	self:ReleaseGhostEntity()
	
	-- Don't allow ragdolls/effects to be ghosts
	if (!util.IsValidProp( model )) then return end
	
	if ( CLIENT ) then
		self.GhostEntity = ents.CreateClientProp( model )
	else
		self.GhostEntity = ents.Create( "prop_physics" )
	end
	
	-- If there's too many entities we might not spawn..
	if (!self.GhostEntity:IsValid()) then
		self.GhostEntity = nil
		return
	end
	
	self.GhostEntity:SetModel( model )
	self.GhostEntity:SetPos( pos )
	self.GhostEntity:SetAngles( angle )
	self.GhostEntity:Spawn()
	
	self.GhostEntity:SetSolid( SOLID_VPHYSICS );
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true );
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.GhostEntity:SetColor( Color( 255, 255, 255, 150 ) )
	
end

--[[---------------------------------------------------------
   Starts up the ghost entity
   The most important part of this is making sure it gets deleted properly
-----------------------------------------------------------]]
function ToolObj:StartGhostEntity( ent )

	-- We can't ghost ragdolls because it looks like ass
	local class = ent:GetClass()
	
	-- We do ghosting serverside in single player
	-- It's done clientside in multiplayer
	if (SERVER && !game.SinglePlayer()) then return end
	if (CLIENT && game.SinglePlayer()) then return end
	
	self:MakeGhostEntity( ent:GetModel(), ent:GetPos(), ent:GetAngles() )
	
end

--[[---------------------------------------------------------
   Releases up the ghost entity
-----------------------------------------------------------]]
function ToolObj:ReleaseGhostEntity()
	
	if ( self.GhostEntity ) then
		if (!self.GhostEntity:IsValid()) then self.GhostEntity = nil return end
		self.GhostEntity:Remove()
		self.GhostEntity = nil
	end
	
	if ( self.GhostEntities ) then
	
		for k,v in pairs( self.GhostEntities ) do
			if ( v:IsValid() ) then v:Remove() end
			self.GhostEntities[k] = nil
		end
		
		self.GhostEntities = nil
	end
	
	if ( self.GhostOffset ) then
	
		for k,v in pairs( self.GhostOffset ) do
			self.GhostOffset[k] = nil
		end
		
	end
	
end

--[[---------------------------------------------------------
   Update the ghost entity
-----------------------------------------------------------]]
function ToolObj:UpdateGhostEntity()

	if (self.GhostEntity == nil) then return end
	if (!self.GhostEntity:IsValid()) then self.GhostEntity = nil return end
	
	local tr = util.GetPlayerTrace( self:GetOwner() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	local Ang1, Ang2 = self:GetNormal(1):Angle(), (trace.HitNormal * -1):Angle()
	local TargetAngle = self:GetEnt(1):AlignAngles( Ang1, Ang2 )
	
	self.GhostEntity:SetPos( self:GetEnt(1):GetPos() )
	self.GhostEntity:SetAngles( TargetAngle )
	
	local TranslatedPos = self.GhostEntity:LocalToWorld( self:GetLocalPos(1) )
	local TargetPos = trace.HitPos + (self:GetEnt(1):GetPos() - TranslatedPos) + (trace.HitNormal)
	
	self.GhostEntity:SetPos( TargetPos )
	
end
