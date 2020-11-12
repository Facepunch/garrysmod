AddCSLuaFile()

ENT.Type = "anim"
 
ENT.PrintName = "Random Ammo"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = ""

ENT.AdminSpawnable = false
ENT.Spawnable = false

if SERVER then
	 
	function ENT:Initialize()
	 
		self:SetModel( "models/Items/item_item_crate.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	 
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
		
		ammo = 
		{
			"item_ammo_pistol",
			"item_ammo_357",
			"item_ammo_smg1",
			"item_ammo_ar2",
			"item_box_buckshot",
		}
		
		timer.Simple( 0, function()
		ent = ents.Create( table.Random( ammo ) )
		ent:SetPos( self:GetPos() + ( self:GetUp() * 5 ) )
		ent:Spawn()
		ent:Activate()
		
		self:Remove()
		end )
		
	end
	 
	function ENT:Use( activator, caller )
	end
	 
	function ENT:Think()
	end

end

if CLIENT then
 
	--[[---------------------------------------------------------
	   Name: FoodBag
	   Purpose: Draw the model in-game.
	   Remember, the things you render first will be underneath!
	---------------------------------------------------------]]
	function ENT:Draw()
		self:DrawModel()
	end
end