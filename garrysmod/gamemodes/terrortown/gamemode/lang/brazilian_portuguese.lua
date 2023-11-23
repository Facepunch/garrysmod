---- Brazilian Portuguese language strings

local L = LANG.CreateLanguage("Português (Brasil)")

--- General text used in various places
L.traitor    = "Traidor"
L.detective  = "Detetive"
L.innocent   = "Inocente"
L.last_words = "Últimas palavras"

L.terrorists = "Terroristas"
L.spectators = "Espectadores"

--- Round status messages
L.round_minplayers = "Não há jogadores suficientes para começar uma nova rodada..."
L.round_voting     = "Votação em andamento, adiando nova rodada em {num} segundos..."
L.round_begintime  = "Uma nova rodada começará em {num} segundos. Prepare-se."
L.round_selected   = "Os Traidores foram escolhidos."
L.round_started    = "A rodada começou!"
L.round_restart    = "A rodada foi reiniciada por um administrador."

L.round_traitors_one  = "Traidor, você é um assassino solitário."
L.round_traitors_more = "Traidor, estes são seus aliados: {names}"

L.win_time         = "O tempo acabou. Os Traidores perderam."
L.win_traitor      = "Os Traidores venceram!"
L.win_innocent     = "Os Traidores foram derrotados!"
L.win_showreport   = "Os resultados da rodada serão exibidos por {num} segundos."

L.limit_round      = "Limite de rodadas atingido. O servidor mudará para o mapa {mapname} em breve."
L.limit_time       = "Tempo limite atingido. O servidor mudará para o mapa {mapname} em breve."
L.limit_left       = "Ainda há {num} rodada(s) ou {time} minutos restantes até o servidor mudar para o mapa {mapname}."

--- Credit awards
L.credit_det_all   = "Detetives, vocês foram recompensados com {num} crédito(s) de equipamento por seu desempenho."
L.credit_tr_all    = "Traidores, vocês foram recompensados com {num} crédito(s) de equipamento por seu desempenho."

L.credit_kill      = "Você ganhou {num} crédito(s) por matar um {role}."

--- Karma
L.karma_dmg_full   = "Seu Karma é {amount}, então você causará dano total nesta rodada!"
L.karma_dmg_other  = "Seu Karma é {amount}. Portanto, todo dano que você causar será reduzido em {num}%"

--- Body identification messages
L.body_found       = "{finder} encontrou o corpo de {victim}. {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "Ele era um Traidor!"
L.body_found_d     = "Ele era um Detetive."
L.body_found_i     = "Ele era Inocente."

L.body_confirm     = "{finder} confirmou a morte de {victim}."

L.body_call        = "{player} chamou um Detetive para investigar o corpo de {victim}!"
L.body_call_error  = "Você deve confirmar a morte deste jogador antes de chamar um Detetive!"

L.body_burning     = "Eita! Este cadáver está pegando fogo!"
L.body_credits     = "Você encontrou {num} crédito(s) no corpo!"

--- Menus and windows
L.close = "Fechar"
L.cancel = "Cancelar"

-- For navigation buttons
L.next = "Próximo"
L.prev = "Anterior"

-- Equipment buying menu
L.equip_title     = "Equipamento"
L.equip_tabtitle  = "Adquirir Equipamento"

L.equip_status    = "Status da compra"
L.equip_cost      = "Você tem {num} crédito(s) restante(s)."
L.equip_help_cost = "Cada equipamento que você comprar custará 1 crédito."

L.equip_help_carry = "Você só pode comprar coisas as quais você tenha algum compartimento para guardá-las."
L.equip_carry      = "Você pode comprar este equipamento."
L.equip_carry_own  = "Você já tem este equipamento."
L.equip_carry_slot = "Você já tem um equipamento no compartimento {slot}."

L.equip_help_stock = "Certos itens só poderão ser comprados uma única vez por rodada."
L.equip_stock_deny = "Este item não está mais em estoque."
L.equip_stock_ok   = "Este item está em estoque."

L.equip_custom     = "Item personalizado adicionado por este servidor."

L.equip_spec_name  = "Nome"
L.equip_spec_type  = "Tipo"
L.equip_spec_desc  = "Descrição"

L.equip_confirm    = "Comprar"

-- Disguiser tab in equipment menu
L.disg_name      = "Disfarce"
L.disg_menutitle = "Controle do Disfarce"
L.disg_not_owned = "Você não possui um Disfarce!"
L.disg_enable    = "Habilitar Disfarce"

L.disg_help1     = "Quando você está disfarçado, seu nome, saúde e karma não são exibidos quando alguém olha para você. Em adição, você é ocultado dos radares dos Detetives."
L.disg_help2     = "Pressione a tecla Enter do teclado numérico para disfarçar-se sem usar o menu. Você também pode fazer uma bind com o comando 'ttt_toggle_disguise' usando o console."

-- Radar tab in equipment menu
L.radar_name      = "Radar"
L.radar_menutitle = "Controle do Radar"
L.radar_not_owned = "Você não possui um Radar!"
L.radar_scan      = "Realizar varredura"
L.radar_auto      = "Automatizar"
L.radar_help      = "Os resultados serão exibidos por {num} segundos. Logo após, o Radar será recarregado para poder ser utilizado novamente."
L.radar_charging  = "O seu Radar ainda está sendo recarregado!"

-- Transfer tab in equipment menu
L.xfer_name       = "Transferência"
L.xfer_menutitle  = "Transferência de créditos"
L.xfer_no_credits = "Você não tem créditos para enviar!"
L.xfer_send       = "Enviar um crédito"
L.xfer_help       = "Você só pode transferir créditos para jogadores do cargo {role}."

L.xfer_no_recip   = "Destinatário inválido, transferência de créditos cancelada."
L.xfer_no_credits = "Você não tem créditos suficientes para transferir."
L.xfer_success    = "A transferência de créditos para {player} foi bem-sucedida."
L.xfer_received   = "{player} lhe deu {num} crédito(s)."

-- Radio tab in equipment menu
L.radio_name      = "Rádio"
L.radio_help      = "Clique em um botão para fazer seu Rádio reproduzir tal som."
L.radio_notplaced = "Você deve posicionar o Rádio em algum lugar para poder reproduzir sons."

-- Radio soundboard buttons
L.radio_button_scream  = "Grito"
L.radio_button_expl    = "Explosão"
L.radio_button_pistol  = "Tiros de Pistola"
L.radio_button_m16     = "Tiros de M16"
L.radio_button_deagle  = "Tiros de Deagle"
L.radio_button_mac10   = "Tiros de MAC10"
L.radio_button_shotgun = "Tiros de Escopeta"
L.radio_button_rifle   = "Tiro de Rifle"
L.radio_button_huge    = "Tiros de H.U.G.E"
L.radio_button_c4      = "C4 apitando"
L.radio_button_burn    = "Em chamas"
L.radio_button_steps   = "Passos"


-- Intro screen shown after joining
L.intro_help     = "Caso você seja novato, pressione F1 para abrir o tutorial!"

-- Radiocommands/quickchat
L.quick_title   = "Atalhos do chat"

L.quick_yes     = "Sim."
L.quick_no      = "Não."
L.quick_help    = "Socorro!"
L.quick_imwith  = "Estou com {player}."
L.quick_see     = "Eu vejo {player}."
L.quick_suspect = "{player} está agindo de maneira suspeita."
L.quick_traitor = "{player} é um Traidor!"
L.quick_inno    = "{player} é inocente."
L.quick_check   = "Alguém ainda está vivo?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "ninguém"
L.quick_disg      = "alguém disfarçado"
L.quick_corpse    = "um corpo não identificado"
L.quick_corpse_id = "o cadáver de {player}"


--- Body search window
L.search_title  = "Resultados da investigação corporal"
L.search_info   = "Informação"
L.search_confirm = "Confirmar Morte"
L.search_call   = "Chamar Detetive"

-- Descriptions of pieces of information found
L.search_nick   = "Este é o corpo de {player}."

L.search_role_t = "Este jogador era um Traidor!"
L.search_role_d = "Este jogador era um Detetive."
L.search_role_i = "Este jogador era um terrorista inocente."

L.search_words  = "Algo lhe diz que algumas das últimas palavras desta pessoa foram: '{lastwords}'"
L.search_armor  = "Ele estava vestindo um colete balístico atípico."
L.search_disg   = "Ele estava carregando um dispositivo que podia ocultar sua identidade."
L.search_radar  = "Ele estava carregando algum tipo de radar. Não está mais funcionando."
L.search_c4     = "Você encontrou uma nota em um bolso. Ela diz que ao cortar o fio {num}, a bomba será desarmada com segurança."

L.search_dmg_crush  = "A maioria dos ossos dele estão quebrados. Parece que ele foi esmagado por algo pesado."
L.search_dmg_bullet = "É óbvio que ele foi baleado."
L.search_dmg_fall   = "Ele caiu para sua morte."
L.search_dmg_boom   = "Seus ferimentos e roupas rasgadas indicam que uma explosão o matou."
L.search_dmg_club   = "Este corpo está muito ferido. Claramente ele foi espancado até a morte."
L.search_dmg_drown  = "O corpo revela sinais de afogamento."
L.search_dmg_stab   = "Ele foi esfaqueado e cortado antes de rapidamente sangrar até a morte."
L.search_dmg_burn   = "Cheiro de terrorista assado por aqui..."
L.search_dmg_tele   = "Parece que a amostra de DNA dele foi embaraçada por emissões de táquion!"
L.search_dmg_car    = "Quando este terrorista atravessou a estrada, acabou sendo atropelado por um motorista com a CNH vencida."
L.search_dmg_other  = "Você não pôde encontrar uma causa específica da morte deste terrorista."

L.search_weapon = "Aparentemente, um(a) {weapon} foi usado(a) para matá-lo."
L.search_head   = "O disparo foi direto na cabeça. A vítima não teve tempo para gritar."
L.search_time   = "Ele morreu aproximadamente após {time} antes de seu corpo ser encontrado."
L.search_dna    = "Recupere uma amostra do DNA do assassino utilizando um Scanner de DNA. A amostra de DNA sumirá em aproximadamente {time} a partir de agora."

L.search_kills1 = "Você encontrou uma lista de assassinatos que comprovam a morte de {player}."
L.search_kills2 = "Você encontrou uma lista de assassinatos com estes nomes:"
L.search_eyes   = "Usando suas técnicas de detetive, você identificou a última pessoa que ele viu: {player}. O assassino, ou uma coincidência?"


-- Scoreboard
L.sb_playing    = "Você está jogando em/no(a)..."
L.sb_mapchange  = "O mapa será mudado em {num} rodadas ou em {time}"

L.sb_mia        = "Desaparecidos"
L.sb_confirmed  = "Mortes Confirmadas"

L.sb_ping       = "Ping"
L.sb_deaths     = "Mortes"
L.sb_score      = "Pontos"
L.sb_karma      = "Karma"

L.sb_info_help  = "Investigue o corpo deste jogador e então você poderá rever os resultados aqui."

L.sb_tag_friend = "AMIGO"
L.sb_tag_susp   = "SUSPEITO"
L.sb_tag_avoid  = "EVITAR"
L.sb_tag_kill   = "MATAR"
L.sb_tag_miss   = "DESAPARECIDO"

--- Help and settings menu (F1)

L.help_title = "Ajuda e Configurações"

-- Tabs
L.help_tut     = "Tutorial"
L.help_tut_tip = "Como o TTT funciona, em 6 passos"

L.help_settings = "Configurações"
L.help_settings_tip = "Configurações pessoais"

-- Settings
L.set_title_gui = "Configurações da interface"

L.set_tips      = "Mostrar dicas de jogabilidade na parte inferior da tela enquanto estiver espectando"

L.set_startpopup = "Duração do popup de informações no início da rodada"
L.set_startpopup_tip = "Quando a rodada começa, um pequeno popup aparece na parte inferior da sua tela por alguns segundos. Configure aqui por quanto tempo ele é exibido."

L.set_cross_opacity   = "Opacidade da mira ao usar o retículo de ferro"
L.set_cross_disable   = "Desativar a mira completamente"
L.set_minimal_id      = "Mostrar apenas informações minimalistas sobre outros terroristas ao olhar para eles"
L.set_healthlabel     = "Mostrar estado físico na barra de vida"
L.set_lowsights       = "Abaixar arma ao usar o retículo de ferro"
L.set_lowsights_tip   = "Habilite esta opção para posicionar sua arma na parte inferior da tela ao usar o retículo de ferro. Isso facilitará a visualização de outros terroristas, porém parecerá menos realista."
L.set_fastsw          = "Troca rápida de arma"
L.set_fastsw_tip      = "Habilite esta opção para trocar de arma sem precisar confirmar a troca com um clique. Habilite a opção de mostrar o menu para deixar o menu de troca de armas visível enquanto você troca de arma."
L.set_fastsw_menu     = "Habilitar o menu com a troca rápida de arma"
L.set_fastswmenu_tip  = "Quando a troca rápida de arma estiver ativada, o popup do menu de troca de armas aparecerá."
L.set_wswitch         = "Desabilitar fechamento automático do menu de troca de armas"
L.set_wswitch_tip     = "Por padrão, o menu de troca de armas fechará automaticamente após alguns segundos de seu aparecimento. Habilite isto para o menu nunca fechar."
L.set_cues            = "Tocar um som quando uma rodada começar ou terminar"


L.set_title_play    = "Configurações de jogabilidade"

L.set_specmode      = "Modo Somente-Espectador (fique sempre espectando)"
L.set_specmode_tip  = "No modo Somente-Espectador você não renascerá quando uma nova rodada começar. Em vez disso, você continuará como Espectador."
L.set_mute          = "Emudecer jogadores vivos enquanto morto"
L.set_mute_tip      = "Habilite para emudecer jogadores vivos enquanto você estiver morto/espectando."


L.set_title_lang    = "Configurações de idioma"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "Selecionar idioma (Select language):"


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "Esta arma está fora de estoque: você já a comprou nesta rodada."
L.buy_pending     = "Você já tem um pedido pendente, aguarde até recebê-lo."
L.buy_received    = "Você recebeu seu equipamento especial."

L.drop_no_room    = "Não há espaço suficiente para jogar esta arma fora!"

L.disg_turned_on  = "Disfarce habilitado!"
L.disg_turned_off = "Disfarce desabilitado."

-- Equipment item descriptions
L.item_passive    = "Item de efeito passivo"
L.item_active     = "Item de uso ativo"
L.item_weapon     = "Arma"

L.item_armor      = "Colete Balístico"
L.item_armor_desc = [[
Reduz o dano das balas em 30%
quando você é atingido.

Equipamento padrão de Detetives.]]

L.item_radar      = "Radar"
L.item_radar_desc = [[
Permite varrer sinais vitais.

Varre automaticamente assim que você o compra.
Configure-o na aba Radar deste menu.]]

L.item_disg       = "Disfarce"
L.item_disg_desc  = [[
Oculta sua identidade enquanto habilitado. Também
evita ser a última pessoa vista por uma vítima.

Habilite-o na aba Disfarce deste menu
ou aperte a tecla Enter do teclado numérico.]]

-- C4
L.c4_hint         = "Pressione {usekey} para armar ou desarmar."
L.c4_no_disarm    = "Você não pode desarmar o C4 de outro Traidor, a não ser que ele esteja morto."
L.c4_disarm_warn  = "Um explosivo C4 que você plantou foi desarmado."
L.c4_armed        = "Você armou a bomba com sucesso."
L.c4_disarmed     = "Você desarmou a bomba com sucesso."
L.c4_no_room      = "Você não pode pegar este C4."

L.c4_desc         = "Poderoso explosivo de contagem regressiva."

L.c4_arm          = "Armar C4"
L.c4_arm_timer    = "Temporizador"
L.c4_arm_seconds  = "Segundos até a detonação:"
L.c4_arm_attempts = "Quando alguém tentar desarmar, {num} dos 6 fios causarão detonação instantânea quando cortados."

L.c4_remove_title    = "Remoção"
L.c4_remove_pickup   = "Pegar C4"
L.c4_remove_destroy1 = "Destruir C4"
L.c4_remove_destroy2 = "Confirmar: destruir"

L.c4_disarm       = "Desarmar C4"
L.c4_disarm_cut   = "Clique para cortar o fio {num}"

L.c4_disarm_t     = "Corte um fio para desarmar a bomba. Como você é um Traidor, todos os fios são seguros. Para os Inocentes, porém, não é tão fácil assim!"
L.c4_disarm_owned = "Corte um fio para desarmar a bomba. É a sua bomba, então todos os fios a desarmarão."
L.c4_disarm_other = "Corte um fio seguro para desarmar a bomba. Vai explodir se você errar!"

L.c4_status_armed    = "ARMADO"
L.c4_status_disarmed = "DESARMADO"

-- Visualizer
L.vis_name        = "Visualizador"
L.vis_hint        = "Pressione {usekey} para pegar (somente Detetives)."

L.vis_help_pri    = "{primaryfire} larga o dispositivo ativado."

L.vis_desc        = [[
Permite visualizar uma cena de crime.

Analisa um cadáver para mostrar como
a vítima morreu, mas somente se
ela tiver morrido por ferimentos de armas de fogo.]]

-- Decoy
L.decoy_name      = "Isca"
L.decoy_no_room   = "Você não pode pegar esta Isca."
L.decoy_broken    = "Sua Isca foi destruída!"

L.decoy_help_pri  = "{primaryfire} planta a Isca."

L.decoy_desc      = [[
Mostra um sinal de radar falso para Detetives,
e faz os scanners de DNA deles indicar a
localização da sua Isca se eles procurarem
a amostra do seu DNA.]]

-- Defuser
L.defuser_name    = "Kit de Desarme"
L.defuser_help    = "{primaryfire} desarma um C4 que está sob sua mira."

L.defuser_desc    = [[
Instantaneamente desarma um explosivo C4.

Usos ilimitados. Um C4 será mais fácil de
ser notado se você estiver com isto equipado.]]

-- Flare gun
L.flare_name      = "Pistola Sinalizadora"
L.flare_desc      = [[
Pode ser usado para queimar cadáveres para que
eles nunca sejam encontrados. Munição limitada.

Queimar um cadáver emite um som estranho.]]

-- Health station
L.hstation_name   = "Estação de Cura"
L.hstation_hint   = "Pressione {usekey} para curar-se. Carga: {num}."
L.hstation_broken = "Sua Estação de Cura foi destruída!"
L.hstation_help   = "{primaryfire} posiciona a Estação de Cura."

L.hstation_desc   = [[
Permite que as pessoas se curem quando posicionada.

Seu tempo de recarga é lento. Qualquer um pode
usá-la, e ela pode ser danificada. Pode ser usada
para analisar o DNA de seus utilizadores.]]

-- Knife
L.knife_name      = "Faca"
L.knife_thrown    = "Faca arremessada"

L.knife_desc      = [[
Mata o alvo instantaneamente e de forma silenciosa,
mas só pode ser usada uma vez.

Pode ser arremessada ao usar
o botão de ataque alternativo.]]

-- Poltergeist
L.polter_desc     = [[
Planta batedores em objetos para empurrar pessoas
à sua volta de maneira violenta.

A energia causa dano em pessoas
que estejam nas proximidades.]]

-- Radio
L.radio_broken    = "Seu Rádio foi destruído!"
L.radio_help_pri  = "{primaryfire} posiciona o Rádio."

L.radio_desc      = [[
Reproduz sons para distrair e/ou enganar.

Posicione o Rádio em algum lugar, e então
reproduza os sons nele utilizando a aba Rádio
deste menu.]]

-- Silenced pistol
L.sipistol_name   = "Pistola Silenciada"

L.sipistol_desc   = [[
Pistola de baixo ruído, usa munição
de pistola normal.

As vítimas não gritarão quando forem mortas.]]

-- Newton launcher
L.newton_name     = "Lançador Newton"

L.newton_desc     = [[
Empurra pessoas a partir de uma distância segura.

Sua munição é infinita, mas dispara lentamente.]]

-- Binoculars
L.binoc_name      = "Binóculos"
L.binoc_desc      = [[
Permite dar zoom em cadáveres para identificá-los
a partir de uma longa distância.

Seus usos são ilimitados, porém o processo
de identificação demora alguns segundos.]]

L.binoc_help_pri  = "{primaryfire} identifica um corpo."
L.binoc_help_sec  = "{secondaryfire} altera o nível de zoom."

-- UMP
L.ump_desc        = [[
SMG experimental que desorienta
alvos.

Usa munição de SMG comum.]]

-- DNA scanner
L.dna_name        = "Scanner de DNA"
L.dna_identify    = "O cadáver deve ser identificado para coletar a amostra do DNA do assassino."
L.dna_notfound    = "Nenhuma amostra de DNA foi encontrada no cadáver."
L.dna_limit       = "Limite de armazenamento atingido. Remova amostras antigas para adicionar novas."
L.dna_decayed     = "A amostra do DNA do assassino se deteriorou."
L.dna_killer      = "Você coletou a amostra do DNA do assassino provinda deste cadáver!"
L.dna_no_killer   = "A amostra de DNA não pôde ser coletada (o assassino se desconectou?)."
L.dna_armed       = "Esta bomba está ativa! Desarme-a primeiro!"
L.dna_object      = "{num} amostra(s) de DNA foi(ram) coletada(s) do objeto."
L.dna_gone        = "Não há nenhuma amostra de DNA nesta área."

L.dna_desc        = [[
Colete amostras de DNA de objetos
e analise-as para saber quem os usou.

Utilize-o em terroristas recentemente mortos
para coletar a amostra do DNA do assassino e assim
poder rastreá-lo.]]

L.dna_menu_title  = "Controles do Scanner de DNA"
L.dna_menu_sample = "Amostra de DNA encontrada em {source}"
L.dna_menu_remove = "Remover"
L.dna_menu_help1  = "Estas são as amostras de DNA que você coletou."
L.dna_menu_help2  = [[
Quando carregado, você pode rastrear a localização
do jogador ao qual a amostra selecionada pertence.
Rastrear alvos distantes consome mais energia.]]

L.dna_menu_scan   = "Rastrear"
L.dna_menu_repeat = "Automatizar"
L.dna_menu_ready  = "PRONTO"
L.dna_menu_charge = "CARREGANDO"
L.dna_menu_select = "SELECIONAR AMOSTRA"

L.dna_help_primary   = "{primaryfire} para coletar uma amostra de DNA"
L.dna_help_secondary = "{secondaryfire} para abrir o menu de controle do Scanner de DNA"

-- Magneto stick
L.magnet_name     = "Magneto-stick"
L.magnet_help     = "{primaryfire} para prender um corpo a uma superfície."

-- Grenades and misc
L.grenade_smoke   = "Granada de Fumaça"
L.grenade_fire    = "Granada Incendiária"

L.unarmed_name    = "Coldre"
L.crowbar_name    = "Pé de Cabra"
L.pistol_name     = "Pistola"
L.rifle_name      = "Rifle"
L.shotgun_name    = "Escopeta"

-- Teleporter
L.tele_name       = "Teletransportador"
L.tele_failed     = "O teletransporte falhou."
L.tele_marked     = "Local de teletransporte marcado."

L.tele_no_ground  = "Você não pode teletransportar-se se você não estiver em um chão sólido!"
L.tele_no_crouch  = "Você não pode teletransportar-se enquanto estiver agachado!"
L.tele_no_mark    = "Nenhum local marcado. Marque um local para teletransportar-se."

L.tele_no_mark_ground = "Você não pode marcar um local para teletransportar-se se você não estiver em um chão sólido!"
L.tele_no_mark_crouch = "Você não pode marcar um local para teletransportar-se enquanto estiver agachado!"

L.tele_help_pri   = "{primaryfire} teletransporta para o local marcado."
L.tele_help_sec   = "{secondaryfire} marca um local de teletransporte."

L.tele_desc       = [[
Teletransporta para um local previamente marcado.

Teletransportar-se faz barulho, e tem
um número limitado de usos.]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "Munição de Pistola"

L.ammo_smg1       = "Munição de SMG"
L.ammo_buckshot   = "Munição de Escopeta"
L.ammo_357        = "Munição de Rifle"
L.ammo_alyxgun    = "Munição de Deagle"
L.ammo_ar2altfire = "Munição de Pistola Sinalizadora"
L.ammo_gravity    = "Munição de Poltergeist"


--- HUD interface text

-- Round status
L.round_wait   = "Aguardando"
L.round_prep   = "Preparando"
L.round_active = "Em progresso"
L.round_post   = "Terminando"

-- Health, ammo and time area
L.overtime     = "TEMPO EXTRA"
L.hastemode    = "MODO PRESSA"

-- TargetID health status
L.hp_healthy   = "Saudável"
L.hp_hurt      = "Machucado"
L.hp_wounded   = "Ferido"
L.hp_badwnd    = "Muito Ferido"
L.hp_death     = "Quase Morto"


-- TargetID karma status
L.karma_max    = "Respeitável"
L.karma_high   = "Bruto"
L.karma_med    = "Guerreiro"
L.karma_low    = "Perigoso"
L.karma_min    = "Irresponsável"

-- TargetID misc
L.corpse       = "Cadáver"
L.corpse_hint  = "Pressione {usekey} para investigar. {walkkey} + {usekey} para investigar furtivamente."

L.target_disg  = " (DISFARÇADO)"
L.target_unid  = "Corpo não identificado"

L.target_traitor = "TRAIDOR ALIADO"
L.target_detective = "DETETIVE"

L.target_credits = "Vasculhe para receber créditos não gastos"

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single  = "Uso único"
L.tbut_reuse   = "Reutilizável"
L.tbut_retime  = "Reutilizável após {num} segundos"
L.tbut_help    = "Pressione {key} para ativar"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "Disfarçado. Seu nome está oculto."
L.radar_hud    = "Radar disponível novamente em: {time}"

-- Spectator muting of living/dead
L.mute_living  = "Jogadores vivos emudecidos"
L.mute_specs   = "Espectadores emudecidos"
L.mute_all     = "Todos emudecidos"
L.mute_off     = "Ninguém emudecido"

-- Spectators and prop possession
L.punch_title  = "SOCÔMETRO"
L.punch_help   = "Movimentar-se ou pular: soca o objeto. Agachar-se: sai do objeto."
L.punch_bonus  = "Sua má pontuação diminuiu seu limite do socômetro em {num}"
L.punch_malus  = "Sua boa pontuação aumentou seu limite do socômetro em {num}!"

L.spec_help    = "Clique para espectar jogadores, ou pressione {usekey} em um objeto para possuí-lo."

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[Você é um Terrorista inocente! Mas há traidores à solta...
Em quem você pode confiar, e quem está por aí para lhe encher de balas?

Tenha cuidado e trabalhe em conjunto com seus camaradas para saírem vivos dessa!]]

L.info_popup_detective = [[Você é um Detetive! O QG de Terroristas disponibilizou recursos especiais para encontrar os traidores.
Use-os para ajudar os inocentes a sobreviver, mas tenha cuidado:
os traidores podem querer que você bata as botas primeiro!

Pressione {menukey} para pegar seu equipamento!]]

L.info_popup_traitor_alone = [[Você é um TRAIDOR! Você não tem aliados nesta rodada.

Mate todos os terroristas inocentes para vencer!

Pressione {menukey} para pegar seu equipamento especial!]]

L.info_popup_traitor = [[Você é um TRAIDOR! Trabalhe com seus comparsas para aniquilar todos os terroristas inocentes.
Mas seja cauteloso, ou sua traição pode ser descoberta...

Estes são seus aliados:
{traitorlist}

Pressione {menukey} para pegar seu equipamento especial!]]

--- Various other text
L.name_kick = "Um jogador foi expulso automaticamente por ter alterado seu nome durante uma rodada."

L.idle_popup = [[Você esteve inativo por {num} segundos e foi movido para o modo Somente-Espectador como resultado. Você não renascerá quando uma nova rodada começar.

Você pode alterná-lo a qualquer momento ao pressionar {helpkey} e desmarcar a opção correspondente na aba Configurações. Você pode optar por desabilitá-lo agora mesmo.]]

L.idle_popup_close = "Fazer nada"
L.idle_popup_off   = "Desabilitar Somente-Espectador"

L.idle_warning = "Aviso: você aparenta estar ausente, e será movido para a equipe dos espectadores a não ser que demonstre alguma atividade!"

L.spec_mode_warning = "Você está no Modo Espectador e não renascerá quando uma nova rodada começar. Para desabilitar esse modo, pressione F1, clique na aba Configurações e desmarque a opção 'Modo Somente-Espectador'."


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "Dicas"
L.tips_panel_tip   = "Dica:"

-- Tip texts

L.tip1 = "Traidores podem investigar cadáveres furtivamente, sem confirmar a sua morte, ao segurar {walkkey} e pressionar {usekey} no cadáver."

L.tip2 = "Armar um explosivo C4 com um longo tempo de duração aumentará o número de fios que causarão sua detonação instantânea quando um inocente tentar desarmá-lo. Ele também emitirá um bipe mais suave e com menos frequência."

L.tip3 = "Detetives podem investigar cadáveres para descobrir quem estava 'refletindo em seus olhos'. Essa é a última pessoa que o terrorista morto viu. Isso não necessariamente indica quem é o assassino, pois o terrorista pode ter sido baleado pelas costas."

L.tip4 = "Ninguém saberá que você morreu até que encontrem seu cadáver e o investiguem."

L.tip5 = "Quando um Traidor mata um Detetive, todos os Traidores são instantaneamente recompensados com créditos."

L.tip6 = "Quando um Traidor morre, todos os Detetives são recompensados com créditos."

L.tip7 = "Quando os Traidores fizerem um progresso significativo matando inocentes, eles serão recompensados com créditos."

L.tip8 = "Traidores e Detetives podem coletar créditos não gastos dos cadáveres de outros Traidores e Detetives."

L.tip9 = "O Poltergeist pode tornar qualquer objeto de física em um projétil mortal. Cada empurrão é acompanhado de uma explosão de energia que fere todos que estiverem ao redor."

L.tip10 = "Como Traidor ou Detetive, fique de olho em mensagens vermelhas no canto superior direito da tela. Elas serão importantes para você."

L.tip11 = "Como Traidor ou Detetive, tenha em mente que você será recompensado com créditos se você e seus comparsas progredirem bem. Lembre-se de gastá-los!"

L.tip12 = "O Scanner de DNA dos Detetives pode ser usado para coletar amostras de DNA de armas e itens e analisá-las para descobrir a localização do jogador que os usou. Isso é útil quando você consegue coletar uma amostra de um cadáver ou de um C4 desarmado!"

L.tip13 = "Quando estiver perto de alguém que você matou, um pouco do seu DNA será deixado no cadáver. Esse DNA pode ser coletado por um Scanner de DNA de um Detetive para encontrar sua localização atual. É melhor esconder o corpo da vítima depois de esfaqueá-la!"

L.tip14 = "Quanto mais longe você estiver de alguém que você matar, mais rapidamente a amostra do seu DNA no corpo da sua vítima vai deteriorar-se."

L.tip15 = "Você é um Traidor e quer tentar matar alguém com um rifle de precisão? Considere habilitar o Disfarce antes. Se você errar um tiro, fuja para um local seguro, desabilite o Disfarce, e ninguém saberá que era você que estava atirando neles."

L.tip16 = "Como Traidor, o Teletransportador pode ajudá-lo a escapar enquanto estiver sendo perseguido, além de permitir que você se desloque rapidamente em um mapa grande. Certifique-se de sempre ter uma posição segura marcada."

L.tip17 = "Os inocentes estão todos agrupados sendo difíceis de serem mortos? Considere experimentar o Rádio para reproduzir sons de um C4 ou de um tiroteio para fazer com que eles se desagrupem."

L.tip18 = "Ao usar o Rádio como Traidor, você pode reproduzir sons através do seu Menu de Equipamentos depois que o Rádio for posicionado. Coloque vários sons para serem reproduzidos em sequência ao clicar nos botões usando a ordem desejada."

L.tip19 = "Como Detetive, se você estiver com alguns créditos sobrando, você pode dar um Kit de Desarme para um Inocente confiável. Assim, você pode gastar seu tempo com um trabalho mais sério de investigação enquanto você deixa a missão arriscada de desarmamento para ele."

L.tip20 = "Os Binóculos dos Detetives permitem localizar e identificar cadáveres a distância. Más notícias se os Traidores estavam querendo usar um cadáver como isca. Mas é claro que, quando um Detetive estiver usando os Binóculos, ele estará desarmado e distraído..."

L.tip21 = "A Estação de Cura dos Detetives permite que jogadores feridos se curem. Mas é claro que, os jogadores feridos podem ser Traidores..."

L.tip22 = "A Estação de Cura armazena uma amostra do DNA de cada jogador que a utilizar. Os Detetives podem utilizar o Scanner de DNA na Estação de Cura para descobrir quem andou se curando."

L.tip23 = "Diferentemente de armas e do C4, o Rádio dos Traidores não contém uma amostra do DNA de quem o posicionou. Não se preocupe com Detetives encontrando o seu DNA e descobrindo a sua verdadeira identidade."

L.tip24 = "Pressione {helpkey} para ver um curto tutorial ou modificar suas configurações do TTT. Por exemplo, você pode desabilitar permanentemente estas dicas lá."

L.tip25 = "Quando um Detetive investiga um corpo, o resultado é disponibilizado para todos no placar ao clicar no nome da pessoa morta."

L.tip26 = "No placar, um ícone de lupa próximo ao nome de alguém indica que você coletou informações sobre aquela pessoa. Se o ícone estiver brilhando, os dados da investigação são provindos de um Detetive e podem conter informações adicionais."

L.tip27 = "Como Detetive, cadáveres com um ícone de lupa depois de seu nome foram investigados por um Detetive e os resultados estão disponíveis para todos os jogadores pelo placar."

L.tip28 = "Espectadores podem pressionar {mutekey} para alternar entre emudecer outros espectadores ou jogadores vivos."

L.tip29 = "Se o servidor instalou idiomas adicionais, você pode mudar para um idioma diferente a qualquer momento no menu Configurações."

L.tip30 = "Os atalhos do chat ou comandos do 'rádio' podem ser utilizados ao pressionar {zoomkey}."

L.tip31 = "Como Espectador, pressione {duckkey} para destravar o cursor do seu mouse e ser possibilitado de clicar neste painel de dicas. Pressione {duckkey} novamente para voltar à visualização normal."

L.tip32 = "O ataque alternativo do Pé de Cabra empurrará outros jogadores."

L.tip33 = "Atirar usando a retícula de ferro de uma arma aumentará levemente a sua precisão e diminuirá o seu recuo. Agachar-se não fará diferença."

L.tip34 = "Granadas de Fumaça são eficazes em ambientes fechados, especialmente para criar confusão em salas lotadas."

L.tip35 = "Como Traidor, lembre-se de que você pode deslocar corpos e escondê-los dos inocentes e dos Detetives."

L.tip36 = "O tutorial disponível na tecla {helpkey} contém uma visão geral sobre as características mais importantes do TTT."

L.tip37 = "No placar, clique no nome de um jogador vivo e então você poderá marcá-lo como 'suspeito' ou 'amigo', entre outras marcações. A marcação será exibida quando você estiver com a mira sobre o jogador marcado."

L.tip38 = "A maioria dos equipamentos especiais posicionáveis (como o C4 e o Rádio) podem ser presos nas paredes ao usar o botão de ataque alternativo."

L.tip39 = "Um explosivo C4 que explodir devido a uma falha no seu desarmamento causará uma explosão menor do que um explosivo C4 que explodir devido ao seu temporizador ter chegado a zero."

L.tip40 = "Caso esteja escrito 'MODO PRESSA' acima do tempo da rodada, a rodada terá inicialmente apenas alguns minutos, mas a cada morte o tempo restante aumentará (como capturar um ponto no TF2). Esse modo pressiona os traidores para que eles mantenham as coisas em movimento."

--- Round report

L.report_title = "Relatório da rodada"

-- Tabs
L.report_tab_hilite = "Destaques"
L.report_tab_hilite_tip = "Destaques da rodada"
L.report_tab_events = "Acontecimentos"
L.report_tab_events_tip = "Registro dos acontecimentos desta rodada"
L.report_tab_scores = "Pontuações"
L.report_tab_scores_tip = "Pontos marcados por cada jogador nesta rodada"

-- Event log saving
L.report_save     = "Salvar Log .txt"
L.report_save_tip = "Salvar o Registro de Acontecimentos para um documento de texto"
L.report_save_error  = "Não há nenhum Registro de Acontecimentos a ser salvo."
L.report_save_result = "O Registro de Acontecimentos foi salvo em:"

-- Big title window
L.hilite_win_traitors = "TRAIDORES VENCEM!"
L.hilite_win_innocent = "INOCENTES VENCEM!"

L.hilite_players1 = "{numplayers} participaram, {numtraitors} eram traidores"
L.hilite_players2 = "{numplayers} participaram, um deles era o traidor"

L.hilite_duration = "A rodada durou {time}"

-- Columns
L.col_time   = "Tempo"
L.col_event  = "Acontecimento"
L.col_player = "Jogador"
L.col_role   = "Cargo"
L.col_kills1 = "Inocentes mortos"
L.col_kills2 = "Traidores mortos"
L.col_points = "Pontos"
L.col_team   = "Bônus de equipe"
L.col_total  = "Total de pontos"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "alguma coisa"

-- Kill events
L.ev_blowup      = "{victim} se explodiu"
L.ev_blowup_trap = "{victim} foi explodido pelo(a) {trap}"

L.ev_tele_self   = "{victim} deu telefrag em si mesmo"
L.ev_sui         = "{victim} não aguentou a pressão e cometeu suicídio"
L.ev_sui_using   = "{victim} se matou usando {tool}"

L.ev_fall        = "{victim} caiu para sua morte"
L.ev_fall_pushed = "{victim} caiu para sua morte depois de ser empurrado por {attacker}"
L.ev_fall_pushed_using = "{victim} caiu para sua morte depois de {attacker} usar o(a) {trap} para empurrá-lo"

L.ev_shot        = "{victim} foi baleado por {attacker}"
L.ev_shot_using  = "{victim} foi baleado por {attacker} usando um(a) {weapon}"

L.ev_drown       = "{victim} foi afogado por {attacker}"
L.ev_drown_using = "{victim} foi afogado pelo(a) {trap} ativado(a) por {attacker}"

L.ev_boom        = "{victim} foi explodido por {attacker}"
L.ev_boom_using  = "{victim} foi explodido por {attacker} usando {trap}"

L.ev_burn        = "{victim} foi frito por {attacker}"
L.ev_burn_using  = "{victim} foi incendiado pelo(a) {trap} devido a {attacker}"

L.ev_club        = "{victim} foi espancado por {attacker}"
L.ev_club_using  = "{victim} foi espancado até a morte por {attacker} usando {trap}"

L.ev_slash       = "{victim} foi esfaqueado por {attacker}"
L.ev_slash_using = "{victim} foi cortado por {attacker} usando {trap}"

L.ev_tele        = "{victim} recebeu um telefrag de {attacker}"
L.ev_tele_using  = "{victim} foi atomizado pelo(a) {trap} colocado(a) por {attacker}"

L.ev_goomba      = "{victim} foi esmagado pelo grande peso de {attacker}"

L.ev_crush       = "{victim} foi esmagado por {attacker}"
L.ev_crush_using = "{victim} foi esmagado pelo(a) {trap} de {attacker}"

L.ev_other       = "{victim} foi morto por {attacker}"
L.ev_other_using = "{victim} foi morto por {attacker} usando {trap}"

-- Other events
L.ev_body        = "{finder} encontrou o cadáver de {victim}"
L.ev_c4_plant    = "{player} armou um C4"
L.ev_c4_boom     = "O C4 armado por {player} explodiu"
L.ev_c4_disarm1  = "{player} desarmou o C4 armado por {owner}"
L.ev_c4_disarm2  = "{player} falhou em desarmar o C4 de {owner}"
L.ev_credit      = "{finder} encontrou {num} crédito(s) no cadáver de {player}"

L.ev_start       = "A rodada começou"
L.ev_win_traitor = "Os traidores covardes venceram a rodada!"
L.ev_win_inno    = "Os adoráveis terroristas inocentes venceram a rodada!"
L.ev_win_time    = "Os traidores ficaram sem tempo e perderam!"

--- Awards/highlights

L.aw_sui1_title = "LÍDER DA SEITA SUICIDA"
L.aw_sui1_text  = "mostrou aos outros suicidas como as coisas funcionam sendo o primeiro a partir."

L.aw_sui2_title = "SOZINHO E DEPRESSIVO"
L.aw_sui2_text  = "foi o único que se matou."

L.aw_exp1_title = "BOLSA PARA PESQUISA DE EXPLOSIVOS"
L.aw_exp1_text  = "foi reconhecido por sua pesquisa com explosivos. {num} cobaias o ajudaram."

L.aw_exp2_title = "PESQUISA DE CAMPO"
L.aw_exp2_text  = "testou sua própria resistência a explosões. Não era alta o suficiente."

L.aw_fst1_title = "FIRST BLOOD"
L.aw_fst1_text  = "entregou a primeira morte de um inocente nas mãos de um traidor."

L.aw_fst2_title = "FIRST BLOOD REVERSO"
L.aw_fst2_text  = "marcou a primeira morte matando um traidor aliado. Bom trabalho."

L.aw_fst3_title = "ATAQUE DE PÂNICO"
L.aw_fst3_text  = "foi o primeiro a matar. Pena que era um camarada inocente."

L.aw_fst4_title = "TIRO CERTO"
L.aw_fst4_text  = "foi o inocente que marcou a primeira morte matando um traidor."

L.aw_all1_title = "MAIS MORTAL ENTRE IGUAIS"
L.aw_all1_text  = "foi responsável por cada morte causada pelos inocentes nesta rodada."

L.aw_all2_title = "LOBO SOLITÁRIO"
L.aw_all2_text  = "foi responsável por cada morte causada pelos traidores nesta rodada."

L.aw_nkt1_title = "EU PEGUEI UM, CHEFE!"
L.aw_nkt1_text  = "conseguiu matar apenas um inocente. Congratulações!"

L.aw_nkt2_title = "UMA BALA PARA DOIS"
L.aw_nkt2_text  = "mostrou que a primeira vítima não foi alva de um tiro de sorte ao matar outra vítima com a mesma bala."

L.aw_nkt3_title = "TRAIDOR EM SÉRIE"
L.aw_nkt3_text  = "acabou com três vidas inocentes de terrorismo hoje."

L.aw_nkt4_title = "O LOBO ENTRE LOBOS QUE MAIS PARECEM OVELHAS"
L.aw_nkt4_text  = "comeu terroristas inocentes no jantar. Um jantar de {num} pratos."

L.aw_nkt5_title = "OPERAÇÃO CONTRATERRORISTA"
L.aw_nkt5_text  = "é pago por cada assassinato. Agora já pode comprar outro iate luxuoso."

L.aw_nki1_title = "TRAIA ISTO"
L.aw_nki1_text  = "achou um traidor. Atirou num traidor. Fácil."

L.aw_nki2_title = "JAPONÊS DA FEDERAL"
L.aw_nki2_text  = "escoltou dois traidores para o além."

L.aw_nki3_title = "TRAIDORES CONTAM CARNEIRINHOS?"
L.aw_nki3_text  = "colocou três traidores para dormir."

L.aw_nki4_title = "FUNCIONÁRIO DE ASSUNTOS INTERNOS"
L.aw_nki4_text  = "é pago por cada assassinato. Agora já pode encomendar sua quinta piscina olímpica."

L.aw_fal1_title = "NÃO, SR. BOND, ESPERO QUE VOCÊ CAIA"
L.aw_fal1_text  = "empurrou alguém de um lugar alto."

L.aw_fal2_title = "PAVIMENTADO"
L.aw_fal2_text  = "deixou seu corpo bater no chão depois de cair de uma altura significativa."

L.aw_fal3_title = "O METEORITO HUMANO"
L.aw_fal3_text  = "esmagou alguém caindo sobre este de uma grande altura."

L.aw_hed1_title = "EFICIÊNCIA"
L.aw_hed1_text  = "descobriu a alegria dos tiros na cabeça e atirou em {num} cabeças."

L.aw_hed2_title = "NEUROLOGIA"
L.aw_hed2_text  = "removeu o cérebro de {num} cabeças para um exame minucioso."

L.aw_hed3_title = "A CULPA É DOS VIDEOGAMES"
L.aw_hed3_text  = "aplicou seu treinamento de simulação de assassinato e atirou em {num} cabeças de inimigos."

L.aw_cbr1_title = "THUNK THUNK THUNK"
L.aw_cbr1_text  = "descobriu que esse é o barulho que o Pé de Cabra faz ao matar, como {num} vítimas também descobriram."

L.aw_cbr2_title = "FREEMAN"
L.aw_cbr2_text  = "cobriu seu Pé de Cabra com nada menos do que {num} cérebros."

L.aw_pst1_title = "PEQUENO INSETO PERSISTENTE"
L.aw_pst1_text  = "marcou {num} mortes usando uma pistola. Logo após, ele abraçou alguém até a morte."

L.aw_pst2_title = "CHACINA DE PEQUENO CALIBRE"
L.aw_pst2_text  = "matou um pequeno exército de {num} com uma pistola. Provavelmente instalou uma pequena escopeta dentro do cano."

L.aw_sgn1_title = "MODO FÁCIL"
L.aw_sgn1_text  = "aplicou tiro onde dói, conseguindo matar {num} alvos."

L.aw_sgn2_title = "MILHARES DE BALAS PEQUENAS"
L.aw_sgn2_text  = "não gostou muito do chumbo grosso, e decidiu doá-lo. {num} destinatários não viveram para aproveitá-lo."

L.aw_rfl1_title = "APONTAR E CLICAR"
L.aw_rfl1_text  = "mostrou que tudo que você precisa para cometer {num} assassinatos é um rifle e uma mão firme."

L.aw_rfl2_title = "EU POSSO VER SUA CABEÇA DAQUI"
L.aw_rfl2_text  = "conhece o rifle que tem. Agora {num} pessoas conhecem o seu rifle também."

L.aw_dgl1_title = "É COMO UM PEQUENO RIFLE"
L.aw_dgl1_text  = "está pegando o jeito de jogar com a Desert Eagle, conseguindo matar {num} pessoas."

L.aw_dgl2_title = "MESTRE DA DESERT EAGLE"
L.aw_dgl2_text  = "surpreendeu {num} pessoas com sua Desert Eagle."

L.aw_mac1_title = "REZAR E MATAR"
L.aw_mac1_text  = "matou {num} pessoas com a MAC10, mas não dirá quanta munição precisou."

L.aw_mac2_title = "MAC COM QUEIJO"
L.aw_mac2_text  = "imagina o que aconteceria se ele estivesse com duas MAC10 em suas mãos. {num} vezes dois?"

L.aw_sip1_title = "FIQUE QUIETO"
L.aw_sip1_text  = "calou a boca de {num} pessoas com sua pistola silenciada."

L.aw_sip2_title = "ASSASSINO SILENCIOSO"
L.aw_sip2_text  = "matou {num} pessoas que não ouviram sua própria morte."

L.aw_knf1_title = "ESFAQUEÁ-LO-EI"
L.aw_knf1_text  = "esfaqueou a cara de alguém pela internet."

L.aw_knf2_title = "ONDE VOCÊ CONSEGUIU ISSO?"
L.aw_knf2_text  = "não era um Traidor, e mesmo assim matou alguém com uma faca."

L.aw_knf3_title = "O TAL ESFAQUEADOR"
L.aw_knf3_text  = "encontrou {num} facas espalhadas, e fez bom uso delas."

L.aw_knf4_title = "O MELHOR ESFAQUEADOR DO MUNDO"
L.aw_knf4_text  = "matou {num} pessoas com uma faca. Não me pergunte como."

L.aw_flg1_title = "AO RESGATE"
L.aw_flg1_text  = "usou seu sinalizador para sinalizar {num} mortes."

L.aw_flg2_title = "SINALIZADOR INDICA FOGO"
L.aw_flg2_text  = "ensinou a {num} homens sobre o perigo de vestir roupas inflamáveis."

L.aw_hug1_title = "UMA H.U.G.E SINTONIZADA"
L.aw_hug1_text  = "estava em sintonia com sua H.U.G.E, fazendo com que suas balas atingissem {num} pessoas."

L.aw_hug2_title = "ESQUIZOFRENIA BALÍSTICA"
L.aw_hug2_text  = "só ficou atirando, e viu sua H.U.G.E ser recompensada com {num} mortes."

L.aw_msx1_title = "PUTT PUTT PUTT"
L.aw_msx1_text  = "levou {num} pessoas com o M16."

L.aw_msx2_title = "LOUCURA DE ALCANCE MÉDIO"
L.aw_msx2_text  = "sabe derrubar pessoas com o M16, conseguindo marcar {num} mortes."

L.aw_tkl1_title = "FOI SEM QUERER"
L.aw_tkl1_text  = "pressionou o gatilho enquanto mirava em um aliado."

L.aw_tkl2_title = "FOI SEM QUERER QUERENDO"
L.aw_tkl2_text  = "pensou que havia matado dois Traidores, mas estava errado sobre ambos."

L.aw_tkl3_title = "KARMA-A-ARMA-AÊ"
L.aw_tkl3_text  = "não conseguiu parar depois de matar dois aliados. Três é seu número da sorte."

L.aw_tkl4_title = "OS MEUS ALIADOS SÃO MEUS INIMIGOS"
L.aw_tkl4_text  = "matou toda a sua equipe. PIMBA!"

L.aw_tkl5_title = "PAPÉIS DIFERENTES"
L.aw_tkl5_text  = "estava interpretando um louco honesto. E é por isso que ele matou quase toda a sua equipe."

L.aw_tkl6_title = "ANTA"
L.aw_tkl6_text  = "não conseguiu descobrir em que equipe estava, e matou mais da metade de seus aliados."

L.aw_tkl7_title = "PEÃO"
L.aw_tkl7_text  = "protegeu seu território de maneira fantástica ao matar mais de um quarto de seus aliados."

L.aw_brn1_title = "COMO A VOVÓ FAZIA"
L.aw_brn1_text  = "fritou várias pessoas para fazer uma batata frita agradável."

L.aw_brn2_title = "PIROMANÍACO"
L.aw_brn2_text  = "foi ouvido gargalhando alto depois de queimar uma de suas muitas vítimas."

L.aw_brn3_title = "PIROMANÍACO GRANADEIRO"
L.aw_brn3_text  = "queimou todos, mas agora está sem granadas incendiárias! Como ele vai lidar com isso!?"

L.aw_fnd1_title = "MÉDICO LEGISTA"
L.aw_fnd1_text  = "encontrou {num} cadáveres por aí."

L.aw_fnd2_title = "TEMOS QUE PEGAR TODOS ELES"
L.aw_fnd2_text  = "encontrou {num} cadáveres para a sua coleção."

L.aw_fnd3_title = "CHEIRO DE MORTE"
L.aw_fnd3_text  = "continua tropeçando em cadáveres, conseguindo tropeçar {num} vezes nesta rodada."

L.aw_crd1_title = "RECICLADOR"
L.aw_crd1_text  = "coletou {num} créditos perdidos em cadáveres."

L.aw_tod1_title = "UMA-QUASE-VITÓRIA"
L.aw_tod1_text  = "morreu segundos antes de sua equipe vencer a partida."

L.aw_tod2_title = "EU ODEIO ESTE JOGO"
L.aw_tod2_text  = "morreu logo após o início da rodada."


--- New and modified pieces of text are placed below this point, marked with the
--- version or the date in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Evitar ser selecionado como Detetive"
L.set_avoid_det_tip = "Habilite isto para solicitar ao servidor a não lhe selecionar como Detetive, se possível. Isso não significa que você terá mais chances de ser um Traidor."

--- v24
L.drop_no_ammo = "Munição insuficiente no clipe da sua arma para largar como uma caixa de munição."

--- v31
L.set_cross_brightness = "Brilho da mira"
L.set_cross_size = "Tamanho da mira"

--- 2015-05-25
L.hat_retrieve = "Você pegou o chapéu de um Detetive."

--- 2017-03-09
L.sb_sortby = "Classificar por:"

--- 2018-07-24
L.equip_tooltip_main = "Menu de Equipamentos"
L.equip_tooltip_radar = "Controle do Radar"
L.equip_tooltip_disguise = "Controle do Disfarce"
L.equip_tooltip_radio = "Controle do Rádio"
L.equip_tooltip_xfer = "Transferir créditos"

L.confgrenade_name = "Granada de Impulso"
L.polter_name = "Poltergeist"
L.stungun_name = "Protótipo UMP"

L.knife_instant = "MORTE INSTANTÂNEA"

L.dna_hud_type = "TIPO"
L.dna_hud_body = "CORPO"
L.dna_hud_item = "ITEM"

L.binoc_zoom_level = "NÍVEL"
L.binoc_body = "CORPO DETECTADO"

L.idle_popup_title = "Ausência"

--- 2021-06-07
L.sb_playervolume = "Volume do jogador"

--- 2021-09-22
L.tip41 = "Você pode ajustar o volume do microfone de um jogador ao clicar com o botão direito no ícone de silenciar dele no placar."
