-- Rifle ammo override

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "357"
ENT.AmmoAmount = 5 --default 10
ENT.AmmoMax = 15   --default 15
ENT.Model = Model("models/items/357ammo.mdl")
ENT.AutoSpawnable = true
