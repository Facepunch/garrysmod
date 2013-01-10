
hook.Add( "PopulateMenuBar", "NPCOptions_MenuBar", function( menubar )

	local m = menubar:AddOrGetMenu( "NPCs" )
	
	m:AddCVar( "Disable Thinking", "ai_disabled", "1", "0" )
	m:AddCVar( "Ignore Players", "ai_ignoreplayers", "1", "0" )
	m:AddCVar( "Keep Corpses", "ai_serverragdolls", "1", "0" )
	m:AddCVar( "Join Player's Squad", "npc_citizen_auto_player_squad", "1", "0" )

	local weapons = m:AddSubMenu( "Weapon Override" )

			weapons:SetDeleteSelf( false )
			weapons:AddCVar( "Default Weapon", "gmod_npcweapon", "" )
			weapons:AddSpacer()

			for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do
		
				weapons:AddCVar( v.title, "gmod_npcweapon", v.class )
	
			end

	
		
end )

list.Add( "NPCUsableWeapons", { class = "none",				title = "None" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_pistol",	title = "Pistol" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_smg1",		title = "SMG" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_ar2",		title = "AR2" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_shotgun",	title = "Shotgun" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_crossbow",	title = "Crossbow" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_stunstick",	title = "Stunstick" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_357",		title = "357" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_rpg",		title = "RPG" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_crowbar",	title = "Crowbar" }  )
list.Add( "NPCUsableWeapons", { class = "weapon_annabelle",	title = "Annabelle" }  )
