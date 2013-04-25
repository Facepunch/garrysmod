
AddCSLuaFile()

ENT.Type			= "anim"
ENT.RenderGroup		= RENDERGROUP_OTHER


function ENT:Initialize()
	
	hook.Add( "OnViewModelChanged", self, self.ViewModelChanged )

	self:SetNotSolid( true )
	self:DrawShadow( false )
	
end

function ENT:DoSetup( ply )

	-- Set these hands to the player
	ply:SetHands( self )
	self:SetOwner( ply )

	-- Which hands should we use?
	local info = player_manager.RunClass( ply, "GetHandsModel" )
	if ( info ) then
		self:SetModel( info.model )
		self:SetSkin( info.skin )
		self:SetBodyGroups( info.body )
	end

	-- Attach them to the viewmodel
	local vm = ply:GetViewModel( 0 )
	self:AttachToViewmodel( vm )

	vm:DeleteOnRemove( self )
	ply:DeleteOnRemove( self )

end

function ENT:GetPlayerColor()

	return self:GetOwner():GetPlayerColor()

end

function ENT:ViewModelChanged( vm, old, new )

	self:AttachToViewmodel( vm )

end

function ENT:AttachToViewmodel( vm )
	
	self:AddEffects( EF_BONEMERGE )
	self:SetParent( vm )
	self:SetMoveType( MOVETYPE_NONE )

	self:SetPos( Vector( 0, 0, 0 ) )
	self:SetAngles( Angle( 0, 0, 0 ) )

end
