---- English language strings

local L = LANG.CreateLanguage("Svenska")

--- General text used in various places
L.traitor    = "Förrädare"
L.detective  = "Detektiv"
L.innocent   = "Oskyldig"
L.last_words = "Sista Ord"

L.terrorists = "Terrorister"
L.spectators = "Åskådare"

--- Round status messages
L.round_minplayers = "För få spelare för att påbörja ny runda..."
L.round_voting     = "Omröstning pågår, fördröjer ny runda med {num} sekunder..."
L.round_begintime  = "En ny runda påbörjas om {num} sekunder. Bered dig."
L.round_selected   = "Förrädarna har blivit utvalda."
L.round_started    = "Rundan har påbörjats!"
L.round_restart    = "Rundan har blivit omstartad av en admin."

L.round_traitors_one  = "Förrädare, du står ensam"
L.round_traitors_more = "Förrädare, detta är dina lagkamrater: {names}"

L.win_time         = "Tiden har tagit slut. Förrädarna har förlorat."
L.win_traitor      = "Förrädarna har vunnit!"
L.win_innocent     = "Förrädarna har blivit besegrade!"
L.win_showreport   = "Låt oss ta en titt på rund-rapporten i {num} sekunder."

L.limit_round      = "Gränsen för antalet rundor har nåtts. {mapname} kommer laddas snart."
L.limit_time       = "Tidsgränsen har tagit slut. {mapname} kommer laddas snart."
L.limit_left       = "{num} rundor eller {time} minuter återstår innan kartan ändras till {mapname}."

--- Credit awards
L.credit_det_all   = "Detektiver, ni har blivit tilldelade {num} verktygskredit(er) för era prestationer."
L.credit_tr_all    = "Förrädare, ni har blivit tilldelade {num} verktygskredit(er) för era prestationer."

L.credit_kill      = "Du har blivit tilldelad {num} kredit(er) för att ha dödat en {role}."

--- Karma
L.karma_dmg_full   = "Din Karma är {amount}, så du utdelar full skada denna runda!"
L.karma_dmg_other  = "Din Karma är {amount}. Till följd av detta är skadan du utdelar reducerad med {num}%"

--- Body identification messages
L.body_found       = "{finder} fann {victim}s kropp. {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "Han var en Förrädare!"
L.body_found_d     = "Han var en Detektiv."
L.body_found_i     = "Han var oskyldig."

L.body_confirm     = "{finder} bekräftade att {victim} har dött."

L.body_call        = "{player} kallade en Detektiv till {victim}s kropp!"
L.body_call_error  = "Du måste bekräfta denna spelarens död för att kunna kalla på en Detektiv!"

L.body_burning     = "Aj! Den här kroppen brinner!"
L.body_credits     = "Du fann {num} kredit(er) på kroppen!"

--- Menus and windows
L.close = "Stäng"
L.cancel = "Avbryt"

-- For navigation buttons
L.next = "Nästa"
L.prev = "Föregående"

-- Equipment buying menu
L.equip_title     = "Verktyg"
L.equip_tabtitle  = "Beställ verktyg"

L.equip_status    = "Beställnings-status"
L.equip_cost      = "Du har {num} kredit(er) kvar."
L.equip_help_cost = "Varje verktyg du köper kostar 1 kredit."

L.equip_help_carry = "Du kan endast köpa verktyg för vilka du har rum."
L.equip_carry      = "Du kan bära detta verktyg."
L.equip_carry_own  = "Du bär redan detta verktyg."
L.equip_carry_slot = "Du har redan ett vapen i nummer {slot}."

L.equip_help_stock = "Vissa verktyg kan du endast köpa en utav varje runda."
L.equip_stock_deny = "Detta verktyg har tagit slut."
L.equip_stock_ok   = "Detta verktyg finns tillgängligt."

L.equip_custom     = "Egengjort verktyg tillagt av denna server."

L.equip_spec_title = "Föremålsspecifikationer"
L.equip_spec_name  = "Namn:"
L.equip_spec_type  = "Typ:"
L.equip_spec_desc  = "Beskrivning:"

L.equip_confirm    = "Köp föremål"

-- Disguiser tab in equipment menu
L.disg_name      = "Förklädare"
L.disg_menutitle = "Förklädningskontroll"
L.disg_not_owned = "Du har ingen Förklädare!"
L.disg_enable    = "Aktivera förklädare"

L.disg_help1     = "När din förklädare är påslagen visas inte ditt namn, din hälsa eller din karma när någon tittar på dig. Du syns heller inte på en Detektivs radar."
L.disg_help2     = "Tryck på Numpad Enter för att sätta på/stänga av förklädnaden utan att använda menyn. Du kan även binda en annan tangent till 'ttt_toggle_disguise' genom att använda konsollen."

-- Radar tab in equipment menu
L.radar_name      = "Radar"
L.radar_menutitle = "Radar-kontroll"
L.radar_not_owned = "Du har ingen Radar!"
L.radar_scan      = "Utför skanning"
L.radar_auto      = "Auto-repetera skanning"
L.radar_help      = "Skannings-resultat visas i {num} sekunder. Efter detta laddas Radarn om och kan användas igen."
L.radar_charging  = "Din Radar laddar fortfarande!"

-- Transfer tab in equipment menu
L.xfer_name       = "Överför"
L.xfer_menutitle  = "Överför krediter"
L.xfer_no_credits = "Du har inga krediter att ge!"
L.xfer_send       = "Sänd en kredit"
L.xfer_help       = "Du kan endast överföra krediter till dina {role}-kamrater."

L.xfer_no_recip   = "Mottagare ej giltig avbryter kredit-överföring."
L.xfer_no_credits = "Ej tillräckligt med krediter för överföring."
L.xfer_success    = "Kredit-överföring till {player} utförd."
L.xfer_received   = "{player} har gett dig {num} krediter."

-- Radio tab in equipment menu
L.radio_name      = "Radio"
L.radio_help      = "Tryck på en knapp för att spela det ljudet på Radion."
L.radio_notplaced = "Du måste placera Radion för att kunna spela ljud på den."

-- Radio soundboard buttons
L.radio_button_scream  = "Skrik"
L.radio_button_expl    = "Explosion"
L.radio_button_pistol  = "Pistol-skott"
L.radio_button_m16     = "M16-skott"
L.radio_button_deagle  = "Deagle-skott"
L.radio_button_mac10   = "MAC10-skott"
L.radio_button_shotgun = "Hagelgevär-skott"
L.radio_button_rifle   = "Gevärsskott"
L.radio_button_huge    = "H.U.G.E-salva"
L.radio_button_c4      = "C4-pip"
L.radio_button_burn    = "Brand"
L.radio_button_steps   = "Fotsteg"


-- Intro screen shown after joining
L.intro_help     = "Om du är ny till detta spel, tryck F1 för att få instruktioner!"

-- Radiocommands/quickchat
L.quick_title   = "Snabb-knappar"

L.quick_yes     = "Ja."
L.quick_no      = "Nej."
L.quick_help    = "Hjälp!"
L.quick_imwith  = "Jag är med {player}."
L.quick_see     = "Jag ser {player}."
L.quick_suspect = "{player} beter sig skumt."
L.quick_traitor = "{player} är en Förrädare!"
L.quick_inno    = "{player} är oskyldig."
L.quick_check   = "Lever någon fortfarande?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "ingen"
L.quick_disg      = "någon i förklädnad"
L.quick_corpse    = "ett oidentifierat lik"
L.quick_corpse_id = "{player}s lik"


--- Body search window
L.search_title  = "Resultat från Kroppsvisit"
L.search_info   = "Information"
L.search_confirm = "Bekräfta Död"
L.search_call   = "Kalla på Detektiv"

-- Descriptions of pieces of information found
L.search_nick   = "Detta är {player}s kropp."

L.search_role_t = "Den här personen var en Förrädare!"
L.search_role_d = "Den här personen var en Detektiv."
L.search_role_i = "Den här personen var en oskyldig terrorist."

L.search_words  = "Någonting säger dig att en del av den här personens sista ord var: '{lastwords}'"
L.search_armor  = "Han bar skyddsutrustning som inte var av vanlig standard."
L.search_disg   = "Han bar utrustning som kunde dölja hans identitet."
L.search_radar  = "Han bar någon sorts radar. Den fungerar inte längre."
L.search_c4     = "In en av fickorna hittar du en lapp. Det står att om sladd nummer {num} klipps av, kommer bomben att stängas av."

L.search_dmg_crush  = "Många av hans ben är brutna. Det verkar som att ett tungt föremål dödade honom."
L.search_dmg_bullet = "Det är uppenbart att han blev ihjälskjuten."
L.search_dmg_fall   = "Han föll till sin död."
L.search_dmg_boom   = "Hans skador och svedda kläder antyder att en explosion blev slutet för honom."
L.search_dmg_club   = "Kroppen är alldeles blåslagen och mörbultad. Uppenbarligen blev han ihjälklubbad."
L.search_dmg_drown  = "Kroppen visar tecken på drunkning."
L.search_dmg_stab   = "Han blev stucken och förblödde hastigt."
L.search_dmg_burn   = "Det luktar grillad terrorist häromkring..."
L.search_dmg_tele   = "Vem kunde ana det? Att teleportera till en plats där någon redan står är inte så bra för den som står där!"
L.search_dmg_car    = "När den här terroristen gick över vägen, blev han överkörd av en hänsynslös bilförare."
L.search_dmg_other  = "Du kan inte hitta en specifik orsakt till den här terroristens död."

L.search_weapon = "En {weapon} användes för att döda den här terroristen."
L.search_head   = "Det slutgiltiga skottet var i huvudet. Det fanns ingen tid till att skrika."
L.search_time   = "Han dog ungefär {time} innan du utförde sökningen."
L.search_dna    = "Ta ett prov av mördarens DNA med hjälp av en DNA-Skanner. DNA-provet kommer att förruttna ungefär {time} från nu."

L.search_kills1 = "Du hittade en lista över mordoffer som bekräftar morden på {player}."
L.search_kills2 = "Du hittade en lista över mordoffer med dessa namn:"
L.search_eyes   = "Genom att använda dina detektivfärdigheter kan du identifiera den sista personen han såg: {player}. Mördaren, eller ett sammanträffande?"


-- Scoreboard
L.sb_playing    = "Du spelar på..."
L.sb_mapchange  = "Kartan ändras om {num} rundor eller om {time}"

L.sb_mia        = "Saknad I Strid"
L.sb_confirmed  = "Bekräftad Död"

L.sb_ping       = "Ping"
L.sb_deaths     = "Döda"
L.sb_score      = "Poäng"
L.sb_karma      = "Karma"

L.sb_info_help  = "Om du kollar igenom denna spelares lik kan du se resultaten här."

L.sb_tag_friend = "VÄN"
L.sb_tag_susp   = "MISSTÄNKT"
L.sb_tag_avoid  = "UNDVIK"
L.sb_tag_kill   = "DÖDA"
L.sb_tag_miss   = "SAKNAD"

--- Help and settings menu (F1)

L.help_title = "Hjälp och Inställningar"

-- Tabs
L.help_tut     = "Handledning"
L.help_tut_tip = "Hur man spelar TTT, i 6 steg"

L.help_settings = "Inställningar"
L.help_settings_tip = "Klient-inställningar"

-- Settings
L.set_title_gui = "Gränssnittsinställningar"

L.set_tips      = "Visa spel-tips i nedkanten av skärmen vid åskådning"
L.set_voice     = "Visa röstchatts-indikatorer uppe till vänster på skärmen"

L.set_startpopup = "Börja med rund info popup varaktighet"
L.set_startpopup_tip = "När rundan påbörjas dyker en liten ruta upp i nedkanten av din skärm i några sekunder. Ändra hur länge den visas här."

L.set_cross_opacity = "Genomskinlighet på korshåret när man tittar i siktet på vapnen"
L.set_cross_disable = "Visa inte korshår över huvud taget"
L.set_minimal_id    = "Minimalistisk spelar-identifiering (ingen karmatext, tips, etc)"
L.set_healthlabel   = "Visa hälsostatus på hälsoremsan"
L.set_lowsights     = "Ta ned vapnet när man tittar i siktet"
L.set_lowsights_tip = "Gör så att vapnet placeras längre ned på skärmen när man tittar i siktet. Detta gör det lättare att se ditt mål, men det ser lite mindre realistiskt ut."
L.set_fastsw        = "Snabbt vapenbyte"
L.set_fastsw_tip    = "Aktivera så att vapnet byts så fort man rör scrollen, utan att du behöver öppna menyn för att byta vapen."
L.set_wswitch       = "Avaktivera automatisk nedstängning av vapenmenyn"
L.set_wswitch_tip   = "Som standard stängs vapenmenyn ned automatiskt några sekunder efter att man använt scrollen. Sätt på detta för att göra så att den stannar uppe."
L.set_cues          = "Spela ett ljud när en runda slutar eller startas"


L.set_title_play    = "Spel-inställningar"

L.set_specmode      = "Var alltid åskådare"
L.set_specmode_tip  = "Åskådar-läge hindrar dig från att leva när en ny runda påbörjas. Istället fortsätter du vara åskådare."
L.set_mute          = "Tysta ned levande spelare när du är död"
L.set_mute_tip      = "Sätt på detta så hörs inte levande spelare när du är död/åskådare."


L.set_title_lang    = "Språkinställningar"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "Välj språk (Select language):"


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "Det här vapnet finns inte tillgängligt: du har redan köpt det den här rundan."
L.buy_pending     = "Du har redan en beställning som väntar, vänta tills du får den."
L.buy_received    = "Du har fått ditt specialverktyg."

L.drop_no_room    = "Det finns ingen plats här för att släppa ditt vapen!"

L.disg_turned_on  = "Förklädnad aktiverad!"
L.disg_turned_off = "Förklädnad avaktiverad."

-- Equipment item descriptions
L.item_passive    = "Passivt verktyg"
L.item_active     = "Aktiv användning-verktyg"
L.item_weapon     = "Vapen"

L.item_armor      = "Kroppsrustning"
L.item_armor_desc = [[
Reducerar skottskador med 30% när
du blir träffad.

Standard-verktyg för Detektiver.]]

L.item_radar      = "Radar"
L.item_radar_desc = [[
Tillåter dig att skanna efter livstecken.

Startar automatiskt så fort du
köper den. Konfigurera den i 
Radar-fliken i den här menyn.]]

L.item_disg       = "Förklädare"
L.item_disg_desc  = [[
Döljer din identitet när den är 
påslagen. Hindrar även att man 
blir den sista sedda personen 
av ett offer.

Slå av/på i Förklädnads-fliken
i den här menyn eller tryck
Numpad Enter.]]

-- C4
L.c4_hint         = "Tryck på {usekey} för att armera eller desarmera."
L.c4_no_disarm    = "Du kan ej desarmera en annan Förrädares C4 såvida han inte är död."
L.c4_disarm_warn  = "En C4 som du har placerat har blivit desarmerad."
L.c4_armed        = "Du lyckades armera bomben."
L.c4_disarmed     = "Du lyckades desarmera bomben."
L.c4_no_room      = "Du kan ej bära denna C4."

L.c4_desc         = "Kraftfullt tidsbestämt sprängämne."

L.c4_arm          = "Armera C4"
L.c4_arm_timer    = "Timer"
L.c4_arm_seconds  = "Sekunder tills detonering:"
L.c4_arm_attempts = "Vid desarmeringsförsök kommer {num} av de 6 sladdarna att orsaka en omedelbar detonering vid avklippning."

L.c4_remove_title    = "Avlägsnande"
L.c4_remove_pickup   = "Plocka upp C4"
L.c4_remove_destroy1 = "Förstör C4"
L.c4_remove_destroy2 = "Bekräfta: förstör"

L.c4_disarm       = "Desarmera C4"
L.c4_disarm_cut   = "Klicka för att klippa av sladd nummer {num}"

L.c4_disarm_t     = "Klipp av en sladd för att desarmera bomben. Eftersom du är en Förrädare är varje sladd säker. De oskylda har det inte lika lätt!"
L.c4_disarm_owned = "Klipp av en sladd för att desarmera bomben. Det är din bomb, så varje sladd kommer att desarmera den."
L.c4_disarm_other = "Klipp av en säker sladd för att desarmera bomben. Den kommer att explodera om du klipper fel!"

L.c4_status_armed    = "ARMERAD"
L.c4_status_disarmed = "DESARMERAD"

-- Visualizer
L.vis_name        = "Visualiserare"
L.vis_hint        = "Tryck {usekey} för att plocka upp (endast Detektiver)."

L.vis_help_pri    = "{primaryfire} släpper det aktiverade redskapet."

L.vis_desc        = [[
Verktyg för brottsscens-
visualisering.

Analyserar ett lik för att visa
hur offret dog, men enbart om
han dog av skottskador.]]

-- Decoy
L.decoy_name      = "Lockbete"
L.decoy_no_room   = "Du kan ej bära detta Lockbete."
L.decoy_broken    = "Ditt Lockbete har förstörts!"

L.decoy_help_pri  = "{primaryfire} riggar Lockbetet."

L.decoy_desc      = [[
Visar ett fejkat radar-spår för
detektiver, och gör så att deras
DNA-skanner visa platsen för
Lockbetet om de skannar efter
ditt DNA.]]

-- Defuser
L.defuser_name    = "Desarmerare"
L.defuser_help    = "{primaryfire} desarmerar C4 i siktet."

L.defuser_desc    = [[
Desarmerar C4 omedelbart.

Kan användas oändligt många 
gånger. C4 märks tydligare 
om du bär detta verktyg.]]

-- Flare gun
L.flare_name      = "Signalpistol"
L.flare_desc      = [[
Kan användas till att bränna lik
så att de aldrig återfinns.
Begränsad ammunition.

Att bränna ett lik gör ett
tydligt ljud.]]

-- Health station
L.hstation_name   = "Hälsostation"
L.hstation_hint   = "Tryck {usekey} för att få hälsa. Laddning: {num}."
L.hstation_broken = "Din Hälsostation har blivit förstörd!"
L.hstation_help   = "{primaryfire} placerar Hälsostationen."

L.hstation_desc   = [[
Tillåter spelare att helas när
den är utplacerad.

Långsam omladdning. Vem som helst
kan använda den, och den kan utsättas
för skada. Kan kollas efter DNA-prov
av dess användare.]]

-- Knife
L.knife_name      = "Kniv"
L.knife_thrown    = "Kastkniv"

L.knife_desc      = [[
Dödar ganska skadade mål
omedelbart och tyst, men har
endast ett användningsområde.

Kan kastas med {secondaryfire}]]

-- Poltergeist
L.polter_desc     = [[
Placerar enheter på föremål
som knuffar omkring dem med
våldsam kraft.

Explosionerna skadar spelare
i närheten.]]

-- Radio
L.radio_broken    = "Din Radio har blivit förstörd!"
L.radio_help_pri  = "{primaryfire} placerar Radion."

L.radio_desc      = [[
Spelar upp distraherande eller
bedragande ljud.

Placera radion någonstans, och spela
sedan upp ljud på den genom att använda
Radio-fliken i den här menyn.]]

-- Silenced pistol
L.sipistol_name   = "Ljuddämpad Pistol"

L.sipistol_desc   = [[
Pistol med dämpade ljud. Använder
vanlig pistol-ammunition.

Offer skriker inte när de blir dödade.]]

-- Newton launcher
L.newton_name     = "Avståndsknuffare"

L.newton_desc     = [[
Knuffa spelare från ett 
bekvämt avstånd.

Oändligt med ammunition, men 
laddar om långsamt.]]

-- Binoculars
L.binoc_name      = "Kikare"
L.binoc_desc      = [[
Zooma in på lik och identifiera dem
från ett långt avstånd.

Kan användas oändligt många gånger,
men identifieringen tar några sekunder.]]

L.binoc_help_pri  = "{primaryfire} identifirerar ett lik."
L.binoc_help_sec  = "{secondaryfire} ändrar inzoomnings-nivån."

-- UMP
L.ump_desc        = [[
Experimentell k-pist som 
desorienterar målen.

Använder vanlig k-pist-ammunition.]]

-- DNA scanner
L.dna_name        = "DNA-skanner"
L.dna_identify    = "Liket måste vara identifierat för att återfå mördarens DNA."
L.dna_notfound    = "Inget DNA-prov kunde hittas på målet."
L.dna_limit       = "Lagringsbegränsningen nådd. Ta bort gamla prov för att lägga till nya."
L.dna_decayed     = "Mördarens DNA-prov har förruttnat."
L.dna_killer      = "Hittade ett prov av mördarens DNA på liket!"
L.dna_no_killer   = "DNAt kunde inte återfås (har mördaren gått ur spelet?)"
L.dna_armed       = "Bomben går fortfarande! Desarmera den först!"
L.dna_object      = "Samlade in {num} nya DNA-prov från föremålet."
L.dna_gone        = "DNA kunde inte hittas i området. (Har mördaren gått ur spelet?)"

L.dna_desc        = [[
Samla DNA-prov från saker
och använd dem för att hitta
dess ägare.

Använd på färska lik för att få
mördarens DNA och söka upp honom.]]

L.dna_menu_title  = "Kontroller för DNA-skanning"
L.dna_menu_sample = "DNA-prov funnet på {source}"
L.dna_menu_remove = "Ta bort valda"
L.dna_menu_help1  = "Detta är DNA-prov som du har samlat på dig."
L.dna_menu_help2  = [[
När den är laddad kan du söka efter platsen
där spelaren med valt DNA finns. För att
hitta mer avlägsna spelare krävs mer energi.]]

L.dna_menu_scan   = "Skanna"
L.dna_menu_repeat = "Repetera automatiskt"
L.dna_menu_ready  = "REDO"
L.dna_menu_charge = "LADDAR"
L.dna_menu_select = "VÄLJ PROV"

L.dna_help_primary   = "{primaryfire} för att ta DNA-prov"
L.dna_help_secondary = "{secondaryfire} för att öppna skann-kontroller"

-- Magneto stick
L.magnet_name     = "Magnetstav"
L.magnet_help     = "{primaryfire} för att sätta fast kropp på ytan."

-- Grenades and misc
L.grenade_smoke   = "Rökgranat"
L.grenade_fire    = "Brandbomb"

L.unarmed_name    = "Hölstrad"
L.crowbar_name    = "Kofot"
L.pistol_name     = "Pistol"
L.rifle_name      = "Gevär"
L.shotgun_name    = "Hagelgevär"

-- Teleporter
L.tele_name       = "Teleportör"
L.tele_failed     = "Teleportering misslyckad."
L.tele_marked     = "Teleporteringsplats markerad."

L.tele_no_ground  = "Kan ej teleportera om du inte står på fast mark!"
L.tele_no_crouch  = "Kan ej teleportera när du duckar!"
L.tele_no_mark    = "Ingen plats markerad. Markera en destination innan du teleporterar."

L.tele_no_mark_ground = "Kan ej markera en teleporteringsplats om du inte står på fast mark!"
L.tele_no_mark_crouch = "Kan ej markera en teleporteringsplats om du duckar!"

L.tele_help_pri   = "{primaryfire} teleporterar till markerad plats."
L.tele_help_sec   = "{secondaryfire} markerar nuvarande plats."

L.tele_desc       = [[
Teleportera till en 
tidigare markerad plats.

Teleportering orsakar oljud,
och antalet gånger den
kan användas är begränsat.]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "9mm ammunition"

L.ammo_smg1       = "K-pist-ammunition"
L.ammo_buckshot   = "Hagelgevärsammunition"
L.ammo_357        = "Gevärsammunition"
L.ammo_alyxgun    = "Deagle-ammunition"
L.ammo_ar2altfire = "Signalammunition"
L.ammo_gravity    = "Poltergeist-ammunition"


--- HUD interface text

-- Round status
L.round_wait   = "Väntar"
L.round_prep   = "Förbereder"
L.round_active = "Pågår"
L.round_post   = "Runda över"

-- Health, ammo and time area
L.overtime     = "ÖVERTID"
L.hastemode    = "HETSLÄGE"

-- TargetID health status
L.hp_healthy   = "Frisk"
L.hp_hurt      = "Skadad"
L.hp_wounded   = "Ganska Skadad"
L.hp_badwnd    = "Svårt Skadad"
L.hp_death     = "Nära Döden"


-- TargetID karma status
L.karma_max    = "Ansedd"
L.karma_high   = "Klumpig"
L.karma_med    = "Skjutglad"
L.karma_low    = "Farlig"
L.karma_min    = "Varning"

-- TargetID misc
L.corpse       = "Lik"
L.corpse_hint  = "Tryck {usekey} för att söka igenom. {usekey} + {walkkey} för att söka i smyg."

L.target_disg  = " (FÖRKLÄDD)"
L.target_unid  = "Oidentifierad kropp"

L.target_traitor = "FÖRRÄDARKAMRAT"
L.target_detective = "DETEKTIV"

L.target_credits = "Sök igenom för att erhålla ospenderade krediter"

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single  = "Engångsanvändning"
L.tbut_reuse   = "Omanvändningsbar"
L.tbut_retime  = "Omanvändningsbar efter {num} sekunder"
L.tbut_help    = "Tryck {key} för att aktivera"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "Förklädd. Ditt namn är dolt."
L.radar_hud    = "Radar är redo för nästa skanning om: {time}"

-- Spectator muting of living/dead
L.mute_living  = "Levande spelare nedtystade"
L.mute_specs   = "Åskådare nedtystade"
L.mute_off     = "Ingen nedtystad"

-- Spectators and prop possession
L.punch_title  = "KNUFF-MÄTARE"
L.punch_help   = "Rörelsetangenter eller hoppa: knuffa föremål. Ducka: lämna föremål."
L.punch_bonus  = "Din dåliga poäng har sänkt din knuff-mätargräns med {num}"
L.punch_malus  = "Din goda poäng har höjt din knuff-mätargräns med {num}!"

L.spec_help    = "Klicka för att se spelet genom en spelares ögon eller tryck {usekey} på ett föremål för att styra det."

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[Du är en oskyldig Terrorist! Men det finns förrädare omkring...
Vem kan du lita på, och vem är ute för att mörda dig?

Var aktsam och arbeta med dina kamrater för att komma ut härifrån levande!]]

L.info_popup_detective = [[Du är en Detektiv! Terrorist-högkvarteren har givit dig speciella resurser för att finna förrädarna.
Använd dem för att hjälpa de oskyldiga överleva, men var försiktig:
förrädarna kommer att försöka ta ned dig först!

Tryck {menukey} för att få dina verktyg!]]

L.info_popup_traitor_alone = [[Du är en FÖRRÄDARE! Du har inga förrädarkamrater denna runda.

Döda alla andra för att vinna!

Tryck {menukey} för att få dina verktyg!]]

L.info_popup_traitor = [[Du är en FÖRRÄDARE! Arbeta med dina förrädarkamrater för att döda alla andra.
Men var försiktig, annars kan ditt förräderi upptäckas...

Detta är dina kamrater:
{traitorlist}

Tryck {menukey} för att få dina verktyg!]]

--- Various other text
L.name_kick = "En spelare blev utsparkad automatiskt för att ha bytt sitt namn under en runda."

L.idle_popup = [[Du var borta i {num} sekunder och blev därför förflyttad till Åskådar-läge. Så länge du är i detta läge kommer du inte att kunna spela när en ny runda börjar.

Du kan slå av/på Åskådar-läge när som helst genom att trycka på {helpkey} och bocka av lådan i inställningsfliken. Du kan även välja att stänga av det nu medsamma.]]

L.idle_popup_close = "Gör ingenting"
L.idle_popup_off   = "Stäng av Åskådar-läge nu"

L.idle_warning = "Varning: du verkar vara borta, och kommer att bli tvingad att åskåda om du inte gör någonting!"

L.spec_mode_warning = "Du är i Åskådar-läge och kommer inte att starta när en runda påbörjas. För att stänga av detta läge, tryck F1, gå till inställningar och bocka av 'Åskådar-läge'."


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "Tips"
L.tips_panel_tip   = "Tips:"

-- Tip texts

L.tip1 = "Förrädare kan söka igenom kroppar tyst, utan att bekräfta deras död, genom att hålla in {walkkey} och trycka {usekey} på liket."

L.tip2 = "Genom att armera en C4 med en längre timer kommer antalet sladdar som orsakar omedelbar detonering att öka. Den kommer även att pipa svagare och med större mellanrum mellan pipen."

L.tip3 = "Detektiver kan söka igenom lik för att se vem som 'reflekteras på näthinnan'. Detta är den sista personen som den döde snubben såg. Det är dock inte nödvändigtvis mördaren om han skjöts i ryggen."

L.tip4 = "Ingen kommer att veta om att du har dött förrän de har funnit din döda kropp och identifierat den genom att söka igenom den."

L.tip5 = "När en Förrädare dödar en Detektiv får han omedelbart en kreditbelöning."

L.tip6 = "När en Förrädare dör får alla Detektiver kreditbelöning."

L.tip7 = "När Förrädarna har dödat tillräckligt många får de en kreditbelöning."

L.tip8 = "Förrädare och Detektiver kan samla på sig oanvända verktygskrediter från döda Förrädar- och Detektiv-kroppar."

L.tip9 = "Poltergeisten kan förvandla vilket rörligt föremål som helst till en dödlig projektil. Varje knuff medför en stark smäll som skadar alla i närheten."

L.tip10 = "Som en Förrädare eller som en Detektiv bör du hålla ett öga på röda meddelanden i det övre högra hörnet av skärmen, då dessa innehåller viktig information."

L.tip11 = "Som en Förrädare eller som en Detektiv får du extra verktygskrediter om dina kamrater arbetar väl. Kom också ihåg att spendera dem!"

L.tip12 = "Detektivernas DNA-skanner kan användas till att samla DNA-prov från vapen och föremål för att sedan skanna och finna dess användare. Detta är användbart när du kan hitta ett prov från ett lik eller en avstängd C4!"

L.tip13 = "Om du är nära ditt mordoffer kommer ditt DNA att hamna på liket. DNAt kan sedan användas med Detektivernas DNA-skannrar för att hitta var du är. Du gör därför bäst i att gömma liken efter att du har knivhuggit det!"

L.tip14 = "Ju längre ifrån du är ditt mordoffer, desto kortare tid kommer ditt DNA finnas kvar på liket innan det förruttnar."

L.tip15 = "Tänkte du skjuta prick som Förrädare? Överväg att använda en Förklädare. Om du missar ett skott kan du springa till en säker plats, stänga av apparaten och komma ut som om ingenting hade hänt."

L.tip16 = "Som Förrädare kan Teleportören hjälpa dig fly när du är jagad, och tillåter dig att komma från plats A till plats B på väldigt kort tid. Se bara till så att du har en säker plats markerad."

L.tip17 = "Är de oskylda ihopklumpade och svåra att ha ihjäl? Prova att använda Radion och spela upp C4-pip eller ljud av en skottlossning för att splittra gruppen."

L.tip18 = "Genom att använda Radion som Förrädare kan du spela upp ljud genom din Verktygs-meny efter att Radion har blivit placerad. Köa flera ljud genom att klicka på flera knappar i den ordning du vill att de ska spelas upp i."

L.tip19 = "Om du har krediter över kan du som Detektiv ge en Desarmerare till en oskyldig som du litar på. Då kan du spendera mer tid till att utreda och lämna den riskfulla bombdesarmeringen till dem."

L.tip20 = "Detektivernas Kikare tillåter likidentifiering från långa avstånd. Det är dåliga nyheter för Förrädarna, om de tänkte använda liket som lockbete. Å andra sidan är Detektiven distraherad och obeväpnad när han använder Kikaren..."

L.tip21 = "Detektivernas Hälsostation tillåter skadade spelare att återhämta sig. Å andra sidan kan de skadade spelarna vara Förrädare..."

L.tip22 = "Genom att använda DNA-skannern på Hälsostationen kan man få fram DNA-prov från alla som använt den."

L.tip23 = "Till skillnad från vapen och C4 lämnas inga DNA-spår på Radion, så Förrädare behöver inte oroa sig för att Detektiver hittar den och förstör deras dag."

L.tip24 = "Tryck på {helpkey} för att se en kort genomgång eller ändra några inställningar för TTT. Till exempel kan du stänga av dessa tips där för gott."

L.tip25 = "När en Detektiv söker igenom en kropp kan resultaten hittas för alla spelare på poängtavlan genom att klicka på den döde personens namn."

L.tip26 = "På poängtavlan betyder ett förstoringsglass bredvid någons namn att det finns sökinformation om den personen. Om ikonen är ljus kommer informationen från en Detektiv och kan innehålla mer information."

L.tip27 = "Som en Detektiv betyder ett förstoringsglas bredvid någons namn att kroppen har blivit genomsökt och att informationen finns tillgänglig för alla spelare via poängtavlan."

L.tip28 = "Åskådare kan trycka på {mutekey} för att rotera mellan alternativ för att tysta ned åskådare eller levande spelare."

L.tip29 = "If the server has installed additional languages, you can switch to a different language at any time in the Settings menu."

L.tip30 = "Snabbknappar eller 'radio-kommandon' kan användas genom att trycka på {zoomkey}."

L.tip31 = "Som en åskådare kan du trycka på {duckkey} för att låsa upp din muspekare och klicka på knapparna på den här panelen. Tryck på {duckkey} igen för att komma tillbaka till musstyrning."

L.tip32 = "Kofotens alternativa avfyrningsläge knuffar andra spelare."

L.tip33 = "Genom att använda siktet på vapnen kommer träffsäkerheten att höjas något och rekylen minskas. Att ducka gör ingen skillnad."

L.tip34 = "Rökgranater är effektiva inomhus, särskilt för att skapa förvirring i ett rum proppfullt med folk."

L.tip35 = "Som en Förrädare bör du komma ihåg att du kan gömma kroppar från oskyldiga och Detektivers snokande ögon."

L.tip36 = "En genomgång av spelläget finns tillgängligt under {helpkey}. I den finns en översikt över viktiga element i spelet."

L.tip37 = "På poängtavlan kan du klicka på någons namn och välja en tagg för dem, t.ex. 'misstänkt' eller 'vän'. Denna tagg dyker sedan upp om du siktar på spelaren."

L.tip38 = "Många placerbara verktyg (såsom C4, Radio) kan sättas fast på väggar genom att klicka på {secondaryfire}."

L.tip39 = "C4 som exploderar på grund av en misslyckad desarmering har mindre explosionsradie än en C4 där timern når noll."

L.tip40 = "Om det står 'HETSLÄGE' ovanför rundtimern kommer rundan först bara att vara några minuter lång, men efter varje oskyldig död kommer tiden att ökas. Det här läget pressar Förrädarna att göra någonting och inte bara stå still hela rundan."


--- Round report

L.report_title = "Rundrapport"

-- Tabs
L.report_tab_hilite = "Höjdpunkter"
L.report_tab_hilite_tip = "Rund-höjdpunkter"
L.report_tab_events = "Händelser"
L.report_tab_events_tip = "Händelseloggen om vad som hände den här rundan"
L.report_tab_scores = "Poäng"
L.report_tab_scores_tip = "Varje spelares poäng den här rundan"

-- Event log saving
L.report_save     = "Spara Log .txt"
L.report_save_tip = "Sparar Händelseloggen i en textfil"
L.report_save_error  = "Ingen Händelselogg-data att spara."
L.report_save_result = "Händelseloggen har sparats i:"

-- Big title window
L.hilite_win_traitors = "FÖRRÄDISK VINST"
L.hilite_win_innocent = "OSKYLDIG VINST"

L.hilite_players1 = "{numplayers} spelare deltog, {numtraitors} var förrädare"
L.hilite_players2 = "{numplayers} spelare deltog, en av dem var en förrädare"

L.hilite_duration = "Rundan pågick i {time}"

-- Columns
L.col_time   = "Tid"
L.col_event  = "Händelse"
L.col_player = "Spelare"
L.col_role   = "Roll"
L.col_kills1 = "Oskyldiga dödade"
L.col_kills2 = "Förrädare dödade"
L.col_points = "Poäng"
L.col_team   = "Lagbonus"
L.col_total  = "Totala poäng"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "någonting"

-- Kill events
L.ev_blowup      = "{victim} sprängde sig själv"
L.ev_blowup_trap = "{victim} sprängdes av {trap}"

L.ev_tele_self   = "{victim} dödade sig själv med teleportör"
L.ev_sui         = "{victim} pallade inte trycket och begick självmord"
L.ev_sui_using   = "{victim} dödade sig själv med {tool}"

L.ev_fall        = "{victim} föll till sin död"
L.ev_fall_pushed = "{victim} föll till sin död efter att {attacker} knuffat honom"
L.ev_fall_pushed_using = "{victim} föll till sin död efter att {attacker} använt {trap} för att knuffa honom"

L.ev_shot        = "{victim} blev skjuten av {attacker}"
L.ev_shot_using  = "{victim} blev skjuten av {attacker} med: {weapon}"

L.ev_drown       = "{victim} dränktes av {attacker}"
L.ev_drown_using = "{victim} dränktes av {trap}, aktiverad av {attacker}"

L.ev_boom        = "{victim} sprängdes av {attacker}"
L.ev_boom_using  = "{victim} sprängdes av {attacker} som använde {trap}"

L.ev_burn        = "{victim} grillades av {attacker}"
L.ev_burn_using  = "{victim} brändes av {trap} pga {attacker}"

L.ev_club        = "{victim} slogs ihjäl av {attacker}"
L.ev_club_using  = "{victim} blev ihjälslagen av {attacker} användandes {trap}"

L.ev_slash       = "{victim} blev ihjälstucken av {attacker}"
L.ev_slash_using = "{victim} blev styckad av {attacker} användandes {trap}"

L.ev_tele        = "{victim} blev dödad av {attacker}s teleportör"
L.ev_tele_using  = "{victim} blev atomiserad av {trap} som sattes upp av {attacker}"

L.ev_goomba      = "{victim} krossades under vikten av {attacker}"

L.ev_crush       = "{victim} krossades av {attacker}"
L.ev_crush_using = "{victim} krossades av {trap} som utlöstes av {attacker}"

L.ev_other       = "{victim} blev dödad av {attacker}"
L.ev_other_using = "{victim} blev dödad av {attacker} användandes {trap}"

-- Other events
L.ev_body        = "{finder} fann {victim}s lik"
L.ev_c4_plant    = "{player} placerade C4"
L.ev_c4_boom     = "C4 som placerades av {player} exploderade"
L.ev_c4_disarm1  = "{player} desarmerade C4 som placerades av {owner}"
L.ev_c4_disarm2  = "{player} misslyckades med att desarmera C4 som placerades av {owner}"
L.ev_credit      = "{finder} fann {num} kredit(er) på {player}s lik"

L.ev_start       = "Rundan började"
L.ev_win_traitor = "De usla förrädarna vann rundan!"
L.ev_win_inno    = "De älskvärda oskyldiga terroristerna vann rundan!"
L.ev_win_time    = "Förrädarna fick slut på tid och förlorade!"

--- Awards/highlights

L.aw_sui1_title = "Ledare av Själmordssekt"
L.aw_sui1_text  = "visade de andra självmördarna hur man gjorde genom att göra det själv först."

L.aw_sui2_title = "Ensam och Deprimerad"
L.aw_sui2_text  = "var den ende som begick självmord."

L.aw_exp1_title = "Explosivt Forskningsbidrag"
L.aw_exp1_text  = "vart erkänd för sin forskning kring explosioner. {num} försöksobjekt hjälpte till."

L.aw_exp2_title = "Fältforskning"
L.aw_exp2_text  = "provade sin motståndskraft mot explosioner. Den var inte tillräckligt hög."

L.aw_fst1_title = "Första Förräderiet"
L.aw_fst1_text  = "levererade det första oskyldiga mordet genom en förrädares händer."

L.aw_fst2_title = "Första Dumma DödandetFirst Bloody Stupid Kill"
L.aw_fst2_text  = "fick det första dödandet genom att skjuta en förrädarkamrat. Bra jobbat."

L.aw_fst3_title = "Första Tabben"
L.aw_fst3_text  = "var den första att döda. Synd att det var en oskyldig kamrat."

L.aw_fst4_title = "Första Slaget"
L.aw_fst4_text  = "slog det första slaget för de oskyldiga terroristerna genom att göra den första döden till en förrädares."

L.aw_all1_title = "Dödlig Bland Jämlikar"
L.aw_all1_text  = "var ansvarig för alla de oskyldigas dödande den här rundan."

L.aw_all2_title = "Ensamvarg"
L.aw_all2_text  = "var ansvarig för alla förrädarnas dödande den här rundan."

L.aw_nkt1_title = "Jag Fick En, Chefen!"
L.aw_nkt1_text  = "lyckades döda en enda oskyldig. Schysst!!"

L.aw_nkt2_title = "En Kula För Två"
L.aw_nkt2_text  = "visade att den första inte bara var tur genom att döda en till."

L.aw_nkt3_title = "Serie-Förrädare"
L.aw_nkt3_text  = "tog idag slut på tre oskyldiga terrorist-liv."

L.aw_nkt4_title = "En Varg i Fårakläder"
L.aw_nkt4_text  = "äter oskyldiga terrorister till middag. En middag bestående av {num} rätter."

L.aw_nkt5_title = "Kontra-Terroristisk Operation"
L.aw_nkt5_text  = "får betalt för varje dödad. Kan nu köpa ännu en lyxjakt."

L.aw_nki1_title = "Förräd detta"
L.aw_nki1_text  = "hittade en förrädare. Sköt en förrädare. Enkelt."

L.aw_nki2_title = "Ansökte till Rättvise-Patrullen"
L.aw_nki2_text  = "eskorterade två förrädare till den andra sidan."

L.aw_nki3_title = "Drömmer Förrädare Om Förrädiska Får?"
L.aw_nki3_text  = "hjälpte tre förrädare till sömns."

L.aw_nki4_title = "Anställd på Interna Affärer"
L.aw_nki4_text  = "får betalt för varje dödad. Kan nu beställa sin femte simbassäng."

L.aw_fal1_title = "Fia med Knuff"
L.aw_fal1_text  = "knuffade någon från en hög höjd."

L.aw_fal2_title = "Däckad"
L.aw_fal2_text  = "föll från en väldigt hög höjd."

L.aw_fal3_title = "Den Mänsklige Meteoriten"
L.aw_fal3_text  = "krossade en man med sin tyngd genom att falla på honom."

L.aw_hed1_title = "Effektivitet"
L.aw_hed1_text  = "upptäckte nöjet med huvudskott och utförde {num}."

L.aw_hed2_title = "Hjärnkirurg"
L.aw_hed2_text  = "avlägsnade {num} hjärnor från dess huvud för en närmare analys."

L.aw_hed3_title = "Jag Beskyller TV-Spelen"
L.aw_hed3_text  = "applicerade sin mordsimulerings-träning och placerade {num} dödliga huvudskott."

L.aw_cbr1_title = "Dunk Dunk Dunk"
L.aw_cbr1_text  = "har en riktig bra svingarm med kofoten, vilket {num} offer fick reda på."

L.aw_cbr2_title = "Martin Timell"
L.aw_cbr2_text  = "täckte sin kofot med inte mindre än {num} människors hjärnor."

L.aw_pst1_title = "Ihärdig Liten Rackare"
L.aw_pst1_text  = "dödade {num} spelare med hjälp av pistolen. Sedan gick han och kramade någon till döds."

L.aw_pst2_title = "Slakt Med Låg Kaliber"
L.aw_pst2_text  = "dödade en liten armé på {num} med en pistol. Förmodligen har han ett litet hagelgevär i mynningen."

L.aw_sgn1_title = "Lätt Som En Plätt"
L.aw_sgn1_text  = "applicerade haglet där det gör som mest skada, och dödade {num} mål på kuppen."

L.aw_sgn2_title = "Tusen Små Hagel"
L.aw_sgn2_text  = "gillade inte riktigt sitt hagel, så han gav bort allt. {num} mottagare levde inte länge nog för att ha kul med det."

L.aw_rfl1_title = "Peka och Klicka"
L.aw_rfl1_text  = "visar att allt du behöver för {num} döda är ett gevär och en stadig hand."

L.aw_rfl2_title = "Jag Kan Se Ditt Huvud Härifrån"
L.aw_rfl2_text  = "kände sitt gevär utan och innan. Nu känner {num} andra också hans till det."

L.aw_dgl1_title = "Gevär I Mini-Format"
L.aw_dgl1_text  = "börjar få grepp om sin Desert Eagle och dödade {num} människor."

L.aw_dgl2_title = "Deaglar'n"
L.aw_dgl2_text  = "blåste iväg {num} människor med sin handkanon."

L.aw_mac1_title = "Sikta(inte) och Skjut"
L.aw_mac1_text  = "dödade {num} människor med sin MAC10, men vägrar uppge hur många skott som krävdes."

L.aw_mac2_title = "Köttbullar med MACaroner"
L.aw_mac2_text  = "undrar vad som skulle hända om han kunde använda två MAC10 samtidigt. {num} gånger två?"

L.aw_sip1_title = "Var Tyst"
L.aw_sip1_text  = "fick tyst på {num} människor med den ljuddämpade pistolen."

L.aw_sip2_title = "Tyst Men Dödlig"
L.aw_sip2_text  = "dödade {num} människor som inte kunde höra sig själv dö."

L.aw_knf1_title = "Knivig Situation"
L.aw_knf1_text  = "stack någon i ansiktet över internet."

L.aw_knf2_title = "Var Hittade Du Den Där?"
L.aw_knf2_text  = "var inte en Förrädare, men lyckades ändå döda någon med en kniv."

L.aw_knf3_title = "En Knivig Situation"
L.aw_knf3_text  = "hittade {num} knivar, och gjorde det bästa med dem."

L.aw_knf4_title = "En Knivslug Man"
L.aw_knf4_text  = "dödade {num} människor med knivar. Fråga mig inte hur."

L.aw_flg1_title = "Till Undsättning"
L.aw_flg1_text  = "använde sin signalpistol till att signalera {num} mord."

L.aw_flg2_title = "Ingen Rök Utan Eld"
L.aw_flg2_text  = "lärde {num} män om faran med att ha lättantändliga kläder på sig."

L.aw_hug1_title = "HUGEnottkrig"
L.aw_hug1_text  = "gick ut i krig med sin H.U.G.E, och lyckades på något sätt skjuta ihjäl {num} människor."

L.aw_hug2_title = "Fett Mycket Para"
L.aw_hug2_text  = "hade väldigt många skott, och investerade dem i {num} människor."

L.aw_msx1_title = "Ett M16-Protokoll"
L.aw_msx1_text  = "prickade av {num} människor från listan med sin M16."

L.aw_msx2_title = "Galenskap På Medelavstånd"
L.aw_msx2_text  = "lyckades plocka ner {num} mål med sin M16."

L.aw_tkl1_title = "Aja-baja!"
L.aw_tkl1_text  = "slant med fingret när han siktade på en kompis."

L.aw_tkl2_title = "De Såg Ut Som Förrädare"
L.aw_tkl2_text  = "trodde att han lyckats döda en Förrädare två gånger, men hade fel båda gångerna."

L.aw_tkl3_title = "Låg Karma"
L.aw_tkl3_text  = "kunde inte sluta efter att ha dödat två medspelare. Hans turnummer är tre."

L.aw_tkl4_title = "Lagslakt"
L.aw_tkl4_text  = "mördade hela sitt lag. Lyckligtvis är han nog inte kvar så länge till."

L.aw_tkl5_title = "Rollspelare"
L.aw_tkl5_text  = "antog sig rollen som was roleplaying en blådåre. Det är därför han dödade merparten av sitt lag."

L.aw_tkl6_title = "Pucko"
L.aw_tkl6_text  = "förstod inte vilken sida han var på, så han dödade mer än hälften av sina lagkamrater."

L.aw_tkl7_title = "Bondlurk"
L.aw_tkl7_text  = "försvarade sin mark genom att döda mer än en fjärdedel av sitt lag."

L.aw_brn1_title = "Precis Som Mormors"
L.aw_brn1_text  = "grillade flera människor tills de fått en fin yta."

L.aw_brn2_title = "Leker Med Elden"
L.aw_brn2_text  = "lärde sig tydligen inte vad mamma lärt honom, vilket flera människor får sota för."

L.aw_brn3_title = "Pyrrhic Burnery"
L.aw_brn3_text  = "burned them all, but is now all out of incendiary grenades! How will he cope!?"

L.aw_fnd1_title = "Coroner"
L.aw_fnd1_text  = "found {num} bodies lying around."

L.aw_fnd2_title = "Gotta Catch Em All"
L.aw_fnd2_text  = "found {num} corpses for his collection."

L.aw_fnd3_title = "Death Scent"
L.aw_fnd3_text  = "keeps stumbling on random corpses, {num} times this round." 

L.aw_crd1_title = "Recycler"
L.aw_crd1_text  = "scrounged up {num} leftover credits from corpses." 

L.aw_tod1_title = "Pyrrhusseger"
L.aw_tod1_text  = "dog bara några sekunder innan hans lag vann rundan."

L.aw_tod2_title = "Jag Hatar Detta Spel"
L.aw_tod2_text  = "dog precis efter att rundan påbörjats."


--- New and modified pieces of text are placed below this point, marked with the
--- version or the date in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Undvik att bli vald som Detective"
L.set_avoid_det_tip = "Aktivera det här för att be servern att inte välja dig som Detective om möjligt. Betyder inte att du är Traitor oftare."
 
--- v24
L.drop_no_ammo = "Otillräcklig ammunition i vapnets klipp att släppa som en ammo låda."
 
--- v31
L.set_cross_brightness = "Hårkors ljushet"
L.set_cross_size = "Hårkors storlek"

--- 2015-05-25
L.hat_retrieve = "Du plockade upp hatten av en detektiv."
