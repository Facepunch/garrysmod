---- German language strings

local L = LANG.CreateLanguage("Deutsch")

--- General text used in various places
L.traitor    = "Verräter"
L.detective  = "Detektiv"
L.innocent   = "Unschuldig"
L.last_words = "Letzte Worte"

L.terrorists = "Terroristen"
L.spectators = "Zuschauer"

--- Round status messages
L.round_minplayers = "Zu wenig Spieler um eine neue Runde zu beginnen..."
L.round_voting     = "Es läuft eine Umfrage, verzögere neue Runde um {num} Sekunde(n)..."
L.round_begintime  = "Eine neue Runde beginnt in {num} Sekunde(n). Bereite dich vor."
L.round_selected   = "Die Verräter wurden ausgewählt."
L.round_started    = "Die Runde hat begonnen!"
L.round_restart    = "Ein Admin erzwang den Neustart der Runde."

L.round_traitors_one  = "Verräter, du bist alleine."
L.round_traitors_more = "Verräter, dies sind die Namen deiner Verbündeten: {names}"

L.win_time         = "Die Zeit ist abgelaufen. Die Verräter haben verloren."
L.win_traitor      = "Die Verräter haben gewonnen!"
L.win_innocent     = "Die Verräter wurden besiegt!"
L.win_showreport   = "Schauen wir uns den Rundenbericht die nächste(n) {num} Sekunde(n) an."

L.limit_round      = "Rundenlimit erreicht. {mapname} wird bald geladen."
L.limit_time       = "Zeitlimit erreicht. {mapname} wird bald geladen."
L.limit_left       = "{num} Runde(n) oder {time} Minute(n) verbleibend bis die Map zu {mapname} gewechselt wird."

--- Credit awards
L.credit_det_all   = "Detektive, euch wurde(n) {num} Ausrüstungs-Credit(s) für eure Leistung gegeben."
L.credit_tr_all    = "Verräter, euch wurde(n) {num} Ausrüstungs-Credit(s) für eure Leistung gegeben."

L.credit_kill      = "Dir wurde(n) {num} Credit(s) gegeben, da du einen {role} getötet hast."

--- Karma
L.karma_dmg_full   = "Dein Karma ist {amount}, also verteilst du diese Runde vollen Schaden!"
L.karma_dmg_other  = "Dein Karma ist {amount}. Daher ist dein Schaden um {num}% reduziert!"

--- Body identification messages
L.body_found       = "{finder} fand den Körper von {victim}. {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "Er war ein Verräter!"
L.body_found_d     = "Er war ein Detektiv."
L.body_found_i     = "Er war unschuldig."

L.body_confirm     = "{finder} bestätigte den Tod von {victim}."

L.body_call        = "{player} rief einen Detektiv zum Körper von {victim}!"
L.body_call_error  = "Du musst erst den Tod dieses Spielers bestätigen, bevor du einen Detektiv rufen kannst!"

L.body_burning     = "Autsch! Diese Leiche brennt lichterloh!"
L.body_credits     = "Du hast {num} Credit(s) an diesem Körper gefunden!"

--- Menus and windows
L.close  = "Schließen"
L.cancel = "Abbrechen"

-- For navigation buttons
L.next = "Weiter"
L.prev = "Zurück"

-- Equipment buying menu
L.equip_title     = "Ausrüstung"
L.equip_tabtitle  = "Ausrüstung bestellen"

L.equip_cost      = "Du hast {num} Credit(s) übrig."
L.equip_help_cost = "Jedes Ausrüstungsteil, das du kaufst, kostet 1 Credit."

L.equip_help_carry = "Du kannst nur das kaufen, für das du auch Platz hast."
L.equip_carry      = "Du kannst diese Ausrüstung tragen."
L.equip_carry_own  = "Du trägst dieses Teil bereits."
L.equip_carry_slot = "Du trägst bereits eine Waffe in Slot {slot}."

L.equip_help_stock = "Einige Teile kannst du nur einmal pro Runde kaufen."
L.equip_stock_deny = "Dieses Teil ist nicht länger vorrätig."
L.equip_stock_ok   = "Dieses Teil ist vorrätig."

L.equip_custom     = "Neues Teil durch den Server hinzugefügt."

L.equip_spec_name  = "Name"
L.equip_spec_type  = "Typ"
L.equip_spec_desc  = "Beschreibung"

L.equip_confirm    = "Ausrüstung kaufen"

-- Disguiser tab in equipment menu
L.disg_name      = "Tarnung"
L.disg_menutitle = "Tarnungs-Einstellungen"
L.disg_not_owned = "Du trägst keine Tarnung!"
L.disg_enable    = "Tarnung aktivieren"

L.disg_help1     = "Während deine Tarnung aktiv ist, werden dein Name, Leben und Karma nicht angezeigt, wenn dich jemand anschaut. Zusätzlich tauchst du nicht auf dem Radar des Detektivs auf."
L.disg_help2     = "Drücke Enter auf dem Numpad um die Tarnung an oder aus zu schalten, ohne das Menü zu nutzen. Du kannst alternativ 'ttt_toggle_diguise' durch die Konsole auf eine andere Taste legen."

-- Radar tab in equipment menu
L.radar_name      = "Radar"
L.radar_menutitle = "Radar-Einstellungen"
L.radar_not_owned = "Du trägst kein Radar!"
L.radar_scan      = "Scan durchführen"
L.radar_auto      = "Scan automatisch wiederholen"
L.radar_help      = "Scan-Ergebnisse werden {num} Sekunden angezeigt, danach ist das Radar wieder aufgeladen und kann erneut genutzt werden."
L.radar_charging  = "Dein Radar lädt immer noch auf!"

-- Transfer tab in equipment menu
L.xfer_name       = "Transfer"
L.xfer_menutitle  = "Credits transferieren"
L.xfer_no_credits = "Du kannst keine Credits abgeben!"
L.xfer_send       = "Sende einen Credit"
L.xfer_help       = "Du kannst Credits nur an weitere {role} senden."

L.xfer_no_recip   = "Der Empfänger ist ungültig, Credit-Transfer abgebrochen."
L.xfer_no_credits = "Ungenügend Credits für einen Transfer."
L.xfer_success    = "Credit-Transfer an {player} abgeschlossen."
L.xfer_received   = "{player} gab dir {num} Credit(s)."

-- Radio tab in equipment menu
L.radio_name      = "Radio"
L.radio_help      = "Drücke einen Knopf um das Radio den Ton abspielen zu lassen."
L.radio_notplaced = "Du musst das Radio platzieren um einen Ton abspielen zu lassen."

-- Radio soundboard buttons
L.radio_button_scream  = "Schrei"
L.radio_button_expl    = "Explosion"
L.radio_button_pistol  = "Pistolen-Schuss"
L.radio_button_m16     = "M16-Schuss"
L.radio_button_deagle  = "Deagle-Schuss"
L.radio_button_mac10   = "MAC10-Schuss"
L.radio_button_shotgun = "Shotgun-Schuss"
L.radio_button_rifle   = "Gewehr-Schuss"
L.radio_button_huge    = "H.U.G.E-Salve"
L.radio_button_c4      = "C4-Piepen"
L.radio_button_burn    = "Brennen"
L.radio_button_steps   = "Schritte"


-- Intro screen shown after joining
L.intro_help     = "Wenn du zum ersten Mal spielst, dann drücke F1 für Instruktionen!"

-- Radiocommands/quickchat
L.quick_title   = "Quickchat-Befehle"

L.quick_yes     = "Ja."
L.quick_no      = "Nein."
L.quick_help    = "Hilfe!"
L.quick_imwith  = "Ich bin bei {player}."
L.quick_see     = "Ich sehe {player}."
L.quick_suspect = "{player} verhält sich verdächtig."
L.quick_traitor = "{player} ist ein Verräter!"
L.quick_inno    = "{player} ist unschuldig."
L.quick_check   = "Lebt noch irgendjemand?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "niemand(en)"
L.quick_disg      = "jemand(en) in Tarnung"
L.quick_corpse    = "ein(en) unidentifizierten/r Körper"
L.quick_corpse_id = "{player}'s Leiche"


--- Body search window
L.search_title   = "Ergebnisse der Leichenuntersuchung"
L.search_info    = "Information"
L.search_confirm = "Tod bestätigen"
L.search_call    = "Detektiv rufen"

-- Descriptions of pieces of information found
L.search_nick   = "Dies ist der Körper von {player}."

L.search_role_t = "Diese Person war ein Verräter!"
L.search_role_d = "Diese Person war ein Detektiv."
L.search_role_i = "Diese Person war ein unschuldiger Terrorist!"

L.search_words  = "Etwas sagt dir, dass die letzten Worte dieser Person \"{lastwords}\" waren."
L.search_armor  = "Sie trug eine nicht-standardmäßige Körperrüstung."
L.search_disg   = "Sie trug ein Gerät, dass ihre Identität verstecken konnte."
L.search_radar  = "Sie trug eine Form eines Radars. Er funktioniert nicht länger."
L.search_c4     = "In der Tasche war eine Notiz. Sie besagt, dass das Durchschneiden des Drahtes {num} die Bombe sicher entschärfen wird."

L.search_dmg_crush  = "Viele Knochen des Opfers sind gebrochen. Es scheint, als habe der Einschlag eines schweren Objekts zum Tode geführt."
L.search_dmg_bullet = "Es ist offensichtlich, dass die Person erschossen wurde."
L.search_dmg_fall   = "Sie fiel in ihren Tod."
L.search_dmg_boom   = "Ihre Wunden und die versengte Kleidung weisen auf eine Explosion hin, die ihr ein Ende bereitet hat."
L.search_dmg_club   = "Der Körper ist ramponiert und verbeult. Die Person wurde mit Sicherheit zu Tode geprügelt."
L.search_dmg_drown  = "Der Körper zeigt Anzeichen und Symptome von Ertrinken."
L.search_dmg_stab   = "Sie wurde stark geschnitten und hatte tiefe Wunden und verblutete schlussendlich."
L.search_dmg_burn   = "Es riecht hier nach gerösteten Terroristen..."
L.search_dmg_tele   = "Es scheint, als sei ihre DNA durch Tachyonen verunstaltet worden!"
L.search_dmg_car    = "Als diese Person die Straße überquerte, wurde sie von einem rücksichtslosen Fahrer überrollt."
L.search_dmg_other  = "Du kannst keinen spezifischen Grund für den Tod dieser Person finden."

L.search_weapon = "Es scheint, als wurde ein(e) {weapon} benutzt um sie zu töten."
L.search_head   = "Die tödliche Wunde war ein Kopfschuss. Keine Zeit um zu schreien."
L.search_time   = "Sie wurde etwa {time} getötet, bevor du die Untersuchung begonnen hast."
L.search_dna    = "Erlange eine Probe der DNA des Mörders mit dem DNA-Scanner. Die DNA-Probe wird in etwa {time} verfallen."

L.search_kills1 = "Du fandest eine Liste an Tötungen, die den Tod von {player} beweist."
L.search_kills2 = "Du fandest eine Liste an Tötungen mit diesen Namen:"
L.search_eyes   = "Mit deinen Detektiv-Fähigkeiten identifizierst du die letzte Person, die sie sah: {player}. Der Mörder oder ein Zufall?"


-- Scoreboard
L.sb_playing    = "Du spielst auf..."
L.sb_mapchange  = "Die Karte wechselt in {num} Runden oder in {time}"

L.sb_mia        = "Vermisst"
L.sb_confirmed  = "Definitiv Tot"

L.sb_ping       = "Ping"
L.sb_deaths     = "Tode"
L.sb_score      = "Punkte"
L.sb_karma      = "Karma"

L.sb_info_help  = "Durchsuche den Körper des Spieler und du wirst hier die Ergebnisse lesen können."

L.sb_tag_friend = "FREUND"
L.sb_tag_susp   = "VERDÄCHTIG"
L.sb_tag_avoid  = "VERMEIDEN"
L.sb_tag_kill   = "TÖTEN"
L.sb_tag_miss   = "VERMISST"

--- Help and settings menu (F1)

L.help_title = "Hilfe und Einstellungen"

-- Tabs
L.help_tut     = "Anleitung"
L.help_tut_tip = "Wie TTT funktioniert, in 6 Schritten"

L.help_settings     = "Einstellungen"
L.help_settings_tip = "Spielerseitige Einstellungen"

-- Settings
L.set_title_gui = "Anzeigeeinstellungen"

L.set_tips      = "Zeige Tipps zum Spiel während des Zuschauens am unteren Bildschirmrand"

L.set_startpopup     = "Dauer des Popups mit Infos am Anfang einer Runde"
L.set_startpopup_tip = "Wenn eine Runde startet, öffnet sich ein kleines Popup am unteren Ende des Bildschirms für ein paar Sekunden. Ändere die Dauer dafür hier."

L.set_cross_opacity   = "Transparenz des Fadenkreuzes"
L.set_cross_disable   = "Deaktiviere das Fadenkreuz komplett"
L.set_minimal_id      = "Minimale Ziel ID unter dem Fadenkreuz (kein Karmatext, Hinweise, etc.)"
L.set_healthlabel     = "Zeige den Status der Gesundheit auf der Gesundheitsanzeige"
L.set_lowsights       = "Senke Waffe beim Zielen durch Kimme und Korn"
L.set_lowsights_tip   = "Aktiviere, dass die Waffe beim Zielen mit Kimme und Korn gesenkt wird. Dies erleichtert das Anvisieren eines Gegners, aber sieht unrealistischer aus."
L.set_fastsw          = "Schneller Waffenwechsel"
L.set_fastsw_tip      = "Ermögliche es durch die Waffen zu wechseln ohne das Waffenwechselmenü zu öffnen. Aktiviere das Menü, damit das Waffenwechselmenü angezeigt wird."
L.set_fastsw_menu     = "Aktiviert das Waffenwechselmenü, selbst wenn der schnelle Waffenwechsel aktiv ist."
L.set_fastswmenu_tip  = "Wenn der schnelle Waffenwechsel aktiv ist, wird das Waffenwechselmenü angezeigt."
L.set_wswitch         = "Verhindere das automatische Schließen des Waffenwechselmenüs."
L.set_wswitch_tip     = "Normalerweise schließt das Waffenwechselmenü automatisch nach ein paar Sekunden, nachdem du zuletzt gescrollet hast. Aktiviere dies, damit es geöffnet bleibt."
L.set_cues            = "Spiele einen Ton ab, wenn eine Runde beginnt oder endet"


L.set_title_play    = "Spieleinstellungen"

L.set_specmode      = "Zuschauer-Modus (bleibe immer Zuschauer)"
L.set_specmode_tip  = "Der Zuschauer-Modus verhindert, dass du bei einer neuen Runde wieder einsteigst. Stattdessen bleibst du Zuschauer."
L.set_mute          = "Stelle lebende Spieler stumm, wenn du tot bist"
L.set_mute_tip      = "Aktiviere dies, um lebende Spieler stumm zu stellen, während du tot bist oder zuschaust."


L.set_title_lang    = "Spracheinstellungen"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "Wähle eine Sprache (Select language):"


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "Diese Waffe ist nicht mehr vorrätig: Du hast sie bereits gekauft."
L.buy_pending     = "Du hast bereits eine Bestellung aufgegeben, warte bis du sie erhältst."
L.buy_received    = "Du hast deine Spezialausrüstung erhalten."

L.drop_no_room    = "Du hast hier keinen Platz um deine Waffe fallen zu lassen!"

L.disg_turned_on  = "Tarnung aktiviert!"
L.disg_turned_off = "Tarnung deaktiviert!"

-- Equipment item descriptions
L.item_passive    = "Gegenstand mit passivem Effekt"
L.item_active     = "Aktiv einsetzbarer Gegenstand"
L.item_weapon     = "Waffe"

L.item_armor      = "Körperrüstung"
L.item_armor_desc = [[
Verringere den Schaden durch Kugeln um 30%.

Standardausrüstung für Detektive.]]

L.item_radar      = "Radar"
L.item_radar_desc = [[
Dies erlaubt dir nach Lebenszeichen zu scannen.
Es startet automatisch beim Kauf.
Stelle es im Reiter "Radar" dieses Menüs ein.]]

L.item_disg       = "Tarnung"
L.item_disg_desc  = [[
Versteckt deine ID. Vermeidet außerdem, dass du die
Person bist, die als letztes vom Opfer gesehen wurde.

Schalte es im Reiter "Tarnung" ein oder aus
oder drücke Enter auf dem Numpad.]]

-- C4
L.c4_hint         = "Drücke {usekey} zum scharf stellen oder entschärfen."
L.c4_no_disarm    = "Du kannst das C4 eines anderen Verräters nicht entfernen, bevor dieser nicht tot ist."
L.c4_disarm_warn  = "Eine Ladung C4, die du platziert hast, ist entschärft worden."
L.c4_armed        = "Du hast die Bombe erfolgreich scharf gestellt."
L.c4_disarmed     = "Du hast die Bombe erfolgreich entschärft."
L.c4_no_room      = "Du kannst dieses C4 nicht tragen."

L.c4_desc         = "Starke Zeitbombe."

L.c4_arm          = "C4 scharf machen"
L.c4_arm_timer    = "Zünder"
L.c4_arm_seconds  = "Sekunden bis zur Detonation:"
L.c4_arm_attempts = "Beim Versuch die Bombe zu entschärfen, lösen {num} der 6 Kabel eine sofortige Detonation beim Durchschneiden aus."

L.c4_remove_title    = "Entfernen"
L.c4_remove_pickup   = "C4 aufheben"
L.c4_remove_destroy1 = "C4 vernichten"
L.c4_remove_destroy2 = "Bestätigen: Vernichten"

L.c4_disarm       = "C4 entschärfen"
L.c4_disarm_cut   = "Klicke zum Durchschneiden von Kabel {num}"

L.c4_disarm_t     = "Durchschneide ein Kabel zum Entschärfen der Bombe. Wenn du Verräter bist, ist jedes Kabel sicher. Unschuldige haben es da nicht so einfach!"
L.c4_disarm_owned = "Durchschneide ein Kabel zum Entschärfen der Bombe. Es ist deine Bombe, also wird jedes Kabel sie sicher entschärfen."
L.c4_disarm_other = "Durchschneide das richtige Kabel, um die Bombe zu entschärfen. Sie explodiert, wenn du das falsche triffst!"

L.c4_status_armed    = "SCHARF"
L.c4_status_disarmed = "ENTSCHÄRFT"

-- Visualizer
L.vis_name        = "Visualisierer"
L.vis_hint        = "Drücke {usekey} zum Aufheben (nur Detektive)."

L.vis_help_pri    = "{primaryfire} lässt das aktivierte Gerät fallen."

L.vis_desc        = [[
Tatort-Visualisierungs-Gerät.

Analysiere eine Leiche um zu sehen,
wie die Person umgebracht wurde, funktioniert
nur bei Tod durch Beschuss.]]

-- Decoy
L.decoy_name      = "Attrappe"
L.decoy_no_room   = "Du kannst diese Attrappe nicht tragen."
L.decoy_broken    = "Deine Attrappe wurde zerstört!"

L.decoy_help_pri  = "{primaryfire} platziert die Attrappe."
L.decoy_desc      = [[
Zeigt Detektiven ein gefälschtes Radar-Signal
und bewirkt, dass der DNA-Scanner den
Ort der Attrappe zeigt, wenn sie nach deiner
DNA suchen.]]

-- Defuser
L.defuser_name    = "Entschärfer"
L.defuser_help    = "{primaryfire} entschärft anvisiertes C4."
L.defuser_desc    = [[
Entschärft sofort eine C4-Bombe.

Unbegrenzt nutzbar. C4 wird leichter zu entdecken
sein, wenn du das bei dir trägst.]]

-- Flare gun
L.flare_name      = "Leuchtkanone"
L.flare_desc      = [[
Kann benutzt werden, um Leichen zu verbrennen,
damit sie nie gefunden werden können.
Begrenzte Munition.
Das Verbrennen einer Leiche macht ein ganz
bestimmtes Geräusch.]]

-- Health station
L.hstation_name   = "Gesundheitsstation"
L.hstation_hint   = "Drücke {usekey} um Leben zu regenerieren. Ladung: {num}."
L.hstation_broken = "Deine Gesundheitsstation wurde zerstört!"
L.hstation_help   = "{primaryfire} platziert die Gesundheitsstation."

L.hstation_desc   = [[
Ermöglicht bei Platzierung, dass sich jeder Spieler
an ihr heilen kann. Langsame Wiederaufladung,
kann beschädigt werden.
Am Gerät sind DNA-Spuren ihrer Benutzer zu finden.]]

-- Knife
L.knife_name      = "Messer"
L.knife_thrown    = "Geworfenes Messer"

L.knife_desc      = [[
Tötet verletzte Ziele sofort und leise,
kann aber nur ein Mal genutzt werden.

Kann mit alternativer Feuertaste geworfen werden.]]

-- Poltergeist
L.polter_desc     = [[
Platziert Beschleuniger an Objekte um sie wild
herumwirbeln zu lassen.

Die Energiespitzen schädigen nahestehende Spieler.]]

-- Radio
L.radio_broken    = "Dein Radio wurde zerstört!"
L.radio_help_pri  = "{primaryfire} platziert das Radio."

L.radio_desc      = [[
Spielt Geräusche zur Ablenkung ab.

Platziere das Radio irgendwo und spiele
Geräusche im Reiter "Radio" dieses Menüs ab.]]

-- Silenced pistol
L.sipistol_name   = "Schallgedämpfte Pistole"

L.sipistol_desc   = [[
Handfeuerwaffe mit geringer Lautstärke,
nutzt normale Pistolenmunition.

Opfer schreien nicht, wenn sie damit getötet werden.]]

-- Newton launcher
L.newton_name     = "Newton Launcher"

L.newton_desc     = [[
Stoße Spieler aus einer sicheren Entfernung.

Unbegrenzt Munition, aber langsame Schussfolge.]]

-- Binoculars
L.binoc_name      = "Fernglas"

L.binoc_desc      = [[
Zoome an eine Leiche heran um sie aus einer
großen Entfernung zu identifizieren.

Unbegrenzt nutzbar, aber das Identifizieren dauert
einige Sekunden.]]

L.binoc_help_pri  = "{primaryfire} identifiziert einen Körper."
L.binoc_help_sec  = "{secondaryfire} ändert Zoom-Level."

-- UMP
L.ump_desc        = [[
Experimentelles SMG, das Ziele desorientiert.

Nutzt normale SMG Munition.]]

-- DNA scanner
L.dna_name        = "DNA-Scanner"
L.dna_identify    = "Die Leiche muss identifiziert sein, um die DNA des Mörders zu erhalten."
L.dna_notfound    = "Keine Spuren von DNA am Ziel gefunden."
L.dna_limit       = "Speicherlimit erreicht. Entferne alte Spuren, um neue hinzuzufügen."
L.dna_decayed     = "Die DNA-Spur des Mörders ist verfallen."
L.dna_killer      = "Es wurde eine DNA-Spur des Mörders von der Leiche aufgesammelt!"
L.dna_no_killer   = "Die DNA konnte nicht erlangt werden (Mörder vom Server gegangen?)."
L.dna_armed       = "Die Bombe ist scharf! Entschärfe sie zuerst!"
L.dna_object      = "{num} neue DNA-Spuren von diesem Objekt aufgesammelt."
L.dna_gone        = "DNA nicht in diesem Bereich gefunden."

L.dna_desc        = [[
Sammelt DNA-Spuren von Objekten auf
und wird genutzt, um den Besitzer dieser ausfindig zu machen.

Kann an frischen Leichen verwendet werden, um die DNA
des Mörders zu erhalten und um ihn aufzuspüren.]]

L.dna_menu_title  = "DNA-Scan-Einstellungen"
L.dna_menu_sample = "DNA-Spuren an {source} gefunden"
L.dna_menu_remove = "Ausgewählte entfernen"
L.dna_menu_help1  = "Dies sind die DNA-Spuren, die du gesammelt hast."
L.dna_menu_help2  = [[
Wenn geladen, kannst du den Ort desjenigen ausfindig machen,
zu dem die DNA-Probe gehört..
Je weiter das Ziel entfernt ist, desto mehr Energie wird gebraucht.]]

L.dna_menu_scan   = "Scannen"
L.dna_menu_repeat = "Auto-Wiederholen"
L.dna_menu_ready  = "BEREIT"
L.dna_menu_charge = "AUFLADEN"
L.dna_menu_select = "PROBE WÄHLEN"

L.dna_help_primary   = "{primaryfire} um eine DNA-Probe zu entnehmen"
L.dna_help_secondary = "{secondaryfire} um die Scaneinstellungen zu öffnen"

-- Magneto stick
L.magnet_name     = "Magneto-Stick"
L.magnet_help     = "{primaryfire} um Körper an Oberfläche anzubinden."

-- Grenades and misc
L.grenade_smoke   = "Rauchgranate"
L.grenade_fire    = "Brandgranate"

L.unarmed_name    = "Unbewaffnet"
L.crowbar_name    = "Brecheisen"
L.pistol_name     = "Pistole"
L.rifle_name      = "Gewehr"
L.shotgun_name    = "Schrotgewehr"

-- Teleporter
L.tele_name       = "Teleporter"
L.tele_failed     = "Teleport fehlgeschlagen."
L.tele_marked     = "Teleportstelle markiert."

L.tele_no_ground  = "Kann nur auf solidem Untergrund teleportieren!"
L.tele_no_crouch  = "Kann nicht geduckt teleportieren!"
L.tele_no_mark    = "Keine Stelle markiert. Markiere ein Ziel vor dem Teleportieren."

L.tele_no_mark_ground = "Kann keine Teleportstelle markieren, während man nicht auf solidem Untergrund steht!"
L.tele_no_mark_crouch = "Kann keine Teleportstelle markieren, während man geduckt ist!"

L.tele_help_pri   = "{primaryfire} teleportiert dich zur markierten Stelle."
L.tele_help_sec   = "{secondaryfire} markiert momentane Position."

L.tele_desc       = [[
Teleportiert dich zu einer zuvor markierten Stelle.

Das Teleportieren macht Geräusche und die Anzahl der
Benutzungen ist begrenzt.]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "9mm Munition"

L.ammo_smg1       = "SMG Munition"
L.ammo_buckshot   = "Shotgun Munition"
L.ammo_357        = "Gewehr Munition"
L.ammo_alyxgun    = "Deagle Munition"
L.ammo_ar2altfire = "Leucht Munition"
L.ammo_gravity    = "Poltergeist Munition"


--- HUD interface text

-- Round status
L.round_wait   = "Warte..."
L.round_prep   = "Vorbereitung"
L.round_active = "Läuft"
L.round_post   = "Runde vorbei"

-- Health, ammo and time area
L.overtime     = "VERLÄNGERUNG"
L.hastemode    = "HAST MODUS"

-- TargetID health status
L.hp_healthy   = "Gesund"
L.hp_hurt      = "Verletzt"
L.hp_wounded   = "Verwundet"
L.hp_badwnd    = "Schwer Verwundet"
L.hp_death     = "Dem Tode nah"


-- TargetID karma status
L.karma_max    = "Verlässlich"
L.karma_high   = "Grob"
L.karma_med    = "Schießwütig"
L.karma_low    = "Gefährlich"
L.karma_min    = "Verantwortungslos"

-- TargetID misc
L.corpse       = "Leiche"
L.corpse_hint  = "Drücke {usekey} zum Durchsuchen. {walkkey} + {usekey} um verdeckt zu untersuchen."

L.target_disg  = " (GETARNT)"
L.target_unid  = "Unidentifizierter Körper"

L.target_traitor   = "VERRÄTER-KOLLEGE"
L.target_detective = "DETEKTIV"

L.target_credits = "Durchsuche, um ungenutzte Credits zu erhalten."

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single  = "Einmaliger Gebrauch"
L.tbut_reuse   = "Wiederverwendbar"
L.tbut_retime  = "Wiederverwendbar nach {num} Sekunden"
L.tbut_help    = "Drücke {key} zum Aktivieren"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "Getarnt. Dein Name ist ausgeblendet."
L.radar_hud    = "Radar bereit für nächsten Scan in: {time}"

-- Spectator muting of living/dead
L.mute_living  = "Lebende stumm gestellt"
L.mute_specs   = "Zuschauer stumm gestellt"
L.mute_all     = "Jeden stumm gestellt"
L.mute_off     = "Niemanden stumm gestellt"

-- Spectators and prop possession
L.punch_title  = "PUNCH-O-METER"
L.punch_help   = "Die Bewegungstasten oder Springen: Objekt bewegen. Ducken: Objekt verlassen."
L.punch_bonus  = "Deine schlechte Punktzahl hat dein Punch-O-Meter Limit um {num} verringert."
L.punch_malus  = "Deine gute Punktzahl hat dein Punch-O-Meter Limit um {num} erhöht!"

L.spec_help    = "Klicke um Spielern zu zuschauen, oder drücke {usekey} auf ein physikalisches Objekt um die Kontrolle zu erhalten."

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[Du bist ein unschuldiger Terrorist!
Aber es gibt Verräter… Wem kannst du trauen, und wem füllst du den Körper mit Blei?
Gib Acht und arbeite mit anderen zusammen um zu überleben!]]

L.info_popup_detective = [[Du bist ein Detektiv! Das Terroristen Hauptquartier hat dir spezielle Ressourcen gegeben um die Verräter zu finden.
Benutze sie um den Unschuldigen zu helfen, aber sei auf der Hut: Die Verräter werden zusehen dich als erstes zu töten!

Drücke {menukey} für neue Ausrüstung!]]

L.info_popup_traitor_alone = [[Du bist ein VERRÄTER! Du hast keine weiteren Verräter diese Runde.
Töte ALLE anderen um zu gewinnen!

Drücke {menukey} um den Verräter Shop zu öffnen!]]

L.info_popup_traitor = [[Du bist VERRÄTER! Arbeite mit deinen Verräter Kollegen um alle anderen Terroristen zu töten.
Aber sei vorsichtig, damit dein Verrat nicht aufgedeckt wird...

Das sind deine Kollegen:
{traitorlist}

Drücke {menukey} um den Verräter Shop zu öffnen!]]

--- Various other text
L.name_kick = "Ein Spieler wurde automatisch gekickt, weil er seinen Namen während einer laufenden Runde geändert hat."

L.idle_popup = [[Du warst für {num} Sekunden untätig und wurdest in den Zuschauer-Modus gesetzt. Währenddessen ist es dir nicht möglich, an einer neuen Runde teilzunehmen.

Du kannst den Zuschauer-Modus ausschalten, indem du {helpkey} drückst und den Haken in den Einstellungen entfernst. Du kannst ihn aber auch jetzt ausschalten.]]

L.idle_popup_close = "Nichts tun"
L.idle_popup_off   = "Deaktiviere Zuschauer-Modus"

L.idle_warning = "Warnung: Du scheinst AFK zu sein und wirst zum Zuschauer, außer du zeigst Aktivität!"

L.spec_mode_warning = "Du bist im Zuschauermodus und wirst nicht spielen, wenn eine Runde beginnt. Um diesen Modus zu verlassen, drücke F1, gehe in die Einstellungen und nimm den Haken bei ‘Zuschauer-Modus’ raus."


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "Tipps"
L.tips_panel_tip   = "Tipp:"

-- Tip texts

L.tip1 = "Verräter können eine Leiche durch Halten von {walkkey} und Drücken von {usekey} verdeckt untersuchen, ohne ihren Tod zu bestätigen."

L.tip2 = "Das Scharfmachen einer C4 Bombe mit längerem Zünder erhöht die Anzahl an Kabeln, die zu einer sofortigen Detonation führen, wenn ein Unschuldiger versucht es zu entschärfen. Außerdem piepst sie leiser und seltener."

L.tip3 = "Detektive können Leichen untersuchen um herauszufinden, wer ‘in den Augen gespiegelt’ wurde. Das ist die letzte Person, die der Tote sah. Das muss nicht der Mörder sein, wenn er von hinten erschossen wurde."

L.tip4 = "Niemand wird von deinem Tod erfahren, bis jemand deine Leiche gefunden und untersucht hat."

L.tip5 = "Wenn ein Verräter einen Detektiv tötet, erlangen diese direkt einen Credit als Belohnung."

L.tip6 = "Wenn ein Verräter von einem Detektiv getötet wird, erhalten alle Detektive einen Credit."

L.tip7 = "Wenn Verräter einen guten Fortschritt beim Töten von Unschuldigen gemacht haben, erhalten sie als Belohnung einen Credit."

L.tip8 = "Verräter und Detektive können unverbrauchte Credits von Leichen anderer Verräter oder Detektive aufsammeln."

L.tip9 = "Der Poltergeist kann physikalische Objekte in tödliche Projektile verwandeln. Jeder Schlag ist begleitet von einem Energieimpuls, der jeden in der Nähe verletzt."

L.tip10 = "Halte als Verräter auf rote oder als Detektiv auf blaue Nachrichten in der oberen rechten Bildschirmecke Ausschau. Diese sind wichtig für dich."

L.tip11 = "Behalte als Verräter oder Detektiv im Kopf, dass du Credits verdienst, wenn deine Partner gut arbeiten. Vergiss nicht diese auch auszugeben!"

L.tip12 = "Der DNA-Scanner des Detektivs kann genutzt werden um DNA-Proben von Waffen und Objekten zu erhalten. Diese können zum Scannen benutzt werden um die Position des Spielers herauszufinden, der diese benutzt hat. Nützlich, wenn du eine Probe von einer Leiche oder einer entschärften Ladung C4 erhalten hast!"

L.tip13 = "Wenn du in der Nähe von jemandem standest, den du getötet hast, hinterlässt du deine DNA auf der Leiche. Diese DNA kann ein Detektiv mit seinem DNA-Scanner untersuchen um deine momentane Position herauszufinden. Es wäre besser wenn du die Leiche versteckst, nachdem du jemanden mit dem Messer getötet hast!"

L.tip14 = "Je weiter du dich von der Leiche entfernst, an der deine DNA hängt, dest schneller verschwindet die DNA Spur."

L.tip15 = "Du bist Verräter und gehst snipen? Du solltest in Betracht ziehen eine Tarnung zu kaufen. Wenn du verfehlst, renn' an einen sicheren Ort und deaktiviere deine Tarnung. Niemand wird wissen, dass du es warst, der auf sie schießen wollte."

L.tip16 = "Der Teleporter kann dir als Verräter helfen zu entkommen oder dich schnell auf der Karte zu bewegen. Stelle sicher, dass du stets einen sicheren Punkt hast, zu dem du dich teleportieren kannst."

L.tip17 = "Stehen die Unschuldigen alle zusammen und sind schwer einzeln zu erledigen? Schnapp' dir das Radio, spiel Sounds von C4 oder Schüssen ab um sie wegzulocken."

L.tip18 = "Du kannst mit dem platzierten Radio als Verräter Sounds im Ausrüstungsmenü abspielen. Du kannst mehrere Sounds hintereinander in Warteschlange geben, indem du sie in der Reihenfolge anklickst, in der sie gespielt werden sollen."

L.tip19 = "Wenn du als Detektiv Credits übrig hast, kannst du deinen Entschärfer an einen glaubwürdigen Unschuldigen abgeben, dich um Wichtigeres kümmern und ihm den gefährlichen Job des Entschärfens überlassen."

L.tip20 = "Das Fernglas der Detektive kann Leichen aus großer Distanz untersuchen. Schlechte Nachrichten für die Verräter, wenn die die Leiche als Lockmittel nutzen wollten. Allerdings ist der Detektiv währenddessen unbewaffnet und abgelenkt..."

L.tip21 = "Die Gesundheitsstation der Detektive lässt verwundeten Spielern zu, sich zu heilen. Natürlich könnten diese verwundeten Spieler auch Verräter sein..."

L.tip22 = "Die Gesundheitsstation zeichnet die DNA jedes Spielers auf, der diese benutzt. Detektive können somit herausfinden, wer mit der Station bereits Lebenspunkte wiederhergestellt hat."

L.tip23 = "Anders als bei Waffen und C4 bleibt keine DNA des Platzierers auf einem Radio. Mach dir also keine Sorge darüber, ob Detektive dein Radio finden."

L.tip24 = "Drücke {helpkey} um ein kurzes Tutorium anzuzeigen und einige TTT-spezifische Einstellungen zu ändern. Du kannst beispielsweise diese Tipps hier deaktivieren."

L.tip25 = "Wenn ein Detektiv einen Körper untersucht, dann sind die Ergebnisse für alle Spieler durch Klicken auf den Spielernamen im Scoreboard sichtbar."

L.tip26 = "Eine Lupe weist im Scoreboard darauf hin, dass es Untersuchungsergebnisse für diese Person gibt. Wenn das Symbol hell ist, dann kommen die Daten von einem Detektiv und können noch mehr Informationen enthalten."

L.tip27 = "Als Detektiv wird eine Lupe neben dem Namen einer Leiche angezeigt, was bedeutet, dass diese von einem Detektiv untersucht wurde. Die Ergebnisse sind für alle im Scoreboard verfügbar."

L.tip28 = "Zuschauer können {mutekey} drücken um durch die Stummschaltmodi von anderen Zuschauern oder lebenden Spielern zu schalten."

L.tip29 = "Wenn der Server zusätzliche Sprachen installiert hat, kannst du diese jederzeit im Einstellungsmenü aufrufen."

L.tip30 = "Schnellkommunikation oder 'radio' Kommandos können durch Drücken von {zoomkey} genutzt werden."

L.tip31 = "Als Zuschauer, drücke {duckkey} um deinen Mauszeiger zu aktivieren und klicke auf die Schaltflächen in diesem Hinweis-Fenster. Drücke {duckkey} erneut, um die Maussicht wieder zu aktivieren."

L.tip32 = "Das Sekundärfeuer der Brechstange schubst andere Spieler weg."

L.tip33 = "Das Schießen, während du mit Kimme und Korn zielst, erhöht deine Präzision leicht und verringert den Rückstoß beim Schießen. Ducken tut dies nicht."

L.tip34 = "Rauchgranaten sind innerhalb von Räumen effektiv. Speziell um Verwirrung zwischen vielen Leuten zu schaffen."

L.tip35 = "Als Verräter, denke daran, dass du die Leichen wegschleppen und vor den Stielaugen der Unschuldigen und der Detektive verstecken kannst und auch solltest."

L.tip36 = "Das Tutorial ist unter {helpkey} verfügbar und beinhaltet eine Übersicht der wichtigsten Tastenbelegungen des Spiels."

L.tip37 = "Auf dem Scoreboard kannst du auf die Namen der lebendigen Spieler klicken und ihnen Markierungen setzen, wie zum Beispiel 'Verdächtig' oder 'Freund'. Diese Markierungen erscheinen, wenn du den markierten Spieler anvisierst."

L.tip38 = "Viele der platzierbaren Ausrüstungsgegenstände (wie zum Beispiel C4 oder das Radio) können mit einem Druck auf die Sekundärfeuertaste an Wänden befestigt werden."

L.tip39 = "C4, das beim Entschärfen ungewollt gezündet wird, hat eine geringere Detonationskraft als solches, bei dem die gesamte Zeit abläuft."

L.tip40 = "Wenn 'HAST MODUS' über der Rundenzeit zu lesen ist, dauert die Runde zunächst nur wenige Minuten länger, wird jedoch mit jedem Tod weiter und weiter verlängert. Dieser Modus übt Druck auf die Verräter aus und sorgt dafür, dass sie sich nicht alle Zeit der Welt nehmen können."


--- Round report

L.report_title = "Rundenbericht"

-- Tabs
L.report_tab_hilite = "Höhepunkte"
L.report_tab_hilite_tip = "Höhepunkte dieser Runde"
L.report_tab_events = "Ereignis"
L.report_tab_events_tip = "Liste der Ereignisse dieser Runde"
L.report_tab_scores = "Punkte"
L.report_tab_scores_tip = "Punkte pro Spieler in dieser Runde"

-- Event log saving
L.report_save     = "Speichere Log .txt"
L.report_save_tip = "Speichert den Ereignis-Log in einer Textdatei"
L.report_save_error  = "Keine Ereignis-Log Daten vorhanden."
L.report_save_result = "Der Ereignis-Log wurde gespeichert:"

-- Big title window
L.hilite_win_traitors = "VERRATEN!"
L.hilite_win_innocent = "ÜBERLEBT!"

L.hilite_players1 = "{numplayers} Spieler nahmen teil, davon waren {numtraitors} Verräter."
L.hilite_players2 = "{numplayers} Spieler nahmen teil, einer war ein Verräter."

L.hilite_duration = "Die Runde dauerte {time}."

-- Columns
L.col_time   = "Dauer"
L.col_event  = "Ereignis"
L.col_player = "Spieler"
L.col_role   = "Rolle"
L.col_kills1 = "Unschuldige Kills"
L.col_kills2 = "Verräter Kills"
L.col_points = "Punkte"
L.col_team   = "Team Bonus"
L.col_total  = "Gesamtpunktzahl"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "etwas"

-- Kill events
L.ev_blowup      = "{victim} jagte sich selbst in die Luft"
L.ev_blowup_trap = "{victim} wurde durch {trap} in die Luft gejagt"

L.ev_tele_self   = "{victim} telefragged sich selbst"
L.ev_sui         = "{victim} hielt es nicht mehr aus und brachte sich um"
L.ev_sui_using   = "{victim} brachte sich mit {tool} um"

L.ev_fall        = "{victim} fiel in den Tod"
L.ev_fall_pushed = "{victim} fiel in den Tod nachdem {attacker} ihn schuppste"
L.ev_fall_pushed_using = "{victim} fiel in den Tod nachdem {attacker} {trap} benutzte, um ihn zu schubsen"

L.ev_shot        = "{victim} wurde von {attacker} erschossen"
L.ev_shot_using  = "{victim} wurde von {attacker} mit einer/m {weapon} erschossen"

L.ev_drown       = "{victim} wurde von {attacker} ertränkt"
L.ev_drown_using = "{victim} wurde durch {trap} von {attacker} ertränkt"

L.ev_boom        = "{victim} wurde von {attacker} gesprengt"
L.ev_boom_using  = "{victim} wurde von {attacker} durch {trap} gesprengt"

L.ev_burn        = "{victim} wurde von {attacker} verbrannt"
L.ev_burn_using  = "{victim} wurde durch {trap} von {attacker} verbrannt"

L.ev_club        = "{victim} wurde von {attacker} zu Tode geprügelt"
L.ev_club_using  = "{victim} wurde von {attacker} durch/mit {trap} zu Tode geprügelt"

L.ev_slash       = "{victim} wurde von {attacker} erstochen"
L.ev_slash_using = "{victim} wurde von {attacker} durch/mit {trap} aufgeschlitzt"

L.ev_tele        = "{victim} wurde von {attacker} telefragged"
L.ev_tele_using  = "{victim} wurde atomisiert durch {trap} von {attacker}"

L.ev_goomba      = "{victim} wurde unter der Masse von {attacker} zerquetscht"

L.ev_crush       = "{victim} wurde von {attacker} zerquetscht"
L.ev_crush_using = "{victim} wurde durch {trap} von {attacker} zerquetscht"

L.ev_other       = "{victim} wurde von {attacker} getötet"
L.ev_other_using = "{victim} wurde von {attacker} durch {trap} getötet"

-- Other events
L.ev_body        = "{finder} hat den Leichnam von {victim} gefunden"
L.ev_c4_plant    = "{player} legte C4"
L.ev_c4_boom     = "Das C4, gelegt von {player}, explodierte"
L.ev_c4_disarm1  = "{player} hat das C4 von {owner} entschärft"
L.ev_c4_disarm2  = "{player} hat beim Entschärfen des C4s von {owner} versagt"
L.ev_credit      = "{finder} fand {num} Credit(s) beim Leichnam von {player}"

L.ev_start       = "Die Runde hat begonnen"
L.ev_win_traitor = "Die heimtückischen Verräter haben die Runde gewonnen!"
L.ev_win_inno    = "Die liebenswerten unschuldigen Terroristen haben die Runde gewonnen!"
L.ev_win_time    = "Den Verrätern ist die Zeit ausgegangen und sie verloren!"

--- Awards/highlights

L.aw_sui1_title = "Leiter des Selbstmord-Kultes"
L.aw_sui1_text  = "zeigte den anderen Selbstmördern, wie sie es zu tun haben, indem er der erste war."

L.aw_sui2_title = "Allein und deprimiert"
L.aw_sui2_text  = "war der einzige, der sich selbst umgebracht hat."

L.aw_exp1_title = "Stipendium für Explosive Forschungen"
L.aw_exp1_text  = "wurde für seine Forschungen an Explosionen anerkannt. {num} Versuchskaninchen haben mitgeholfen."

L.aw_exp2_title = "Feldforschung"
L.aw_exp2_text  = "testete seinen Widerstand gegen Explosionen. Er war nicht genug."

L.aw_fst1_title = "First Blood"
L.aw_fst1_text  = "ließ als Verräter das erste unschuldige Blut vergießen."

L.aw_fst2_title = "First Bloody Stupid Kill"
L.aw_fst2_text  = "hat die erste Tötung durch das Umbringen eines Verräter-Kollegen erzielt. Ganz tolle Arbeit."

L.aw_fst3_title = "Erstes Missgeschick"
L.aw_fst3_text  = "übte die erste Tötung aus. Blöd nur, dass es ein Unschuldiger war."

L.aw_fst4_title = "Erster Schlag"
L.aw_fst4_text  = "hat den ersten Schlag für die Unschuldigen getätigt, indem er den ersten Verräter getötet hat."

L.aw_all1_title = "Der Tödlichste unter Gleichen"
L.aw_all1_text  = "war für jede einzelne Tötung der Unschuldigen in dieser Runde verantwortlich."

L.aw_all2_title = "Einsamer Wolf"
L.aw_all2_text  = "war für jede einzelne Tötung der Verräter in dieser Runde verantwortlich."

L.aw_nkt1_title = "Ich hab' einen, Boss!"
L.aw_nkt1_text  = "hat es geschafft einen einzigen Unschuldigen zu töten. Wie süß!"

L.aw_nkt2_title = "Eine Kugel für zwei"
L.aw_nkt2_text  = "zeigte, dass der Erste nicht nur Glück war, indem er auch noch einen Zweiten umbrachte."

L.aw_nkt3_title = "Serien-Verräter"
L.aw_nkt3_text  = "beendete heute drei unschuldige Leben."

L.aw_nkt4_title = "Wolf unter eher Schaf-gleichen Wölfen"
L.aw_nkt4_text  = "verspeist Unschuldige zum Frühstück. Heute ist es mit {num} Stück groß ausgefallen!"

L.aw_nkt5_title = "Konter-terroristische Maßnahme"
L.aw_nkt5_text  = "wird pro Tötung bezahlt. Bald gibt's eine neue Yacht."

L.aw_nki1_title = "Betray This!"
L.aw_nki1_text  = "fand einen Verräter. Tötete einen Verräter. Ganz simpel."

L.aw_nki2_title = "Mitglied beim Gerechtigkeits-Trupp"
L.aw_nki2_text  = "eskortierte zwei Verräter ins Jenseits."

L.aw_nki3_title = "Träumen Verräter von verräterischen Schafen?"
L.aw_nki3_text  = "legte drei Verräter schlafen."

L.aw_nki4_title = "Angestellter innerer Angelegenheiten"
L.aw_nki4_text  = "wird pro Tötung bezahlt. Er kann sich nun seinen fünften Pool leisten."

L.aw_fal1_title = "Nein, Mr. Bond, ich erwarte, dass sie fallen"
L.aw_fal1_text  = "hat jemanden von ganz weit oben heruntergeschubst."

L.aw_fal2_title = "Geplättet"
L.aw_fal2_text  = "hat seinen Körper den Boden berühren lassen, nachdem er von einer bemerkenswerten Höhe gefallen ist."

L.aw_fal3_title = "Der menschliche Meteorit"
L.aw_fal3_text  = "hat jemanden zerquetscht indem er auf ihm gelandet ist."

L.aw_hed1_title = "Effizienz"
L.aw_hed1_text  = "hat die Freude an Kopfschüssen erkannt und verteilte insgesamt {num} Stück."

L.aw_hed2_title = "Neurologie"
L.aw_hed2_text  = "entfernte insgesamt {num} Gehirne aus den Köpfen anderer, um sie genauer zu untersuchen."

L.aw_hed3_title = "Killerspiele sind Schuld"
L.aw_hed3_text  = "hat sich zur Mörder-Simulation angemeldet und insgesamt {num} Gegnern in die Rübe geschossen."

L.aw_cbr1_title = "Thunk Thunk Thunk"
L.aw_cbr1_text  = "hat einen ganz schönen Schwung mit der Brechstange, wie {num} Opfer schmerzlich herausfinden mussten."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text  = "hat seine Brechstange in den Gehirnen von nicht weniger als {num} Leuten versenkt."

L.aw_pst1_title = "Hartnäckige kleine Lümmel"
L.aw_pst1_text  = "erzielte {num} Tötungen mit einer Pistole. Danach führten sie fort, jemanden zu Tode zu umarmen."

L.aw_pst2_title = "Kleinkaliber-Gemetzel"
L.aw_pst2_text  = "tötete eine kleine Armee von {num} mit einer Pistole. Wahrscheinlich installierte er ein kleines Schrotgewehr im Lauf."

L.aw_sgn1_title = "Easy Mode"
L.aw_sgn1_text  = "verwendete Schrot da, wo es wehtut, und ermordete {num} Ziele."

L.aw_sgn2_title = "Tausend kleine Kügelchen"
L.aw_sgn2_text  = "mochte sein Schrot nicht und gab alles weg. {num} Empfänger genossen es nicht."

L.aw_rfl1_title = "Zielen und abdrücken"
L.aw_rfl1_text  = "zeigte: Alles, was man für {num} Tötungen benötigt ist ein Gewehr und eine ruhige Hand."

L.aw_rfl2_title = "Ich seh deinen Kopf von hier drüben"
L.aw_rfl2_text  = "kennt sein Gewehr. Jetzt tun es {num} andere Leute ebenso."

L.aw_dgl1_title = "Wie ein kleines Gewehr"
L.aw_dgl1_text  = "gewöhnt sich langsam an die Desert Eagle und tötete {num} Leute."

L.aw_dgl2_title = "Eagle Master"
L.aw_dgl2_text  = "hat {num} Leute mit der Deagle weggeblasen."

L.aw_mac1_title = "Pray and Slay"
L.aw_mac1_text  = "tötete {num} Leute mit der MAC10, sagte allerdings nicht wie viel Munition er dafür gebraucht hat."

L.aw_mac2_title = "Mac and Cheese"
L.aw_mac2_text  = "fragt sich, was passieren würde, wenn man zwei MAC10s gleichzeitig benutzen würde. Zwei mal {num}?"

L.aw_sip1_title = "Ruhe"
L.aw_sip1_text  = "stellt {num} Leute mit einer schallgedämpften Pistole stumm."

L.aw_sip2_title = "Lautloser Assassine"
L.aw_sip2_text  = "tötete {num} Leute, die sich nicht einmal selbst schreien hören haben."

L.aw_knf1_title = "Das Messer kennt dich"
L.aw_knf1_text  = "hat jemandem über das Internet ins Gesicht gestochen."

L.aw_knf2_title = "Woher hast du das!?"
L.aw_knf2_text  = "war zwar kein Verräter, hat allerdings trotzdem jemanden aufgeschlitzt."

L.aw_knf3_title = "Such A 'Knife' Man"
L.aw_knf3_text  = "fand {num} herumliegende Messer und nutzte sie."

L.aw_knf4_title = "World's 'Knifest' Man"
L.aw_knf4_text  = "tötete {num} mit Messern. Frag' nicht wie..."

L.aw_flg1_title = "Zur Rettung"
L.aw_flg1_text  = "benutzte die Signalpistole um {num} Tode zu signalisieren."

L.aw_flg2_title = "Lodern weist auf Feuer hin"
L.aw_flg2_text  = "brachte {num} Leuten die Risiko bei, leicht entflammbare Kleidung zu tragen."

L.aw_hug1_title = "A H.U.G.E Spread"
L.aw_hug1_text  = "war in der Laune mit seiner H.U.G.E irgendwie dafür zu sorgen, dass dessen Kugeln {num} Leute trafen."

L.aw_hug2_title = "A Patient Para"
L.aw_hug2_text  = "hat den Abzug einfach nicht losgelassen und hat seine H.U.G.E-Geduld mit {num} Tötungen belohnt."

L.aw_msx1_title = "Putt Putt Putt"
L.aw_msx1_text  = "hat sich {num} Leute mit der M16 geschnappt."

L.aw_msx2_title = "Wahnsinn auf mittlere Entfernung"
L.aw_msx2_text  = "weiß, wie er Ziele mit der M16 rausnimmt und erzielte {num} Tötungen."

L.aw_tkl1_title = "Nur ein Versehen"
L.aw_tkl1_text  = "rutschte genau in dem Moment, als er seinen Kumpel ansah, mit dem Finger ab."

L.aw_tkl2_title = "Doppeltes Versehen"
L.aw_tkl2_text  = "verdächtigte zwei Leute als Verräter. Leider zwei Mal falsch."

L.aw_tkl3_title = "Karma-bewusst"
L.aw_tkl3_text  = "tötete zwei Verbündete und machte dann auch beim Dritten kein Halt. Immerhin ist drei 'ne Glückszahl!"

L.aw_tkl4_title = "Teamkiller"
L.aw_tkl4_text  = "brachte das komplette eigene Team um. OMGBANBANBAN."

L.aw_tkl5_title = "Rollenspieler"
L.aw_tkl5_text  = "spielte seine Rolle als böser Mann wirklich authentisch. Das ist auch der Grund, warum er die meisten seines Teams umbrachte."

L.aw_tkl6_title = "Trottel"
L.aw_tkl6_text  = "konnte nicht herausfinden, auf welcher Seite er eigentlich spielte und brachte mehr als die Hälfte seines Teams um."

L.aw_tkl7_title = "Redneck"
L.aw_tkl7_text  = "hat sein Gebiet recht gut verteidigt und etwa ein Viertel des eigenen Teams ausgelöscht."

L.aw_brn1_title = "Wie bei Oma"
L.aw_brn1_text  = "verbrannte mehrere Leute, bis sie schön knusprig waren."

L.aw_brn2_title = "Pyromane"
L.aw_brn2_text  = "wurde laut knisternd erhört, nachdem er eines seiner vielen Opfer verbrannte."

L.aw_brn3_title = "Pyromanische Brennerei"
L.aw_brn3_text  = "hat sie alle verbrannt, aber hat nun keine Brandgranaten mehr! Wie will er die Lage meistern!?"

L.aw_fnd1_title = "Gerichtsmediziner"
L.aw_fnd1_text  = "fand {num} Leichen, die in der Gegend herumlagen."

L.aw_fnd2_title = "Schnapp sie dir alle"
L.aw_fnd2_text  = "fand {num} Leichen für seine Sammlung."

L.aw_fnd3_title = "Geruch des Todes"
L.aw_fnd3_text  = "stolperte immer wieder über irgendwelche Leichen. {num} Mal diese Runde."

L.aw_crd1_title = "Recycler"
L.aw_crd1_text  = "schnorrte sich {num} zurückgelassene Credits von Leichen zusammen."

L.aw_tod1_title = "Teuer erkaufter Sieg"
L.aw_tod1_text  = "starb nur wenige Sekunden bevor sein Team die Runde gewann."

L.aw_tod2_title = "Ich hasse dieses Spiel"
L.aw_tod2_text  = "starb direkt am Anfang der Runde."


--- New and modified pieces of text are placed below this point, marked with the
--- version or the date in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Nicht als Detektiv ausgewählt werden"
L.set_avoid_det_tip = "Aktiviere diese Funktion, damit du nicht als Detektiv ausgewählt wirst. Das heißt nicht, dass du öfter Verräter wirst..."

--- v24
L.drop_no_ammo = "Du hast zu wenig Munition im Magazin, um eine Munitionskiste fallenzulassen."

--- v31
L.set_cross_brightness = "Fadenkreuz Helligkeit"
L.set_cross_size       = "Fadenkreuz Größe"

--- 2015-05-25
L.hat_retrieve = "Du hast den Hut eines Detektivs aufgehoben."

--- 2017-03-09
L.sb_sortby = "Sortiere nach:"

--- 2018-07-24	
L.equip_tooltip_main = "Ausrüstungsmenü"
L.equip_tooltip_radar = "Radar-Einstellungen"
L.equip_tooltip_disguise = "Tarnungs-Einstellungen"
L.equip_tooltip_radio = "Radio-Einstellungen"
L.equip_tooltip_xfer = "Credits übertragen"

L.confgrenade_name = "Discombobulator"
L.polter_name = "Poltergeist"
L.stungun_name = "UMP Prototyp"

L.knife_instant = "SOFORTIGE TÖTUNG"

L.dna_hud_type = "TYP"
L.dna_hud_body = "KÖRPER"
L.dna_hud_item = "GEGENSTAND"

L.binoc_zoom_level = "NIVEAU"
L.binoc_body = "KÖRPER GEFUNDEN"

L.idle_popup_title = "Untätig"

--- 2021-06-07
L.sb_playervolume = "Lautstärke"
