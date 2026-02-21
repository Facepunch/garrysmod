-- Italian language strings

local L = LANG.CreateLanguage("Italiano")

-- Testo generale usato in varie posizioni
-- General text used in various places
L.traitor = "Traditore"
L.detective = "Detective"
L.innocent = "Innocente"
L.last_words = "Ultime parole"

L.terrorists = "Terroristi"
L.spectators = "Spettatori"

-- Messaggi per lo stato del round
-- Round status messages
L.round_minplayers = "Non ci sono abbastanza giocatore per cominciare un nuovo round..."
L.round_voting = "Voto in corso, prolungando il round di {num} secondi..."
L.round_begintime = "Un nuovo round inizia tra {num} secondo/i. Preparatevi."
L.round_selected = "I traditori sono stati scelti."
L.round_started = "Il round è iniziato!"
L.round_restart = "È stato forzato il riavvio del round da un admin."

L.round_traitors_one = "Traditore, sei rimasto da solo."
L.round_traitors_more = "Traditore, questi sono i tuoi alleati: {names}"

L.win_time = "Il tempo è finito. I Traditori hanno perso."
L.win_traitors = "Traditori vincono!"
L.win_innocents = "Innocenti vincono!"
L.win_bees = "Pareggio!"
L.win_showreport = "Guardiamo il report per {num} secondi."

L.limit_round = "Raggiunto il limite del tempo del round. {mapname} caricherà presto."
L.limit_time = "Il tempo è finito. {mapname} caricherà presto."
L.limit_left = "{num} round o {time} minuti rimanenti prima che la mappa cambi in {mapname}."

-- Ricompense crediti
-- Credit awards
L.credit_all = "Al tuo team sono stati dati {num} credito/i per la vostra performance."
L.credit_tr_all = "Traditori, vi sono stati dati {num} credito/i per la vostra performance."

L.credit_kill = "Hai ricevuto {num} credito/i per aver ucciso un {role}."

-- Karma
L.karma_dmg_full = "Il tuo Karma è {amount}, quindi questo round fai il massimo del danno!"
L.karma_dmg_other = "Il tuo Karma è {amount}. Come risultato il danno è diminuito del {num}%"

-- Messaggi per l'identificazione dei messaggi
-- Body identification messages
L.body_found = "{finder} ha trovato il corpo di {victim}. {role}"

-- Il {role} in body_found sarà sostituito con una di queste stringhe:
-- The {role} in body_found will be replaced by one of the following:
L.body_found_t = "Era un Traditore!"
L.body_found_d = "Era un Detective."
L.body_found_i = "Era un Innocente."

L.body_confirm = "{finder} ha confermato la morte di {victim}."

L.body_call = "{player} ha chiamato un detective al corpo di {victim}!"
L.body_call_error = "Devi confermare la morte di questo giocatore prima di chiamare un Detective!"

L.body_burning = "Ahia! Questo corpo va a fuoco!"
L.body_credits = "Hai trovato {num} credito/i sul corpo!"

--- Menù e finestre
-- Menus and windows
L.close = "Chiudi"
L.cancel = "Cancella"

-- Per i tasti della navigazione
-- For navigation buttons
L.next = "Prossimo"
L.prev = "Precedente"

-- Menù equipaggiamento
-- Equipment buying menu
L.equip_title = "Equipaggiamento"
L.equip_tabtitle = "Ordina Equipaggiamento"

L.equip_status = "Stato ordinamento"
L.equip_cost = "Hai {num} credito/i."
L.equip_help_cost = "Ogni oggetto dell'equipaggiamento che acquisti costa 1 credito."

L.equip_help_carry = "Puoi solo acquistare oggetti per i quali hai spazio."
L.equip_carry = "Puoi portare questo oggetto."
L.equip_carry_own = "Stai già portando questo oggetto."
L.equip_carry_slot = "Hai già un'arma nello slot {slot}."

L.equip_help_stock = "Di alcuni oggetti ne puoi acquistare solo uno per round."
L.equip_stock_deny = "Questo oggetto non si può più acquistare."
L.equip_stock_ok = "Questo oggetto si può più acquistare."

L.equip_custom = "Oggetti personalizzati aggiunti dal server."

L.equip_spec_name = "Nome"
L.equip_spec_type = "Tipo"
L.equip_spec_desc = "Descrizione"

L.equip_confirm = "Compra oggetto"

-- Finestra Travestimento nel menù equipaggiamento
-- Disguiser tab in equipment menu
L.disg_name = "Travestimento"
L.disg_menutitle = "Controllo travestimento"
L.disg_not_owned = "Non hai un travestimento!"
L.disg_enable = "Attiva travestimento"

L.disg_help1 = "Quando il tuo travestimento è attivo, il tuo nome, la tua vita e il tuo karma non si vedono quando qualcuno ti guarda. In più, sarai nascosto al radar del Detective."
L.disg_help2 = "Premi Numpad Enter per togliere il travestimento senza aprire il menù. Puoi anche metter un tasto diverso in 'ttt_toggle_disguise' usando la console."

-- Finestra Radar nel menù equipaggiamento
-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Controllo del Radar"
L.radar_not_owned = "Non hai un Radar!"
L.radar_scan = "Fai una scansione"
L.radar_auto = "Scansione automatica"
L.radar_help = "I risultati della scansione si vedono per {num} secondi, dopo di quello il radar dovrà essere ricaricato e potrà essere usato nuovamente."
L.radar_charging = "Il tuo Radar si sta ancora caricando!"

-- Finestra Trasferimento nel menù equipaggiamento
-- Transfer tab in equipment menu
L.xfer_name = "Trasferimento"
L.xfer_menutitle = "Trasferisci crediti"
L.xfer_no_credits = "Non hai crediti da donare!"
L.xfer_send = "Dai un credito"
L.xfer_help = "Può trasferire i crediti solo ai compagni {role}."

L.xfer_no_recip = "Bersaglio non valido, trasferimento dei crediti annullato."
L.xfer_no_credits = "Crediti insufficienti per il trasferimento."
L.xfer_success = "Trasferimento crediti a {player} completato."
L.xfer_received = "{player} ti ha dato {num} crediti."

-- Finestra Radio nel menù equipaggiamento
-- Radio tab in equipment menu
L.radio_name = "Radio"
L.radio_help = "Clicca un bottone per far fare alla Radio quel suono."
L.radio_notplaced = "Devi piazzare la Radio prima di far partire un suono."

-- Bottoni per suoni della Radio
-- Radio soundboard buttons
L.radio_button_scream = "Urlo"
L.radio_button_expl = "Esplosione"
L.radio_button_pistol = "Colpi di pistola"
L.radio_button_m16 = "Colpi di M16"
L.radio_button_deagle = "Colpi di Deagle"
L.radio_button_mac10 = "Colpi di MAC10"
L.radio_button_shotgun = "Colpi di Fucile a Pompa"
L.radio_button_rifle = "Colpi di Cecchino"
L.radio_button_huge = "Colpi di H.U.G.E"
L.radio_button_c4 = "Rumore del C4"
L.radio_button_burn = "Fuoco"
L.radio_button_steps = "Passi"


-- Schermata di introduzione mostrata dopo essere entrato
-- Intro screen shown after joining
L.intro_help = "Se sei nuovo al gioco, premi F1 per istruzioni!"

-- Chat rapida
-- Radiocommands/quickchat
L.quick_title = "Tasti veloci della chat"

L.quick_yes = "Sì."
L.quick_no = "No."
L.quick_help = "Aiuto!"
L.quick_imwith = "Sono con {player}."
L.quick_see = "Vedo {player}."
L.quick_suspect = "{player} è sospetto."
L.quick_traitor = "{player} è un Traditore!"
L.quick_inno = "{player} è innocente."
L.quick_check = "Qualcuno è ancora vivo?"

-- {player} nella chat veloce solitamente diventa il nickname di un giocatore
-- ma potrebbe diventare anche uno di quello qui sotto. Mantenerli in minuscolo.
-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "nessuno"
L.quick_disg = "qualcuno con travestimento"
L.quick_corpse = "un corpo non identificato"
L.quick_corpse_id = " il corpo di {player}"


-- Finestra identificazione
-- Body search window
L.search_title = "Risultati ricerca"
L.search_info = "Informazione"
L.search_confirm = "Conferma morte"
L.search_call = "Chiama Detective"

-- Descrizione delle informazioni trovate
-- Descriptions of pieces of information found
L.search_nick = "Questo è il corpo di {player}."

L.search_role_t = "Questa persona era un Traditore!"
L.search_role_d = "Questa persona era un Detective."
L.search_role_i = "Questa persona era un Innocente."

L.search_words = "Qualcosa ti dice che le ultime parole di questa persona erano: '{lastwords}'"
L.search_armor = "Stava indossando un'armatura speciale."
L.search_disg = "Stava usando un dispositivo che poteva nascondere la sua identità."
L.search_radar = "Avevano qualche tipo di radar. Non funziona più."
L.search_c4 = "In una tasca hai trovato una nota. Dice che tagliare il filo {num} disarmerà la bomba."

L.search_dmg_crush = "Molte delle sue ossa sono rotte. Sembra che l'impatto di un oggetto pesante lo abbia ucciso."
L.search_dmg_bullet = "È ovvio che sia stato ucciso da dei colpi di arma da fuoco."
L.search_dmg_fall = "Sono morti di caduta."
L.search_dmg_boom = "Le sue ferite e i vestiti bruciati indicano che un'esplosione lo hanno ucciso."
L.search_dmg_club = "Il suo corpo è pieno di ferite. Chiaramente è stato ucciso a bastonate."
L.search_dmg_drown = "Il corpo morta i segni dell'affogamento."
L.search_dmg_stab = "È stato accoltellato prima di morire velocemente dissanguato."
L.search_dmg_burn = "Si sente odore di terrorista bruciato qui..."
L.search_dmg_tele = "Sembra che il DNA stato criptato da delle emissioni tachioniche!"
L.search_dmg_car = "Quando il terrorista ha attraversato la strada, sono stati investiti da un pilota spericolato."
L.search_dmg_other = "Non puoi trovare una causa di morte specifica per la morte di questo terrorista."

L.search_weapon = "Sembra che sia stato usato un {weapon} per ucciderlo."
L.search_head = "La ferita fatale è stata un colpo in testa. Non c'era il tempo di urlare."
L.search_time = "È morto all'incirca {time} prima che facessi la ricerca."
L.search_timefake = "È morto all'incirca 00:15 prima che facessi la ricerca."
L.search_dna = "Prendi un campione di DNA con il DNA Scanner. Il campione di DNA scadrà {time} da ora."

L.search_kills1 = "Hai trovato una lista di uccisioni che conferma la morte di {player}."
L.search_kills2 = "Hai trovato una lista di uccisioni con questi nomi:"
L.search_eyes = "Usando le tue abilità da detective, hai identificato che l'ultima persona che ha visto è: {player}. L'assassino, o una coincidenza?"


-- Scoreboard
L.sb_playing = "Stai giocando su..."
L.sb_mapchange = "La mappa cambierà tra {num} round o tra {time}"

L.sb_sortby = "Ordina per:"

L.sb_mia = "Disperso"
L.sb_confirmed = "Morti confermati"

L.sb_ping = "Ping"
L.sb_deaths = "Morti"
L.sb_score = "Punti"
L.sb_karma = "Karma"

L.sb_info_help = "Identifica il corpo di questo giocatore, e potrai vedere qui i risultati."

L.sb_tag_friend = "AMICO"
L.sb_tag_susp = "SOSPETTO"
L.sb_tag_avoid = "EVITA"
L.sb_tag_kill = "UCCIDI"
L.sb_tag_miss = "PERSO"

-- Menù aiuto e impostazioni
-- Help and settings menu (F1)

L.help_title = "Aiuto e Impostazioni"

-- Finestre
-- Tabs
L.help_tut = "Tutorial"
L.help_tut_tip = "Come funziona TTT, in 6 passi"

L.help_settings = "Impostazioni"
L.help_settings_tip = "Impostazioni lato client"

-- Impostazioni
-- Settings
L.set_title_gui = "Impostazioni interfaccia"

L.set_tips = "Mostra consigli in basso mentre sei uno spettatore"

L.set_startpopup = "Durata delle informazioni all'inizio del round"
L.set_startpopup_tip = "Quando il round comincia, un piccolo avviso appare in fondo al tuo schermo per alcuni secondi. Cambia il tempo per il quale si vede."

L.set_cross_opacity = "Opacità del mirino"
L.set_cross_disable = "Disabilita completamente il mirino"
L.set_minimal_id = "ID bersaglio minimale sotto il mirino (niente karma, consigli, ecc.)"
L.set_healthlabel = "Mostra lo stato della vita sulla barra degli HP"
L.set_lowsights = "Abbassa arma quando usi il mirino di ferro"
L.set_lowsights_tip = "Abilita la funzionalità di abbassare il modello dell'arma sullo schermo mentre usi il mirino di ferro. Ti renderà più facile vedere il tuo bersaglio, ma sembrerà meno realistico."
L.set_fastsw = "Cambio armi veloce"
L.set_fastsw_tip = "Abilita di cambiare le armi senza cliccare per usare l'arma. Abilita il menù per vederlo mentre cambi."
L.set_fastsw_menu = "Abilita il menu con il cambio veloce di armi"
L.set_fastswmenu_tip = "Quando il cambio veloce di armi è abilitato, il menù di cambio apparirà."
L.set_wswitch = "Disabilita la chiusura automatica del menù delle armi"
L.set_wswitch_tip = "Per default il menù si chiude automaticamente dopo alcuni secondi dopo l'ultimo scroll. Abilita per farlo restare aperto."
L.set_cues = "Senti un avviso appena inizia o finisce il round"


L.set_title_play = "Impostazioni gameplay"

L.set_specmode = "Modalità solo spettatore (rimani sempre in spettatori)"
L.set_specmode_tip = "La modalità solo spettatore impedirà che tu respawni quando un round comincia, rimanendo invece spettatore."
L.set_mute = "Muta tutti i giocatori vivi quando muori"
L.set_mute_tip = "Muta tutti i giocatori ancora in vita mentre sei morto o spettatore."


L.set_title_lang = "Impostazioni lingua"

-- Potrebbe essere meglio lasciarlo in inglese, così i giocatori inglese possono sempre
-- trovare l'impostazione della lingua anche se è una lingua che non conoscono.
-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang = "Selezionare lingua (Select language):"

-- Armi ed equipaggiamento, HUD e messaggi
-- Weapons and equipment, HUD and messages

-- Azioni equipaggiamento, come acquistare o lasciare
-- Equipment actions, like buying and dropping
L.buy_no_stock = "Quest'arma non puoi più acquistarla: lo hai già fatto questo round."
L.buy_pending = "Hai già un ordine in attesa, aspetta di riceverlo."
L.buy_received = "Hai ricevuto il tuo equipaggiamento speciale."

L.drop_no_room = "Non c'è spazio qui per lasciare la tua arma!"

L.disg_turned_on = "Travestimento attivato!"
L.disg_turned_off = "Travestimento disattivato."

-- Descrizione oggetti dell'equipaggiamento
-- Equipment item descriptions
L.item_passive = "Oggetti con effetto passivo"
L.item_active = "Oggetti con effetto passivo"
L.item_weapon = "Armi"

L.item_armor = "Armatura"
L.item_armor_desc = [[
Riduce il danno dei proiettili del 30% quando
vieni colpito.
Equipaggiamento di default per i Detective.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Ti permette di fare una scansione dei segni vitali.
Comincia una ricerca automatica appena
lo compri. Configuralo nella finestra Radar di questo
menù.]]

L.item_disg = "Travestimento"
L.item_disg_desc = [[
Nasconde le tue informazioni quando attivo. Evita anche
di essere l'ultima persona vista da una vittima.
Disabilitalo nella finestra Travestimento di questo menù
o premi Numpad Enter.]]

-- C4
L.c4_hint = "Premi {usekey} per innescare o disinnescare."
L.c4_no_disarm = "Non puoi disinnescare il C4 di un altro Traditore almeno che non sia morto."
L.c4_disarm_warn = "Un C4 che hai piazzato è stato disinnescato."
L.c4_armed = "Hai innescato la bomba con successo."
L.c4_disarmed = "Hai disinnescato la bomba con successo."
L.c4_no_room = "Non puoi portare questo C4."

L.c4_desc = "Potente esplosivo a tempo."

L.c4_arm = "Innesca C4"
L.c4_arm_timer = "Timer"
L.c4_arm_seconds = "Secondi alla detonazione:"
L.c4_arm_attempts = "Nei tentativi di disinnesco, {num} dei 6 fili causerà l'esplosione istantanea del C4."

L.c4_remove_title = "Rimuovi"
L.c4_remove_pickup = "Prendi C4"
L.c4_remove_destroy1 = "Distruggi C4"
L.c4_remove_destroy2 = "Conferma: distruggi"

L.c4_disarm = "Disinnesca C4"
L.c4_disarm_cut = "Clicca per tagliare il filo {num}"

L.c4_disarm_t = "Taglia un filo per disinnescare la bomba. Come Traditore, ogni filo va bene. Per gli Innocenti non è così facile!"
L.c4_disarm_owned = "Taglia un filo per disinnescare la bomba. È la tua bomba, quindi ogni filo la disinnescherà."
L.c4_disarm_other = "Taglia un filo sicuro per disinnescare la bomba. Esploderà se tagli quello sbagliato!"

L.c4_status_armed = "INNESCATA"
L.c4_status_disarmed = "DISINNESCATA"

-- Visualizzatore
-- Visualizer
L.vis_name = "Visualizzatore"
L.vis_hint = "Premi {usekey} per raccoglierlo (solo Detective)."

L.vis_help_pri = "{primaryfire} fa cadere il dispositivo attivo."

L.vis_desc = [[
Dispositivo per visualizzare una scena del crimine.
Analizza un cadavere per mostrare come
la vittima è stata uccisa, ma solo se
è morta per colpi di arma da fuoco.]]

-- Esca
-- Decoy
L.decoy_name = "Esca"
L.decoy_no_room = "Non puoi portare questa Esca."
L.decoy_broken = "la tua Esca è stata distrutta!"

L.decoy_help_pri = "{primaryfire} piazza l'Esca."

L.decoy_desc = [[
Mostra un segnale falso sul radar dei Detective,
e mostra sui loro DNA scanner la posizione
dell'Esca se scannerizzano
il tuo DNA.]]

-- Disinnescatore
-- Defuser
L.defuser_name = "Disinnescatore"
L.defuser_help = "{primaryfire} disinnesca C4 selezionato."

L.defuser_desc = [[
Disinnesca istantaneamente un C4.
Usi illimitati. Il C4 sarà più facile
notarlo se porti quest'oggetto con te.]]

-- Pistola lanciarazzi
-- Flare gun
L.flare_name = "Pistola lanciarazzi"
L.flare_desc = [[
Può essere usata per bruciare corpi così che
non vengano mai trovati. Munizioni limitate.
Bruciare un cadavere fa un suono
distinto.]]

-- Stazione di Cura
-- Health station
L.hstation_name = "Stazione di Cura"
L.hstation_hint = "Premi {usekey} per ricevere HP. Carica: {num}."
L.hstation_broken = "La tua Stazione di Cura è stata distrutta!"
L.hstation_help = "{primaryfire} piazza la Stazione di Cura."

L.hstation_desc = [[
Permette ai giocatori di curarsi una volta piazzata.
Ricarica lenta. Chiunque può usarla, e
può essere danneggiata. Può essere analizzata per prendere
i campioni di DNA di chi l'ha usata.]]

-- Coltello
-- Knife
L.knife_name = "Coltello"
L.knife_thrown = "Coltello lanciato"

L.knife_desc = [[
Uccidi bersagli feriti istantaneamente e
silenziosamente, ma ha un solo utilizzo.
Può essere tirato con il tasto del fuoco alternativo.]]

-- Poltergeist
L.polter_desc = [[
Pianta dei razzi su degli oggetti per lanciarli
per lanciarli violentemente.
Le scariche di energia danneggiano i giocatori
nelle vicinanze.]]

-- Radio
L.radio_broken = "La tua Radio è stata distrutta!"
L.radio_help_pri = "{primaryfire} piazza una Radio."

L.radio_desc = [[
Fa dei suoni per distrarre o ingannare.
Piazza la radio da qualche parte, poi
fai partire dei suoni dalla finestra Radio
in questo menù.]]

-- Pistola silenziata
-- Silenced pistol
L.sipistol_name = "Pistola silenziata"

L.sipistol_desc = [[
Pistola silenziata, usa i proiettili della
pistola.
Le vittime non urleranno quando uccise.]]

-- Newton launcher
L.newton_name = "Newton launcher"

L.newton_desc = [[
Spinge i giocatori ad una distanza di sicurezza.
Munizioni infinite, ma spara lentamente.]]

-- Binocolo
-- Binoculars
L.binoc_name = "Binocolo"
L.binoc_desc = [[
Zooma sui cadaveri e li identifica
da molto distante.
Usi illimitati, ma l'identificazione
necessita di alcuni secondi.]]

L.binoc_help_pri = "{primaryfire} identifica una corpo."
L.binoc_help_sec = "{secondaryfire} cambia il livello di zoom."

-- UMP
L.ump_desc = [[
SMG sperimentale che disorienta i
bersagli.
Usa munizioni SMG standard.]]

-- DNA scanner
L.dna_name = "DNA scanner"
L.dna_identify = "Il cadavere deve essere identificato per prendere il DNA dell'assassino."
L.dna_notfound = "Nessun campione di DNA trovato sul bersaglio."
L.dna_limit = "Limite di deposito raggiunge. Rimuovi vecchi campioni per aggiungerne altri."
L.dna_decayed = "Campione di DNA dell'assassino si è deteriorato."
L.dna_killer = "Preso un campione di DNA dell'assassino dal cadavere!"
L.dna_no_killer = "Il DNA non può essere preso (assassino disconnesso?)."
L.dna_armed = "La bomba è innescata! Disinnescala prima!"
L.dna_object = "Preso {num} nuovo campione di DNA dall'oggetto."
L.dna_gone = "DNA non rilevato nella zona."

L.dna_desc = [[
Prendi campioni di DNA dagli oggetti
e usali per trovare il proprietario del DNA.
Usalo su giocatori appena uccisi per prendere il DNA dell'assassino
e trovarli.]]

L.dna_menu_title = "Controlli DNA scanner"
L.dna_menu_sample = "Campione di DNA trovato su {source}"
L.dna_menu_remove = "Rimuovi selezionato"
L.dna_menu_help1 = "Questi sono i campioni di DNA che hai raccolto."
L.dna_menu_help2 = [[
Quando carico, puoi scansionare la posizione del
giocatore a cui appartiene il campione di DNA.
Trovare bersagli distanti usa più energia.]]

L.dna_menu_scan = "Fai scansione"
L.dna_menu_repeat = "Ripeti automaticamente"
L.dna_menu_ready = "PRONTO"
L.dna_menu_charge = "CARICAMENTO"
L.dna_menu_select = "SELEZIONA CAMPIONE"

L.dna_help_primary = "{primaryfire} per prendere un campione di DNA"
L.dna_help_secondary = "{secondaryfire} per i controlli dello scanner open"

-- Magneto stick
L.magnet_name = "Magneto-stick"
L.magnet_help = "{primaryfire} per attaccare i corpi alle superfici."

-- Granate e altro
-- Grenades and misc
L.grenade_smoke = "Granata fumogena"
L.grenade_fire = "Granata incendiaria"

L.unarmed_name = "Disarmato"
L.crowbar_name = "Crowbar"
L.pistol_name = "Pistola"
L.rifle_name = "Fucile da cecchino"
L.shotgun_name = "Fucile a pompa"

-- Teletrasporto
-- Teleporter
L.tele_name = "Teletrasporto"
L.tele_failed = "Teletrasporto fallito."
L.tele_marked = "Posizione teletrasporto segnalata."

L.tele_no_ground = "Non puoi teletrasportarti se non sei a terra!"
L.tele_no_crouch = "Non puoi teletrasportarti mentre sei abbassato!"
L.tele_no_mark = "Nessuna posizione segnalata. Segnala una destinazione prima di teletrasportarti."

L.tele_no_mark_ground = "Non puoi segnalare una posizione per il teletrasporto se non sei a terra!"
L.tele_no_mark_crouch = "Non puoi segnalare una posizione per il teletrasporto mentre sei abbassato!"

L.tele_help_pri = "{primaryfire} teletrasporta alla posizione segnalata."
L.tele_help_sec = "{secondaryfire} segnala questa posizione."

L.tele_desc = [[
Teletrasportati ad una posizione precedentemente segnalata.
Teletrasportarti fa rumore, e il
numero di utilizzi è limitato.]]

-- Nomi delle munizioni, mostrati quando raccolte
-- Ammo names, shown when picked up
L.ammo_pistol = "Munizioni 9mm"

L.ammo_smg1 = "Munizioni SMG"
L.ammo_buckshot = "Munizioni Fucile a Pompa"
L.ammo_357 = "Munizioni Fucile da Cecchino"
L.ammo_alyxgun = "Munizioni Deagle"
L.ammo_ar2altfire = "Munizioni Pistola Lanciarazzi"
L.ammo_gravity = "Munizioni Poltergeist"


-- Testo interfaccia HUD
-- HUD interface text

-- Stato round
-- Round status
L.round_wait = "In attesa"
L.round_prep = "Preparazione"
L.round_active = "In corso"
L.round_post = "Round finito"

-- Vita, munizioni e area temporale
-- Health, ammo and time area
L.overtime = "SUPPLEMENTARI"
L.hastemode = "SUPPLEMENTARI"

-- Stato della vita del bersaglio mirato
-- TargetID health status
L.hp_healthy = "In salute"
L.hp_hurt = "Colpito"
L.hp_wounded = "Ferito"
L.hp_badwnd = "Ferito gravemente"
L.hp_death = "Quasi morto"


--Stato del karma del bersaglio mirato
-- TargetID karma status
L.karma_max = "Affidabile"
L.karma_high = "Poco affidabile"
L.karma_med = "Grilletto facile"
L.karma_low = "Pericoloso"
L.karma_min = "Irresponsabile"

-- Altro sul bersaglio mirato
-- TargetID misc
L.corpse = "Cadavere"
L.corpse_hint = "Premi {usekey} per identificare. {walkkey} + {usekey} per identificare segretamente."

L.target_disg = " (TRAVESTITO)"
L.target_unid = "Corpo non identificato"

L.target_traitor = "COMPAGNO TRADITORE"
L.target_detective = "DETECTIVE"

L.target_credits = "Identifica per ricevere i crediti non spesi"

-- Bottoni per traditori (bottoni sull'HUD con l'icona della mano che solo i traditori possono vedere)
-- Traitor buttons (HUD buttons with hand icons that only traditori can see)
L.tbut_single = "Uso singolo"
L.tbut_reuse = "Riutilizzabile"
L.tbut_retime = "Riutilizzabile dopo {num} secondi"
L.tbut_help = "Premi {key} per attivare"

-- Stringhe di informazione sull'equipaggiamento (sulla sinistra sopra il pannello di vita/munizioni)
-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud = "Travestito. Il tuo nome è nascosto."
L.radar_hud = "Radar pronto per il prossima scansione tra: {time}"

-- Spettatori che mutano vivi/morti
-- Spectator muting of living/dead
L.mute_living = "Giocatori in vita mutati"
L.mute_specs = "Spettatori mutati"
L.mute_all = "Tutti mutati"
L.mute_off = "Nessuno mutato"

-- Spettatori e prendere possesso di un oggetto
-- Spectators and prop possession
L.punch_title = "PUNCH-O-METER"
L.punch_help = "Tasti per il movimento o salto: lancia oggetto. Abbassati: lascia oggetto."
L.punch_bonus = "Il tuo punteggio basso ha diminuito il livello del punch-o-meter di {num}"
L.punch_malus = "Il tuo punteggio alto ha aumentato il livello del punch-o-meter di {num}!"

L.spec_help    = "Clicca per guardare giocatori, o premi {usekey} su un oggetto con fisica per possederlo."

-- Informazioni che si vedono quando comincia il round
-- Info popups shown when the round starts

-- Questi si trovano su più linee, e usano le parentesi quadre invece che
-- le virgolette. È una cosa di Lua. Ogni invio si vedrà in gioco.
-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[Sei un innocente! Ma ci sono dei traditori...
Ma di chi ti puoi fidare, e chi invece è lì per ucciderti?
Guardati le spalle e collabora con i tuoi compagni per uscirne vivo!]]

L.info_popup_detective = [[Sei un Detective! La sede dei terroristi ti ha dato delle risorse speciali per trovare i traditori.
Usale per aiutare gli innocenti a sopravvivere, ma fai attenzione:
i traditori cercheranno di ucciderti per primo!
Premi {menukey} per ricevere il tuo equipaggiamento!]]

L.info_popup_traitor_alone = [[Sei un TRADITORE! Non hai compagni traditori questo round.
Uccidi tutti gli per vincere!
Premi {menukey} per ricevere il tuo equipaggiamento!]]

L.info_popup_traitor = [[Sei un TRADITORE! Collabora con i compagni traditori per uccidere gli altri.
Ma fai attenzione, o il tuo tradimento potrebbe essere scoperto...
Questi sono i tuoi compagni:
{traitorlist}
Premi {menukey} per ricevere il tuo equipaggiamento!]]

-- Altro testo vario
-- Various other text
L.name_kick = "Un giocatore è stato espulso per aver cambiato il suo nome durante round."

L.idle_popup = [[Sei stato inattivo per {num} secondi e sei stato spostato nella modalità solo Spettatori. Mentre sei in questa modalità, non spawnerai all'inizio del round.
Puoi rimuovere la modalità solo Spettatori in ogni momento premendo {helpkey} e deselezionando la casella nella finestra Impostazioni. Puoi anche scegliere di disabilitarla ora.]]

L.idle_popup_close = "Non fare niente"
L.idle_popup_off = "Disabilita modalità solo spettatori ora"

L.idle_warning = "Attenzione: sembri essere inattivo/AFK, e verrai spostato negli Spettatori almeno che tu non ti muova!"

L.spec_mode_warning = "Sei in modalità Spettatore e non spawnerai all'inizio del round. Per disabilitare questa modalità, premi F1, vai nelle Impostazioni e togli la spunta a 'modalità solo Spettatori'."


-- Consigli, mostrati in basso agli spettatori
-- Tips, shown at bottom of screen to spectators

-- Pannello consigli
-- Tips panel
L.tips_panel_title = "Consigli"
L.tips_panel_tip = "Consiglio:"

-- Stringhe consigli
-- Tip texts

L.tip1 = "Traditori possono identificare un corpo silenziosamente, senza confermare la morte, tenendo premuto {walkkey} e premendo {usekey} sul cadavere."

L.tip2 = "Innescare un C4 con più tempo aumenterà il numero di cavi che la fanno esplodere istantaneamente quando un innocente prova a disinnescarla. Fara suoni meno forti e più di rado."

L.tip3 = "I Detective possono identificare un cadavere per trovare chi è 'riflesso nei suoi occhi'. Questa è l'ultima persona che il cadavere vedesse prima di morire. Non è per obbligatoriamente l'assassino se è stato ucciso alle spalle."

L.tip4 = "Nessuno saprà che sei morto finché non trovano il tuo cadavere e lo identificano."

L.tip5 = "Quando un Traditore uccide un Detective, ricevono istantaneamente una ricompensa in crediti."

L.tip6 = "Quando un Traditore muore, tutti i Detective ricevono una ricompensa in crediti."

L.tip7 = "Quando i Traditori hanno fatto un progresso importante nell'uccidere gli innocenti, ricevono un credito come ricompensa."

L.tip8 = "Traditori e Detective possono collezionare crediti non spesi dai cadaveri di altri Traditori e Detective."

L.tip9 = "Il Poltergeist può trasformare qualsiasi oggetto in un proiettile mortale. Ogni colpo è accompagnato da una scarica di energia ferendo tutti quanti nei dintorni."

L.tip10 = "Come Traditore o Detective, tieni d'occhio i messaggi rossi in alto a destra. Saranno importanti per te."

L.tip11 = "Come Traditore o Detective, tieni a mente che riceverai altri crediti se i tuoi compagni giocheranno bene. Ricordati di spenderli!"

L.tip12 = "Il DNA Scanner dei Detective DNA Scanner può essere usato per prendere campioni di DNA da armi e oggetti e scansionarli per trovare chi li ha usati. Utile prendere un campione da un cadavere o da un C4 disinnescato!"

L.tip13 = "Quando sei vicino ad uccidere qualcuno, un po' del tuo DNA rimane sul cadavere. Questo DNA può essere usato dal DNA Scanner del Detective per trovarti. Meglio nascondere i cadaveri dopo averli accoltellati!"

L.tip14 = "Più sarai lontano dalla persona che uccidi, più velocemente il DNA sul corpo si deteriorerà."

L.tip15 = "Sei un Traditore e vuoi sparare con il cecchino? Prova ad usare il Trasferimento. Se non colpisci, scappa in un posto sicuro, disabilita il Travestimento, e nessuno saprà che gli stavi sparando."

L.tip16 = "Come Traditore, il Teletrasporto può aiutarti a scappare quando inseguito, e ti permette di viaggiare velocemente in una mappa grande. Assicurati che tu abbia sempre una posizione sicura segnalata."

L.tip17 = "Gli innocenti sono tutti raggruppati e difficili da trovare soli? Prova ad usare la Radio e fare i suoni di un C4 o di una sparatoria per farli scappare."

L.tip18 = "Usando la Radio da Traditore, puoi far partire i suoni tramite il menù dopo aver piazzato la radio. Metti in coda diversi suoni cliccandoli più volte nell'ordine in cui li vuoi."

L.tip19 = "Come Detective, se ti rimangono dei crediti potresti dare ad un Innocente fidato un Disinnescatore. Poi puoi spendere tempo facendo investigazioni serie e lasciare il pericoloso disinnescaggio a loro."

L.tip20 = "Il binocolo dei Detective permette di identificare cadaveri a distanza. Brutte notizie se i Traditori speravano di usare questo cadavere come esca. Ovviamente, mentre usa il Binocolo un Detective è disarmato e distratto..."

L.tip21 = "La Stazione di Cura dei Detective fa curare i giocatori feriti. Ovviamente, potrebbero essere Traditori..."

L.tip22 = "La Stazione di Cura registra il campione di DNA di chiunque la usa. I Detective possano usare il DNA Scanner per scoprire chi si è curato."

L.tip23 = "Al contrario delle armi e del C4, la Radio dei Traditori non contiene campioni di DNA di chi l'ha piazzata. Non preoccupatevi che i Detective al trovino e facciano saltare la vostra copertura."

L.tip24 = "Premi {helpkey} per vedere un piccolo tutorial o modifica alcune impostazioni di TTT. Per esempio, puoi disabilitare questi consigli."

L.tip25 = "Quando un Detective identifica un corpo, il risultato è disponibile per tutti sullo scoreboard, cliccando il nome della persona morta."

L.tip26 = "Nello scoreboard, una magnifica icona di vetro vicino al nome di qualcuno indica che hai delle informazioni su quella persona. Se l'icona è chiara, le informazioni vengono da un Detective e potrebbero essere più complete."

L.tip27 = "Come Detective, i cadaveri con una magnifica icona di vetro vicino al nome di qualcuno indica che sono stati identificati da un Detective e i risultati sono disponibili a tutti tramite lo scoreboard."

L.tip28 = "Gli Spettatori possono premere {mutekey} per mutare altri spettatori o i giocatori in vita."

L.tip29 = "Se il server ha installate altre lingue, puoi cambiare lingua in ogni momento dal menù delle Impostazioni."

L.tip30 = "Chat veloce o i comandi 'radio' possono essere usati con il tasto {zoomkey}."

L.tip31 = "Come Spettatore, premi {duckkey} per sbloccare il cursore del mouse e clicca i bottoni su questa finestra dei consigli. Premi {duckkey} ancora per muovere la visuale."

L.tip32 = "Il fuoco secondario della Crowbar spingerà gli altri giocatori."

L.tip33 = "Sparare dal mirino di ferro di un'arma migliora leggermente la tua precisione e diminuisci il rinculo. Abbassarti non lo fa."

L.tip34 = "Le granate fumogene sono efficienti in luoghi chiusi, specialmente per creare confusione in stanze con molte persone."

L.tip35 = "Come Traditore, ricorda che puoi prendere i cadaveri e nasconderli dagli occhi degli Innocenti e dei Detective."

L.tip36 = "Il tutorial disponibile premendo {helpkey} contiene una descrizione sui tasti più importanti di questa modalità."

L.tip37 = "Nello scoreboard, clicca il nome di un giocatore in vita e potrai selezionare un tag per loro, come 'sospetto' o 'amico'. Questo tag si vedrà quando li miri."

L.tip38 = "Molti degli oggetti che si possono piazzare (come C4, Radio) posso essere attacati ai muri usando il fuoco secondario."

L.tip39 = "Il C4 che esplode per errore durante le operazione di disinnescamento ha un'esplosione più piccola di quando esplode perché è scaduto il tempo."

L.tip40 = "Se dice 'SUPPLEMENTARI' sopra il tempo del round, il round all'inizio durerà solo qualche minuto, ma con ogni uccisione il tempo a disposizione aumenterà (come catturare un punto su TF2). Questa modalità mette pressione ai traditori, così che facciano in fretta."


-- Round report

L.report_title = "Report del Round"

-- Finestre
-- Tabs
L.report_tab_hilite = "Momenti chiave"
L.report_tab_hilite_tip = "Momenti chiave del round"
L.report_tab_events = "Eventi"
L.report_tab_events_tip = "Log degli eventi accaduti in questo round"
L.report_tab_scores = "Punteggi"
L.report_tab_scores_tip = "Punteggi fatti da ogni giocatore in questo round"

-- Salvataggio log degli eventi
-- Event log saving
L.report_save = "Salva il Log .txt"
L.report_save_tip = "Salva il Log degli eventi in un file di testo"
L.report_save_error = "Nessun Log degli eventi da salvare."
L.report_save_result = "Il Log degli eventi è stato salvato in:"

-- Schermata con titolo grande
-- Big title window
L.hilite_win_traitors = "I TRADITORI HANNO VINTO"
L.hilite_win_innocents = "GLI INNOCENTI HANNO VINTO"

L.hilite_players1 = "{numplayers} hanno partecipato, {numtraitors} erano traditori"
L.hilite_players2 = "{numplayers} hanno partecipato, uno di loro era un traditore"

L.hilite_duration = "Il round è durato {time}"

-- Colonne
-- Columns
L.col_time = "Tempo"
L.col_event = "Evento"
L.col_player = "Giocatore"
L.col_role = "Ruolo"
L.col_kills1 = "Uccisioni"
L.col_kills2 = "Uccisioni squadra"
L.col_points = "Punti"
L.col_team = "Bonus team"
L.col_total = "Punti totali"

-- Il nome di una trappola che ci ha uccisi a cui il mapper non ha dato un nome
-- Name of a trap that killed us that has not been named by the mapper
L.something = "qualcosa"

-- Eventi uccisioni
-- Kill events
L.ev_blowup = "{victim} si è fatto esplodere"
L.ev_blowup_trap = "{victim} è stato fatto esplodere da {trap}"

L.ev_tele_self = "{victim} si è telefraggato"
L.ev_sui = "{victim} non ce l'ha fatta e si è ucciso"
L.ev_sui_using = "{victim} si è ucciso usando {tool}"

L.ev_fall = "{victim} è morto di caduta"
L.ev_fall_pushed = "{victim} è morto di caduta dopo essere stato spinto da {attacker}"
L.ev_fall_pushed_using = "{victim} è morto di caduta dopo essere stato spinto da {attacker} con la trappola {trap}"

L.ev_shot = "{victim} è stata ucciso con un arma da {attacker}"
L.ev_shot_using = "{victim} è stata ucciso da {attacker} con l'arma {weapon}"

L.ev_drown = "{victim} è stato affogato da {attacker}"
L.ev_drown_using = "{victim} è stato affogato da {trap} tramite {attacker}"

L.ev_boom = "{victim} è stato fatto esplodere da {attacker}"
L.ev_boom_using = "{victim} è stato fatto esplodere da {attacker} con la trappola {trap}"

L.ev_burn = "{victim} è stato bruciato da {attacker}"
L.ev_burn_using = "{victim} è stato bruciato dalla trappola {trap} attivata da {attacker}"

L.ev_club = "{victim} è stato massacrato da {attacker}"
L.ev_club_using = "{victim} è stato massacrato da {attacker} usando la trappola {trap}"

L.ev_slash = "{victim} è stato accoltellato da {attacker}"
L.ev_slash_using = "{victim} è stato accoltellato da {attacker} usando la trappola {trap}"

L.ev_tele = "{victim} è stato telefraggato da {attacker}"
L.ev_tele_using = "{victim} è stato atomizzato dalla trappola {trap} attivata da {attacker}"

L.ev_goomba = "{victim} è stata schiacciato dall'enorme masso di {attacker}"

L.ev_crush = "{victim} è stato schiacciato da {attacker}"
L.ev_crush_using = "{victim} è stato schiacciato dalla trappola {trap} attivata da {attacker}"

L.ev_other = "{victim} è stata ucciso da {attacker}"
L.ev_other_using = "{victim} è stata ucciso da {attacker} con la trappola {trap}"

-- Altri eventi
-- Other events
L.ev_body = "{finder} ha trovato il cadavere di {victim}"
L.ev_c4_plant = "{player} ha piazzato un C4"
L.ev_c4_boom = "Il C4 piazzato da {player} è esploso"
L.ev_c4_disarm1 = "{player} ha disinnescato il C4 piazzato da {owner}"
L.ev_c4_disarm2 = "{player} non è riuscito a disarmare il C4 piazzato da {owner}"
L.ev_credit = "{finder} ha trovato {num} credito/i sul cadavere di {player}"

L.ev_start = "Il round è cominciato"
L.ev_win_traitor = "Gli ignobili traditori hanno vinto il round!"
L.ev_win_inno = "Gli amabili innocenti hanno vinto il round!"
L.ev_win_time = "I traditori hanno finito il tempo e hanno perso!"

-- Premi/momenti chiave
-- Awards/highlights

L.aw_sui1_title = "Capo del Culto dei Suicidi"
L.aw_sui1_text = "ha mostrato a tutti gli altri suicidi come farlo facendolo per primo."

L.aw_sui2_title = "Solo e Depresso"
L.aw_sui2_text = "l'unico che si è ucciso da solo."

L.aw_exp1_title = "Ricerca Esplosivi"
L.aw_exp1_text = "è stato premiato per la sua ricerca sugli esplosivi. {num} persone lo hanno aiutato nei test."

L.aw_exp2_title = "Ricerca sul Campo"
L.aw_exp2_text = "ha provato la sua resistenza agli esplosivi. Non era abbastanza alta."

L.aw_fst1_title = "Primo Sangue"
L.aw_fst1_text = "è stato il primo traditore ad uccidere un innocente."

L.aw_fst2_title = "Prima Stupida Uccisione"
L.aw_fst2_text = "ha fatto la prima uccisione uccidendo un compagno traditore. Complimenti."

L.aw_fst3_title = "Primo Errore"
L.aw_fst3_text = "è stato il primo ad uccidere. Peccato che fosse un compagno innocente."

L.aw_fst4_title = "Primo Colpo"
L.aw_fst4_text = "ha fatto la prima uccisione colpendo un traditore."

L.aw_all1_title = "Più Letale tra Compagni"
L.aw_all1_text = "è stato responsabile di ogni uccisione fatta dagli innocenti."

L.aw_all2_title = "Lupo Solitario"
L.aw_all2_text = "è stato responsabile per ogni uccisione fatta dai traditori."

L.aw_nkt1_title = "Ne Ho Preso Uno, Boss!"
L.aw_nkt1_text = "ha ucciso un singolo innocente. Bene!"

L.aw_nkt2_title = "Un Proiettile per Due"
L.aw_nkt2_text = "ha mostrato al primo che non era un colpo fortunato uccidendone un altro."

L.aw_nkt3_title = "Traditore Seriale"
L.aw_nkt3_text = "ha tolto la vita a tre innocenti oggi."

L.aw_nkt4_title = "Lupo tra Più Pecore Simili a Lupi"
L.aw_nkt4_text = "mangia innocenti per cena. Una cena di {num} portate."

L.aw_nkt5_title = "Operazione Anti-Terrorismo"
L.aw_nkt5_text = "viene pagato per uccisione. Ora ha uno yacht di lusso."

L.aw_nki1_title = "Tradisci Questo"
L.aw_nki1_text = "trovato un traditore. Ucciso un traditore. Facile."

L.aw_nki2_title = "Fatto Domanda alla Justice Squad"
L.aw_nki2_text = "ha portato due traditori nell'altro mondo."

L.aw_nki3_title = "I Traditori Sognano una Pecorella Traditrice?"
L.aw_nki3_text = "ha messo a riposo tre traditori."

L.aw_nki4_title = "Dipendente degli Affari Interni"
L.aw_nki4_text = "viene pagato per uccisione. Ora può ordinare la sua quinta piscina."

L.aw_fal1_title = "No Mr. Bond, mi Aspetto che Lei Cada"
L.aw_fal1_text = "ha spinto qualcuno da un posto molto alto."

L.aw_fal2_title = "Atterrato"
L.aw_fal2_text = "ha fatto cadere il suo corpo a terra dopo essere caduto da un'altezza importante."

L.aw_fal3_title = "Meteorite Umano"
L.aw_fal3_text = "ha schiacciato qualcuno cadendogli in testa da una grande altezza."

L.aw_hed1_title = "Efficienza"
L.aw_hed1_text = "ha scoperto la bellezza dei colpi alla testa facendone {num}."

L.aw_hed2_title = "Neurologia"
L.aw_hed2_text = "ha rimosso il cervello da {num} teste per esaminarli."

L.aw_hed3_title = "I Videogiochi me l'Hanno Fatto Fare"
L.aw_hed3_text = "ha applicato le sue conoscenze nelle simulazione sparando in testa a {num} persone."

L.aw_cbr1_title = "Thunk Thunk Thunk"
L.aw_cbr1_text = "da belle mazzate con la crowbar, come constatato da {num} vittime."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text = "ha coperto la sua crowbar con il cervello di {num} persone."

L.aw_pst1_title = "Persistente Piccolo Bastardo"
L.aw_pst1_text = "ha ucciso {num} persone con la pistola. Poi sono andati ad abbracciare qualcuno fino alla morte."

L.aw_pst2_title = "Strage di Piccolo Calibro"
L.aw_pst2_text = "ha ucciso un piccolo gruppo di {num} persone con la pistola. Probabilmente con un piccolo fucile a pompa nella canna."

L.aw_sgn1_title = "Modalità Facile"
L.aw_sgn1_text = "ha infilato il pallettone dove fa male, uccidendo {num} persone."

L.aw_sgn2_title = "Migliaia di Piccoli Pellet"
L.aw_sgn2_text = "non gli piaceva tanto il suo pallettone, quindi li ha regalati tutti. {num} persone che lo hanno ricevuto non sono sopravvissute abbastanza a lungo per apprezzarlo."

L.aw_rfl1_title = "Punta e Clicca"
L.aw_rfl1_text = "ha mostrato che quello che serve per uccidere {num} persone è un fucile da cecchino e una mano ferma."

L.aw_rfl2_title = "Posso Vedere la tua Testa da Qui"
L.aw_rfl2_text = "conosce il suo fucile. Ora anche altre {num} persone lo conoscono."

L.aw_dgl1_title = "È Come un Piccolo Fucile"
L.aw_dgl1_text = "si sta abituando con la Desert Eagle e ha ucciso {num} persone."

L.aw_dgl2_title = "Eagle Master"
L.aw_dgl2_text = "ha distrutto {num} persone con la deagle."

L.aw_mac1_title = "Prega e Uccidi"
L.aw_mac1_text = "ha ucciso {num} persone con il MAC10, ma non parliamo di quante munizioni ha usato."

L.aw_mac2_title = "Mac-cheroni al Formaggio"
L.aw_mac2_text = "cosa potrebbe succedere se potesse sparare con due MAC10. {num} uccisioni per 2?"

L.aw_sip1_title = "Fai Silenzio"
L.aw_sip1_text = "ha fatto stare in silenzio {num} persone con la sua pistola silenziata."

L.aw_sip2_title = "Assassino Silenzioso"
L.aw_sip2_text = "ha ucciso {num} persone e nessuno ha sentito niente."

L.aw_knf1_title = "Coltello che ti Conosce"
L.aw_knf1_text = "ha accoltellato qualcuno sul volto su internet."

L.aw_knf2_title = "Da Dove l'Hai Preso?"
L.aw_knf2_text = "non era un Traditore, ma ha comunque ucciso qualcuno con un coltello."

L.aw_knf3_title = "Un Apprezzatore di Coltelli"
L.aw_knf3_text = "ha trovato {num} coltelli in giro, e li ha utilizzati per uccidere."

L.aw_knf4_title = "Il Più Abile Accoltellatore del Mondo"
L.aw_knf4_text = "ha ucciso {num} persone con un coltello. Non chiedete come."

L.aw_flg1_title = "Al Salvataggio"
L.aw_flg1_text = "ha usato i suoi razzi per segnalare le sue {num} uccisioni."

L.aw_flg2_title = "Razzo Segnalatore"
L.aw_flg2_text = "ha insegnato a {num} persone il pericolo di indossare vestiti infiammabili."

L.aw_hug1_title = "Una strage di H.U.G.E."
L.aw_hug1_text = "era in sintonia con il suo H.U.G.E, riuscendo in qualche modo a colpire {num} persone."

L.aw_hug2_title = "Tranquillità"
L.aw_hug2_text = "ha continuato a sparare, e ha visto la sua grande pazienza essere ricompensata con {num} uccisioni."

L.aw_msx1_title = "Putt Putt Putt"
L.aw_msx1_text = "ha fatto fuori {num} persone con il suo M16."

L.aw_msx2_title = "Follia a Media Distanza"
L.aw_msx2_text = "sa come colpire i suoi bersagli con il suo M16, uccidendo {num} persone."

L.aw_tkl1_title = "Fatto un Errorino"
L.aw_tkl1_text = "gli è partito un colpo mentre mirava ad un compagno."

L.aw_tkl2_title = "Doppio Errorino"
L.aw_tkl2_text = "pensava di aver ucciso un Traditore due volte, invece si è sbagliato entrambe le volte."

L.aw_tkl3_title = "Consapevole del Karma"
L.aw_tkl3_text = "non poteva fermarsi dopo aver ucciso due compagni. Tre è un numero fortunato."

L.aw_tkl4_title = "Uccisore di compagni"
L.aw_tkl4_text = "ha ucciso tutta la sua squadra. OHMIODIOBANBANBAN."

L.aw_tkl5_title = "Giocatore di ruolo"
L.aw_tkl5_text = "stava facendo finta di essere un pazzo. Per questo ha ucciso la maggior parte della sua squadra."

L.aw_tkl6_title = "Idiota"
L.aw_tkl6_text = "non riusciva a capire a che squadra appartenesse, e ha ucciso più della metà dei suoi compagni."

L.aw_tkl7_title = "Contadino"
L.aw_tkl7_text = "ha protetto il suo campo perfettamente uccidendo più di un quarto dei suoi compagni."

L.aw_brn1_title = "Come le Faceva la Nonna"
L.aw_brn1_text = "ha fritto diverse persone come patatine fritte."

L.aw_brn2_title = "Piromane"
L.aw_brn2_text = "lo abbiamo sentito ridere dopo aver bruciato una delle sue tante vittime."

L.aw_brn3_title = "Bruciatore Pirrico"
L.aw_brn3_text = "li ha bruciati tutti, ma ora ha finito le sue granate incendiarie! Come farà!?"

L.aw_fnd1_title = "Coroner"
L.aw_fnd1_text = "ha trovato {num} cadaveri in giro."

L.aw_fnd2_title = "Gotta Catch 'Em All"
L.aw_fnd2_text = "ha trovato {num} cadaveri per la sua collezione."

L.aw_fnd3_title = "Odore di morte"
L.aw_fnd3_text = "continua a incontrare cadaveri a terra, {num} volte questo round."

L.aw_crd1_title = "Riciclatore"
L.aw_crd1_text = "ha raccolto {num} crediti da cadaveri."

L.aw_tod1_title = "Vittoria Pirrica"
L.aw_tod1_text = "morto solo pochi secondi prima che la sua squadra vincesse."

L.aw_tod2_title = "Odio Questo Gioco"
L.aw_tod2_text = "morto proprio all'inizio del round."


--- Stringhe nuove e modificate sono inserite qui sotto, segnati con la versione
--- nella quale sono state inserite, per rendere più facile aggiornare le traduzioni
--- New and modified pieces of text are placed below this point, marked with the
--- version or the date in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Evita di essere scelto come Detective"
L.set_avoid_det_tip = "Abilita questa opzione per chiedere al server di non selezionarti come Detective se possibile. Non vuole dire che sarai Traditore più spesso."

--- v24
L.drop_no_ammo = "Munizioni insufficienti nel tuo caricatore per lasciare un pacchetto di munizioni."

--- v31
L.set_cross_brightness = "Luminosità mirino"
L.set_cross_size = "Grandezza mirino"

--- 2015-05-25
L.hat_retrieve = "Hai raccolto il cappello di un Detective."

--- 2017-03-09
L.sb_sortby = "Ordina per:"

--- 2018-07-24
L.equip_tooltip_main = "Menù equipaggiamento"
L.equip_tooltip_radar = "Controllo Radar"
L.equip_tooltip_disguise = "Controllo Travestimento"
L.equip_tooltip_radio = "Controllo Radio"
L.equip_tooltip_xfer = "Trasferisci crediti"

L.confgrenade_name = "Discombobulator"
L.polter_name = "Poltergeist"
L.stungun_name = "Prototipo UMP"

L.knife_instant = "UCCISIONE ISTANTANEA"

L.dna_hud_type = "TIPO"
L.dna_hud_body = "CORPO"
L.dna_hud_item = "OGGETTO"

L.binoc_zoom_level = "LIVELLO"
L.binoc_body = "CORPO TROVATO"

L.idle_popup_title = "Inattivo"
