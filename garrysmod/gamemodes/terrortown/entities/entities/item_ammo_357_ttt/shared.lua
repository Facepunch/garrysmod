-- Rifle ammo override

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "357"
ENT.AmmoAmount = 10
ENT.AmmoMax = 20
ENT.Model = Model("models/items/357ammo.mdl")
ENT.AutoSpawnable = true
