---- Portuguese language strings

local L = LANG.CreateLanguage("Português")

--- General text used in various places
L.traitor    = "Traidor"
L.detective  = "Detetive"
L.innocent   = "Inocente"
L.last_words = "Últimas palavras"

L.terrorists = "Terroristas"
L.spectators = "Espectadores"

--- Round status messages
L.round_minplayers = "Não há jogadores suficientes para começar uma nova rodada..."
L.round_voting     = "Voto em andamento, atrasando nova rodada em {num} segundos..."
L.round_begintime  = "Uma nova rodada começa em {num} segundos. Preparem-se."
L.round_selected   = "Os Traidores foram escolhidos."
L.round_started    = "Uma nova rodada começou!"
L.round_restart    = "A rodada foi forçada a reiniciar por um admin."

L.round_traitors_one  = "Traidor, você é um assassino solitário."
L.round_traitors_more = "Traidor, estes são seus alliados: {names}"

L.win_time         = "O tempo acabou. Os Traidores perderam."
L.win_traitor      = "Traidores venceram!"
L.win_innocent     = "Traidores foram derrotados!"
L.win_showreport   = "Veremos os resultados da rodada por {num} segundos."

L.limit_round      = "Limite de rodadas alcançado. {mapname} será carregado logo."
L.limit_time       = "Tempo limite alcançado. {mapname} será carregado logo."
L.limit_left       = "{num} rodada(s) or {time} restantes até a mudança de mapa para {mapname}."

--- Credit awards
L.credit_det_all   = "Detetives, vocês foram recompensados com {num} crédito(s) de equipamento por seus atos."
L.credit_tr_all    = "Traidores, vocês foram recompensados com {num} crédito(s) de equipamento por sua performance."

L.credit_kill      = "Você ganhou {num} crédito(s) por matar um {role}."

--- Karma
L.karma_dmg_full   = "Seu Karma é {amount}, então você receberá dano normalmente!"
L.karma_dmg_other  = "Seu Karma é {amount}. Portanto, todo dano que receber será reduzido em {num}%."

--- Body identification messages
L.body_found       = "{finder} achou o corpo de {victim}. {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "Ele era um Traidor!"
L.body_found_d     = "Ele era um Detetive."
L.body_found_i     = "Ele era inocente."

L.body_confirm     = "{finder} confirmou a morte de {victim}."

L.body_call        = "{player} chamou o Detetive para investigar o corpo de {victim}!"
L.body_call_error  = "Você deve confirmar a morte de um jogador antes de chamar um Detetive!"

L.body_burning     = "Wow! Esse corpo está pegando fogo!"
L.body_credits     = "Você achou {num} crédito(s) no corpo!"

--- Menus and windows
L.close = "Fechar"
L.cancel = "Cancelar"

-- For navigation buttons
L.next = "Próximo"
L.prev = "Anterior"

-- Equipment buying menu
L.equip_title     = "Equipamento"
L.equip_tabtitle  = "Pegar Equipamento"

L.equip_status    = "Dispondo estado."
L.equip_cost      = "Você tem {num} crédito(s) restante(s)."
L.equip_help_cost = "Cada equipamento que comprar, lhe custará 1 crédito."

L.equip_help_carry = "Você só poderá comprar coisas se tiver como carregar."
L.equip_carry      = "Você pode carregar esse equipamento."
L.equip_carry_own  = "Você já tem esse item."
L.equip_carry_slot = "Você já tem uma arma nesse slot {slot}."

L.equip_help_stock = "Alguns itens, você só pode ter 1 por rodada."
L.equip_stock_deny = "Este item não está no estoque."
L.equip_stock_ok   = "Este item está no estoque."

L.equip_custom     = "Item customizado adicionado por este servidor."

L.equip_spec_name  = "Nome"
L.equip_spec_type  = "Tipo"
L.equip_spec_desc  = "Descrição"

L.equip_confirm    = "Comprar equipamento"

-- Disguiser tab in equipment menu
L.disg_name      = "Disfarçar-se"
L.disg_menutitle = "Controle do Disfarce"
L.disg_not_owned = "Você não está carregando um Disfarce!"
L.disg_enable    = "Habilitar Disfarce"

L.disg_help1     = "Quando o Disfarce está hablilitado, seu nome, saúde e karma não são mostrados quando alguém te olha. Em adição, você será escondido do radar do Detetive."
L.disg_help2     = "Aperte Numpad+Enter para alternar o uso do disfarce sem abrir o menu. Você pode também escolher uma tecla diferente no teclado, digitando 'ttt_toggle_disguise' no console."

-- Radar tab in equipment menu
L.radar_name      = "Radar"
L.radar_menutitle = "Controle do Radar"
L.radar_not_owned = "Você não carrega um Radar!"
L.radar_scan      = "Procurar"
L.radar_auto      = "Fazer scan automaticamente"
L.radar_help      = "Resultados são mostrados por {num} segundos, depois o Radar precisa recarregar para ser usado novamente."
L.radar_charging  = "Seu Radar ainda está carregando!"

-- Transfer tab in equipment menu
L.xfer_name       = "Transferir"
L.xfer_menutitle  = "Transferir créditos"
L.xfer_no_credits = "Você não tem créditos para dar!"
L.xfer_send       = "Enviar créditos"
L.xfer_help       = "Você só pode doar créditos para {role} companheiros."

L.xfer_no_recip   = "Destinatário inválido, transferência abortada."
L.xfer_no_credits = "Créditos insuficientes para transferir."
L.xfer_success    = "Transferência para {player} está completa."
L.xfer_received   = "{player} te deu {num} crédito(s)."

-- Radio tab in equipment menu
L.radio_name      = "Rádio"
L.radio_help      = "Clique com algum botão para fazer seu Rádio tocar."
L.radio_notplaced = "Você deve colocar o Rádio em algum lugar para usar."

-- Radio soundboard buttons
L.radio_button_scream  = "Grito"
L.radio_button_expl    = "Explosão"
L.radio_button_pistol  = "Tiros de Pistola"
L.radio_button_m16     = "Tiros de M16"
L.radio_button_deagle  = "Tiros de Deagle"
L.radio_button_mac10   = "Tiros de MAC10"
L.radio_button_shotgun = "Tiros de Espintgarda"
L.radio_button_rifle   = "Tiros de Rifle"
L.radio_button_huge    = "Tiros de H.U.G.E"
L.radio_button_c4      = "C4 apitando"
L.radio_button_burn    = "Em chamas"
L.radio_button_steps   = "Passos"


-- Intro screen shown after joining
L.intro_help     = "Se você é novato, aperte F1 para instruções!"

-- Radiocommands/quickchat
L.quick_title   = "Atalhos do chat"

L.quick_yes     = "Sim."
L.quick_no      = "Não."
L.quick_help    = "Socorro!"
L.quick_imwith  = "Estou com {player}."
L.quick_see     = "Eu vejo {player}."
L.quick_suspect = "{player} está agindo de maneira suspeita."
L.quick_traitor = "{player} é um Traidor!"
L.quick_inno    = "{player} é um Inocente."
L.quick_check   = "Alguém vivo?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "ninguém"
L.quick_disg      = "alguém disfarçado"
L.quick_corpse    = "um corpo não idenfiticado"
L.quick_corpse_id = "cadáver de {player}"


--- Body search window
L.search_title  = "Resultado das investigações no corpo"
L.search_info   = "Informação"
L.search_confirm = "Confirmar morte"
L.search_call   = "Chamar detetive"

-- Descriptions of pieces of information found
L.search_nick   = "Este é o corpo de {player}."

L.search_role_t = "Esta pessoa era um Traidor!"
L.search_role_d = "Esta pessoa era um Detetive."
L.search_role_i = "Esta pessoa era Inocente."

L.search_words  = "Algo me diz que as últimas palavras dessa pessoa eram: '{lastwords}'"
L.search_armor  = "Estava vestindo um Colete."
L.search_disg   = "Estava carregando um dispositivo de disfarce."
L.search_radar  = "Eles carregavam um tipo de radar, que não funciona mais."
L.search_c4     = "No bolso tem uma nota. Diz que cortando o fio {num} desativará a C4 com segurança."

L.search_dmg_crush  = "Há muitos ossos quebrados. Parece que foi esmagado por algo pesado."
L.search_dmg_bullet = "É óbvio que ele foi baleado."
L.search_dmg_fall   = "Ele caiu para sua morte."
L.search_dmg_boom   = "Seus ferimentos e roupas rasgadas indicam que uma explosão o matou."
L.search_dmg_club   = "Este corpo está com muitos ferimentos. Claramente foi espancado até a morte."
L.search_dmg_drown  = "O corpo revela sinais de afogamento."
L.search_dmg_stab   = "Ele foi esfaqueado antes de sangrar até a morte."
L.search_dmg_burn   = "Cheiro de terrorista assado por aqui..."
L.search_dmg_tele   = "Parece que o DNA foi embaralhado por causa de emissões de táquion!"
L.search_dmg_car    = "Quando atravessou a estrada, foi atropelado por um barbeiro."
L.search_dmg_other  = "Não foi possível identificar uma provável causa da morte."

L.search_weapon = "Parece que uma {weapon} foi usada para matá-lo."
L.search_head   = "O foi um HEADSHOT. Sem tempo para gritar."
L.search_time   = "Ele morreu aos {time} até ser encontrado para investigação."
L.search_dna    = "Recupere uma amostra de DNA do assassino com o Scanner de DNA. A amostra sumirá em {time}."

L.search_kills1 = "Você encontrou uma lista de assassinatos que comprovam a morte de {player}."
L.search_kills2 = "Você encontrou uma lista de assassinatos com os nomes:"
L.search_eyes   = "Usando suas técnicas de detetive, você identificou a última pessoa que ele viu: {player}. O assassino? Ou pura coincidência?"


-- Scoreboard
L.sb_playing    = "Você está jogando no..."
L.sb_mapchange  = "O mapa mudará em {num} rodadas ou em {time}"

L.sb_mia        = "Desaparecidos"
L.sb_confirmed  = "Mortes Confirmadas"

L.sb_ping       = "Ping"
L.sb_deaths     = "Mortes"
L.sb_score      = "Score"
L.sb_karma      = "Karma"

L.sb_info_help  = "Procure o corpo deste jogador e você poderá rever os resultados aqui."

L.sb_tag_friend = "AMIGO"
L.sb_tag_susp   = "SUSPEITO"
L.sb_tag_avoid  = "EVITAR"
L.sb_tag_kill   = "MATAR"
L.sb_tag_miss   = "DESAPARECIDO"

--- Help and settings menu (F1)

L.help_title = "Ajuda e Configurações"

-- Tabs
L.help_tut     = "Tutorial"
L.help_tut_tip = "Como TTT funciona, em 6 passos"

L.help_settings = "Configurações"
L.help_settings_tip = "Configurações pessoais"

-- Settings
L.set_title_gui = "Configurar interface"

L.set_tips      = "Mostrar dicas de jogo enquanto for espectador"

L.set_startpopup = "Duração do popup de informação no início do round"
L.set_startpopup_tip = "Quando a rodada começa, um pequeno popup aparece na sua tela por alguns segundos. Mude o tempo que é mostrado aqui."

L.set_cross_opacity   = "Opacidade da mira travada"
L.set_cross_disable   = "Desativar completamente a mira"
L.set_minimal_id      = "ID Minimalista do Alvo abaixo da mira (sem karma, textos, dicas, etc)"
L.set_healthlabel     = "Mostrar estado físico na barra de saúde"
L.set_lowsights       = "Abaixar arma quando usar mira travada"
L.set_lowsights_tip   = "Habilitar para posicionar o modelo de arma abaixo na tela quando usando mira travada. Facilitará ao mirar, mas tornará menos realista."
L.set_fastsw          = "Trocar arma rapidamente"
L.set_fastsw_tip      = "Habilitar ciclo de armas quando rola o mouse sem precisar abrir o menu de troca de armas."
L.set_fastsw_menu     = "Habilitar menu com troca de arma rápida"
L.set_fastswmenu_tip  = "Quando a troca de arma rápida é ativada, o menu de troca irá aparecer."
L.set_wswitch         = "Desabilitar autofechamento do menu de troca de armas"
L.set_wswitch_tip     = "Por padrão, o trocador de armas fechará automaticamente após alguns segundos de seu último uso. Habilite isso para facilitar as coisas."
L.set_cues            = "Ouvir um sinal quando uma rodada começa ou termina"


L.set_title_play    = "Configurações de gameplay"

L.set_specmode      = "Modo somente espectador"
L.set_specmode_tip  = "No modo somente espectador você não renascerá quando começar uma nova rodada, ao invés, continuará como espectador."
L.set_mute          = "Jogadores vivos silenciados"
L.set_mute_tip      = "Silenciar jogadores vivos quando estiver morto ou for espectador."


L.set_title_lang    = "Configurações de idioma"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "Selecionar idioma:"


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "Esta arma está fora de estoque, você já a comprou nessa rodada."
L.buy_pending     = "Você já tem um pedido em andamento, espere sua encomenda chegar para pedir uma nova."
L.buy_received    = "Você recebeu um equipamento especial."

L.drop_no_room    = "Não há espaço para jogar esta arma fora!"

L.disg_turned_on  = "Disfarce habilitado!"
L.disg_turned_off = "Disfarce desabilitado."

-- Equipment item descriptions
L.item_passive    = "Item de efeito passivo"
L.item_active     = "Item de efeito ativo"
L.item_weapon     = "Arma"

L.item_armor      = "Armadura"
L.item_armor_desc = [[
Reduz o dano recebido por balas em
30% quando atingido.

Equipamento padrão de Detetives.]]

L.item_radar      = "Radar"
L.item_radar_desc = [[
Permite escanear sinais vitais.

Escaneia automaticamente assim que você
o compra. Configure-o na aba Radar deste
menu.]]

L.item_disg       = "Disfarce"
L.item_disg_desc  = [[
Esconde sua identificação e quando você
foi 'a última pessoa vista' se habilitado.

Habilite o uso na aba Disfarce 
deste menu ou aperte Numpad+Enter.]]

-- C4
L.c4_hint         = "Aperte {usekey} para armar ou disarmar."
L.c4_no_disarm    = "Você não pode desarmar a C4 de outro Traidor ao menos que ele esteja morto."
L.c4_disarm_warn  = "Uma C4 que você plantou foi desarmado."
L.c4_armed        = "Você armou sua bomba com sucesso."
L.c4_disarmed     = "Você desarmou esta bomba com sucesso."
L.c4_no_room      = "Você não pode carregar esta C4."

L.c4_desc         = "Poderoso explosivo de contagem regressiva."

L.c4_arm          = "Armar C4"
L.c4_arm_timer    = "Temporizador"
L.c4_arm_seconds  = "Segundos até detonação:"
L.c4_arm_attempts = "Em tentativas de desarme, {num} de 6 fios causará explosão na hora que for cortado."

L.c4_remove_title    = "Remoção"
L.c4_remove_pickup   = "Pegar C4"
L.c4_remove_destroy1 = "Destruir C4"
L.c4_remove_destroy2 = "Confirmar: destruir"

L.c4_disarm       = "Desarmar C4"
L.c4_disarm_cut   = "Clique para cortar o fio {num}"

L.c4_disarm_t     = "Corte um fio para desarmar a bomba. Como Traidor, todos os fios são seguros. Já para inocentes não é tão fácil!"
L.c4_disarm_owned = "Corte um fio para desarmar a bomba. A bomba é sua, qualquer fio irá desarmá-la."
L.c4_disarm_other = "Corte um fio seguro para desarmar a bomba. Explodirá se você escolher o fio errado!"

L.c4_status_armed    = "ARMADA"
L.c4_status_disarmed = "DESARMADA"

-- Visualizer
L.vis_name        = "Visualizador"
L.vis_hint        = "Aperte {usekey} para pegar (somente Detetives)."

L.vis_help_pri    = "{primaryfire} solta o dispositivo ativo."

L.vis_desc        = [[
Dispositivo que analisa a cena do crime.

Analisa o cadáver e mostra como
a vítima foi morta, mas só se 
morreu a tiros.]]

-- Decoy
L.decoy_name      = "Isca"
L.decoy_no_room   = "Você não pode carregar essa isca."
L.decoy_broken    = "Suca isca foi destruída!"

L.decoy_help_pri  = "{primaryfire} plantar isca."

L.decoy_desc      = [[
Mostra um sinal falso de radar para
detetives, faz seu Escaneador de DNA
mostrar o local da Isca se eles buscarem
seu DNA.]]

-- Defuser
L.defuser_name    = "Desarme"
L.defuser_help    = "{primaryfire} desarma uma C4 na mira."

L.defuser_desc    = [[
Instantaneamente desarma um explosivo C4.

Uso ilimitado. C4 serão mais fáceis
de perceber se carregar isto.]]

-- Flare gun
L.flare_name      = "Arma de sinalizadores"
L.flare_desc      = [[
Pode ser usada para queimar corpos
que não foram encontrados. Municão limitada.

Queimar um corpo causará um som
estranho.]]

-- Health station
L.hstation_name   = "Estação de Cura"
L.hstation_hint   = "Aperte {usekey} para ser curado. Carga: {num}."
L.hstation_broken = "Sua Estação de Cura foi destruída!"
L.hstation_help   = "{primaryfire} coloca Estação de Cura."

L.hstation_desc   = [[
Permite curar pessoas quando colocada.

Carrega lentamente. Todos podem usar, e
pode ser danificada. Pode ser usada para
checar amostras de DNA de quem a usou.]]

-- Knife
L.knife_name      = "Faca"
L.knife_thrown    = "Faca jogada"

L.knife_desc      = [[
Mata alvos feridos instantaneamente e
em silêncio, mas é de uso único.

Pode ser jogada usando fogo alternativo.]]

-- Poltergeist
L.polter_desc     = [[
Planta batedores em objetos para cavar
à sua volta violentamente.

A energia causa dano em pessoas
próximas.]]

-- Radio
L.radio_broken    = "Seu Rádio foi destruído!"
L.radio_help_pri  = "{primaryfire} coloca o Rádio."

L.radio_desc      = [[
Toca sons para distrair ou enganar.

Coloque o Rádio em algum lugar, e então
toque os sons abrindo a aba Rádio
nesse menu.]]

-- Silenced pistol
L.sipistol_name   = "Pistola Silenciada"

L.sipistol_desc   = [[
Arma de mão que faz pouco barulho, usa munição
de pistola normal.

Vítimas não gritam quando mortas.]]

-- Newton launcher
L.newton_name     = "Lançador Newton"

L.newton_desc     = [[
Empurra pessoas a partir de uma ditância segura.

Munição infinita, mas atira lentamente.]]

-- Binoculars
L.binoc_name      = "Binóculos"
L.binoc_desc      = [[
Dê zoom em cadáveres para identificá-los
a partir de uma grande distância.

Uso ilimitado, mas a identificação
leva alguns segundos.]]

L.binoc_help_pri  = "{primaryfire} identifica um corpo."
L.binoc_help_sec  = "{secondaryfire} muda a distância a ser vista."

-- UMP
L.ump_desc        = [[
SMG experimental que desorienta
alvos.

Usa munição de SMG comum.]]

-- DNA scanner
L.dna_name        = "Scanner de DNA"
L.dna_identify    = "O cadáver deve ser identificado para mostrar o DNA do assassino."
L.dna_notfound    = "Nenhuma amostra de DNA no corpo."
L.dna_limit       = "Tempo de armazenamento alcançado. Remova velhas amostras para colocar novas."
L.dna_decayed     = "Amostra de DNA do assassino foi perdida."
L.dna_killer      = "Coletou uma amostra de DNA do assassino deste cadáver!"
L.dna_no_killer   = "O DNA não pôde ser revelado (assassino desconectou-se?)."
L.dna_armed       = "Essa bomba tá viva! Disarme primeiro!"
L.dna_object      = "Coletada(s) {num} amostra(s) de DNA deste objeto."
L.dna_gone        = "Não há DNA nessa área."

L.dna_desc        = [[
Coleta amostra de DNA de objetos
e use-o para saber quem os usou.

Use em cadáveres recentes para achar o DNA
do assassino e rastreá-lo.]]

L.dna_menu_title  = "Controles do Scanner de DNa"
L.dna_menu_sample = "Amostra de DNA em {source}"
L.dna_menu_remove = "Remover selecionado"
L.dna_menu_help1  = "Estas são as amostras de DNA que você coletou."
L.dna_menu_help2  = [[
Quando carregado, você pode rastrear o dono
da amostra de DNA selecionado.
Achar pessoas distantes consome mais energia.]]

L.dna_menu_scan   = "Escanear"
L.dna_menu_repeat = "Autorrepetir"
L.dna_menu_ready  = "PRONTO"
L.dna_menu_charge = "CARREGANDO"
L.dna_menu_select = "ESCOLHER AMOSTRA"

L.dna_help_primary   = "{primaryfire} para coletar amostra de DNA"
L.dna_help_secondary = "{secondaryfire} para abrir o controle de amostras"

-- Magneto stick
L.magnet_name     = "Magneto-stick"
L.magnet_help     = "{primaryfire} para carregar algo."

-- Grenades and misc
L.grenade_smoke   = "Granada de fumaça"
L.grenade_fire    = "Granada incendiária"

L.unarmed_name    = "Coldre"
L.crowbar_name    = "Crowbar"
L.pistol_name     = "Pistola"
L.rifle_name      = "Rifle"
L.shotgun_name    = "Shotgun"

-- Teleporter
L.tele_name       = "Teletransporte"
L.tele_failed     = "Teletransporte falhou."
L.tele_marked     = "Local de teletransporte marcado."

L.tele_no_ground  = "Não pode teletransportar-se a não ser que esteja em chão firme!"
L.tele_no_crouch  = "Não pode teletransportar-se agachado!"
L.tele_no_mark    = "Nenhum local marcado. Determine um local para teletransportar-se."

L.tele_no_mark_ground = "Não pode marcar lugar, não é chão firme!"
L.tele_no_mark_crouch = "Não pode marcar lugar enquanto agachado!"

L.tele_help_pri   = "{primaryfire} teletransporta para local marcado."
L.tele_help_sec   = "{secondaryfire} marca local de teletransporte."

L.tele_desc       = [[
Teletransporta para local pré-marcado.

Teletransportar faz barulho, e tem
número de uso limitado.]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "Municão de 9mm"

L.ammo_smg1       = "Munição de SMG"
L.ammo_buckshot   = "Munição de Shotgun"
L.ammo_357        = "Munição do Rifle"
L.ammo_alyxgun    = "Munição da Deagle"
L.ammo_ar2altfire = "Munição da Sinalizador"
L.ammo_gravity    = "Munição do Poltergeist"


--- HUD interface text

-- Round status
L.round_wait   = "Aguardando"
L.round_prep   = "Preparando"
L.round_active = "Em progresso"
L.round_post   = "Terminado"

-- Health, ammo and time area
L.overtime     = "TEMPO EXTRA"
L.hastemode    = "MODO PRESSA"

-- TargetID health status
L.hp_healthy   = "Saudável"
L.hp_hurt      = "Machucado"
L.hp_wounded   = "Ferido"
L.hp_badwnd    = "Muito Ferido"
L.hp_death     = "Quase morto"


-- TargetID karma status
L.karma_max    = "Respeitável"
L.karma_high   = "Bruto"
L.karma_med    = "Guerreiro"
L.karma_low    = "Perigoso"
L.karma_min    = "Irresponsável"

-- TargetID misc
L.corpse       = "Corpo"
L.corpse_hint  = "Aperte {usekey} para investigar. {walkkey} + {usekey} para investigar escondido."

L.target_disg  = " (DISFARÇADO)"
L.target_unid  = "Corpo não identificado"

L.target_traitor = "TRAIDOR ALIADO"
L.target_detective = "DETETIVE"

L.target_credits = "Olhe corpos para ver se tem créditos não gastos!"

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single  = "Uso único"
L.tbut_reuse   = "Reutilizável"
L.tbut_retime  = "Reutilizável após {num} seg"
L.tbut_help    = "Aperte {key} para ativar"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "Disfarce ativado. Seu nome está oculto."
L.radar_hud    = "Radar pronto novamente em: {time}"

-- Spectator muting of living/dead
L.mute_living  = "Jogadores vivos mutados"
L.mute_specs   = "Espectadores mutados"
L.mute_all     = "Todos mutados"
L.mute_off     = "Ninguém mutado"

-- Spectators and prop possession
L.punch_title  = "SOCÔMETRO"
L.punch_help   = "Movimentar-se ou pular: soca objeto. Agachar: solta objeto."
L.punch_bonus  = "Sua pontuação ruim diminuiu seu limite do Socômetro em {num}"
L.punch_malus  = "Sua boa pontuação aumentou seu limite do Socômetro em {num}!"

L.spec_help    = "Clique para observar jogadores, ou aperte {usekey} em um objeto para possuí-lo."

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[Você é um Terrorista inocente! Mas há Traidores à solta...
Em quem confiar, e quem está por aí para te encher de balas?

Cuidado e trabalhe em conjunto com seus camaradas e saiam dessa vivos!]]

L.info_popup_detective = [[Você é um Detetive! O QG de Terroristas te deu recursos especiais para achar os traidores.
Use-os para ajudar os inocentes a sobreviver, mas tenha cuidado:
os Traidores podem estar querendo te derrubar primeiro!

Aperte {menukey} para pegar seu equipamento!]]

L.info_popup_traitor_alone = [[Você é um TRAIDOR! Não tem comparsas nessa rodada.

Mate todos os outros para ganhar!

Aperte {menukey} para pegar seu equipamento especial!]]

L.info_popup_traitor = [[Você é um TRAIDOR! Trabalhe com seus comparsas para mator todos.
Seja cuidadoso, sua traição pode ser descoberta...

Esses são seus aliados:
{traitorlist}

Aperte {menukey} para pegar seu equipamento especial!]]

--- Various other text
L.name_kick = "Um jogador foi automaticamente expulso por mudar seu nome durante uma rodada."

L.idle_popup = [[Você esteve inativo por {num} segundos e foi movido para o modo Somente-Espectador. Nesse modo, não renascerá no começo de novas rodadas.

Você pode sair desse modo apertando {helpkey} e desmarcando o modo Somente-Espectador na aba de Configurações. Você o pode fazer agora.]]

L.idle_popup_close = "Fazer nada."
L.idle_popup_off   = "Desabilitar modo Somente-Espectador agora."

L.idle_warning = "Aviso: você parece estar ausente/AFK, e será feito de espectador se não mostrar atividade!"

L.spec_mode_warning = "Você está no modo Espectador e não renascerá no começo de novas rodadas. Para desabilitar, aperte F1, vá para Configurações e desmarque a opção 'modo Somente-Espectador'."


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "Dicas"
L.tips_panel_tip   = "Dica:"

-- Tip texts

L.tip1 = "Traidores podem examinar corpos sem chamar a atenção, ou confirmar a morte, por segurar {walkkey} e apertar {usekey} no cadáver."

L.tip2 = "Armando uma C4 com mais tempo faz com que hajam mais fios que causem explosão instantânea quando algum inocente tentar desarma-la. Ela também emite um sinal sonoro mais suave e com menos frequência."

L.tip3 = "Detetives podem investigar cadáveres e ver quem estava 'refletido em seus olhos'. A última pessoa que viu. Pode não ser o assassino se foi morto pelas costas."

L.tip4 = "Ninguém saberá que você morreu até que ahem seu corpo e o investiguem."

L.tip5 = "Quando um Traidor mata um Detetive, todos recebem um recompensa em créditos."

L.tip6 = "Quando um Traidor morre, todos os Detetives recebem uma recompensa em créditos."

L.tip7 = "Quando os Traidores fizerem um progresso significativo matando inocentes, eles recebem créditos como recompensa."

L.tip8 = "Traidores e Detetives podem pegar créditos não gastos de cadáveres de outros Traidores e Detetives."

L.tip9 = "O Poltergeist pode tornar um objeto comum em um projétil mortal. Cada empurrão é acompanhado de uma explosão de energia machucando todos perto."

L.tip10 = "Como Traidor ou Detetive, fique de olho em mensagens vermelhas no topo da tela. São importantes para você."

L.tip11 = "Como Traidor ou Detetive, tenha em mente que será recompensado com créditos se você e seus companheiros agirem corretamente. Lembre-se de gastá-los!"

L.tip12 = "O Scanner de DNA do Detetive pode coletar amostras em armas e itens e então usadas para saber onde está o jogador que as usou por último. Útil quando pega amostra em cadáveres e C4 desarmadas!"

L.tip13 = "Quando perto de alguém que matou, um pouco do seu DNA é deixado no cadáver. Este DNA pode ser usado com DNA Scanner para encontrar a sua localização atual. Melhor esconder o corpo depois de esfaquear alguém!"

L.tip14 = "Quanto mais longe você estiver de alguém que você mata, mais rápido a amostra de DNA no corpo da vítima vai decair."

L.tip15 = "Você é Traidor e quer camperar? Considere usar o Disfarce. Se errar um tiro, ache um local seguro, desabilite o Disfarce, e ninguém saberá quem atirou."

L.tip16 = "Como Traidor, o Teletransportador pode te ajudar quando estiver encurralado, e permite viajar rapidamente em mapas grandes. Lembre-se de sempre ter uma posição segura pré-marcada."

L.tip17 = "Os inocentes estão juntos e difíceis de matar? Considere usar o Rádio para simular o som de uma C4 ou um tiroteio para afastar alguns."

L.tip18 = "Usando Rádio como Traidor você pode tocar sons pelo menu de Equipamento depois que o Rádio foi colocado. Coloque vários sons ao clicar na sequência que desejar."

L.tip19 = "Como Detetive, se você tem créditos sobrando considere dar um Desarme para um Inocente. Então você pode deixar o trabalho duro pra eles e investigar sem se preocupar tanto."

L.tip20 = "O Binóculo dos Detetives tem um campo de visão amplo para procurar e identificar cadáveres. Má notícia para Traidores que tentavam usar o corpo como isca. É claro que, quando usando o Binóculo, você está distraído e desarmado..."

L.tip21 =  "A Estação de Cura dos Detetives remove os ferimentos dos jogadores. É claro, que algum desses feridos pode ser um Traidor..."

L.tip22 = "A Estação de Cura guarda o DNA de todos que a usam. Detetives podem ver esse DNA para descobrir quem anda se curando."

L.tip23 = "Ao contrário de armas e C4, o Rádio dos Traidores não dá amostra de DNA de quem o usou. Não se preocupe com Detetives achando sua distração."

L.tip24 = "Aperte {helpkey} para ver um pequeno tutorial ou modificar algumas configurações do TTT. Por exemplo, você pode desativar essas dicas permanentemente."

L.tip25 = "Quando um Detetive investiga um corpo, os resultados podem ser vistos por todos no placar ao clicar no nome da pessoa morta."

L.tip26 = "No placar, quando há uma lupa do lado do nome de alguém, significa que você investigou aquela pessoa. Se o ícone brilha, a informação vem de um Detetive, pode conter mais informações."

L.tip27 = "Como Detetive, quando há uma lupa do lado do nome de uma pessoa morta significa que ela foi investigada por um Detetive e os resultados estão visíveis a todos no placar."

L.tip28 = "Espectatores podem apertar {mutekey} para escolher em silenciar outros espectadores ou jogadores vivos."

L.tip29 = "Se o servidor tiver instalado linguagens adicionais, você pode mudar a qualquer momento no menu de Configurações."

L.tip30 = "Chat rápido ou comandos do 'Rádio' podem ser usados apertando {zoomkey}."

L.tip31 = "Como Espectador, aperte {duckkey} para destravar o mouse e clicar nos botões deste painel. Aperte {duckkey} novamente para voltar ao normal."

L.tip32 = "O ataque secundário da Crowbar empurra os jogadores."

L.tip33 = "Atirando pela mira travada de uma arma irá diminuir o recuo e aumentar um pouco a precisão. Agaichar-se não."

L.tip34 = "Granadas de Fumaça são ótimas para usar em ambientes fechados, principalmente quartos lotados."

L.tip35 = "Como Traidor, lembre-se de que você pode carregar e esconder os corpos de suas vítimas dos olhos curiosos dos Inocentes e Detetives."

L.tip36 = "O tutorial está disponível ao apertar {helpkey} contém uma visão geral do que é mais importante no jogo."

L.tip37 = "No placar, você pode selecionar pessoas vivas e colocar tags como 'inocente' ou 'suspeito', isso aparecerá quando você mirar neles."

L.tip38 = "Muitos dos itens colocáveis (como C4 e Rádio) pode ser preso na parede ao usar o tiro secundário (Mouse2)."

L.tip39 = "A C4 que explode sob o erro de desarme tem uma explosão menor comparada a C4 que explodiria se chegasse a 0."

L.tip40 = "Se diz 'MODO PRESSA' sob o temporizador do jogo, a rodada será mais curta, mas a cada morte o tempo disponível é aumentado (como capturar pontos no TF2). Esse modo bota pressão nos Traidores, obrigando-os a agir logo."


--- Round report

L.report_title = "Relatório da rodada"

-- Tabs
L.report_tab_hilite = "Destaques"
L.report_tab_hilite_tip = "Destaques da rodada"
L.report_tab_events = "Eventos"
L.report_tab_events_tip = "Log de eventos que aconteceram nesta rodada"
L.report_tab_scores = "Pontuações"
L.report_tab_scores_tip = "Pontos marcados por cada jogador só nessa rodada"

-- Event log saving
L.report_save     = "Salvar Log .txt"
L.report_save_tip = "Salvar o Log de Eventos em um arquivo de texto"
L.report_save_error  = "Sem Log de Eventos para salvar."
L.report_save_result = "O Log de Eventos foi salvo em:"

-- Big title window
L.hilite_win_traitors = "TRAIDORES VENCEM!"
L.hilite_win_innocent = "INOCENTES VENCEM!"

L.hilite_players1 = "{numplayers} participaram, {numtraitors} eram Traidores"
L.hilite_players2 = "{numplayers} participaram, um deles era Traidor"

L.hilite_duration = "A rodada durou {time}"

-- Columns
L.col_time   = "Tempo"
L.col_event  = "Evento"
L.col_player = "Jogador"
L.col_role   = "Papel"
L.col_kills1 = "Inocentes mortos"
L.col_kills2 = "Traidores mortos"
L.col_points = "Pontos"
L.col_team   = "Bônus de Time"
L.col_total  = "Total de pontos"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "algo"

-- Kill events
L.ev_blowup      = "{victim} se explodiu"
L.ev_blowup_trap = "{victim} foi explodido pela {trap}"

L.ev_tele_self   = "{victim} se telefragou"
L.ev_sui         = "{victim} não aguentou a pressão e cometeu suicídio"
L.ev_sui_using   = "{victim} se matou usando {tool}"

L.ev_fall        = "{victim} caiu para sua morte"
L.ev_fall_pushed = "{victim} caiu para sua morte depois de {attacker} o empurra-lo"
L.ev_fall_pushed_using = "{victim} caiu para sua morte depois de {attacker} usar a {trap} para empurrá-lo"

L.ev_shot        = "{victim} foi baleado por {attacker}"
L.ev_shot_using  = "{victim} foi baleado por {attacker} usando uma {weapon}"

L.ev_drown       = "{victim} foi afogado por {attacker}"
L.ev_drown_using = "{victim} foi afogado pela {trap} ativada por {attacker}"

L.ev_boom        = "{victim} foi explodido por {attacker}"
L.ev_boom_using  = "{victim} foi explodido por {attacker} usando {trap}"

L.ev_burn        = "{victim} foi frito por {attacker}"
L.ev_burn_using  = "{victim} foi incendiado pela {trap} devido a {attacker}"

L.ev_club        = "{victim} foi batido por {attacker}"
L.ev_club_using  = "{victim} foi atacado violentamente por {attacker} usando {trap}"

L.ev_slash       = "{victim} foi esfaqueado por {attacker}"
L.ev_slash_using = "{victim} foi cortado por {attacker} usando {trap}"

L.ev_tele        = "{victim} foi telefragado por {attacker}"
L.ev_tele_using  = "{victim} foi atomizado pela {trap} colocada por {attacker}"

L.ev_goomba      = "{victim} foi esmagado pelo grande peso de {attacker}"

L.ev_crush       = "{victim} foi esmagado por {attacker}"
L.ev_crush_using = "{victim} foi esmagado pela {trap} de {attacker}"

L.ev_other       = "{victim} foi morto por {attacker}"
L.ev_other_using = "{victim} foi morto {attacker} usando {trap}"

-- Other events
L.ev_body        = "{finder} achou o corpo de {victim}"
L.ev_c4_plant    = "{player} plantou uma C4"
L.ev_c4_boom     = "A C4 plantada por {player} explodiu"
L.ev_c4_disarm1  = "{player} desarmou a C4 plantada por {owner}"
L.ev_c4_disarm2  = "{player} falhou ao desarmar a C4 plantada por {owner}"
L.ev_credit      = "{finder} achou {num} crédito(s) no cadáver de {player}"

L.ev_start       = "A rodada começou"
L.ev_win_traitor = "Os ignóbeis traidores ganharam a rodada!"
L.ev_win_inno    = "Os amáveis terroristas inocentes ganharam a rodada!"
L.ev_win_time    = "Os traidores ficaram sem tempo e perderam!"

--- Awards/highlights

L.aw_sui1_title = "Líder da seita Suicída"
L.aw_sui1_text  = "mostrou aos outros suicídas como funciona sendo o primeiro a ir."

L.aw_sui2_title = "Sozinho e Depressivo"
L.aw_sui2_text  = "foi o único que se matou."

L.aw_exp1_title = "Explorador de Explosivos"
L.aw_exp1_text  = "foi reconhecido por sua pesquisa com explosivos. {num} cobaias o ajudaram."

L.aw_exp2_title = "Pesquisa de Campo"
L.aw_exp2_text  = "testou sua própria resistência a explosões. Não era alta o suficiente."

L.aw_fst1_title = "Primeira Morte"
L.aw_fst1_text  = "entregou a morte do primeiro inocente nas mãos de um Traidor."

L.aw_fst2_title = "Primeira Morte Estúpida"
L.aw_fst2_text  = "marcou a primeira morte matando um Traidor aliado. Bom trabalho."

L.aw_fst3_title = "Primeiro Assassino"
L.aw_fst3_text  = "primeiro a matar. Pena que era um terrorista companheiro."

L.aw_fst4_title = "Primeiro Golpe"
L.aw_fst4_text  = "foi um inocente que marcou a primeira morte matando um Traidor."

L.aw_all1_title = "Mortal entre Iguais"
L.aw_all1_text  = "foi responsável pela morte de todos os inocentes nessa rodada."

L.aw_all2_title = "Lobo Solitário"
L.aw_all2_text  = "foi responsável pela morte de todos os traidores nessa rodada."

L.aw_nkt1_title = "Peguei um Chefe!"
L.aw_nkt1_text  = "conseguiu matar um inocente. Parabéns!"

L.aw_nkt2_title = "Uma Bala pra Dois"
L.aw_nkt2_text  = "mostrou que não foi um tiro de sorte por matar outro."

L.aw_nkt3_title = "Traidor em Série"
L.aw_nkt3_text  = "acabou com três vidas inocentes do terrorismo hoje."

L.aw_nkt4_title = "Lobo entre Lobos que parecem Ovelhas"
L.aw_nkt4_text  = "comeu inocentes terroristas no jantar. Um jantar de {num} pratos."

L.aw_nkt5_title = "Operação Contra-Terrorista"
L.aw_nkt5_text  = "é pago por cada assassinato. Agora pode comprar outro iate luxuoso."

L.aw_nki1_title = "Traia isto!"
L.aw_nki1_text  = "achou um Traidor. Atirou num Traidor. Fácil."

L.aw_nki2_title = "Aplicado no Esquadrão Justiça"
L.aw_nki2_text  = "escoltou dois Traidores para o além."

L.aw_nki3_title = "Contando Ovelhinhas Traidoras nos Sonhos?"
L.aw_nki3_text  = "botou três Traidores para dormir."

L.aw_nki4_title = "Empregado dos Assuntos Interno"
L.aw_nki4_text  = "é pago por cada assassinato. Já pode pedir sua 50ª piscina olímpica."

L.aw_fal1_title = "Não Mr. Bond, Espero Que Caia"
L.aw_fal1_text  = "jogou alguém de um lugar alto."

L.aw_fal2_title = "Gravidade Grave"
L.aw_fal2_text  = "deixe o corpo cair de uma grande altitude novamente."

L.aw_fal3_title = "O Meteorito Humano"
L.aw_fal3_text  = "esmagou alguém caindo em cima dele de um lugar alto."

L.aw_hed1_title = "Eficiência"
L.aw_hed1_text  = "descobriu a felicidade que trazem os headshots e fez {num}."

L.aw_hed2_title = "Neurologia"
L.aw_hed2_text  = "removeu o cérebro de {num} cabeças para um exame preciso."

L.aw_hed3_title = "Videogames Me Fizeram Fazer Isso"
L.aw_hed3_text  = "aplicou sua simulação de assassinatos treinando e praticou headshot em {num} inimigos."

L.aw_cbr1_title = "Thunk Thunk Thunk"
L.aw_cbr1_text  = "é o barulho que o crowbar fez ao matar, {num} pessoas encontradas."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text  = "cobriu com o crowbar o cérebro de nada menos que {num} pessoas."

L.aw_pst1_title = "Persistente Pequeno Demonio"
L.aw_pst1_text  = "marcou {num} mortes usando pistola. Em seguida, eles passaram a se abraçar na morte."

L.aw_pst2_title = "Chacina de Pequeno Calibre"
L.aw_pst2_text  = "matou um pequeno exército de {num} com uma pistola. Provavelmente instalou uma pequena escopeta dentro do cano."

L.aw_sgn1_title = "Modo fácil"
L.aw_sgn1_text  = "aplicando tiro onde dói, matando {num} alvos."

L.aw_sgn2_title = "Milhares de Pequenas Pastilhas"
L.aw_sgn2_text  = "não gostava de seus tiros, então os deu embora. {num} recipientes não viveram para aproveitá-los."

L.aw_rfl1_title = "Apontar e clicar"
L.aw_rfl1_text  = "mostre que tudo que precisa para {num} mortes é um rifle e uma mão firme."

L.aw_rfl2_title = "Eu Posso Ver Sua Cabeça Daqui"
L.aw_rfl2_text  = "conhece o rifle que tem. Agora {num} pessoas o conhecem também."

L.aw_dgl1_title = "É Como um Pequeno Rifle"
L.aw_dgl1_text  = "é pegar o jeito da Desert Eagle e matar {num} pessoas."

L.aw_dgl2_title = "Mestre da Águia"
L.aw_dgl2_text  = "explodiu {num} pessoas com sua Deagle."

L.aw_mac1_title = "Rezar e Matar"
L.aw_mac1_text  = "matou {num} com a MAC10, mas é impossível dizer quanta munição usou."

L.aw_mac2_title = "Mac com Queijo"
L.aw_mac2_text  = "imagina se tivesse em mãos duas MAC10. {num} vezes dois?"

L.aw_sip1_title = "Seja quieto"
L.aw_sip1_text  = "calou a boca de {num} pessoas com uma Pistola Silenciada."

L.aw_sip2_title = "Assassino Silencioso"
L.aw_sip2_text  = "matou {num} pessoas que não ouviram a morte chegando."

L.aw_knf1_title = "Bom Esfaquear Você"
L.aw_knf1_text  = "esfaqueou a cara de alguém pela internet."

L.aw_knf2_title = "Onde Conseguiu Isso?"
L.aw_knf2_text  = "não era Traidor, mas ainda matou alguém com a Faca."

L.aw_knf3_title = "Um Homem de Faca"
L.aw_knf3_text  = "achou {num} facas por aí e fez bom uso delas."

L.aw_knf4_title = "Melhor Homem de Faca do Mundo"
L.aw_knf4_text  = "matou {num} pessoas com uma Faca. Não me pergunte como."

L.aw_flg1_title = "Ao Resgate"
L.aw_flg1_text  = "usou seu sinalizador para mostrar {num} mortes."

L.aw_flg2_title = "Sinalizador indica Fogo"
L.aw_flg2_text  = "ensinou {num} homens o perigo de vestir roupas inflamáveis."

L.aw_hug1_title = "Uma H.U.G.E Expandida"
L.aw_hug1_text  = "estava em sintonia com sua H.U.G.E, de algum jeito conseguiu derrubar {num} pessoas."

L.aw_hug2_title = "Um Paciente Para"
L.aw_hug2_text  = "só ficou atirando, e viu sua H.U.G.E ser recompensada com {num} mortes."

L.aw_msx1_title = "Putt Putt Putt"
L.aw_msx1_text  = "levou {num} pessoas com a M16."

L.aw_msx2_title = "Loucura de Alcance Médio"
L.aw_msx2_text  = "sabe derrubar um alvo com M16, marcando {num} mortes."

L.aw_tkl1_title = "Ops"
L.aw_tkl1_text  = "apertou no gatilho enquanto mirava em um companheiro."

L.aw_tkl2_title = "Duas vezes ops!"
L.aw_tkl2_text  = "pensou que eram Traidores duas vezes, estava errado em ambas."

L.aw_tkl3_title = "Karma Consciente"
L.aw_tkl3_text  = "não conseguiu parar no segundo aliado morto. Três é seu número da sorte."

L.aw_tkl4_title = "Matador de Amigos"
L.aw_tkl4_text  = "matou seu time inteiro. OMGBANBANBAN."

L.aw_tkl5_title = "Roleplayer"
L.aw_tkl5_text  = "estava jogando como um louco, honesto. É por isso que matou quase todo seu time."

L.aw_tkl6_title = "Anta"
L.aw_tkl6_text  = "não conseguiu assimilar em que time estava, matando mais da metade de seus companheiros."

L.aw_tkl7_title = "Cabeça Vermelha"
L.aw_tkl7_text  = "protegeu seu território matando mais de um quarto de seus aliados."

L.aw_brn1_title = "Como a Vovó fazia"
L.aw_brn1_text  = "fritou várias pessoas numa bela fogueira."

L.aw_brn2_title = "Piromaníaco"
L.aw_brn2_text  = "foi ouvida altas risadas depois de queimar uma de suas muitas vítimas."

L.aw_brn3_title = "Derrapagem Pirra"
L.aw_brn3_text  = "queimou todos, mas agora está sem Granadas Incendiárias! E agora!?"

L.aw_fnd1_title = "Médico Legista"
L.aw_fnd1_text  = "achou {num} corpos por aí."

L.aw_fnd2_title = "Temos que pegar você!"
L.aw_fnd2_text  = "achou {num} cadáveres para sua coleção."

L.aw_fnd3_title = "Cheiro de Morte"
L.aw_fnd3_text  = "continua tropeçando em cadáveres, {num} nessa rodada."

L.aw_crd1_title = "Reciclador"
L.aw_crd1_text  = "roubou {num} créditos de cadáveres."

L.aw_tod1_title = "Vitória Pirra"
L.aw_tod1_text  = "morreu segundos antes de seu time vencer a partida."

L.aw_tod2_title = "Odeio esse jogo"
L.aw_tod2_text  = "morreu no começo da partida."


--- New and modified pieces of text are placed below this point, marked with the
--- version in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Evitar ser Detetive"
L.set_avoid_det_tip = "Habilite isso para pedir ao servidor para não ser escolhido como Detetive. Não significa que será Traidor mais vezes."

--- v24
L.drop_no_ammo = "Munição insuficiente para jogar no chão como uma caixa de munição."

--- v31
L.set_cross_brightness = "Brilho da mira"
L.set_cross_size = "Tamanho da mira"

--- 5-25-15
L.hat_retrieve = "Você pegou o chapéu de um detetive."
