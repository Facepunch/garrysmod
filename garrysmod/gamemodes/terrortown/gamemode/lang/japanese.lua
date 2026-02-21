---- Japanese language strings

local L = LANG.CreateLanguage("日本語")

-- General text used in various places
L.traitor = "Traitor"
L.detective = "Detective"
L.innocent = "Innocent"
L.last_words = "遺言"

L.terrorists = "テロリスト"
L.spectators = "観戦者"

-- Round status messages
L.round_minplayers = "ラウンドを開始するのに必要なプレイヤーがいないようだ…"
L.round_voting = "投票中のため、{num}秒まで新しいラウンドを延期中…"
L.round_begintime = "{num}秒内にラウンドを開始する。早めに準備をしよう。"
L.round_selected = "Traitor選択完了。"
L.round_started = "ラウンド開始！"
L.round_restart = "ラウンドは管理者によってリスタートされたようだ。"

L.round_traitors_one = "Traitorよ、一人でも頑張れ。"
L.round_traitors_more = "Traitorよ、仲間の{names}と一緒に彼らを始末しよう。"

L.win_time = "時間切れ。Traitorの負けだ。"
L.win_traitor = "Traitorの勝利！"
L.win_innocent = "Innocentの勝利！"
L.win_showreport = "さあ{num}秒の間ラウンドレポートを見てみよう。"

L.limit_round = "ラウンドリミットに達した。もうすぐロードされるだろう。"
L.limit_time = "タイムリミットに達した。もうすぐロードされるだろう。"
L.limit_left = "マップ変更するまで{num}ラウンドないし{time}分残っている。"

--- Credit awards
L.credit_det_all   = "Detectiveよ、任務遂行のために{num}個のクレジットを得たぞ。"
L.credit_tr_all    = "Traitorよ、任務遂行のために{num}個のクレジットを得たぞ。"

L.credit_kill      = "{role}を始末したので、{num}個のクレジットを得たぞ。"

--- Karma
L.karma_dmg_full   = "今のカルマは{amount}なので、与えられるダメージは通常だ。"
L.karma_dmg_other  = "今のカルマは{amount}なので、与えられるダメージは{num}%減少してしまった。"

--- Body identification messages
L.body_found       = "{finder}は{victim}の死体を見つけた. {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "奴はTraitorだったな！"
L.body_found_d     = "奴はDetectiveだったようだ…"
L.body_found_i     = "奴はInnocentだったようだ…"

L.body_confirm     = "{finder}は{victim}の死を確認した。"

L.body_call        = "{player}はDetectiveを{victim}の死体の場所に呼んだ！"
L.body_call_error  = "Detectiveを呼ぶ前にこのプレイヤーの死の確認が必要だ！"

L.body_burning     = "熱っ！この死体は燃えてるぞ！"
L.body_credits     = "死体から{num}クレジットを拾った！"

--- Menus and windows
L.close = "閉じる"
L.cancel = "キャンセル"

-- For navigation buttons
L.next = "次へ"
L.prev = "前へ"

-- Equipment buying menu
L.equip_title     = "アイテム"
L.equip_tabtitle  = "アイテム購入"

L.equip_status    = "注文状況"
L.equip_cost      = "残り{num}クレジット"
L.equip_help_cost = "いずれの装備も購入費用は１クレジットだ（設定でクレジット消費数を設定できる）。"

L.equip_help_carry = "自分が所持してないものだけだけ買うことができるぞ。"
L.equip_carry      = "この装備は持つことが可能だ。"
L.equip_carry_own  = "既にこのアイテムを持っているぞ。"
L.equip_carry_slot = "既にスロット{slot}の武器を持っているぞ。"

L.equip_help_stock = "いくつかのアイテムはラウンド毎に1つしか買えない。"
L.equip_stock_deny = "このアイテムはもう在庫がない。"
L.equip_stock_ok   = "このアイテムはまだ在庫がある。"

L.equip_custom     = "このサーバーにカスタムアイテムを追加した。"

L.equip_spec_name  = "名前"
L.equip_spec_type  = "種類"
L.equip_spec_desc  = "説明"

L.equip_confirm    = "購入"

-- Disguiser tab in equipment menu
L.disg_name      = "変装装置"
L.disg_menutitle = "変装メニュー"
L.disg_not_owned = "変装装置はまだ持っていないぞ！"
L.disg_enable    = "変装を有効にする"

L.disg_help1     = "変装している時、誰かがあなたを見てもあなたの名前、体力とカルマは表示されない。また、Detectiveのレーダーにも反応されないだろうな。"
L.disg_help2     = "テンキーのEnterを押すとCキーからのメニューを使用せずに変装を切り替えできる。 開発者コンソールで「ttt_toggle_disguise」を異なるキーに割り当てることが可能。"

-- Radar tab in equipment menu
L.radar_name      = "レーダー"
L.radar_menutitle = "レーダーメニュー"
L.radar_not_owned = "レーダーはまだ持っていないぞ！"
L.radar_scan      = "スキャンを実行。"
L.radar_auto      = "自動で繰り返し実行。"
L.radar_help      = "スキャン結果を{num}秒間表示し、その後レーダーは再び新しい位置を教えてくれる。"
L.radar_charging  = "レーダーチャージ中..."

-- Transfer tab in equipment menu
L.xfer_name       = "譲渡"
L.xfer_menutitle  = "クレジット譲渡"
L.xfer_no_credits = "譲渡するためのクレジットがないぞ！"
L.xfer_send       = "クレジット送信"
L.xfer_help       = "仲間の{role}にクレジットを渡すことができる。"

L.xfer_no_recip   = "受取人が妥当ではないのでクレジットの移動は中断された。"
L.xfer_no_credits = "渡すクレジットが不足している。"
L.xfer_success    = "クレジットの{player}への受け渡しを完了した。"
L.xfer_received   = "{player}はあなたに{num}クレジットを渡した。"

-- Radio tab in equipment menu
L.radio_name      = "ラジオ"
L.radio_help      = "音を再生するためにボタンをクリックしよう。"
L.radio_notplaced = "再生するためにはRadioを置かなくてはならないぞ。"

-- Radio soundboard buttons
L.radio_button_scream  = "悲鳴"
L.radio_button_expl    = "爆発音"
L.radio_button_pistol  = "Pistol発砲音"
L.radio_button_m16     = "M16発砲音"
L.radio_button_deagle  = "Deagle発砲音"
L.radio_button_mac10   = "MAC10発砲音"
L.radio_button_shotgun = "Shotgun発砲音"
L.radio_button_rifle   = "Rifle発砲音"
L.radio_button_huge    = "H.U.G.E発砲音"
L.radio_button_c4      = "C4警告音"
L.radio_button_burn    = "燃焼音"
L.radio_button_steps   = "足音"


-- Intro screen shown after joining
L.intro_help     = "このゲームは始めてかな？F1を押すとインストラクションを見れるぞ！"

-- Radiocommands/quickchat
L.quick_title   = "クイックチャットキー"

L.quick_yes     = "そうだ。"
L.quick_no      = "違う。"
L.quick_help    = "助けてくれ！"
L.quick_imwith  = "{player}と一緒にいるぞ。"
L.quick_see     = "{player}を監視中だ。"
L.quick_suspect = "{player}が怪しい動きをしているぞ。"
L.quick_traitor = "{player}がTraitorだ！"
L.quick_inno    = "{player}はInnocentだな。"
L.quick_check   = "まだ生きている奴はいるか？"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "いない奴"
L.quick_disg      = "変装中"
L.quick_corpse    = "死体"
L.quick_corpse_id = "{player}の死体"


--- Body search window
L.search_title  = "調査結果"
L.search_info   = "情報"
L.search_confirm = "確認済み"
L.search_call   = "Detectiveを呼ぶ"

-- Descriptions of pieces of information found
L.search_nick   = "こいつは{player}の死体だ。"

L.search_role_t = "こいつはTraitorだったな！"
L.search_role_d = "こいつはDetectiveだった。"
L.search_role_i = "こいつはInnocentだった。"

L.search_words  = "遺言'{lastwords}'"
L.search_armor  = "ボディアーマーを着ていたようだ。"
L.search_disg   = "変装をしていたようだ。"
L.search_radar  = "レーダーを所持していたようだ。もう機能していないがな。"
L.search_c4     = "ポケットからメモを見つけた。それには'爆弾を解除するには{num}番のワイヤーをカットしろ'と書かれている。"

L.search_dmg_crush  = "こいつの骨の多くが折れている。重たい物でもぶつかって死んだようだ。"
L.search_dmg_bullet = "こいつは撃たれて死んだようだな。"
L.search_dmg_fall   = "こいつは転落死したようだな。"
L.search_dmg_boom   = "こいつの傷と焼けた衣服から見ると、爆発で死んだように思えるな。"
L.search_dmg_club   = "死体には打撲傷と殴られた跡がある。殴られて死んだようだな。"
L.search_dmg_drown  = "死因は溺死のようだ。"
L.search_dmg_stab   = "こいつは刃物に刺されて出血死したようだ。。"
L.search_dmg_burn   = "この辺りにはテロリストが焼けたような臭いがするな..."
L.search_dmg_tele   = "こいつのDNAはタキオン粒子の放出によってかき混ぜられたように見えるな。"
L.search_dmg_car    = "このテロリストが道路を渡った際、野蛮なドライバーにでも轢かれたのか。"
L.search_dmg_other  = "このテロリストの死因を特定できない。"

L.search_weapon = "{weapon}によって殺されたようだな。"
L.search_head   = "致命的な傷はヘッドショットによるものだ。 叫ぶ間も無い。"
L.search_time   = "こいつは調査のおおよそ{time}秒前に死んだな。"
L.search_dna    = "裏切り者のDNAサンプルをDNAスキャナーで回収しなくては。DNAサンプルは今からおおよそ{time}秒で腐敗するだろう。"

L.search_kills1 = "{player}の死を立証する殺害リストを見つけた。"
L.search_kills2 = "これらの名前の載った殺害リストを見つけた:"
L.search_eyes   = "Detectiveスキルを使用し、こいつの見た最後の人物を確認した: {player}. 裏切り者か、それとも偶然か？"


-- Scoreboard
L.sb_playing    = "サーバー名"
L.sb_mapchange  = "マップ変更まで{num}ラウンドか{time}秒"

L.sb_mia        = "行方不明"
L.sb_confirmed  = "死亡確認"

L.sb_ping       = "ピング値"
L.sb_deaths     = "死亡回数"
L.sb_score      = "スコア"
L.sb_karma      = "カルマ"

L.sb_info_help  = "このプレイヤーの死体を調査すると、ここで結果を精査することができるぞ。"

L.sb_tag_friend = "仲間"
L.sb_tag_susp   = "容疑者"
L.sb_tag_avoid  = "避けたい者"
L.sb_tag_kill   = "殺害対象"
L.sb_tag_miss   = "行方不明"

--- Help and settings menu (F1)

L.help_title = "ヘルプと設定"

-- Tabs
L.help_tut     = "チュートリアル"
L.help_tut_tip = "TTTを正しく遊ぶための6つのステップ"

L.help_settings = "設定"
L.help_settings_tip = "クライアント側の設定"

-- Settings
L.set_title_gui = "インターフェイス設定"

L.set_tips      = "観戦中に画面の下部にヒントを表示する"

L.set_startpopup = "ラウンド開始情報のポップアップを表示"
L.set_startpopup_tip = "ラウンドが始まったら、数秒だけ画面の下部に小さなポップアップを表示する。ここで表示する時間を設定可能だ。"

L.set_cross_opacity   = "アイアンサイトのクロスヘア不透明度"
L.set_cross_disable   = "クロスヘアを完全に無効"
L.set_minimal_id      = "クロスヘア下の最小限のターゲットID（カルマ ヒントなどを非表示）"
L.set_healthlabel   = "ヘルスバー上にステータスラベルを表示する"
L.set_lowsights     = "アイアンサイト使用時には武器を下に下げる"
L.set_lowsights_tip = "有効にするとアイアンサイト使用中は武器のモデルの位置を画面の下の方に表示させる。これはターゲットを見やすくするが、見た目のリアリティは下がるだろう。"
L.set_fastsw        = "高速武器スイッチ"
L.set_fastsw_tip    = "有効にするとホイールスクロールで順番に武器を切り替えれる。武器スイッチメニューを表示するには下の\"高速武器スイッチ時のメニュー表示を有効にする\"を有効にしよう。"
L.set_fastsw_menu     = "高速武器スイッチ時のメニュー表示を有効にする"
L.set_fastswmenu_tip  = "高速武器スイッチ有効時でもスイッチメニューをポップアップ表示する"
L.set_wswitch       = "武器スイッチメニューが自動で閉じるのを無効にする"
L.set_wswitch_tip   = "デフォルトでは武器スイッチメニューはホイールスクロール後数秒で自動的に閉じる。 有効にするとメニューはそのままにできる。"
L.set_cues          = "ラウンド開始時、終了時に音を鳴らす"


L.set_title_play    = "ゲーム設定"

L.set_specmode      = "常時観戦者モード(観戦者のままになれる)"
L.set_specmode_tip  = "常時観戦者モードはラウンドが新しく始まっても、ずっと観戦者のままにしてくれるぞ。"
L.set_mute          = "死んでいるときは生存者をミュートする"
L.set_mute_tip      = "死んでいるとき、または観戦者の時は生存者をミュートにすることを有効。"


L.set_title_lang    = "言語設定"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "言語を選ぼう (Select language):"


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "この武器は品切れだ: 既にこのラウンドで購入済みだ。"
L.buy_pending     = "既に注文されている、受け取りまで待とう。"
L.buy_received    = "特殊装備を受け取った。"

L.drop_no_room    = "空きが無いから武器を捨てるしかない。"

L.disg_turned_on  = "変装完了。"
L.disg_turned_off = "変装解除。"

-- Equipment item descriptions
L.item_passive    = "パッシブ効果アイテム"
L.item_active     = "使用アイテム"
L.item_weapon     = "武器"

L.item_armor      = "ボディアーマー"
L.item_armor_desc = [[
弾丸によるダメージを３０％軽減。

探偵には最初から装着されている。]]


L.item_radar      = "レーダー"
L.item_radar_desc = [[
生命反応を捉えることができる。

購入するとすぐに自動で探知してくれる。 
設定はCキーのレーダーメニューから。]]


L.item_disg       = "変装装置"
L.item_disg_desc  = [[
変装中はあなたのID情報を隠せる。 
さらに、獲物が最期に目撃した人物になるのも避けれる。

このメニューの変装メニュー内か
テンキーのEnterで切り替えれる。]]

-- C4
L.c4_hint         = "{usekey}を押して起動もしくは解除"
L.c4_no_disarm    = "別のTraitorが死ぬまで、彼のC4は解除できないようだ。"
L.c4_disarm_warn  = "C4が解除されてしまった。"
L.c4_armed        = "爆弾は起動完了だ。"
L.c4_disarmed     = "爆弾の解除に成功した。"
L.c4_no_room      = "こんな狭い所ではC4は持てないぞ。"

L.c4_desc         = "強力な時限爆弾。"

L.c4_arm          = "C4起動"
L.c4_arm_timer    = "時間"
L.c4_arm_seconds  = "爆発まで:"
L.c4_arm_attempts = "解除を試みる際、６本のワイヤーの内{num}本はカットしてしまうと即爆発するので要注意だ。"

L.c4_remove_title    = "撤去"
L.c4_remove_pickup   = "拾う"
L.c4_remove_destroy1 = "破壊"
L.c4_remove_destroy2 = "確認:破壊"

L.c4_disarm       = "C4を解除"
L.c4_disarm_cut   = "クリックして{num}本目のワイヤーを切断する"

L.c4_disarm_t     = "ワイヤーを切って爆弾を解除するんだ。Traitorならどのワイヤーでも安全だが、Innocentならそう簡単にはいかないぞ！"
L.c4_disarm_owned = "ワイヤーをカットして爆弾を解除してくれ。あなたの爆弾だからどのワイヤーでも安全だ。"
L.c4_disarm_other = "安全なワイヤーをカットして爆弾を解除してくれ。間違えたら即爆発だ！"

L.c4_status_armed    = "起動中"
L.c4_status_disarmed = "解除済み"

-- Visualizer
L.vis_name        = "可視化装置"
L.vis_hint        = "{usekey}で拾う（Detectiveのみ）"

L.vis_help_pri    = "{primaryfire}で可視化装置を落とす"

L.vis_desc        = [[
殺害現場を可視化してくれる機械。

死体を分析して被害者がどのように
殺害されたかを表示するが、被害者が
銃撃の傷で死んだ場合のみだ。]]

-- Decoy
L.decoy_name      = "デコイ"
L.decoy_no_room   = "この狭い所ではデコイは持てないようだ。"
L.decoy_broken    = "デコイが破壊された！"

L.decoy_help_pri  = "{primaryfire}でデコイ設置"

L.decoy_desc      = [[
Detectiveに偽のレーダー反応を表示させ、
彼らがあなたのDNAをスキャンしていた場合は
彼らのDNAスキャナーがデコイの場所を
表示するようにしてくれる。]]

-- Defuser
L.defuser_name    = "除去装置"
L.defuser_help    = "{primaryfire}でC4除去"

L.defuser_desc    = [[
C4爆弾を即座に除去する。

使用回数は無制限。これさえ
持っていればC4に気がつくのに容易だろう。]]

-- Flare gun
L.flare_name      = "信号拳銃"
L.flare_desc      = [[
死体を燃やすことができる。証拠隠滅に必須。
弾は限られているので注意。

燃えている死体からは大きな燃焼音を
発するので注意。]]

-- Health station
L.hstation_name   = "回復ステーション"
L.hstation_hint   = "{usekey}で回復。エネルギー残量:{num}"
L.hstation_broken = "回復ステーションが破壊された！"
L.hstation_help   = "{primaryfire}で回復ステーション設置"

L.hstation_desc   = [[
回復が可能な設置型の機械。

チャージは遅い。誰でも使用することができるが、
耐久力があるので注意。使用者のDNAサンプルを
チェックすることができる。]]

-- Knife
L.knife_name      = "ナイフ"
L.knife_thrown    = "ナイフ投擲"

L.knife_desc      = [[
怪我した者なら即座に静かに始末できるが、
一度しか使用できない。

オルトファイアで投げることができる。]]

-- Poltergeist
L.polter_desc     = [[
オブジェクトにThumperを設置すると、
使用者の意志に関係なくそのオブジェクトが暴れまわる。

暴れ終わった後のThumperの爆発は
近くの人間にダメージを与える。]]

-- Radio
L.radio_broken    = "ラジオが破壊された！"
L.radio_help_pri  = "{primaryfire}でラジオを置く"

L.radio_desc      = [[
注意を逸らしたり欺くために音を再生できる。

どこか適当な場所にラジオを置いてから、
ショップメニュー内のラジオメニューから
音を再生できる。]]

-- Silenced pistol
L.sipistol_name   = "消音ピストル"

L.sipistol_desc   = [[
サプレッサー付きのハンドガン。
通常のピストルの弾丸を使用する。

撃たれた犠牲者は悲鳴をあげることはないだろう。]]

-- Newton launcher
L.newton_name     = "ニュートンランチャー"

L.newton_desc     = [[
遠距離からでも人を弾き飛ばせる弾を発射する。

弾は無制限だが、次の弾を発射するのに時間がかかる。]]

-- Binoculars
L.binoc_name      = "双眼鏡"
L.binoc_desc      = [[
遠く離れた距離から死体まで拡大し、
確認することができる。

無制限で使用できるが、
確認するのに数秒かかる。]]

L.binoc_help_pri  = "{primaryfire}で死体確認"
L.binoc_help_sec  = "{secondaryfire}で拡大レベルを変更"

-- UMP
L.ump_desc        = [[
ターゲットを混乱させる強力なSMG。

SMG弾を使用する。]]


-- DNA scanner
L.dna_name        = "DNAスキャナー"
L.dna_notfound    = "DNAサンプルは見つからなかった。"
L.dna_limit       = "容器は限界に達した。古いサンプルを捨てて新しいのを加えるんだ。"
L.dna_decayed     = "殺害者のDNAサンプルは腐っていたようだ。"
L.dna_killer      = "死体から殺害者のDNAサンプルを入手した！"
L.dna_duplicate   = "一致した！スキャナーにこのDNAが登録されたぞ。"
L.dna_no_killer   = "DNAは回収されることができないようだ (殺害者はゲームを退出したんだろうか?)."
L.dna_armed       = "この爆弾は稼働中だ！早く解除するんだ！"
L.dna_object      = "オブジェクトから{num}個の新しいDNAサンプルを入手した。"
L.dna_gone        = "このエリアにDNA反応はないようだ。"

L.dna_desc        = [[
物からDNAサンプルを入手しそれらを
使用してDNAの持ち主を探せる。

確認後の死体のみに使用でき、
殺害者のDNAを入手して彼らを追跡できる。]]

L.dna_menu_title  = "DNAスキャンメニュー"
L.dna_menu_sample = "DNAサンプルが{source}から見つけた。"
L.dna_menu_remove = "削除"
L.dna_menu_help1  = "これらがあなたが集めたDNAサンプルだ。"
L.dna_menu_help2  = [[
チャージされたとき、 あなたは選択したDNAサンプルの
持ち主の場所をスキャンできる。
距離のあるターゲットを発見するにはよりエネルギーを消耗する。]]

L.dna_menu_scan   = "スキャン"
L.dna_menu_repeat = "自動で繰り返す"
L.dna_menu_ready  = "準備完了"
L.dna_menu_charge = "チャージ中"
L.dna_menu_select = "サンプル選択"

L.dna_help_primary   = "{primaryfire}でDNAサンプル回収"
L.dna_help_secondary = "{secondaryfire}でスキャンメニューを開く"

-- Magneto stick
L.magnet_name     = "マグネットスティック"
L.magnet_help     = "{primaryfire}で死体を貼り付ける"

-- Grenades and misc
L.grenade_smoke   = "発煙弾"
L.grenade_fire    = "焼夷手榴弾"

L.unarmed_name    = "無防備"
L.crowbar_name    = "バール"
L.pistol_name     = "ピストル"
L.rifle_name      = "スナイパーライフル"
L.shotgun_name    = "ショットガン"

-- Teleporter
L.tele_name       = "テレポーター"
L.tele_failed     = "テレポートに失敗した。"
L.tele_marked     = "テレポート位置を設定した。"

L.tele_no_ground  = "安定した足場に立つまではテレポートはできないぞ！"
L.tele_no_crouch  = "しゃがんでいるとテレポートはできないぞ！"
L.tele_no_mark    = "設定した場所がないようだ。テレポートする前に移動先を設定するんだ。"

L.tele_no_mark_ground = "安定した足場に立つまではテレポート位置を設定することはできないぞ！"
L.tele_no_mark_crouch = "しゃがんでいるとテレポート位置を設定することができないぞ！"

L.tele_help_pri   = "{primaryfire}で設定した場所にテレポートする"
L.tele_help_sec   = "{secondaryfire}で現在地を設定する"

L.tele_desc       = [[
あらかじめ設定した地点にテレポートができる。

テレポートはノイズを発し、
使用回数は限られている。]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "9mm弾"

L.ammo_smg1       = "SMG弾"
L.ammo_buckshot   = "バックショット"
L.ammo_357        = "ライフル弾"
L.ammo_alyxgun    = "マグナム弾"
L.ammo_ar2altfire = "火炎弾"
L.ammo_gravity    = "重力弾"


--- HUD interface text

-- Round status
L.round_wait   = "プレイヤー待機中"
L.round_prep   = "ラウンド準備中"
L.round_active = "ラウンド進行中"
L.round_post   = "ラウンド終了"

-- Health, ammo and time area
L.overtime     = "延長時間"
L.hastemode    = "残り時間"

-- TargetID health status
L.hp_healthy   = "無傷"
L.hp_hurt      = "苦痛"
L.hp_wounded   = "怪我"
L.hp_badwnd    = "重傷"
L.hp_death     = "瀕死"


-- TargetID karma status
L.karma_max    = "安全"
L.karma_high   = "粗野"
L.karma_med    = "トリガーハッピー"
L.karma_low    = "危険"
L.karma_min    = "どうしようもない"

-- TargetID misc
L.corpse       = "死体"
L.corpse_hint  = "{usekey}を押して調査。{walkkey} + {usekey}で密かに調査。"

L.target_disg  = "(変装中)"
L.target_unid  = "誰かの死体"

L.target_traitor = "仲間のTraitor"
L.target_detective = "Detective"

L.target_credits = "調べて未使用クレジットを入手する"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single  = "一度きり"
L.tbut_reuse   = "再使用可能"
L.tbut_retime  = "{num}秒後に再使用可能"
L.tbut_help    = "[{usekey}]を押して起動"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "変装中"
L.radar_hud    = "レーダーの再スキャンまで:{time}秒"

-- Spectator muting of living/dead
L.mute_living  = "生存者をミュートした"
L.mute_specs   = "観戦者をミュートした"
L.mute_all     = "全てをミュートした"
L.mute_off     = "ミュートを解除した"

-- Spectators and prop possession
L.punch_title  = "パンチ・オー・メーター"
L.punch_help   = "移動キーもしくはジャンプ: オブジェクト移動。しゃがみ:オブジェクトを離れる。"
L.punch_bonus  = "あなたのスコアが低かったので、パンチ・オー・メーターのリミットを{num}下がってしまった。"
L.punch_malus  = "あなたのスコアが高かったので、パンチ・オー・メーターのリミットを{num}上がった！"

L.spec_help    = "観戦者に向けてクリックする、またはオブジェクトに向けて{usekey}を押したら、それに憑依できる。"

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[あなたは無実のテロリスト、Innocentだ！だが周囲にはTraitor（裏切り者）が...
あなたは誰を信用し、誰があなたを蜂の巣にするのだろうな?

背中に注意し信頼関係を築き生き延びよう！]]

L.info_popup_detective = [[あなたはDetectiveだ！テロリストの本部はTraitor（裏切り者）を見つけるためにあなたに特別な力を与えた。
それらを使用しInnocent達の生存を手助けしよう、でも気をつけろ:
Traitorは真っ先にあなたを始末しようと殺意を向けているぞ！

{menukey}を押して装備を受け取るんだ！]]

L.info_popup_traitor_alone = [[あなたはTraitor（裏切り者）だ！このラウンドでは仲間はいないようだ。

自分以外の全員始末すれば勝利だ！

{menukey}を押して特別な装備を受け取るんだ！]]

L.info_popup_traitor = [[あなたはTraitor（裏切り者）だ！他者を全て始末するために仲間と共に協力するんだ。
だが気をつけろ、あなたの裏切り行為はバレるかもしれないぞ...

仲間達:
{traitorlist}

{menukey}を押して特別な装備を受け取るんだ！]]

--- Various other text
L.name_kick = "プレイヤーはラウンド中に名前を変更したため自動的にKickされた。"

L.idle_popup = [[あなたは{num}秒間放置状態だったので強制的に常時観戦者モードに移動させられた。このモードでいる間、あなたは新しいラウンドが始まった時に参加はできない。

{helpkey}を押して設定タブでボックスのチェックを外すことでいつでも常時観戦者モードを切り替えることができる。今すぐに無効を選ぶこともできるぞ。]]

L.idle_popup_close = "何もしない"
L.idle_popup_off   = "常時観戦者モード無効化"

L.idle_warning = "注意:あなたが放置状態かAFKに見えると、あなたが動きを示すまで観戦にされるぞ！"

L.spec_mode_warning = "あなたは常時観戦者モードなのでラウンド開始時に参加できなかった。このモードを無効にするにはF1を押して設定タブで「常時観戦者モード」のチェックを外そう。"


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "ヒント"
L.tips_panel_tip   = "ヒント:"

-- Tip texts

L.tip1 = "Traitorは死体に対し{walkkey}を押しながら{usekey}を押すことにより死亡を確認することなく、静かに死体を調べることができる。"

L.tip2 = "タイマーを長くしてC4爆弾を起動するとInnocentが解除を試みる際に即座に爆発するワイヤーの本数が増える。しばしば警告音も静かにかつ少なくなる。"

L.tip3 = "Detectiveは死体を探ってその人の'最後に見た'者を知ることができる。。被害者が後ろから撃たれていたのならその人物を殺害者と決めつけるのは早とちり。"

L.tip4 = "あなたの死体を発見し、調査して確認するまではあなたの死んだことは不明。"

L.tip5 = "TraitorがDetectiveを始末すると、報酬としてクレジットを受け取る。"

L.tip6 = "Traitorが死亡すると、Detective全員は報酬としてクレジットを受け取る。"

L.tip7 = "Traitorは何人かのInnocentを始末すると、報酬としてクレジットを受け取る。"

L.tip8 = "TraitorとDetectiveは他のTraitorやDetectiveの死体から未使用クレジットを入手することができる。"

L.tip9 = "ポルターガイストは物を使用者の意志に関係なく暴れまわる。暴れているときには近くにいる者にダメージを与える衝撃波が生じる。"

L.tip10 = "TraitorとDetectiveは右上の赤いメッセージを見逃すな。そいつはけっこう重要だからな。"

L.tip11 = "TraitorとDetectiveは覚えておいてください, あなたはあなたと仲間がうまく働けば追加クレジットの報酬を与えられます. 必ずそのクレジットを使うのを忘れないでくださいね!"

L.tip12 = "DetectiveのDNA scannerは武器とアイテムからDNAサンプルを集めることができるようになり, そしてスキャンでそのプレイヤーの居場所を捕捉します. 死体や解除したC4からサンプルを入手できて便利ですよ!"

L.tip13 = "あなたが始末した相手の近くにいる時, あなたのDNAのいくつかは死体に残されています. そのDNAはDetectiveのDNA scannerであなたの居場所を見つけるのに使用されることがあります. ナイフで始末した後は死体を隠蔽すると良いでしょう!"

L.tip14 = "あなたが始末した相手から遠くに離れるにつれ, 死体に付着したあなたのDNAサンプルはより早く腐敗するでしょう."

L.tip15 = "あなたはTraitorで, スナイプしようとしていますか? Disguiserを試してみることを検討してください. もし外しても, 安全な場所に逃げ, Disguiserを解除すれば撃ったのがあなただと気付く者はいないでしょう."

L.tip16 = "Teleporterは追跡されている時にTraitorのあなたの逃走を手助けし, 大きなマップを素早く渡り歩くことができるようにします. 必ず常に安全な場所にマークしましょう."

L.tip17 = "Innocentが皆集まっていて孤立させるのは難しいですか? 何人かを引き離すためにRadioでC4の音か銃撃音の再生を試みることを検討してみてください."

L.tip18 = "TraitorがRadioを使用するには, Radioが置かれた後に装備メニューから音を再生することができます. 複数の音を再生したい場合はそこから複数のボタンをクリックして複数の音のキューを作ってください."

L.tip19 = "Detectiveは, もしクレジットが余っているのなら信頼できるInnocentにDefuserを渡してしまってもかまいません. そうすればあなたは調査の方に時間を費やし, 爆弾の解除からは離れることができます."

L.tip20 = "DetectiveのBinocularsは長距離を調べ死体の確認をできるようになります. 悪いお知らせはTraitorが死体を餌として使用したいと思っていた場合です. 当然, Binoculars使用中のDetectiveは無防備で注意散漫ですから..."

L.tip21 = "DetectiveのHealth Stationは負傷したプレイヤーを回復させます. もちろん, それらの負傷した人はTraitorかもしれないですけどね..."

L.tip22 = "Health Stationは使用した全員のDNAサンプルを記録します. DetectiveはDNA scannerでそれを使用して, 回復している人を知ることができます."

L.tip23 = "武器やC4と違い, Radioは置いたTraitorのDNAサンプルを含めません. Detectiveがそれを見つけて避難場所を吹き飛ばすことを心配する必要はありません."

L.tip24 = "{helpkey}を押すと短いチュートリアルの表示とTTTの詳細な設定を変更できます. 例えば, このTIPSを永久に非表示にもできます."

L.tip25 = "Detectiveが死体を調査すると, 結果はスコアボードで死亡した人の名前をクリックすることにより全てのプレイヤーが確認できます."

L.tip26 = "スコアボードの誰かの名前のすぐ近くの虫眼鏡アイコンはあなたがその人物の情報を調査したことを示しています. アイコンが明るければ, データはDetectiveからの追加の情報が含まれているかもしれません. "

L.tip27 = "Detectiveは, Detectiveによって調査されたニックネームの後ろの虫眼鏡の付いた死体とそれらの結果をスコアボードを通して全てのプレイヤーに示すことができます."

L.tip28 = "観戦者は{mutekey}を押すことで他の観戦者や生存者のミュートを切り替えることができます."

L.tip29 = "サーバーが追加の言語をインストールしている場合, 設定メニューからいつでも違う言語に切り替えることができます."

L.tip30 = "クイックチャットか'ラジオ'コマンドは{zoomkey}を押すことで使用できます."

L.tip31 = "観戦者は, {duckkey}を押すとマウスカーソルとこのTIPSパネルのボタンクリックを開放します. 再度{duckkey}を押すとマウスビューに戻ります."

L.tip32 = "Crowbarのセカンダリファイア(右クリック)は他のプレイヤーを押します."

L.tip33 = "武器のアイアンサイトを覗いて発砲することはわずかに精度を上昇させ, 反動を下げるでしょう. しゃがんでもそれらの効果はありません."

L.tip34 = "Smoke grenadeは屋内で効果的です, とりわけ人でいっぱいの部屋の中では混乱を招けるでしょうね."

L.tip35 = "Traitorは忘れないでください, あなたは死体を運ぶことでInnocentとDetectiveの詮索の目から彼らを隠すことができます."

L.tip36 = "{helpkey}で見ることのできるチュートリアルには最重要なキーの総覧が含まれています."

L.tip37 = "スコアボード上では, 生存しているプレイヤーの名前をクリックし, 彼らに'疑わしい'や'仲間'のようなタグを付けることができます. このタグは彼らに近づくとクロスヘアの下に表示されます."

L.tip38 = "(C4やRadioのような)置くことのできるアイテムの多くはセカンダリファイア(右クリック)で壁に固定することができます."

L.tip39 = "C4の解除失敗による爆発はタイマーがゼロに達したC4の爆発より小さいです."

L.tip40 = "ラウンドタイマーの上に'HASTE MODE'と書かれている場合, ラウンドは数分だけ早くなりますが, あらゆる死によって追加の時間を得られます(TF2のCPのように). このモードはTraitorに動き続けるようプレッシャーをかけます."


--- Round report

L.report_title = "ラウンドレポート"

-- Tabs
L.report_tab_hilite = "ハイライト"
L.report_tab_hilite_tip = "ラウンドハイライト"
L.report_tab_events = "イベント"
L.report_tab_events_tip = "このラウンドでのイベントの記録"
L.report_tab_scores = "スコア"
L.report_tab_scores_tip = "このラウンドのみの各プレイヤーのポイント"

-- Event log saving
L.report_save     = "セーブログ.txt"
L.report_save_tip = "テキストファイルにイベントログが保存された。"
L.report_save_error  = "保存するイベントログのデータがない。"
L.report_save_result = "イベントログのデータが保存された:"

-- Big title window
L.hilite_win_traitors = "Traitor陣営の勝利"
L.hilite_win_innocent = "Innocent陣営の勝利"

L.hilite_players1 = "{numplayers}人のプレイヤーが参加して、彼らの内{numtraitors}人がTraitorだった。"
L.hilite_players2 = "{numplayers}人のプレイヤーが参加して、彼らの内1人だけTraitorだった。"

L.hilite_duration = "ラウンドが終わるのに{time}秒かかった。"

-- Columns
L.col_time   = "時間"
L.col_event  = "イベント"
L.col_player = "プレイヤー"
L.col_role   = "役職"
L.col_kills1 = "キル数"
L.col_kills2 = "チームキル数"
L.col_points = "ポイント"
L.col_team = "チームボーナス"
L.col_total = "トータルポイント"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "何か"

-- Kill events
L.ev_blowup      = "{victim}は吹き飛んだ"
L.ev_blowup_trap = "{victim}は{trap}によって吹き飛ばされた"

L.ev_tele_self   = "{victim}は手榴弾で自爆した"
L.ev_sui         = "{victim}は何かを受け入れられず自殺した"
L.ev_sui_using   = "{victim}は{tool}を使用して自殺した"

L.ev_fall        = "{victim}は転落死した"
L.ev_fall_pushed = "{victim}は{attacker}に押されて転落死"
L.ev_fall_pushed_using = "{victim}は{attacker}に{trap}で押されて転落死"

L.ev_shot        = "{victim}は{attacker}に撃たれた"
L.ev_shot_using  = "{victim}は{attacker}に{weapon}で撃たれた"

L.ev_drown       = "{victim}は{attacker}によって溺死させられた"
L.ev_drown_using = "{victim}は{attacker}が{trap}を起動したことにより溺死させられた"

L.ev_boom        = "{victim}は{attacker}によって爆破された"
L.ev_boom_using  = "{victim}は{attacker}の使用した{trap}によって吹き飛ばされた"

L.ev_burn        = "{victim}は{attacker}によって焼かれた"
L.ev_burn_using  = "{victim}は{attacker}の仕組んだ{trap}により燃やされた"

L.ev_club        = "{victim}は{attacker}によって殴られた"
L.ev_club_using  = "{victim}は{attacker}の{trap}でしたたかに殴り殺された"

L.ev_slash       = "{victim}は{attacker}に刺された"
L.ev_slash_using = "{victim}は{attacker}に{trap}で切り刻まれた"

L.ev_tele        = "{victim}は{attacker}により手榴弾で爆殺された"
L.ev_tele_using  = "{victim}は{attacker}が仕掛けた{trap}により粉々にされた"

L.ev_goomba      = "{victim}は巨大な{attacker}により踏み潰された"

L.ev_crush       = "{victim}は{attacker}により押し潰された"
L.ev_crush_using = "{victim}は{attacker}の{trap}により押し潰された"

L.ev_other       = "{victim}は{attacker}により殺害された"
L.ev_other_using = "{victim}は{attacker}の使用した{trap}により殺害された"

-- Other events
L.ev_body        = "{finder}は{victim}の死体を見つけた"
L.ev_c4_plant    = "{player}はC4を設置した"
L.ev_c4_boom     = "{player}の設置したC4が爆発した"
L.ev_c4_disarm1  = "{player}は{owner}の設置したC4を解除した"
L.ev_c4_disarm2  = "{player}は{owner}の設置したC4の解除に失敗した"
L.ev_credit      = "{finder}は{player}の死体から{num}クレジットを見つけた"

L.ev_start       = "ラウンドを開始した"
L.ev_win_traitor = "卑劣なTraitor達がラウンドに勝利した！"
L.ev_win_inno    = "愛すべきInnocent達がラウンドに勝利した！"
L.ev_win_time    = "Traitor達は時間切れで敗北した！"

--- Awards/highlights

L.aw_sui1_title = "自殺カルトのリーダー"
L.aw_sui1_text  = "は最初の一歩を踏み出す者になることでどうすれば良いのかを他の自殺者達に示しました."

L.aw_sui2_title = "孤独と憂鬱"
L.aw_sui2_text  = "は唯一の自殺者でした."

L.aw_exp1_title = "爆発物研究証"
L.aw_exp1_text  = "は爆発物の研究が認められました. {num}人の被験者を助け出しましたからね."

L.aw_exp2_title = "フィールドリサーチ"
L.aw_exp2_text  = "は爆発への耐久力をテストしました. 耐久力は高くなかったようです."

L.aw_fst1_title = "まずは一匹"
L.aw_fst1_text  = "はTraitor達の手に最初のInnocentの死を届けました."

L.aw_fst2_title = "1人目は人違い"
L.aw_fst2_text  = "は仲間のTraitorを撃ったことでファーストキルを取りました. Good job."

L.aw_fst3_title = "初めの過ち"
L.aw_fst3_text  = "は殺害1番乗りでした. 残念ながら始末したのはInnocentの仲間でしたが."

L.aw_fst4_title = "最初の衝撃"
L.aw_fst4_text  = "が最初に始末したのがTraitorだったことでInnocentのテロリスト達に衝撃が走りました."

L.aw_all1_title = "真に危険な者"
L.aw_all1_text  = "はこのラウンドでInnocentによる全ての死を招きました."

L.aw_all2_title = "一匹狼"
L.aw_all2_text  = "はこのラウンドでTraitorによる全ての死を招きました."

L.aw_nkt1_title = "1人殺りましたよ, ボス!"
L.aw_nkt1_text  = "は首尾よく1人のInnocentを始末しました. 嬉しいですね!"

L.aw_nkt2_title = "凶弾は2人へ"
L.aw_nkt2_text  = "は他も始末することで最初の1人はラッキーショットではなかったことを示しました."

L.aw_nkt3_title = "シリアルトレイター"
L.aw_nkt3_text  = "は今日3人のInnocentのテロリズム人生を終わらせました."

L.aw_nkt4_title = "羊のような狼達の中の狼"
L.aw_nkt4_text  = "はディナーにInnocentのテロリスト達を食しました. ディナーは{num}コースでした."

L.aw_nkt5_title = "対テロ諜報員"
L.aw_nkt5_text  = "は始末する度に報酬を得ました. 今や豪華なヨットを買うことができます."

L.aw_nki1_title = "この裏切り者が"
L.aw_nki1_text  = "はTraitorを見つけました. Traitorを撃ちました. 簡単でしたね."

L.aw_nki2_title = "ジャスティススクワッドへの志願"
L.aw_nki2_text  = "は2名のTraitorを来世へとエスコートしました."

L.aw_nki3_title = "トレイターは裏切り羊の夢を見るか?"
L.aw_nki3_text  = "は3人のTraitorを寝かしつけました."

L.aw_nki4_title = "内務従業員"
L.aw_nki4_text  = "は始末する度に報酬を得ました.　今や5個目のスイミングプールを買うことができます."

L.aw_fal1_title = "いや, ボンドさん, 落ちてもらうだけだ."
L.aw_fal1_text  = "は高所から誰かを突き落としました."

L.aw_fal2_title = "おやすみなさい"
L.aw_fal2_text  = "は彼らの体をかなりの高度から落として床にヒットさせました."

L.aw_fal3_title = "人間隕石"
L.aw_fal3_text  = "は誰かを高所から落とすことによって潰しました."

L.aw_hed1_title = "効率的"
L.aw_hed1_text  = "はヘッドショットの楽しさを見出して{num}人始末しました."

L.aw_hed2_title = "神経学"
L.aw_hed2_text  = "はよく調べるため{num}人の頭から脳を取り除きました."

L.aw_hed3_title = "ビデオゲームの影響"
L.aw_hed3_text  = "は殺人鬼シミュレーショントレーニングに傾倒して{num}人の敵をヘッドショットしました."

L.aw_cbr1_title = "ドカッ バキッ ボカッ"
L.aw_cbr1_text  = "は{num}人の犠牲者に見つかった際にCrowbarを振ってみせました."

L.aw_cbr2_title = "バール好き"
L.aw_cbr2_text  = "は{num}人もの脳漿をバールに浴びせました."

L.aw_pst1_title = "根気強いちっちゃなやつ"
L.aw_pst1_text  = "はピストルで{num}キルを取りました. そして続いて死に至らしめるために抱きしめました."

L.aw_pst2_title = "小口径での殺戮"
L.aw_pst2_text  = "はピストルで{num}人の小規模な軍隊を始末しました. おそらくバレルの中に小さなショットガンを入れていたのでしょう."

L.aw_sgn1_title = "余裕だったな"
L.aw_sgn1_text  = "は負傷者にバックショット弾を命中させて, {num}人のターゲットを殺害しました."

L.aw_sgn2_title = "千の小弾"
L.aw_sgn2_text  = "はバックショット弾が大嫌いなので, 全部ばら撒きました. 受け取った{num}人は人生を楽しめませんでしたが."

L.aw_rfl1_title = "ポイントアンドクリック"
L.aw_rfl1_text  = "は{num}人を始末するにはライフルと安定した手が必要な全てだと示しました."

L.aw_rfl2_title = "頭, 見えてますよ"
L.aw_rfl2_text  = "はライフルを理解しています. 今, 他の{num}人もライフルを理解しました."

L.aw_dgl1_title = "小さなライフルみたいだね"
L.aw_dgl1_text  = "はデザートイーグルのコツを掴んで{num}人を始末しました."

L.aw_dgl2_title = "イーグルマスター"
L.aw_dgl2_text  = "はデザートイーグルで{num}人を消しました."

L.aw_mac1_title = "敬虔と殺人"
L.aw_mac1_text  = "はMAC10で{num}人を始末しましたが, どのくらいの弾を必要としたかは言わないでしょう."

L.aw_mac2_title = "マカロニ・アンド・チーズ"
L.aw_mac2_text  = "は2挺のMAC10を上手く扱うことができたらどうなるのか驚きました.　{num}回もを2挺で?"

L.aw_sip1_title = "お静かに"
L.aw_sip1_text  = "は消音ピストルで{num}人を黙らせました."

L.aw_sip2_title = "静寂のアサシン"
L.aw_sip2_text  = "は{num}人を自身の死を聞き取らせずに始末しました."

L.aw_knf1_title = "ナイフは知っている"
L.aw_knf1_text  = "はインターネット越しに面前の誰かを刺しました."

L.aw_knf2_title = "どこから手に入れたんだい?"
L.aw_knf2_text  = "はTraitorではありませんでしたが, それでも誰かをナイフで殺害しました."

L.aw_knf3_title = "とんでもないナイフ使い"
L.aw_knf3_text  = "は周囲に転がっている{num}本のナイフを見つけ, 活用しました."

L.aw_knf4_title = "世界一のナイフ使い"
L.aw_knf4_text  = "はナイフで{num}人を始末しました. どうやったのかは聞かないでください."

L.aw_flg1_title = "助けに行くよ"
L.aw_flg1_text  = "は{num}人の死の合図にフレアを使用しました."

L.aw_flg2_title = "フレアは炎へ"
L.aw_flg2_text  = "は{num}人の男に可燃性の衣服を着ることの危険性を教えました."

L.aw_hug1_title = "大きな拡散"
L.aw_hug1_text  = "はH.U.G.Eと1つになり, とにかくうまいこと{num}人に弾丸をヒットさせました."

L.aw_hug2_title = "忍耐強いパラ"
L.aw_hug2_text  = "はただただ撃ち続け, そしてH.U.G.Eの忍耐は{num}人の始末で報いるのを見ました."

L.aw_msx1_title = "バタバタバタ"
L.aw_msx1_text  = "はM16で{num}人排除しました."

L.aw_msx2_title = "ミドルレンジマッドネス"
L.aw_msx2_text  = "が{num}人キル取っているということはM16でのターゲットの仕留め方を知っていますね."

L.aw_tkl1_title = "驚かせよう"
L.aw_tkl1_text  = "はちょうど相棒の方を向いている時に指を滑ってしまったようだ。"

L.aw_tkl2_title = "2重の驚き"
L.aw_tkl2_text  = "は2回トレイターを始末したと思っていたが、2人とも違ったようだな。"

L.aw_tkl3_title = "カルマ重視"
L.aw_tkl3_text  = "はチームメイトを2人始末した後も止められませんでした. 3はラッキーナンバーですから."

L.aw_tkl4_title = "チームキラー"
L.aw_tkl4_text  = "はチーム全員を始末しました. BANしましょうよ!"

L.aw_tkl5_title = "ロールプレイヤー"
L.aw_tkl5_text  = "は狂人のロールプレイをしていました, 本当にね. それはなぜならチームの多くを始末したからです."

L.aw_tkl6_title = "ばか"
L.aw_tkl6_text  = "は彼らがどちら側かを理解できず、半数を超える仲間を始末した。"

L.aw_tkl7_title = "レッドネック"
L.aw_tkl7_text  = "はチームメイトの4分の1以上を始末したことで十分な縄張りを守った。"

L.aw_brn1_title = "おばあちゃんのお料理レシピ"
L.aw_brn1_text  = "は何人かを美味しそうなクリスプに料理してあげた。"

L.aw_brn2_title = "パイロイド"
L.aw_brn2_text  = "は燃えている多くの犠牲者の後ろで高笑いしているのを聞かれました."

L.aw_brn3_title = "ピュロスの焼却"
L.aw_brn3_text  = "は焼夷グレネードを使ったら全員を燃やしてやった！どうやって対処すればいいんだ！？"

L.aw_fnd1_title = "検死官"
L.aw_fnd1_text  = "は{num}人の転がっている死体を発見した。"

L.aw_fnd2_title = "めざせテロリストマスター"
L.aw_fnd2_text  = "はコレクションとして{num}人の死体を発見した。"

L.aw_fnd3_title = "死の芳香"
L.aw_fnd3_text  = "はこのラウンドで奇遇にも{num}人の死体を発見した。"

L.aw_crd1_title = "リサイクル屋"
L.aw_crd1_text  = "は死体から{num}個の未使用クレジットをあさった。"

L.aw_tod1_title = "ピュロスの勝利"
L.aw_tod1_text  = "はチームが勝利するたった数秒前に死亡した。"

L.aw_tod2_title = "クソゲー"
L.aw_tod2_text  = "はラウンド開始してすぐに死亡した。"


--- New and modified pieces of text are placed below this point, marked with the
--- version or the date in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Detectiveになるのを避ける"
L.set_avoid_det_tip = "これを有効にすると、サーバーができる限りDetectiveにさせないようにしてくれる。だからといってTraitorになりやすいとは限らないがな。"

--- v24
L.drop_no_ammo = "弾薬箱として捨てるのに武器に装填されている弾がないようだ。"

--- v31
L.set_cross_brightness = "クロスヘアの明るさ"
L.set_cross_size = "クロスヘアの大きさ"

--- 2015-05-25
L.hat_retrieve = "Detectiveの帽子を拾った。"

--- 2017-03-09
L.sb_sortby = "並び変え順:"

--- 2018-07-24
L.equip_tooltip_main = "装備品一覧"
L.equip_tooltip_radar = "レーダーメニュー"
L.equip_tooltip_disguise = "変装メニュー"
L.equip_tooltip_radio = "ラジオメニュー"
L.equip_tooltip_xfer = "クレジット譲渡"

L.confgrenade_name = "Discombobulator"
L.polter_name = "ポルターガイスト"
L.stungun_name = "UMP-プロトタイプ"

L.knife_instant = "斬殺"

L.dna_hud_type = "種類"
L.dna_hud_body = "死体"
L.dna_hud_item = "アイテム"

L.binoc_zoom_level = "拡大レベル"
L.binoc_body = "死体が検出された。"

L.idle_popup_title = "放置"
