-- Shottie ammo override

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "Buckshot"
ENT.AmmoAmount = 8
ENT.AmmoMax = 24
ENT.Model = "models/items/boxbuckshot.mdl"
ENT.AutoSpawnable = true
