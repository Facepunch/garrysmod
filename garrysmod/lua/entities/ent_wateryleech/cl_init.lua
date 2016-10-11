include('shared.lua')

language.Add("#ent_wateryleech", "Carnivorous Leeches")
language.Add("ent_wateryleech", "Carnivorous Leeches")
// Following will rename the real source engine entities.
language.Add("#ent_watery_leech", "Carnivorous Leeches")
language.Add("#trigger_waterydeath", "Carnivorous Leeches")

function ENT:Draw()
	self:DrawModel()
end
