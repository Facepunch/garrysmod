
AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OTHER

function ENT:Initialize()

	hook.Add( "OnViewModelChanged", self, self.ViewModelChanged )

	self:SetNotSolid( true )
	self:DrawShadow( false )
	self:SetTransmitWithParent( true ) -- Transmit only when the viewmodel does!

end

function ENT:DoSetup( ply, spec )

	-- Set these hands to the player
	ply:SetHands( self )
	self:SetOwner( ply )

	-- Which hands should we use? Let the gamemode decide
	hook.Call( "PlayerSetHandsModel", GAMEMODE, spec or ply, self )

	-- Attach them to the viewmodel
	local vm = ( spec or ply ):GetViewModel( 0 )
	self:AttachToViewmodel( vm )

	vm:DeleteOnRemove( self )
	ply:DeleteOnRemove( self )

end

function ENT:GetPlayerColor()

	--
	-- Make sure there's an owner and they have this function
	-- before trying to call it!
	--
	local owner = self:GetOwner()
	if ( !IsValid( owner ) ) then return end
	if ( !owner.GetPlayerColor ) then return end

	return owner:GetPlayerColor()

end

function ENT:ViewModelChanged( vm, old, new )

	-- Ignore other peoples viewmodel changes!
	if ( vm:GetOwner() != self:GetOwner() ) then return end

	self:AttachToViewmodel( vm )

end

function ENT:AttachToViewmodel( vm )

	self:AddEffects( EF_BONEMERGE )
	self:SetParent( vm )
	self:SetMoveType( MOVETYPE_NONE )

	self:SetPos( vector_origin )
	self:SetAngles( angle_zero )

end
