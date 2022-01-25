---- Spanish language strings

local L = LANG.CreateLanguage("Español")

--- General text used in various places
L.traitor    = "Traidor"
L.detective  = "Detective"
L.innocent   = "Inocente"
L.last_words = "Últimas palabras"

L.terrorists = "Terroristas"
L.spectators = "Espectadores"

--- Round status messages
L.round_minplayers = "No hay suficientes jugadores para inciar una nueva ronda..."
L.round_voting     = "Se ha iniciado una invitación, iniciando una nueva ronda en {num} segundos..."
L.round_begintime  = "Va a comenzar una ronda en {num} segundos. ¡Prepárate!"
L.round_selected   = "Se ha elegido a los traidores."
L.round_started    = "¡La ronda ha comenzado!"
L.round_restart    = "Un administrador ha reiniciado la ronda."

L.round_traitors_one  = "Eres el traidor, estás solo."
L.round_traitors_more = "Eres el traidor, tus aliados son: {names}"

L.win_time         = "Se ha acabado el tiemp. Los traidores han perdido."
L.win_traitor      = "¡Han ganado los traidores!"
L.win_innocent     = "¡Los traidores han sido derrotados!"
L.win_showreport   = "¡Echa un vistazo al informe de la ronda durante {num} segundos."

L.limit_round      = "Se ha alcanzado el límite de rondas. El próximo mapa será {mapname}."
L.limit_time       = "Se ha alcanzado el límite de tiempo. El próximo mapa será {mapname}."
L.limit_left       = "Quedan {num} ronda{s} o {time} minutos para cambiar de mapa a {mapname}."

--- Credit awards
L.credit_det_all   = "Detectives, habéis sido recompensados con {num} crédito(s) por vuestra actuación."
L.credit_tr_all    = "Traidores, habéis sido recompensados con {num} crédito(s) por vuestra actuación."

L.credit_kill      = "Has recibido {num} crédito(s) por matar a un {role}."

--- Karma
L.karma_dmg_full   = "Tienes {amount} de karma, ¡así que esta ronda causas más daño!"
L.karma_dmg_other  = "Tienes {amount} de karma. Como resultado, el daño que causas se ha reducido un {num}%"

--- Body identification messages
L.body_found       = "{finder} ha encontrado el cadáver de {victim}. {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "¡Era un traidor!"
L.body_found_d     = "¡Era un detective!"
L.body_found_i     = "¡Era inocente!"

L.body_confirm     = "{finder} ha confirmado la muerte de {victim}."

L.body_call        = "¡{player} ha pedido que un detective investigue el cadáver de {victim}!"
L.body_call_error  = "¡Debes confirmar la muerte de este jugador antes de llamar a un detective!"

L.body_burning     = "¡Vaya! ¡Este cadáver está chamuscado!"
L.body_credits     = "¡Has encontrado {num} crédito(s) en el cadáver!"

--- Menus and windows
L.close = "Cerrar"
L.cancel = "Cancelar"

-- For navigation buttons
L.next = "Siguiente"
L.prev = "Anterior"

-- Equipment buying menu
L.equip_title     = "Equipamiento"
L.equip_tabtitle  = "Menú de compra"

L.equip_status    = "Estado de compra"
L.equip_cost      = "Te quedan {num} crédito(s)."
L.equip_help_cost = "Cada cosa que has comprado cuesta un crédito."

L.equip_help_carry = "Sólo puedes comprar cosas para las que tengas espacio."
L.equip_carry      = "Puedes llevar esto."
L.equip_carry_own  = "Ya tienes esto."
L.equip_carry_slot = "Ya tienes esta arma en el espacio {slot}."

L.equip_help_stock = "Algunos objetos sólo se pueden comprar una vez por ronda."
L.equip_stock_deny = "No hay existencias de este objeto."
L.equip_stock_ok   = "Hay existencias de este objeto."

L.equip_custom     = "Objeto personalizado del servidor."

L.equip_spec_name  = "Nombre"
L.equip_spec_type  = "Tipo"
L.equip_spec_desc  = "Descripción"

L.equip_confirm    = "Comprar"

-- Disguiser tab in equipment menu
L.disg_name      = "Disfraz"
L.disg_menutitle = "Menú del disfraz"
L.disg_not_owned = "¡No has comprado ningún disfraz!"
L.disg_enable    = "Activar disfraz"

L.disg_help1     = "Cuando activas tu disfraz, tu nombre, salud y karma no se muestran cuando alguien te mira. Además, serás invisible ante el radar del detective."
L.disg_help2     = "Pulsa intro en el Bloq. Num para activar o desactivar el disfraz sin usar el menú. Si lo deseas puedes ponerte otra tecla usando el comando 'ttt_toggle_disguise' en la consola."

-- Radar tab in equipment menu
L.radar_name      = "Radar"
L.radar_menutitle = "Menú del radar"
L.radar_not_owned = "¡No has comprado ningún radar!"
L.radar_scan      = "Escanear"
L.radar_auto      = "Repetir escaneo"
L.radar_help      = "Los resultados se muestran durante {num} segundos. El radar se podrá usar de nuevo cuando se haya recargado."
L.radar_charging  = "¡Tu radar aún está cargándose!"

-- Transfer tab in equipment menu
L.xfer_name       = "Transferencia"
L.xfer_menutitle  = "Transferir créditos"
L.xfer_no_credits = "¡No tienes créditos para dar!"
L.xfer_send       = "Enviar un crédito"
L.xfer_help       = "Solo puedes transferir créditos a los jugadores que sean {role}."

L.xfer_no_recip   = "Jugador no encontrado, transferencia cancelada."
L.xfer_no_credits = "No hay créditos suficientes."
L.xfer_success    = "Se ha realizado la transferencia a {player}."
L.xfer_received   = "{player} te ha dado {num} crédito(s)."

-- Radio tab in equipment menu
L.radio_name      = "Radio"
L.radio_help      = "Haz clic a un botón para que tu radio reproduzca sonido."
L.radio_notplaced = "Debes colocar la radio para que suene."

-- Radio soundboard buttons
L.radio_button_scream  = "Grito"
L.radio_button_expl    = "Explosión"
L.radio_button_pistol  = "Disparos de pistola"
L.radio_button_m16     = "Disparos de M16"
L.radio_button_deagle  = "Disparos de Deagle"
L.radio_button_mac10   = "Disparos de MAC10"
L.radio_button_shotgun = "Disparos de escoepta"
L.radio_button_rifle   = "Disparo de rifle"
L.radio_button_huge    = "Ráfaga de H.U.G.E"
L.radio_button_c4      = "Pitido de C4"
L.radio_button_burn    = "Fuego"
L.radio_button_steps   = "Pasos"


-- Intro screen shown after joining
L.intro_help     = "¡Si eres nuevo en el juego pulsa F1 para ver las instrucciones!"

-- Radiocommands/quickchat
L.quick_title   = "Teclas de acceso rápido a chat"

L.quick_yes     = "Sí."
L.quick_no      = "No."
L.quick_help    = "¡Ayuda!"
L.quick_imwith  = "Estoy con {player}."
L.quick_see     = "Veo a {player}."
L.quick_suspect = "{player} es sospechoso."
L.quick_traitor = "¡{player} es un traidor!"
L.quick_inno    = "{player} es inocente."
L.quick_check   = "¿Queda alguien vivo?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "nadie"
L.quick_disg      = "alguien disfrazado"
L.quick_corpse    = "un cuerpo no identificado"
L.quick_corpse_id = "cadáver de {player}"


--- Body search window
L.search_title  = "Resultados de búsqueda"
L.search_info   = "Información"
L.search_confirm = "Confirmar muerte"
L.search_call   = "Llamar detective"

-- Descriptions of pieces of information found
L.search_nick   = "Este cadáver es de {player}."

L.search_role_t = "¡Esta persona era un traidor!"
L.search_role_d = "Esta persona era un detective."
L.search_role_i = "Esta persona era un terrorista inocente."

L.search_words  = "Algo te dice que las últimas palabras de esta persona fueron: '{lastwords}'"
L.search_armor  = "Llevaba un chaleco antibalas."
L.search_disg   = "Llevaba un dispositivo para camuflar su identidad."
L.search_radar  = "Llevaba un radar. Pero ya no funciona."
L.search_c4     = "Tenía una nota en el bolsillo. Pone que cortando el cable {num} se desactiva una bomba."

L.search_dmg_crush  = "Algunos de sus huesos están rotos. Parece ser que ha muerto por el impacto de un objeto."
L.search_dmg_bullet = "Ha sido fusilado."
L.search_dmg_fall   = "Ha muerto por caída."
L.search_dmg_boom   = "Sus heridas y su ropa indican a que una explosión fue la causa de su muerte."
L.search_dmg_club   = "Su cuerpo está amoratado y golpeado. Ha sido apalizado."
L.search_dmg_drown  = "El cuerpo muestra signos de axfisia. Ha muerto ahogado."
L.search_dmg_stab   = "Ha sido apuñalado. Ha muerto desangrado."
L.search_dmg_burn   = "Por aquí huele a terrorista a la parrilla..."
L.search_dmg_tele   = "¡Parece que su ADN estaba mezclado con emisiones de taquiones!"
L.search_dmg_car    = "Cuando ha ido a cruzar la carretera, un conductor descuidado lo ha atropellado."
L.search_dmg_other  = "No se puede encontrar una causa específica de la muerte de este terrorista."

L.search_weapon = "Parece que se usó un arma {weapon} para matarlo."
L.search_head   = "Murió de un solo disparo en la cabeza. No le dio tiempo a gritar."
L.search_time   = "Han pasado {time} segundos escasos desde su muerte hasta tu inspección."
L.search_dna    = "Toma una muestra del ADN del asesino con el escáner de ADN. La muestra de ADN caducará en {time} segundos."

L.search_kills1 = "Has encontrado una lista de muertes que confirma la muerte de {player}."
L.search_kills2 = "Has encontrado una lista de muertes con los nombres:"
L.search_eyes   = "Gracias a tus habilidades de detective, has identificado que la última persona a la que vio fuey: {player}. ¿Será una coincidencia? ¿O quizá sea su verdadero asesino?"


-- Scoreboard
L.sb_playing    = "Estás jugando en..."
L.sb_mapchange  = "El mapa cambia en {num} rondas o {time}"

L.sb_mia        = "Perdido en combate"
L.sb_confirmed  = "Muerto confirmado"

L.sb_ping       = "Ping"
L.sb_deaths     = "Muertes"
L.sb_score      = "Punt."
L.sb_karma      = "Karma"

L.sb_info_help  = "Investiga el cadáver de este jugador, puedes revisar los resultados aquí."

L.sb_tag_friend = "AMIGO"
L.sb_tag_susp   = "SOSPECHOSO"
L.sb_tag_avoid  = "EVITAR"
L.sb_tag_kill   = "MATAR"
L.sb_tag_miss   = "PERDIDO"

--- Help and settings menu (F1)

L.help_title = "Ayuda y ajustes"

-- Tabs
L.help_tut     = "Tutorial"
L.help_tut_tip = "Como funciona TTT, en 6 pasos"

L.help_settings = "Ajustes"
L.help_settings_tip = "Ajustes del cliente"

-- Settings
L.set_title_gui = "Ajustes de la interfaz"

L.set_tips      = "Mostrar consejos en la parte inferior de la pantalla mientras estás de espectador"

L.set_startpopup = "Duración de la ventana de información al comienzo de la ronda"
L.set_startpopup_tip = "Cuando comienza la ronda, aparece una pequeña ventana en la parte inferior de la pantalla unos segundos. Cambia aquí el tiempo que está."

L.set_cross_opacity = "Opacidad de la mira"
L.set_cross_disable = "Desactivar la mira completamente"
L.set_minimal_id    = "Identificación minimalista del objetivo (no muestra karma, consejos, etc.)"
L.set_healthlabel   = "Mostrar estado de la salud en la barra de salud"
L.set_lowsights     = "Bajar el arma al usar la mira"
L.set_lowsights_tip = "Actívalo para posicionar el arma más abajo cuando apuntes con ella. Esto hará más fácil dar en el blanco, pero será menos realista."
L.set_fastsw        = "Cambio rápido de arma"
L.set_fastsw_tip    = "Actívalo para pasar de un arma a otra rápidamente sin abrir el menú de cambio de arma."
L.set_fastsw_menu   = "Activar arma rápida conmutación"
L.set_fastswmenu_tip  = "Si se activa la arma rápida conmutación, el intercambiador de menú aparecerá"
L.set_wswitch       = "Desactivar autocierre del menú de cambio de arma"
L.set_wswitch_tip   = "Por defecto, el menú de cambio de arma se cierra automáticamente al pasar unos segundos. Activa esto para que no se cierre."
L.set_cues          = "Reproducir una señal cuando la ronda empieza o acaba"


L.set_title_play    = "Ajustes de juego"

L.set_specmode      = "Modo sólo espectador (estar siempre en espectador)"
L.set_specmode_tip  = "El modo sólo espectador evitará que te regeneres al comenzar la próxima ronda, en su lugar estarás de espectador."
L.set_mute          = "Enmudecer a los vivos al morir"
L.set_mute_tip      = "Actívalo para que se enmudezcan los vivos cuando estás muerto/de espectador."


L.set_title_lang    = "Ajustes de idioma"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "Elegir idioma (Select language):"


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "Esta arma está agotada: ya la has comprado en esta ronda."
L.buy_pending     = "Aún tienes una compra pendiente, espera a recibirla."
L.buy_received    = "Has recibido tu equipamiento especial."

L.drop_no_room    = "¡No tienes espacio para tirar tu arma aquí!"

L.disg_turned_on  = "¡Disfraz activado!"
L.disg_turned_off = "Disfraz desactivado."

-- Equipment item descriptions
L.item_passive    = "Objeto de efecto pasivo"
L.item_active     = "Objeto de uso activo"
L.item_weapon     = "Arma"

L.item_armor      = "Antibalas"
L.item_armor_desc = [[
Reduce el daño de bala en un 30%
al recibir impactos.

Predeterminado para detectives.]]

L.item_radar      = "Radar"
L.item_radar_desc = [[
Te permite escanear señales de vida.

Comienza a escanear tan pronto como
lo compras. Configúralo en la pestaña
Radar de este mismo menú.]]

L.item_disg       = "Disfraz"
L.item_disg_desc  = [[
Oculta tu información cuando lo llevas.
Además hace que no aparezcas como la
Última persona a la que vio la víctima.

Activa y desactívalo en la pestaña
Disfraz de este menú o pulsa Intro en
el Bloq. Num.]]

-- C4
L.c4_hint         = "Pulsa {usekey} para activar o desactivar."
L.c4_no_disarm    = "No puedes desactivar otro C4 de un traidor si no está muerto."
L.c4_disarm_warn  = "Un explosivo C4 que habías colocado ha sido desactivado."
L.c4_armed        = "Has colocado la bomba."
L.c4_disarmed     = "Has desactivado la bomba."
L.c4_no_room      = "No puedes llevar este C4."

L.c4_desc         = "Artefacto explosivo programado."

L.c4_arm          = "Activar C4"
L.c4_arm_timer    = "Temporizador"
L.c4_arm_seconds  = "Segundos hasta que explote:"
L.c4_arm_attempts = "A la hora de desactivarla, {num} de los 6 cables causarán la explosión instantánea."

L.c4_remove_title    = "Desactivación"
L.c4_remove_pickup   = "Recoger C4"
L.c4_remove_destroy1 = "Destruir C4"
L.c4_remove_destroy2 = "Confirmar: destruir"

L.c4_disarm       = "Desactivar C4"
L.c4_disarm_cut   = "Haz clic para cortar el {num}"

L.c4_disarm_t     = "Corta un cable para desactivar la bomba. Cualquiera vale, porque eres traidor. ¡Los inocentes no lo tienen tan fácil!"
L.c4_disarm_owned = "Corta un cable para desactivar la bomba. Cualquiera vale, porque es tu bomba."
L.c4_disarm_other = "Corta un cable seguro para desactivar la bomba. ¡Explotará si te equivocas de cable!"

L.c4_status_armed    = "ACTIVADA"
L.c4_status_disarmed = "DESACTIVADA"

-- Visualizer
L.vis_name        = "Visualizador"
L.vis_hint        = "Pulsa {usekey} para recogerlo (sólo detectives)."

L.vis_help_pri    = "{primaryfire} lanza el dispositivo activado."

L.vis_desc        = [[
Dispositivo que muestra la escena
del crimen.

Analiza un cadáver para mostrar cómo
fue asesinado, pero solo si murió
por impacto de bala.]]

-- Decoy
L.decoy_name      = "Señuelo"
L.decoy_no_room   = "No puedes llevar este señuelo."
L.decoy_broken    = "¡Tu señuelo ha sido destruido!"

L.decoy_help_pri  = "{primaryfire} coloca el señuelo."

L.decoy_desc      = [[
Muestra una señal falsa en el radar de
los detectives y hace que sus escáner
de ADN muestren la ubicación del
señuelo si analizan tu ADN.]]

-- Defuser
L.defuser_name    = "Kit de desactivación"
L.defuser_help    = "{primaryfire} desactiva el C4."

L.defuser_desc    = [[
Desactiva el C4 instantáneamente.

Uso ilimitado. Los C4 serán más
fáciles de localizar con esto.]]

-- Flare gun
L.flare_name      = "Pistola de bengalas"
L.flare_desc      = [[
Puede usarse para quemar cadáveres y que
no puedan ser analizados.
Munición limitada.

Quemar un cuerpo produce un sonido
que puede ser reconocible.]]

-- Health station
L.hstation_name   = "Estación de salud"
L.hstation_hint   = "Pulsa {usekey} para conseguir salud. Carga: {num}."
L.hstation_broken = "¡Tu estación de salud ha sido destruida!"
L.hstation_help   = "{primaryfire} coloca una estación de salud."

L.hstation_desc   = [[
Permite a la gente curarse cuando
está colocado.

Se recarga lentamente. Cualquiera puede
usarlo y puede destruirse. En él pueden
tomarse muestras de ADN de sus usuarios.]]

-- Knife
L.knife_name      = "Cuchillo"
L.knife_thrown    = "Cuchillo lanzado"

L.knife_desc      = [[
Mata a los objetivos instantánea y
silenciosamente, pero solo se puede
usar una vez.

Puede lanzarse con el clic secundario.]]

-- Poltergeist
L.polter_desc     = [[
Coloca golpeadores en los objetos para
empujarlos alrededor violentamente.

Las ondas expansivas dañan a la gente
que se encuentra cerca.]]

-- Radio
L.radio_broken    = "¡Tu radio ha sido destruida!"
L.radio_help_pri  = "{primaryfire} coloca la radio."

L.radio_desc      = [[
Dispositivo que eproduce un sonido
para distraer.

Coloca la radio en algún lado y activa
un sonido desde la pestaña Radio de
este menú.]]

-- Silenced pistol
L.sipistol_name   = "Pistola silenciada"

L.sipistol_desc   = [[
Reduce el ruido de la pistola. Usa la
munición estándar.

Las víctimas no gritarán al morir.]]

-- Newton launcher
L.newton_name     = "Lanzador de neutonio"

L.newton_desc     = [[
Empuja a la gente desde una distancia
segura.

Munición infinita, dispara lentamente.]]

-- Binoculars
L.binoc_name      = "Prismáticos"
L.binoc_desc      = [[
Con ellos podrás identificar los
cadáveres desde lejos.

Usos ilimitados, pero tomará unos
segundos la identificación del
cuerpo.]]

L.binoc_help_pri  = "{primaryfire} identifica un cadaver."
L.binoc_help_sec  = "{secondaryfire} modifica el zoom."

-- UMP
L.ump_desc        = [[
Prototipo de subfusil que desorienta
a los objetivos en los que impacta.

Usa munición estándar.]]

-- DNA scanner
L.dna_name        = "Escáner de ADN"
L.dna_identify    = "Debe identificarse el cadáver para tomar el ADN del asesino."
L.dna_notfound    = "No se ha encontrado muestra de ADN en el objetivo."
L.dna_limit       = "Se ha alcanzado el límite de almacenamiento. Tira las muestras antiguas."
L.dna_decayed     = "Ha caducado la muestra de ADN del asesino."
L.dna_killer      = "¡Se ha encontrado una muestra de ADN del asesino en el cadáver!"
L.dna_no_killer   = "No se ha encontrado ADN (¿se habrá desconectado el asesino?)."
L.dna_armed       = "¡Hay una bomba colocada! ¡Desactívala primero!"
L.dna_object      = "Se han encontrado {num} muestra(s) de ADN nueva(s) del objeto."
L.dna_gone        = "No se han encontrado restos de ADN en esta zona."

L.dna_desc        = [[
Toma muestras de ADN de cosas y cuerpos
y úsalos para encontrar a su dueño.

Utilizalo en los cadáveres frescos para
tomar el ADN y seguirle la pista.]]

L.dna_menu_title  = "Control de escaneo de ADNA"
L.dna_menu_sample = "Muestra de ADN en {source}"
L.dna_menu_remove = "Eliminar selección"
L.dna_menu_help1  = "Has tomado estas muestras de ADN."
L.dna_menu_help2  = [[
Cuando está cargado, puedes escanear la
ubicación del jugador al que pertenece la
muestra de ADN que hayas elegido. Cuanto
mayor sea la distancia más energía gastará.]]

L.dna_menu_scan   = "Escanear"
L.dna_menu_repeat = "Repetir"
L.dna_menu_ready  = "LISTO"
L.dna_menu_charge = "CARGANDO"
L.dna_menu_select = "ELEGIR MUESTRA"

L.dna_help_primary   = "{primaryfire} para tomar una muestra de ADN"
L.dna_help_secondary = "{secondaryfire} para abrir los controles del escáner"

-- Magneto stick
L.magnet_name     = "Magnetopalo"
L.magnet_help     = "{primaryfire} para adjuntar un objeto al suelo."

-- Grenades and misc
L.grenade_smoke   = "Granada de humo"
L.grenade_fire    = "Granada incendiaria"

L.unarmed_name    = "Sin nada"
L.crowbar_name    = "Palanca"
L.pistol_name     = "Pistola"
L.rifle_name      = "Rifle"
L.shotgun_name    = "Escopeta"

-- Teleporter
L.tele_name       = "Teleportador"
L.tele_failed     = "Teleporte fallido."
L.tele_marked     = "Destino marcado."

L.tele_no_ground  = "¡No puedes teleportarte si no estás en una superficie sólida!"
L.tele_no_crouch  = "¡No puedes teleportarte mientras estás agachado!"
L.tele_no_mark    = "No hay ningún destino marcado. Marca uno antes de teleportarte."

L.tele_no_mark_ground = "¡No puedes establecer un destino si no estás en una superficie sólida!"
L.tele_no_mark_crouch = "¡No puedes establecer un destino mientras estás agachado!"

L.tele_help_pri   = "{primaryfire} te teleporta al destino."
L.tele_help_sec   = "{secondaryfire} establece la ubicación actual como destino."

L.tele_desc       = [[
Teleporta al destino previamente
establecido.

El teleporte causa ruido y el
número de usos es limitado.]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "Balas de 9mm"

L.ammo_smg1       = "Munición del subfusil"
L.ammo_buckshot   = "Munición de la escopeta"
L.ammo_357        = "Munición del rifle"
L.ammo_alyxgun    = "Munición de la Deagle"
L.ammo_ar2altfire = "Munición de bengalas"
L.ammo_gravity    = "Munición de poltergeist"


--- HUD interface text

-- Round status
L.round_wait   = "Esperando"
L.round_prep   = "Preparando"
L.round_active = "En progreso"
L.round_post   = "Ronda acabada"

-- Health, ammo and time area
L.overtime     = "PRÓRROGA"
L.hastemode    = "MODO PRISA"

-- TargetID health status
L.hp_healthy   = "Saludable"
L.hp_hurt      = "Dañado"
L.hp_wounded   = "Herido"
L.hp_badwnd    = "Gravemente herido"
L.hp_death     = "Casi muerto"


-- TargetID karma status
L.karma_max    = "Formal"
L.karma_high   = "Vulgar"
L.karma_med    = "Gatillo fácil"
L.karma_low    = "Peligroso"
L.karma_min    = "Responsable"

-- TargetID misc
L.corpse       = "Cadáver"
L.corpse_hint  = "Pulsa {usekey} para investigar. {walkkey} + {usekey} para investigar en secreto."

L.target_disg  = " (DISFRAZ)"
L.target_unid  = "Cuerpo sin identificar"

L.target_traitor = "TRAIDOR ALIADO"
L.target_detective = "DETECTIVE"

L.target_credits = "Busca para recibir créditos no usados"

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single  = "Un solo uso"
L.tbut_reuse   = "Reutilizable"
L.tbut_retime  = "Reutilizable cada {num} seg"
L.tbut_help    = "Pulsa {key} para activar"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "Disfrazado. Se ha ocultado tu nombre."
L.radar_hud    = "El radar estará listo en: {time}"

-- Spectator muting of living/dead
L.mute_living  = "Jugadores vivos enmudecidos"
L.mute_specs   = "Espectadores enmudecidos"
L.mute_all     = "Cada enmudecido"
L.mute_off     = "Nadie enmudecido"

-- Spectators and prop possession
L.punch_title  = "PUÑÓMETRO"
L.punch_help   = "WASD o saltar: golpear el objeto. Agacharse: dejar el objeto."
L.punch_bonus  = "Tu mala puntuación ha reducido el límite de tu puñómetro en {num}"
L.punch_malus  = "Tu buena puntuación ha aumentado el límite de tu puñómetro en {num}!"

L.spec_help    = "Haz clic para ver jugadores o pulsa {usekey} en un objeto físico para utilizarlo."

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[¡Eres un terrorista inocente! Pero hay traidores por ahí...
¡En quién puedes confiar y quién trata de llenarte de plomo?

¡Vigila tus espaldas y trabaja con tus camaradas para salir vivo de aquí!]]

L.info_popup_detective = [[¡Eres un detective! Terroristas S.A. te ha cedido material especial para encontrar al traidor.
úsalos para ayudar a los inocentes a sobrevivir, pero ten cuidado:
¡los traidores tratarán de acabar contigo primero!

¡Pulsa {menukey} para recibir tu equipamiento!]]

L.info_popup_traitor_alone = [[¡Eres un TRAIDOR! No tienes aliados esta ronda.

¡Acaba con todos los demás para ganar!

¡Pulsa {menukey} para recibir tu equipamiento!]]

L.info_popup_traitor = [[¡Eres un TRAIDOR! Colabora con tus aliados para acabar con todos.
Pero ten cuidado tu traición será descubierta...

Tus camaradas son:
{traitorlist}

¡Pulsa {menukey} para recibir tu equipamiento!]]

--- Various other text
L.name_kick = "Se ha expulsado automáticamente a un jugador porque se ha cambiado el nombre durante una ronda."

L.idle_popup = [[Has estado ausente durante {num} segundos y has sido movido al modo sólo espectador. Mientras estás en este modo no te regenerarás en cada ronda.

Puedes activar o desactivar el modo sólo espectador en cualquier momento con {helpkey} y desmarcando la opción en la pestaña Ajustes. Además puedes elegir desactivarla ahora mismo.]]

L.idle_popup_close = "No hacer nada"
L.idle_popup_off   = "Desactivar el modo ahora"

L.idle_warning = "Aviso: parece que estás ausente, ¡serás movido a espectador si no muestras actividad!"

L.spec_mode_warning = "Estás en espectador y no reaparecerás en las siguientes rondas. Para desactivar esto, pulsa F1, ve a Ajustes y desmarca 'modo sólo espectador'."


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "Consejos"
L.tips_panel_tip   = "Consejo:"

-- Tip texts

L.tip1 = "Los traidores pueden inspeccionar cadáveres silenciosamente, sin confirmar su muerte. Manteniendo {walkkey} y pulsando {usekey} sobre él."

L.tip2 = "Colocando un explosivo C4 con un temporizador que dure mucho tiempo, harás que el número de cables también aumente. También hará que pite más lentamente al principio."

L.tip3 = "Los detectives pueden ver en los cadáveres quien fue la última persona que vio. Esto no indica que sea el asesino en todos los casos, pudo ser asesinado por la espalda."

L.tip4 = "Nadie sabrá que has muerto hasta que no se encuentre e identifique tu cadáver."

L.tip5 = "Cuando un traidor mata a un detective, recibe un crédito instantáneamente."

L.tip6 = "Cuando un traidor muere, todos los detectives son recompensados con créditos."

L.tip7 = "Cuando los traidores realizan un progreso significante matando inocentes, recibirán un crédito como recompensa."

L.tip8 = "Los traidores y detectives pueden tomar créditos de los cuerpos de otros traidores o detectives."

L.tip9 = "El poltergeist puede convertir cualquier objeto físico en un proyectil mortal. Una explosión que causa un empujón que puede resultar mortal para quien pille por delante."

L.tip10 = "Como traidor o detective, no le quites el ojo de encima a los mensajes de arriba a la derecha. Esto será importante."

L.tip11 = "Como traidor o detective, recuerda que si tu y tus camaradas lo hacéis bien, seréis recompensados con créditos. ¡Acuérdate de gastarlos!"

L.tip12 = "El escáner de ADN de los detectives puede utilizarse para tomar muestras de ADN de armas y objetos y localizar al jugador que los usó. Es útil cuando puedes tomar muestras de un cadáver o un C4 desactivado!"

L.tip13 = "Cuando estás cerca de alguien a quien has matado, tu ADN se queda en el cadáver. Este ADN puede ser escaneado y revelará tu ubicación. ¡Mejor que escondas el cuerpo tras acuchillar a alguien!"

L.tip14 = "Cuanto más lejos estés de la víctima a la que mates, más rápido caducará tu muestra de ADN en su cuerpo."

L.tip15 = "¡Eres un traidor y vas usar un rifle francotirador? No estaría mal comprar un disfraz. Si fallas un tiro, corre a un lugar seguro, desactiva tu disfraz y nadie sabrá que fuiste tú el que disparó."

L.tip16 = "Como traidor, el teleportador puede ayudarte a escapar cuando te acorralen y te permite viajar rápidamente de una punta a otra del mapa. Asegúrate siempre de tener una zona segura marcada como destino."

L.tip17 = "¡Están agrupados todos los inocentes y es difícil acabar con ellos? Prueba a reproducir el sonido de la explosión de un C4 en la radio para revolverlos un poquillo."

L.tip18 = "Using the Radio as Traitor, you can play sounds through your Equipment Menu after the radio has been placed. Queue up multiple sounds by clicking multiple buttons in the order you want them."

L.tip19 = "Como detective, si te sobran créditos podrías darle un kit de desactivación a un inocente de confianza. Así puedes emplear tu tiempo en hacer arduas investigaciones y dejar el caso de la bomba a tu compañero."

L.tip20 = "Los prismáticos de los detectives permiten investigar e identificar los cadáveres a distancia. Malas noticias para el traidor que intente usar el cuerpo como cebo. Claro, que, mientras un detective usa los prismáticos estará indefenso..."

L.tip21 = "La estación de salud de los detectives permite curarse a los jugadores heridos. Pero... algunos de esos jugadores heridos podrían ser traidores..."

L.tip22 = "La estación de salud recoge una muestra de ADN de todos los que la usan. Los detectives pueden usar esto con el escáner de ADN para saber quiénes se han curado."

L.tip23 = "Al contrario de las armas y los C4, la radio de los traidores no contiene muestras de ADN de la persona que la colocó. No te preocupes de que te puedan encontrar y si eres detective, ni te molestes en inspeccionarlo."

L.tip24 = "Pulsa {helpkey} para ver un pequeño tutorial o modificar algunos ajustes de propios de TTT. Por ejemplo, puedes desactivar permanentemente los consejos."

L.tip25 = "Cuando un detective inspecciona un cuerpo, el resultado estará disponible para todos los jugadores haciendo clic el nombre de la persona muerta en la tabla de puntuación."

L.tip26 = "En la tabla de puntuaciones, cuando aparece el icono de una lupa junto al nombre de una persona, indica que has buscado información acerca de esa persona. Si el icono brilla, los datos son de detective y quizá contengan información adicional."

L.tip27 = "Como detective, los cadáveres con una lupa junto al nombre han sido investigados por un detective y sus resultados están disponibles para todos los jugadores por medio de la tabla de puntuaciones."

L.tip28 = "Los espectadores pueden pulsar {mutekey} para elegir si enmudecer o no a los otros espectadores y jugadores vivos."

L.tip29 = "Si el servidor ha instalado idiomas adicionales, puedes cambiar a un idioma distinto en cualquier momento desde el menú de ajustes."

L.tip30 = "El comando 'radio' puede utilizarse pulsando {zoomkey}."

L.tip31 = "Como espectador, pulsa {duckkey} para desbloquear tu cursor del ratón y hacer clic en los botones de este panel de consejos. Pulsa {duckkey} de nuevo para volver a la vista del ratón."

L.tip32 = "Con la palanca empujarás a otros jugadores usando el clic secundario."

L.tip33 = "Disparando mientras apuntas con la mira del arma incrementarás bastante tu puntería y disminuirás el retroceso. Agachándote no conseguirás este efecto."

L.tip34 = "La granadas de humo son efectivas en interiores, especialmente creando confusión en múltiples salas."

L.tip35 = "Como traidor, recuerda que puedes mover los cadáveres para esconderlos de los ojos de los inocentes y los detectives."

L.tip36 = "El tutorial disponible bajo {helpkey} contiene una vista general de la mayoráa de teclas del juego."

L.tip37 = "En la tabla de puntuaciones, haz clic en el nombre de un jugador vivo y podrás etiquetarlo de 'sospechoso' o 'amigo'. Esta etiqueta se mostrará si le pones la mira encima."

L.tip38 = "Algunos de los objetos de equipamiento colocables (como el C4 o la radio) pueden pegarse en paredes usando el clic secundario."

L.tip39 = "Los C4 que explotan como producto de cortar el cable equivocado durante su desactivación, causan una explosión menor a la que causa un C4 que haya llegado a cero."

L.tip40 = "Si aparece 'MODO PRISA' bajo el cronómetro, la rondas durará solo unos minutos, pero con cada muerte el tiempo aumentará (como la captura de puntos en TF2). Este modo presiona a los traidores para mantener las cosas en movimiento."

--- Round report

L.report_title = "Información de la ronda"

-- Tabs
L.report_tab_hilite = "Destacado"
L.report_tab_hilite_tip = "Destacado en la ronda"
L.report_tab_events = "Eventos"
L.report_tab_events_tip = "Registro de los eventos que se han producido esta ronda"
L.report_tab_scores = "Puntos"
L.report_tab_scores_tip = "Puntuación conseguida por cada jugador en esta ronda"

-- Event log saving
L.report_save     = "Guardar el registro en .txt"
L.report_save_tip = "Guarda el registro de eventos en un archivo de texto"
L.report_save_error  = "No hay datos que guardar."
L.report_save_result = "El registro de eventos se ha guardado en:"

-- Big title window
L.hilite_win_traitors = "GANAN LOS TRAIDORES"
L.hilite_win_innocent = "GANAN LOS INOCENTES"

L.hilite_players1 = "Están jugando {numplayers} personas y {numtraitors} de ellos son traidores"
L.hilite_players2 = "Están jugando {numplayers} personas y uno de ellos es un traidor"

L.hilite_duration = "La ronda ha durado {time}"

-- Columns
L.col_time   = "Tiempo"
L.col_event  = "Evento"
L.col_player = "Jugador"
L.col_role   = "Rol"
L.col_kills1 = "Inocentes asesinados"
L.col_kills2 = "Traidores asesinados"
L.col_points = "Puntos"
L.col_team   = "Bonif. de equipo"
L.col_total  = "Puntos totales"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "algo"

-- Kill events
L.ev_blowup      = "{victim} se inmoló"
L.ev_blowup_trap = "{victim} ha muerto por {trap}"

L.ev_tele_self   = "{victim} ha muerto por teleportarse"
L.ev_sui         = "{victim} no lo ha podido soportar y se ha suicidado"
L.ev_sui_using   = "{victim} se ha suicidado con su {tool}"

L.ev_fall        = "{victim} se ha matado"
L.ev_fall_pushed = "{victim} se ha caído tras ser atacado por {attacker} y se ha matado"
L.ev_fall_pushed_using = "{victim} se ha caído tras ser atacado por {attacker} con {trap} y se ha matado"

L.ev_shot        = "{victim} ha sido fusilado por {attacker}"
L.ev_shot_using  = "{victim} ha sido fusilado por {attacker}, quien usaba el arma {weapon}"

L.ev_drown       = "{victim} ha sido ahogado por {attacker}"
L.ev_drown_using = "{victim} ha sido ahogado por la {trap} de {attacker}"

L.ev_boom        = "{victim} ha sido reventado por {attacker}"
L.ev_boom_using  = "{victim} ha sido reventado por {attacker}, quien usaba una {trap}"

L.ev_burn        = "{victim} ha sido achicharrado por {attacker}"
L.ev_burn_using  = "{victim} ha sido achicharrado por la {trap} de {attacker}"

L.ev_club        = "{victim} ha sido apalizado por {attacker}"
L.ev_club_using  = "{victim} ha sido apalizado hasta la muerte por {attacker}, quien usaba una {trap}"

L.ev_slash       = "{victim} ha sido apuñalado por {attacker}"
L.ev_slash_using = "{victim} ha sido apuñaldo por {attacker}, quien usaba una {trap}"

L.ev_tele        = "{victim} ha muerto teletransportándose por {attacker}"
L.ev_tele_using  = "{victim} ha muerto por la {trap} que colocó {attacker}"

L.ev_goomba      = "{victim} ha sido aplastado por {attacker}"

L.ev_crush       = "{victim} ha sido aplastado por {attacker}"
L.ev_crush_using = "{victim} ha sido aplastado por la {trap} de {attacker}"

L.ev_other       = "{victim} ha sido asesinado por {attacker}"
L.ev_other_using = "{victim} ha sido asesinado por {attacker}, quien usaba una {trap}"

-- Other events
L.ev_body        = "{finder} ha encontrado el cadáver de {victim}"
L.ev_c4_plant    = "{player} ha colocado el C4"
L.ev_c4_boom     = "El C4 colocado por {player} ha explotado"
L.ev_c4_disarm1  = "{player} ha desactivado el C4 que colocó {owner}"
L.ev_c4_disarm2  = "{player} ha fallado al desactivar el C4 colocado por {owner}"
L.ev_credit      = "{finder} ha encontrado {num} crédito(s) del cadáver de {player}"

L.ev_start       = "La ronda ha comenzado"
L.ev_win_traitor = "¡Los deleznables traidores han ganado la ronda!"
L.ev_win_inno    = "¡Los adorables inocentes han ganado la ronda!"
L.ev_win_time    = "¡Los traidores se han quedado sin tiempo y han perdido!"

--- Awards/highlights

L.aw_sui1_title = "Líder del culto al suicidio"
L.aw_sui1_text  = "mostró a los demás como suicidarse, porque ha sido el primero en hacerlo."

L.aw_sui2_title = "Solitario y deprimido"
L.aw_sui2_text  = "ha sido el único que se ha suicidado."

L.aw_exp1_title = "Beca en investigación de explosivos"
L.aw_exp1_text  = "ha sido reconocido por tu investigación en explosiones. Le ayudaron {num} sujetos de prueba."

L.aw_exp2_title = "Campo de investigación"
L.aw_exp2_text  = "Pusiste a prueba su resistencia a explosiones. No fue suficiente."

L.aw_fst1_title = "Primera sangre"
L.aw_fst1_text  = "Has asesinado al primer inocente como traidor."

L.aw_fst2_title = "Primera muerte sangrienta y estupida"
L.aw_fst2_text  = "causó la primera muerte disparando a un traidor. Buen trabajo."

L.aw_fst3_title = "Primera cagada"
L.aw_fst3_text  = "causó la primera muerte. Lo es que era un inocente camarada."

L.aw_fst4_title = "Primer golpe"
L.aw_fst4_text  = "dio el primer golpe causando la primera muerte de un traidor."

L.aw_all1_title = "Mortal a partes iguales"
L.aw_all1_text  = "ha sido responsable de todas las muertes que ha causado durante esta ronda."

L.aw_all2_title = "Lobo solitario"
L.aw_all2_text  = "ha sido responsable de todas las muertes que ha causado durante esta ronda."

L.aw_nkt1_title = "¡Tengo uno, jefe!"
L.aw_nkt1_text  = "consiguió matar a un solo inocente. ¡Maravilloso!"

L.aw_nkt2_title = "Una bala, dos muertos"
L.aw_nkt2_text  = "ha dejado claro que no tenido potra al matar a dos con una sola bala, es solo habilidad."

L.aw_nkt3_title = "Traidor en serie"
L.aw_nkt3_text  = "ha acabado con la vida de tres terroristas inocentes."

L.aw_nkt4_title = "Un lobo, como una oveja entre las ovejas"
L.aw_nkt4_text  = "se ha pillado a un inocente para cenar. Y ha repetido {num} veces."

L.aw_nkt5_title = "Operación antiterrorista"
L.aw_nkt5_text  = "fue recompensado por sus muertes. Ahora te puedes comprar otro yate de lujo."

L.aw_nki1_title = "Intenta engañarme ahora"
L.aw_nki1_text  = "encontró a un traidor. Disparó a un traidor. Fácil."

L.aw_nki2_title = "Aplicando el quito artículo"
L.aw_nki2_text  = "ha escoltado a dos traidores al más allá."

L.aw_nki3_title = "¿Los traidores contarán ovejas negras?"
L.aw_nki3_text  = "mandó a dormir a tres traidores."

L.aw_nki4_title = "Asuntos internos de empleados"
L.aw_nki4_text  = "fue recompensado por sus muertes. ¡Ahora puede decir que tiene tres piscinas!"

L.aw_fal1_title = "Tocado"
L.aw_fal1_text  = "tiró a alguien desde una altura respetable."

L.aw_fal2_title = "Hundido"
L.aw_fal2_text  = "dejó que su cuerpo tocara el suelo desde una altura respetable."

L.aw_fal3_title = "El meteorito humano"
L.aw_fal3_text  = "mató a uno cayendo sobre él desde una gran altura."

L.aw_hed1_title = "Eficacia"
L.aw_hed1_text  = "descubrió como dar en la cabeza y lo hizo {num} veces."

L.aw_hed2_title = "Neurología"
L.aw_hed2_text  = "extrajo los cerebros de {num} cabezas de enemigos."

L.aw_hed3_title = "Los videojuegos me hacen hacerlo"
L.aw_hed3_text  = "aplicó su entrenamiento de simulación de asesinato por disparo en la cabeza a {num} enemigos."

L.aw_cbr1_title = "¡Bonk, bonk, bonk!"
L.aw_cbr1_text  = "tiene la manía de blandir su palanca como una espada, y se han encontrado {num} muertos."

L.aw_cbr2_title = "Gordon Freeman"
L.aw_cbr2_text  = "a falta de puertas, ha abierto con su palanca nada menos que {num} cabezas."

L.aw_pst1_title = "Pequeña maldición persistente"
L.aw_pst1_text  = "causó {num} muertes con su pistola. Y misteriosamente, murió."

L.aw_pst2_title = "Masacre de pequeño calibre"
L.aw_pst2_text  = "mató un pequeño ejército de {num} personas con una pistola. Supongo que tendría una escopeta guardada en la pistola."

L.aw_sgn1_title = "Modo fácil"
L.aw_sgn1_text  = "ha dado donde duele con sus balas, acabando con la vida de {num} objetivos."

L.aw_sgn2_title = "101 balas"
L.aw_sgn2_text  = "se ve que no le gustaban mucho sus balas, porque se dedicó a desperdiciarlas. {num} personas no vivieron para contarlo."

L.aw_rfl1_title = "Apunta y dispara"
L.aw_rfl1_text  = "mostró que todo lo que necesita para causar {num} muertes es un rifle y unas manos."

L.aw_rfl2_title = "Veo tu cabeza desde aquí"
L.aw_rfl2_text  = "congenió con su rifle. Ahora, otras {num} personas lo han hecho también."

L.aw_dgl1_title = "Es como un rifle pequeñito"
L.aw_dgl1_text  = "ha sido cojer una Desert Eagle y matar a {num} personas."

L.aw_dgl2_title = "Patrulla Águila"
L.aw_dgl2_text  = "mató a {num} personas con la Desert Eagle."

L.aw_mac1_title = "A Dios rogando..."
L.aw_mac1_text  = "mató a {num} personas con la MAC10, pero mejor no hablar de la munición que ha gastado."

L.aw_mac2_title = "Mac y tomac"
L.aw_mac2_text  = "se pregunta qué pasaría si hubiera llevado dos MAC10s. ¿2 veces {num}?"

L.aw_sip1_title = "Calla"
L.aw_sip1_text  = "silenció a {num} personas con silenciador."

L.aw_sip2_title = "Asesino silencioso"
L.aw_sip2_text  = "mató a {num} que ni le oyeron."

L.aw_knf1_title = "Facestab"
L.aw_knf1_text  = "mató a alguien por delante con el cuchillo."

L.aw_knf2_title = "¿De dónde has sacado eso?"
L.aw_knf2_text  = "no era un traidor, pero aún así ha matado a alguien con un cuchillo."

L.aw_knf3_title = "Como uña y mugre"
L.aw_knf3_text  = "se encontró {num} cuchillos por el suelo e hizo uso de ellos."

L.aw_knf4_title = "El más navajero del mundo"
L.aw_knf4_text  = "mató a {num} personas con un cuchillo. No me preguntes como."

L.aw_flg1_title = "Al rescate"
L.aw_flg1_text  = "usó sus bengalas como señales para {num} muertes."

L.aw_flg2_title = "Bengala indica fuego"
L.aw_flg2_text  = "enseñó a {num} tíos que el peligroso llevar ropa inflamable."

L.aw_hug1_title = "Cuando el león R.H.U.G.E..."
L.aw_hug1_text  = "ha habido química entre él y su H.U.G.E, algo hizo que sus balas llegasen a {num} personas."

L.aw_hug2_title = "Despacito y con buena letra"
L.aw_hug2_text  = "se quedó disparando y, pacientemente, su H.U.G.E le recompensó con {num} víctimas."

L.aw_msx1_title = "Putt Putt Putt"
L.aw_msx1_text  = "ha matado a {num} personas con la M16."

L.aw_msx2_title = "DeM-16encia"
L.aw_msx2_text  = "sabe como matar con la M16, causó {num} bajas."

L.aw_tkl1_title = "Perdón"
L.aw_tkl1_text  = "apretó el gatillo cuando estaba apuntando a su compañero."

L.aw_tkl2_title = "Perdós"
L.aw_tkl2_text  = "creyó que encontrarse a dos traidores, pero en ambas se equivocó."

L.aw_tkl3_title = "Karmaconsciente"
L.aw_tkl3_text  = "no podía parar tras matar a dos aliados. El tres es su número de la suerte."

L.aw_tkl4_title = "TKer"
L.aw_tkl4_text  = "ha matado a todo su equipo. OMGBANBANBAN!!1!1UNO11!."

L.aw_tkl5_title = "Jugador de rol"
L.aw_tkl5_text  = "ha jugado como un campeón, ha sido honesto. Y por eso ha acabado con la mayoría de los de su equipo"

L.aw_tkl6_title = "Idiota"
L.aw_tkl6_text  = "no se sabe de parte de quién estaba, se ha cargado a más de la mitad de sus camaradas."

L.aw_tkl7_title = "Campesino"
L.aw_tkl7_text  = "protegió su territorio acabando con un cuarto de sus aliados."

L.aw_brn1_title = "Como los hacía mamá"
L.aw_brn1_text  = "frió a varias personas, están crujientes."

L.aw_brn2_title = "Pyroide"
L.aw_brn2_text  = "se oyeron unos gritos tras quemar una de sus muchas vícitmas."

L.aw_brn3_title = "Crematorio pírrico"
L.aw_brn3_text  = "quemó a todos, ¡pero ahora no hay granadas incendiarias! ¿¡Cómo hará frente!?"

L.aw_fnd1_title = "Juez de instrucción"
L.aw_fnd1_text  = "encontró {num} cuerpos por ahí."

L.aw_fnd2_title = "¡Hazte con todos!"
L.aw_fnd2_text  = "se ha encontrado {num} cadáveres para su colección."

L.aw_fnd3_title = "Escena del crimen"
L.aw_fnd3_text  = "se ha estado tropezando con varios cadáveres, {num} veces esta ronda."

L.aw_crd1_title = "Carroñero"
L.aw_crd1_text  = "ha recogido {num} créditos de cadáveres."

L.aw_tod1_title = "Victoria pírrica"
L.aw_tod1_text  = "ha muerto segundos antes de que ganara su equipo."

L.aw_tod2_title = "Odio este juego"
L.aw_tod2_text  = "ha muerto al inicio de la ronda."


--- New and modified pieces of text are placed below this point, marked with the
--- version or the date in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Evitar ser detective"
L.set_avoid_det_tip = "Activa esto para decirle al servidor que no seas detective si es posible. Esto no indica que vayas a ser traidor más a menudo."

--- v24
L.drop_no_ammo = "No tienes munición suficiente como para soltar una caja de munición."

--- v31
L.set_cross_brightness = "Luminosidad de la mira"
L.set_cross_size = "Tamaño de la mira"

--- 2015-05-25
L.hat_retrieve = "Recogiste el sombrero de un detective."

--- 2017-03-09
L.sb_sortby = "Ordene por:"

--- 2018-07-24
L.equip_tooltip_main = "Menú de equipamiento"
L.equip_tooltip_radar = "Control de radar"
L.equip_tooltip_disguise = "Control de disfraz"
L.equip_tooltip_radio = "Control de radio"
L.equip_tooltip_xfer = "Transferir créditos"

L.confgrenade_name = "Granada propulsora"
L.polter_name = "Poltergeist"
L.stungun_name = "Prototipo UMP"

L.knife_instant = "MUERTE INSTANTÁNEA"

L.dna_hud_type = "TIPO"
L.dna_hud_body = "CADÁVER"
L.dna_hud_item = "OBJETO"

L.binoc_zoom_level = "NIVEL"
L.binoc_body = "CADÁVER DETECTADO"

L.idle_popup_title = "Ausente"

--- 2021-06-07
L.sb_playervolume = "Volumen del jugador"

--- 2021-09-22
L.tip41 = "Puedes ajustar el volumen del micrófono de un jugador haciendo click derecho en el botón de silenciar al final de la tabla de puntuaciones."
