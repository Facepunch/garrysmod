--- Traitor radio sounds

TRADIO = {}

-- This table contains every sound that can be played by the Radio traitor item.
--
-- It also contains settings that change how the sound is displayed on the client,
-- or how the sound is played on the server:
--
-- name: The name of the sound shown in the T menu. Can be localized.
-- name_params: The parameters to use when localizing the name, if any.
-- sound: The sound to be played, or a table of sounds to pick from randomly.
-- serial: If true, play through the sound table in sequential order instead of randomly.
-- times: The number of times to repeat the sound. If set to a table, randomizes the number of times within the range {min, max}.
-- delay: The delay between sound repetitions. If set to a table, randomizes the delay within the range {min, max}.
-- ampl: The sound level. See https://wiki.facepunch.com/gmod/Enums/SNDLVL
--
-- If serial = true, you can nest multiple sound tables within the sound table.
-- This will cause the radio to choose a random sound from the first table,
-- then on the next repetition, choose a random sound from the next table,
-- and so on. See footsteps (lines 70-80) for an example of this.
--
--
-- If you want to add custom sounds to the radio, use TRADIO.AddNewSound in a shared lua file.
-- For example:
--   TRADIO.AddNewSound("glock", {
--      name = "Glock shots",
--      sound = Sound("Weapon_Glock.single"),
--      delay = 0.1,
--      times = {4, 8},
--      ampl = 90
--   })
--
-- If you want to overwrite an existing sound, you can simply modify TRADIO.Sounds directly.
-- For example:
--   TRADIO.Sounds.explosion = {
--      name = "Balloon pop!",
--      sound = Sound("garrysmod/balloon_pop_cute.wav")
--   }

TRADIO.Sounds = {
   -- Simple Sounds
   scream = {
      name = "radio_button_scream",
      sound = {
         Sound("vo/npc/male01/pain07.wav"),
         Sound("vo/npc/male01/pain08.wav"),
         Sound("vo/npc/male01/pain09.wav"),
         Sound("vo/npc/male01/no02.wav")
      }
   },
   explosion = {
      name = "radio_button_expl",
      sound = Sound("BaseExplosionEffect.Sound")
   },
   beeps = {
      name = "radio_button_c4",
      sound = Sound("weapons/c4/c4_beep1.wav"),
      delay = 0.75,
      times = {8, 12},
      ampl = 70
   },
   hstation = {
      name = "radio_button_heal",
      sound = Sound("items/medshot4.wav"),
      delay = 2,
      times = {3, 5}
   },

   -- Serial Sounds
   footsteps = {
      name = "radio_button_steps",
      sound = {
         {Sound("player/footsteps/concrete1.wav"), Sound("player/footsteps/concrete2.wav")},
         {Sound("player/footsteps/concrete3.wav"), Sound("player/footsteps/concrete4.wav")}
      },
      serial = true,
      times = {8, 16},
      delay = 0.35,
      ampl = 80
   },

   burning = {
      name = "radio_button_burn",
      sound = {
         Sound("General.BurningObject"),
         Sound("General.StopBurning")
      },
      serial = true,
      delay = 4,
   },

   teleport = {
      name = "radio_button_tele",
      sound = {
         Sound("ambient/levels/labs/teleport_mechanism_windup1.wav"),
         Sound("ambient/levels/labs/electric_explosion4.wav")
      },
      serial = true,
      delay = 1
   },

   -- Gun Sounds
   shotgun = {
      name = "radio_button_shotgun",
      sound = Sound( "Weapon_XM1014.Single" ),
      delay = {0.8, 1.6},
      times = {1, 3},
      ampl = 90
   },

   pistol = {
      name = "radio_button_pistol",
      sound = Sound( "Weapon_FiveSeven.Single" ),
      delay = {0.4, 0.8},
      times = {2, 4},
      ampl = 90
   },

   mac10 = {
      name = "radio_button_mac10",
      sound = Sound( "Weapon_mac10.Single" ),
      delay = 0.065,
      times = {5, 10},
      ampl = 90
   },

   deagle = {
      name = "radio_button_deagle",
      sound = Sound( "Weapon_Deagle.Single" ),
      delay = {0.6, 1.2},
      times = {1, 3},
      ampl = 90
   },

   m16 = {
      name = "radio_button_m16",
      sound = Sound( "Weapon_M4A1.Single" ),
      delay = 0.2,
      times = {1, 5},
      ampl = 90
   },

   rifle = {
      name = "radio_button_rifle",
      sound = Sound( "weapons/scout/scout_fire-1.wav" ),
      ampl = 80
   },

   huge = {
      name = "radio_button_huge",
      sound = Sound( "Weapon_m249.Single" ),
      delay = 0.055,
      times = {6, 12},
      ampl = 90
   },

   glock = {
      name = "radio_button_glock",
      sound = Sound("Weapon_Glock.single"),
      delay = 0.1,
      times = {4, 8},
      ampl = 90
   },

   sipistol = {
      name = "radio_button_sipist",
      sound = Sound("Weapon_USP.SilencedShot"),
      delay = {0.38, 0.76},
      times = {2, 4},
      ampl = 50
   }
}

function TRADIO.AddNewSound(key, soundData)
   local newkey = key
   local i = 1
   while TRADIO.Sounds[newkey] do
      newkey = key .. tostring(i)
      i = i + 1
   end

   TRADIO.Sounds[newkey] = soundData

   if CLIENT then
      table.insert(TRADIO.SoundOrder, newkey)
   end
end
