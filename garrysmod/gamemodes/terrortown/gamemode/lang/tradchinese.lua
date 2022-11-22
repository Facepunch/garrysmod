---- Traditional Chinese language strings

local L = LANG.CreateLanguage("正體中文 ")

--- General text used in various places
L.traitor    = "叛徒"
L.detective  = "探長"
L.innocent   = "無辜者"
L.last_words = "遺言"

L.terrorists = "恐怖分子"
L.spectators = "旁觀者"

--- Round status messages
L.round_minplayers = "沒有足夠的玩家來開始新的回合…"
L.round_voting     = "投票進行中，新的回合將延遲到 {num} 秒後開始…"
L.round_begintime  = "新回合將在 {num} 秒後開始。請做好準備。"
L.round_selected   = "叛徒玩家已選出"
L.round_started    = "回合開始！"
L.round_restart    = "遊戲被管理員強制重新開始。"

L.round_traitors_one  = "叛徒，您得自己頂住了。"
L.round_traitors_more = "叛徒，您的隊友是： {names} 。"

L.win_time         = "時間用盡，叛徒失敗了。"
L.win_traitor      = "叛徒取得了勝利！"
L.win_innocent     = "叛徒們被擊敗了！"
L.win_showreport   = "一起觀看觀看 {num} 秒的回合總結吧！"

L.limit_round      = "已達遊戲回合上限，接著將載入地圖 {mapname}"
L.limit_time       = "已達遊戲時間上限，接著將載入地圖 {mapname}"
L.limit_left       = "在載入地圖 {mapname} 前，還有 {num} 回合或者 {time} 分鐘的剩餘時間。"

--- Credit awards
L.credit_det_all   = "探長，依據您的表現，將獲得 {num} 點的信用點數。"
L.credit_tr_all    = "叛徒，依據您的表現，將獲得 {num} 點的信用點數。"

L.credit_kill      = "您殺死 {role} 而獲得了 {num} 點的信用點數"

--- Karma
L.karma_dmg_full   = "您的業值為 {amount} ，因此本回合您擁有造成百分之百傷害的待遇！"
L.karma_dmg_other  = "您的業值為 {amount} ，因此本回合您造成的傷害將減少 {num} %"

--- Body identification messages
L.body_found       = " {finder} 發現了 {victim} 的屍體。 {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "他是一位叛徒！"
L.body_found_d     = "他是一位探長。"
L.body_found_i     = "他是一位無辜者。"

L.body_confirm     = "{finder} 確認了 {victim} 的死。"

L.body_call        = "{player} 呼喚探長前來檢查 {victim} 的屍體！"
L.body_call_error  = "您必須先確定該玩家的死，才能呼叫探長！"

L.body_burning     = "噢！ 這屍體著火了！"
L.body_credits     = "您在屍體上找到 {num} 點的信用點數！"

--- Menus and windows
L.close = "關閉"
L.cancel = "取消"

-- For navigation buttons
L.next = "下一個"
L.prev = "上一個"

-- Equipment buying menu
L.equip_title     = "裝備"
L.equip_tabtitle  = "購買裝備"

L.equip_status    = "購買選單"
L.equip_cost      = "您的信用點數剩下 {num} 點。"
L.equip_help_cost = "您買的每一件裝備都消耗 1 點的信用點數。"

L.equip_help_carry = "您只能在擁有空位時購買物品。"
L.equip_carry      = "您能攜帶這件裝備。"
L.equip_carry_own  = "您已擁有這件裝備。"
L.equip_carry_slot = "已擁有武器欄第 {slot} 項的武器。"

L.equip_help_stock = "每回合您只能購買一件相同的物品。"
L.equip_stock_deny = "這件物品不會再有庫存。"
L.equip_stock_ok   = "這件物品已有庫存。"

L.equip_custom     = "自訂物品新增於伺服器中。"

L.equip_spec_name  = "名字"
L.equip_spec_type  = "類型"
L.equip_spec_desc  = "描述"

L.equip_confirm    = "購買裝備"

-- Disguiser tab in equipment menu
L.disg_name      = "偽裝物"
L.disg_menutitle = "偽裝控制器"
L.disg_not_owned = "您無法持有偽裝物！"
L.disg_enable    = "執行偽裝"

L.disg_help1     = "偽裝開啟後，別人瞄準您時，將不會看見您的名字，生命以及業值。除此之外，您也能躲避探長的雷達。"
L.disg_help2     = "可直接在主選單外，使用數字鍵來切換偽裝。您也可以用控制台指令綁定一個按鍵（ttt_toggle_disguise）。"

-- Radar tab in equipment menu
L.radar_name      = "雷達"
L.radar_menutitle = "雷達控制器"
L.radar_not_owned = "您未持有雷達！"
L.radar_scan      = "執行掃描"
L.radar_auto      = "自動重複掃描"
L.radar_help      = "掃描結果將顯示 {num} 秒，接著雷達充電後您便可以再次使用。"
L.radar_charging  = "您的雷達尚在充電中！"

-- Transfer tab in equipment menu
L.xfer_name       = "傳送器"
L.xfer_menutitle  = "傳送餘額"
L.xfer_no_credits = "您沒有傳送餘額了"
L.xfer_send       = "發送傳送餘額"
L.xfer_help       = "您只能轉移傳送餘額給 {role} 玩家。"

L.xfer_no_recip   = "接收者無效，傳送餘額轉移失敗。"
L.xfer_no_credits = "傳送餘額不足，無法轉移"
L.xfer_success    = "傳送點數成功轉移給 {player} ！"
L.xfer_received   = " {player} 給予您 {num} 點傳送餘額。"

-- Radio tab in equipment menu
L.radio_name      = "收音機"
L.radio_help      = "點擊按鈕，讓收音機播放音樂。"
L.radio_notplaced = "您必須放置收音機以播放音樂。"

-- Radio soundboard buttons
L.radio_button_scream  = "尖叫"
L.radio_button_expl    = "爆炸"
L.radio_button_pistol  = "手槍射擊"
L.radio_button_m16     = "M16步槍射擊"
L.radio_button_deagle  = "沙漠之鷹射擊"
L.radio_button_mac10   = "MAC10衝鋒槍射擊"
L.radio_button_shotgun = "散彈射擊"
L.radio_button_rifle   = "狙擊步槍射擊"
L.radio_button_huge    = "M249機槍連發"
L.radio_button_c4      = "C4嗶嗶聲"
L.radio_button_burn    = "燃燒"
L.radio_button_steps   = "腳步聲"


-- Intro screen shown after joining
L.intro_help     = "若您是遊戲初學者，可按下F1查看遊戲教學！"

-- Radiocommands/quickchat
L.quick_title   = "快速聊天按鍵"

L.quick_yes     = "是。"
L.quick_no      = "不是。"
L.quick_help    = "救命！"
L.quick_imwith  = "我和 {player} 在一起。"
L.quick_see     = "我看到了 {player} 。"
L.quick_suspect = " {player} 行跡可疑。"
L.quick_traitor = " {player} 是叛徒！"
L.quick_inno    = " {player} 是無辜者。"
L.quick_check   = "還有人活著嗎？"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "沒有人"
L.quick_disg      = "有人偽裝了"
L.quick_corpse    = "一具未搜索過的屍體"
L.quick_corpse_id = " {player} 的屍體"


--- Body search window
L.search_title  = "屍體搜索結果"
L.search_info   = "訊息"
L.search_confirm = "確認死亡"
L.search_call   = "呼叫探長"

-- Descriptions of pieces of information found
L.search_nick   = "這是 {player} 的屍體。"

L.search_role_t = "這個人是叛徒！"
L.search_role_d = "這個人是探長。"
L.search_role_i = "這個人是無辜的恐怖分子。"

L.search_words  = "某些事物讓您了解到此人的遺言： {lastwords}"
L.search_armor  = "他穿戴非標準裝甲。"
L.search_disg   = "他持有一個能隱匿身份的設備"
L.search_radar  = "他持有像是雷達的物品。已經無法使用了。"
L.search_c4     = "您在他口袋中找到了一本筆記。記載著線路 {num} 是解除炸彈須剪除的一條。"

L.search_dmg_crush  = "他多處骨折。看起來是某種重物的衝擊撞死了他。"
L.search_dmg_bullet = "他很明顯是被射殺身亡的。"
L.search_dmg_fall   = "他是墜落身亡的。"
L.search_dmg_boom   = "他的傷口以及燒焦的衣物，應是爆炸導致其死亡。"
L.search_dmg_club   = "他的身體有許多擦傷打擊痕跡，明顯是被毆打致死的。"
L.search_dmg_drown  = "他身上的蛛絲馬跡顯示是溺死的。"
L.search_dmg_stab   = "他是被刺擊與揮砍後，迅速失血致死的。"
L.search_dmg_burn   = "聞起來有燒焦的恐怖分子在附近.."
L.search_dmg_tele   = "看起來他的DNA以超光速粒子之形式散亂在附近。"
L.search_dmg_car    = "他穿越馬路時被一個粗心的駕駛碾死了。"
L.search_dmg_other  = "您無法找到這恐怖份子的具體死因。"

L.search_weapon = "這顯示死者是被 {weapon} 所殺。"
L.search_head   = "最嚴重的傷口在頭部。完全沒機會叫喊。"
L.search_time   = "他大約死於您進行搜索的 {time} 前。"
L.search_dna    = "用DNA掃描器檢索兇手的DNA標本，DNA樣本大約在 {time} 前開始衰退。"

L.search_kills1 = "您找到一個名單，記載著他發現的死者： {player}"
L.search_kills2 = "您找到了一個名單，記載著他殺的這些人:"
L.search_eyes   = "透過您的探查技能，您確信他臨死前見到的最後一個人： {player} 。是兇手，還是巧合？"


-- Scoreboard
L.sb_playing    = "您正在玩的伺服是.."
L.sb_mapchange  = "地圖將於 {num} 個回合或是 {time} 後更換"

L.sb_mia        = "下落不明"
L.sb_confirmed  = "確認死亡"

L.sb_ping       = "Ping"
L.sb_deaths     = "死亡數"
L.sb_score      = "分數"
L.sb_karma      = "業值"

L.sb_info_help  = "搜索此玩家的屍體，可以獲取一些線索。"

L.sb_tag_friend = "可信任者"
L.sb_tag_susp   = "有嫌疑者"
L.sb_tag_avoid  = "應迴避者"
L.sb_tag_kill   = "已死者"
L.sb_tag_miss   = "失蹤者"

--- Help and settings menu (F1)

L.help_title = "幫助與設定"

-- Tabs
L.help_tut     = "遊戲教學"
L.help_tut_tip = "遊玩TTT的六步心法"

L.help_settings = "設定"
L.help_settings_tip = "客戶端設定"

-- Settings
L.set_title_gui = "介面設置"

L.set_tips      = "旁觀時，在螢幕下方顯示遊戲提示"

L.set_startpopup = "開局提示延遲"
L.set_startpopup_tip = "當回合開始時，小提示將顯示在螢幕下方一段時間，此參數可更改訊息的停留時間"

L.set_cross_opacity = "準心透明度"
L.set_cross_disable = "關閉準心"
L.set_minimal_id    = "只在準心下顯示所對準之目標的ID（如業值，提示等）"
L.set_healthlabel   = "在生命條旁顯示健康狀態（如受傷，接近死亡等）"
L.set_lowsights     = "開啟瞄準器時隱蔽武器"
L.set_lowsights_tip = "開啟瞄準器時隱蔽武器模組，這會讓您更容易看見目標，但會減少遊戲真實程度。"
L.set_fastsw        = "快速切換武器"
L.set_fastsw_tip    = "允許您直接用滑鼠滾輪切換武器（註：將不開啟武器選單，直接取出）。"
L.set_fastsw_menu     = "啟用快速切換武器選單"
L.set_fastswmenu_tip  = "當啟用快速武器切換功能，會出現彈出式切換選單。"
L.set_wswitch       = "關閉武器切換自動關閉"
L.set_wswitch_tip   = "預設中，使用滑鼠滾輪切換武器時，停留數秒後會選擇該被選中之武器並關閉。選此項將關閉預設。"
L.set_cues          = "在回合開始或結束時發出指示聲音"


L.set_title_play    = "遊戲設定"

L.set_specmode      = "旁觀者模式（始終作為觀察者 ）"
L.set_specmode_tip  = "在您離開本模式前，新回合開始時您仍會以旁觀者加入遊戲。"
L.set_mute          = "死亡後不再聽到活人的語音（僅作用於您）"
L.set_mute_tip      = "當您是死者／旁觀者時，將聽不見活人的語音。"


L.set_title_lang    = "語言設定"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "選擇語言 (Select language)："


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "無法購買此武器：您已擁有它了。"
L.buy_pending     = "您已訂購此物品，請等待配送。"
L.buy_received    = "您已收到此裝備。"

L.drop_no_room    = "您沒有足夠空間存放新武器！"

L.disg_turned_on  = "偽裝開啟！"
L.disg_turned_off = "偽裝關閉。"

-- Equipment item descriptions
L.item_passive    = "被動效果型物品"
L.item_active     = "主動操作型物品"
L.item_weapon     = "武器"

L.item_armor      = "身體裝甲"
L.item_armor_desc = [[
擁有它，
您將減少30%的射擊傷害。
探長的預設裝備。]]

L.item_radar      = "雷達"
L.item_radar_desc = [[
允許您掃描生命訊號。
一旦持有，它將自動掃描。
需要啟用時，可在選單設定它]]

L.item_disg       = "偽裝"
L.item_disg_desc  = [[
啟用時，您的ID將被隱藏；也可避免探長在
屍體上找到死者生前見到的最後一個人。

需要啟用時：在選單裡標記偽裝選項，或是按下
相關數字鍵。]]

-- C4
L.c4_hint         = "按下 {usekey} 來裝置或拆除C4。"
L.c4_no_disarm    = "在其他叛徒死前，您無法拆除他的C4。"
L.c4_disarm_warn  = "您所裝置的C4已被拆除。"
L.c4_armed        = "C4裝置成功。"
L.c4_disarmed     = "您成功拆除了C4。"
L.c4_no_room      = "您無法攜帶C4。"

L.c4_desc         = "C4爆炸！"

L.c4_arm          = "裝置C4。"
L.c4_arm_timer    = "計時器"
L.c4_arm_seconds  = "引爆秒數："
L.c4_arm_attempts = "拆除C4時，六條引線中有 {num} 條會立即引發爆炸。"

L.c4_remove_title    = "移除"
L.c4_remove_pickup   = "撿起C4"
L.c4_remove_destroy1 = "銷毀C4"
L.c4_remove_destroy2 = "確認：銷毀"

L.c4_disarm       = "拆除C4"
L.c4_disarm_cut   = "點擊以剪斷 {num} 號引線"

L.c4_disarm_t     = "剪斷引線以拆除C4。您是叛徒，當然每條引線都是安全的，但其他人可就沒那麼容易了！"
L.c4_disarm_owned = "剪斷引線以拆除C4。您是裝置此C4的人，細節瞭然於胸，任一條引線都可成功拆除。"
L.c4_disarm_other = "剪斷正確的引線以拆除C4。倘若您犯了錯，後果將不堪設想唷！"

L.c4_status_armed    = "裝置"
L.c4_status_disarmed = "拆除"

-- Visualizer
L.vis_name        = "顯像器"
L.vis_hint        = "按下 {usekey} 鍵撿起它（僅限於偵探）。"

L.vis_help_pri    = " {primaryfire} 扔出已啟動的儀器。"

L.vis_desc        = [[
可讓犯罪現場顯像化的儀器。

分析屍體，顯像出死者被殺害時的情況，
但僅限於死者遭到射殺時。]]

-- Decoy
L.decoy_name      = "雷達誘餌"
L.decoy_no_room   = "您無法攜帶雷達誘餌。"
L.decoy_broken    = "您的雷達誘餌已被摧毀！"

L.decoy_help_pri  = " {primaryfire} 裝置了雷達誘餌"


L.decoy_desc      = [[
顯示假的雷達信號給探長，

探長執行DNA掃描時，
將會顯示雷達誘餌的位置作為代替。]]

-- Defuser
L.defuser_name    = "拆彈器"
L.defuser_help    = " {primaryfire} 拆除目標炸彈。"

L.defuser_desc    = [[
迅速拆除一個C4。
不限制使用次數。若您持有此設備，
拆除C4時會輕鬆許多。]]

-- Flare gun
L.flare_name      = "信號槍"
L.flare_desc      = [[
可用來燒毀屍體，使它們永遠不會被發現。該武器有彈藥限制
有彈藥限制。
燃燒屍體時，會發出極度明顯的聲音。]]

-- Health station
L.hstation_name   = "醫療站"
L.hstation_hint   = "按下 {usekeu} 恢復健康。剩餘存量： {num}"
L.hstation_broken = "您的醫療站已被摧毀！"
L.hstation_help   = " {primaryfire} 裝置了一個醫療站。"

L.hstation_desc   = [[
設置後，允許人們前來治療。
恢復速度相當緩慢。
所有人都可以使用，且醫療站本身也會受損。
不僅如此，它亦可以檢驗每位使用者的DNA樣本。]]

-- Knife
L.knife_name      = "刀子"
L.knife_thrown    = "飛刀"

L.knife_desc      = [[
可以迅速、無聲的殺死受傷的目標，但只能使用一次。
按下右鍵即可使用飛刀。]]

-- Poltergeist
L.polter_desc     = [[
放置震動器在物體上，
使它們粗暴地四處亂跑、亂跳。
能量爆炸，
會使接近的人受到傷害。]]

-- Radio
L.radio_broken    = "您的收音機已被摧毀！"
L.radio_help_pri  = " {primaryfire} 裝置了收音機。"

L.radio_desc      = [[
播放音樂使人們分心、誤導。
將收音機置於某處，
在選單使用收音機並播放音樂。]]


-- Silenced pistol
L.sipistol_name   = "消音手槍"

L.sipistol_desc   = [[
噪音極小的手槍。
使用一般的手槍彈藥。
被害者被射殺時不會喊叫。]]


-- Newton launcher
L.newton_name     = "牛頓發射器"

L.newton_desc     = [[
推擊一個人，以換取安全距離。
彈藥無限，但射擊間隔較長。]]


-- Binoculars
L.binoc_name      = "雙筒望遠鏡"
L.binoc_desc      = [[
拉近鏡頭，可遠距離觀察並確認屍體。
不限使用次數，但確認屍體時會更花時間。]]

L.binoc_help_pri  = " {primaryfire} 確認屍體。"
L.binoc_help_sec  = " {secondaryfire} 改變望遠鏡的放大倍率。"


-- UMP
L.ump_desc        = [[
實驗型衝鋒槍，容易失去控制。
使用標準衝鋒槍彈藥。]]


-- DNA scanner
L.dna_name        = "DNA掃描器"
L.dna_identify    = "檢索屍體將能確認兇手身分。"
L.dna_notfound    = "目標上沒有DNA樣本。"
L.dna_limit       = "已達最大採集額度，新增前請先移除舊樣本。"
L.dna_decayed     = "兇手的DNA樣本發生衰變。"
L.dna_killer      = "成功採集到兇手的DNA樣本！"
L.dna_no_killer   = "DNA樣本無法檢索（兇手已斷線？）"
L.dna_armed       = "炸彈已啟動！趕緊拆除它！"
L.dna_object      = "在目標上採集到 {num} 個新DNA樣本。"
L.dna_gone        = "區域內沒偵測到可採集之DNA樣本。"

L.dna_desc        = [[
採集物體上的DNA樣本，並用其找尋對應的主人。

使用在屍體上，採集殺手的DNA並追蹤他。]]



L.dna_menu_title  = "DNA掃描控制器"
L.dna_menu_sample = "這是 {source} 的DNA樣本"
L.dna_menu_remove = "移除所選樣本"
L.dna_menu_help1  = "這些是您採集的DNA樣本"
L.dna_menu_help2  = [[
充電完畢後，您可以選取之DNA樣本，掃描其主人之準確位置。
找尋遠距離的目標將消耗更多能量。]]


L.dna_menu_scan   = "掃描"
L.dna_menu_repeat = "自動重複"
L.dna_menu_ready  = "準備中."
L.dna_menu_charge = "充電中"
L.dna_menu_select = "選擇樣本"

L.dna_help_primary   = " {primaryfire} 來採集DNA樣本"
L.dna_help_secondary = " {secondaryfire} 來啟動掃描控制器"

-- Magneto stick
L.magnet_name     = "電磁棍"
L.magnet_help     = " {primaryfire} 用於屍體以將之吸附。"

-- Grenades and misc
L.grenade_smoke   = "煙霧彈"
L.grenade_fire    = "燃燒彈"

L.unarmed_name    = "收起武器"
L.crowbar_name    = "鐵撬"
L.pistol_name     = "手槍"
L.rifle_name      = "狙擊槍"
L.shotgun_name    = "散彈槍"

-- Teleporter
L.tele_name       = "傳送裝置"
L.tele_failed     = "傳送失敗"
L.tele_marked     = "傳送地點已標記"

L.tele_no_ground  = "您必須站在地面上來才能進行傳送！"
L.tele_no_crouch  = "蹲著的時候不能傳送！"
L.tele_no_mark    = "請先標記傳送地點，才能進行傳送。"

L.tele_no_mark_ground = "您必須站在地面上才能標記傳送地點！"
L.tele_no_mark_crouch = "您必須站起來才能標記傳送點！"

L.tele_help_pri   = " {primaryfire} 傳送到已標記之傳送地點。"
L.tele_help_sec   = " {scondaryfire} 標記傳送地點。"

L.tele_desc       = [[
可以傳送到先前標記的地點。

傳送器會產生噪音，而且使用次數是有限的。
]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "9mm手槍彈藥"

L.ammo_smg1       = "衝鋒槍彈藥"
L.ammo_buckshot   = "散彈槍彈藥"
L.ammo_357        = "步槍彈藥"
L.ammo_alyxgun    = "沙漠之鷹彈藥"
L.ammo_ar2altfire = "信號彈藥"
L.ammo_gravity    = "搗蛋鬼彈藥"


--- HUD interface text

-- Round status
L.round_wait   = "等待中"
L.round_prep   = "準備中"
L.round_active = "遊戲進行中"
L.round_post   = "回合結束"

-- Health, ammo and time area
L.overtime     = "延長時間"
L.hastemode    = "急速模式"

-- TargetID health status
L.hp_healthy   = "健康的"
L.hp_hurt      = "輕傷的"
L.hp_wounded   = "輕重傷的"
L.hp_badwnd    = "重傷的"
L.hp_death     = "近乎死亡"


-- TargetID karma status
L.karma_max    = "名聲好"
L.karma_high   = "有點粗魯"
L.karma_med    = "扣扳機愛好者"
L.karma_low    = "危險人物"
L.karma_min    = "負人命債累累"

-- TargetID misc
L.corpse       = "屍體"
L.corpse_hint  = "按下 {usekey} 來搜索，用 {walkkey} + {usekey} 進行無聲搜索。"

L.target_disg  = " （偽裝狀態）"
L.target_unid  = "未確認的屍體"

L.target_traitor = "叛徒同夥"
L.target_detective = "探長"

L.target_credits = "搜索屍體以獲取未被消耗的信用點數"

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single  = "單獨使用"
L.tbut_reuse   = "重複使用"
L.tbut_retime  = "在 {num} 秒後重複使用"
L.tbut_help    = "按下 {key} 鍵啟動"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "開始偽裝，您的名字已隱藏。"
L.radar_hud    = "雷達將在 {time} 後進行下一次掃描。"

-- Spectator muting of living/dead
L.mute_living  = "將生存的玩家設定靜音"
L.mute_specs   = "將旁觀者設定靜音"
L.mute_all     = "全部靜音"
L.mute_off     = "取消靜音"

-- Spectators and prop possession
L.punch_title  = "重擊測量器 " --"PUNCH-O-METER"
L.punch_help   = "按下行走鍵或跳躍鍵以推撞物品；按蹲下鍵則離開物品控制。"
L.punch_bonus  = "您的分數較低，重擊測量器上限減少 {num}"
L.punch_malus  = "您的分數較高，重擊測量器上限增加 {num} ！"

L.spec_help    = "點擊以觀察玩家，或按下 {usekey} 來控制並持有物體。"

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[
您是位無辜的恐怖分子！但您的周圍存在著叛徒...
您能相信誰？誰又會乘您不備殺害您？
注意背後並與同伴合作，努力生存下來！]]

L.info_popup_detective = [[
您是位探長！恐怖分子總部給予您許多特殊資源以揪出叛徒。
用它們來確保無辜者的生命，但請小心：叛徒將優先殺害您！
按下 {menukey} 取得裝備！]]


L.info_popup_traitor_alone = [[您是位叛徒！這回合中您沒有同伴！

殺死所有其他玩家，以獲得勝利！

按下 {menukey} 取得裝備！]]

L.info_popup_traitor = [[
您是位叛徒！和其他叛徒合作殺害其他所有人，以獲得勝利。
但請小心，您的身份可能會暴露...
您的同伴有:
{traitorlist} 

按下{menukey}取得裝備！]]

--- Various other text
L.name_kick = "一名玩家因於此回合中改變了名字而被自動踢出遊戲。"

L.idle_popup = [[您閒置了 {num} 秒，所以被轉往觀察者模式。
當您位於此模式時，將不會在回合開始時重生。
您可在任何時間取消觀察者模式，按下 {helpkey} 並在選單取消勾選「觀察者模式」即可。當然，您也可以選擇立刻關閉它。]]

L.idle_popup_close = "什麼也不做"
L.idle_popup_off   = "立刻關閉觀察者模式"

L.idle_warning = "警告：您已閒置一段時間，將轉往觀察者模式。活著就要動！"

L.spec_mode_warning = "您位於觀察者模式故將不會在回合開始時重生。若要關閉此模式，按下F1並取消勾選「觀察者模式」即可。"


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "提示"
L.tips_panel_tip   = "提示："

-- Tip texts

L.tip1 = "叛徒不用確認其死亡即可悄悄檢查屍體，只需對著屍體按著 {walkkey} 鍵後再按 {usekey} 鍵即可。"

L.tip2 = "將C4爆炸時間設置更長，可增加引線數量，使拆彈者失敗之可能性大幅上升，且能讓C4的嗶嗶聲更輕柔、更緩慢。"

L.tip3 = "探長能在屍體查出誰是「死者最後看見的人」。若是遭到背後攻擊，最後看見的將不會是兇手。"

L.tip4 = "被您的屍體被發現並確認之前，沒人知道您已經死亡。"

L.tip5 = "叛徒殺死探長時，會立即得到一點的信用點數。"

L.tip6 = "一名叛徒死後，所以探長將得到一點的信用點數作為獎勵。"

L.tip7 = "叛徒殺害無辜者，有了絕好進展時，所有叛徒將獲得一點的信用點數作為獎勵。"

L.tip8 = "叛徒和探長能從夥伴屍體上，取得未被消耗的信用點數。"

L.tip9 = "搗蛋鬼將使物體變得極其危險。搗蛋鬼調整過的物體將產生爆炸能量傷害接近它的人。"

L.tip10 = "叛徒與探長應保持注意螢幕右上方的紅色訊息，這對您無比重要。"

L.tip11 = "若叛徒與探長能和同伴配合得好，將擁有額外的信用點數。請將它用在對的地方！"

L.tip12 = "探長的DNA掃描器可使用在武器或道具上，找到曾使用它的玩家的位置。用在屍體或C4上效果將更好！"

L.tip13 = "太靠近您殺害的人的話，DNA將殘留在屍體上，探長的DNA掃描器會以此找到您的正確位置。切記，殺了人最好將屍體藏好！"

L.tip14 = "殺人時離被害者越遠，殘留在屍體上的DNA就會越快衰變！"

L.tip15 = "您是叛徒而且想進行狙擊？試試偽裝吧！若您狙殺失準，逃到安全的地方，取消偽裝，就沒人知道是您開的槍囉！"

L.tip16 = "作為叛徒，傳送器可幫助您逃脫追蹤，並讓您得以迅速穿過整個地圖。請隨時確保有個安全的傳送標記。"

L.tip17 = "是否遇過無辜者群聚在一起而難以下手？請試試用收音機發出C4嗶嗶聲或交火聲，讓他們分散。"

L.tip18 = "叛徒可以在選單使用已放置的收音機，依序點擊想播放的聲音，就會按順序排列播放。"

L.tip19 = "探長若有多餘的信用點數，可將拆彈器交給一位可信任的無辜者，將危險的C4交給他們，自己全神貫注地調查與處決叛徒。"

L.tip20 = "探長的望遠鏡可讓您遠距離搜索並確認屍體，壞消息是叛徒總是會用誘餌欺騙您。當然，使用望遠鏡的探長全身都是破綻。"

L.tip21 = "探長的醫療站可讓受傷的玩家恢復健康，當然，其中也包括叛徒..."

L.tip22 = "治療站將遺留每位前來治療的人的DNA樣本，探長可將其用在DNA掃描器上，尋找究竟誰曾受過治療。"

L.tip23 = "與武器、C4不同，收音機並不會留下您的DNA樣本，不用擔心探長會在上頭用DNA識破您的身分。"

L.tip24 = "按下 {helpkey} 閱讀教學或變更設定，比如說，您可以永遠關掉現在所看到的提示唷～"

L.tip25 = "探長確認屍體後，相關訊息將在計分板公布，如要查看只需點擊死者之名字即可。."

L.tip26 = "計分板上，人物名字旁的放大鏡圖樣可以查看關於他的訊息，若圖樣亮著，代表是某位探長確認後的結果。"

L.tip27 = "探長調查屍體後的結果將公布在計分板，供所有玩家查看。"

L.tip28 = "觀察者可以按下 {mutekey} 循環調整對其他觀察者或遊戲中的玩家靜音。"

L.tip29 = "若伺服器有安裝其他語言，您可以在任何時間開啟F1選單，啟用不同語言。"

L.tip30 = "若要使用語音或無線電，可以按下 {zoomkey} 使用。"

L.tip31 = "作為觀察者，按下 {duckkey} 能使視角固定，可在遊戲內移動游標，也可以點擊提示欄裡的按鈕。此外，再次按下 {duckkey} 會解除之，恢復預設視角控制。"

L.tip32 = "使用撬棍時，按下右鍵可推開其他玩家。"

L.tip33 = "使用武器瞄準器射擊將些微提升您的精準度，並降低後座力。蹲下則不會。"

L.tip34 = "煙霧彈於室內相當有效，尤其是在擁擠的房間中製造混亂。"

L.tip35 = "叛徒，請記住您能搬運屍體並將它們藏起來，避開無辜者與探長的耳目。"

L.tip36 = "按下 {helpkey} 可以觀看教學，其中包含了重要的遊戲關鍵。"

L.tip37 = "在計分板上，點擊活人玩家的名字，可以選擇一個標記（如令人懷疑的或友好的）記錄這位玩家。此標誌會在您的準心指向該玩家時顯示。"

L.tip38 = "許多需放置的裝備（如C4或收音機），可以使用右鍵將其置於牆上。"

L.tip39 = "拆除C4時失誤導致的爆炸，比起直接引爆時來得小。"

L.tip40 = "若時間上顯示「急速模式」，此回合的時間會很短，但每位玩家的死亡都將延長時間（就像TF2的佔領點模式）。延長時間將迫使叛徒加緊腳步。"


--- Round report

L.report_title = "回合報告"

-- Tabs
L.report_tab_hilite = "重頭戲"
L.report_tab_hilite_tip = "回合重頭戲"
L.report_tab_events = "事件"
L.report_tab_events_tip = "發生在此回合的指標性事件"
L.report_tab_scores = "分數"
L.report_tab_scores_tip = "本回合單一玩家獲得的點數"

-- Event log saving
L.report_save     = "儲存 Log.txt"
L.report_save_tip = "將事件記錄並儲存在txt檔內"
L.report_save_error  = "沒有可供儲存的事件記錄"
L.report_save_result = "事件記錄已存在："

-- Big title window
L.hilite_win_traitors = "叛徒獲得勝利"
L.hilite_win_innocent = "無辜者獲得勝利"

L.hilite_players1 = " {numplayers} 名玩家加入遊戲， {numtraitors} 名玩家是叛徒"
L.hilite_players2 = " {numplayers} 名玩家加入遊戲，其中一人是叛徒"

L.hilite_duration = "回合持續了 {time}"

-- Columns
L.col_time   = "時間"
L.col_event  = "事件"
L.col_player = "玩家"
L.col_role   = "角色"
L.col_kills1 = "無辜者殺敵數"
L.col_kills2 = "叛徒殺敵數"
L.col_points = "點數"
L.col_team   = "團隊紅利"
L.col_total  = "總分"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "某件物品"

-- Kill events
L.ev_blowup      = "{victim} 被自己炸飛"
L.ev_blowup_trap = "{victim} 被 {trap} 炸飛"

L.ev_tele_self   = "{victim} 被自己給傳送殺了"
L.ev_sui         = "{victim} 不可取的自殺了！"
L.ev_sui_using   = "{victim} 用 {tool} 殺了自己"

L.ev_fall        = "{victim} 墜落而死"
L.ev_fall_pushed = "{victim} 因為 {attacker} 推下，墜落而死"
L.ev_fall_pushed_using = "{victim} 被 {attacker} 用 {trap} 推下，墜落而死"

L.ev_shot        = "{victim} 被 {attacker} 射殺"
L.ev_shot_using  = "{victim} 被 {attacker} 用 {weapon} 射殺"

L.ev_drown       = "{victim} 被 {attacker} 推入水中溺死"
L.ev_drown_using = "{victim} 被 {attacker} 用 {trap} 推入水中溺死"

L.ev_boom        = "{victim} 被 {attacker} 炸死"
L.ev_boom_using  = "{victim} 被 {attacker} 用 {trap} 炸爛"

L.ev_burn        = "{victim} 被 {attacker} 燒死"
L.ev_burn_using  = "{victim} 被 {attacker} 用 {trap} 燒成焦屍"

L.ev_club        = "{victim} 被 {attacker} 打死"
L.ev_club_using  = "{victim} 被 {attacker} 用 {trap} 打成爛泥"

L.ev_slash       = "{victim} 被 {attacker} 砍死"
L.ev_slash_using = "{victim} 被 {attacker} 用 {trap} 砍成兩半"

L.ev_tele        = "{victim} 被 {attacker} 傳送殺"
L.ev_tele_using  = "{victim} 被 {attacker} 用 {trap} 傳送時之能量分裂成原子"

L.ev_goomba      = "{victim} 被 {attacker} 用巨大物體壓爛"

L.ev_crush       = "{victim} 被 {attacker} 壓爛"
L.ev_crush_using = "{victim} 被 {attacker} 用 {trap} 壓碎"

L.ev_other       = "{victim} 被 {attacker} 殺死"
L.ev_other_using = "{victim} 被 {attacker} 用 {trap} 殺死"

-- Other events
L.ev_body        = "{finder} 發現了 {victim} 的屍體"
L.ev_c4_plant    = "{player}  安裝了C4"
L.ev_c4_boom     = "{player} 安裝的C4爆炸了"
L.ev_c4_disarm1  = "{player} 拆除了 {owner} 安裝的C4"
L.ev_c4_disarm2  = "{player} 因拆除失誤而引爆了 {owner} 安裝的C4"
L.ev_credit      = "{finder} 在 {player} 的屍體上找到 {num} 點的信用點數"

L.ev_start       = "回合開始"
L.ev_win_traitor = "卑鄙的叛徒贏了這回合！"
L.ev_win_inno    = "無辜的恐怖分子贏了這回合！"
L.ev_win_time    = "叛徒因為超過時間而輸了這回合！"

--- Awards/highlights

L.aw_sui1_title = "自殺邪教的教主"
L.aw_sui1_text  = "率先向其他自殺者展示如何自殺。"

L.aw_sui2_title = "孤獨沮喪者"
L.aw_sui2_text  = "就他一人自殺，無比哀戚。"

L.aw_exp1_title = "炸彈研究的第一把交椅"
L.aw_exp1_text  = "決心研究C4， {num} 名受試者證明了他的學說。"

L.aw_exp2_title = "田野研究"
L.aw_exp2_text  = "測試自己的抗暴性，顯然完全不夠高。"

L.aw_fst1_title = "第一滴血"
L.aw_fst1_text  = "將第一位無辜者的生命送到叛徒手上。"

L.aw_fst2_title = "愚蠢的血腥首殺"
L.aw_fst2_text  = "擊殺一名叛徒同伴而得到首殺，做得好啊！"

L.aw_fst3_title = "首殺大挫折"
L.aw_fst3_text  = "第一殺便將無辜者同伴誤認為叛徒，真是挫折啊！"

L.aw_fst4_title = "吹響號角"
L.aw_fst4_text  = "殺害一名叛徒，為無辜者陣營吹響了號角。"

L.aw_all1_title = "致命的平等"
L.aw_all1_text  = "得為所有人的死負責的無辜者。"

L.aw_all2_title = "孤獨之狼"
L.aw_all2_text  = "得為所有人的死負責的叛徒。"

L.aw_nkt1_title = "老大！我抓到一個！"
L.aw_nkt1_text  = "在一名無辜者落單時策劃一場謀殺，漂亮！"

L.aw_nkt2_title = "一石二鳥"
L.aw_nkt2_text  = "用另一具屍體證明上一槍不是巧合。"

L.aw_nkt3_title = "連續殺人魔"
L.aw_nkt3_text  = "在今天結束了三名無辜者的生命。"

L.aw_nkt4_title = "穿梭在批著羊皮的狼之間的狼"
L.aw_nkt4_text  = "將無辜者們作為晚餐吃了。共吃了 {num} 人。"

L.aw_nkt5_title = "反恐特工"
L.aw_nkt5_text  = "每一殺都能拿到報酬，現在他已經買得起豪華遊艇了！"

L.aw_nki1_title = "背叛死亡吧！"
L.aw_nki1_text  = "找出叛徒，將子彈送到他腦袋，簡單吧！"

L.aw_nki2_title = "申請進入正義連隊"
L.aw_nki2_text  = "成功將兩名叛徒送下地獄。"

L.aw_nki3_title = "叛徒夢到過叛徒羊嗎？"
L.aw_nki3_text  = "讓三名叛徒得到平靜。"

L.aw_nki4_title = "復仇者聯盟"
L.aw_nki4_text  = "每一殺都能拿到報酬。您已經夠格加入復仇者聯盟了！"

L.aw_fal1_title = "不，龐德先生，我希望您跳下去"
L.aw_fal1_text  = "將某人推下足以致死的高度。"

L.aw_fal2_title = "地板人"
L.aw_fal2_text  = "讓自己的身體從極端無盡的高度上落地。"

L.aw_fal3_title = "人體流星"
L.aw_fal3_text  = "讓一名玩家從高處落下，摔成爛泥。"

L.aw_hed1_title = "高效能"
L.aw_hed1_text  = "發現爆頭的樂趣，並擊殺了 {num} 名敵人。"

L.aw_hed2_title = "神經內科"
L.aw_hed2_text  = "近距離將 {num} 名玩家的腦袋取出，完成腦神經研究。"

L.aw_hed3_title = "是遊戲使我這麼做的"
L.aw_hed3_text  = "運用殺人模擬訓練的技巧，爆了 {num} 顆頭"

L.aw_cbr1_title = "鏗鏗鏗"
L.aw_cbr1_text  = "擁有相當規律的鐵撬舞動， {num} 名受害者能證明這點。"

L.aw_cbr2_title = "高登•弗里曼"
L.aw_cbr2_text  = "離開黑山，用喜愛的撬棍殺了至少 {num} 名玩家。"

L.aw_pst1_title = "死亡之握"
L.aw_pst1_text  = "用手槍殺死 {num} 名玩家前，都上前握了手。"

L.aw_pst2_title = "小口徑屠殺"
L.aw_pst2_text  = "用手槍殺了 {num} 人的小隊。我們推測他槍管裡頭有個微型散彈槍。"

L.aw_sgn1_title = "簡單模式"
L.aw_sgn1_text  = "用散彈槍近距離殺了 {num} 名玩家。"

L.aw_sgn2_title = "一千個小子彈"
L.aw_sgn2_text  = "不喜歡自己的散彈，打算送人。但已有 {num} 名受贈人無法享受禮物了。"

L.aw_rfl1_title = "瞄準，射擊！"
L.aw_rfl1_text  = "穩定的手上，那把狙擊槍奪去了 {num} 名玩家的生命。"

L.aw_rfl2_title = "我在這就看到您的頭了啦！"
L.aw_rfl2_text  = "十分瞭解他的狙擊槍，其他 {num} 名玩家隨即也瞭解了他的狙擊槍。"

L.aw_dgl1_title = "這簡直像是小型狙擊槍"
L.aw_dgl1_text  = "「沙鷹在手，天下我有！」，用沙漠之鷹殺了 {num} 名玩家。"

L.aw_dgl2_title = "老鷹大師"
L.aw_dgl2_text  = "用他手中的沙漠之鷹殺了 {num} 名玩家。"

L.aw_mac1_title = "祈禱，然後趴倒"
L.aw_mac1_text  = "用MAC10衝鋒槍殺了 {num} 名玩家，但別提他需要多少發子彈。"

L.aw_mac2_title = "大麥克的起司"
L.aw_mac2_text  = "想知道他持有兩把衝鋒槍會發生什麼事？那大概是 {num} 殺的兩倍囉？"

L.aw_sip1_title = "黑人給我閉嘴！"
L.aw_sip1_text  = "用消聲手槍射殺了 {num} 人。"

L.aw_sip2_title = "艾吉歐•奧狄托利"
L.aw_sip2_text  = "殺死 {num} 個人，但沒有任何人會聽到它們的死前呢喃。見識刺客大師的風骨吧！"

L.aw_knf1_title = "刀子懂您"
L.aw_knf1_text  = "在網路上用刀子捅人。"

L.aw_knf2_title = "您從哪弄來的啊？"
L.aw_knf2_text  = "不是叛徒，但仍然用刀子殺了一些人。"

L.aw_knf3_title = "開膛手傑克"
L.aw_knf3_text  = "在地上撿到 {num} 把匕首，並使用它們。"

L.aw_knf4_title = "我是赤屍藏人"
L.aw_knf4_text  = "通過刀子殺死了 {num} 個人。我只是個醫生。"

L.aw_flg1_title = "玩火少年"
L.aw_flg1_text  = "用燃燒彈導致 {num} 人死亡。"

L.aw_flg2_title = "汽油加上番仔火"
L.aw_flg2_text  = "使 {num} 名玩家葬身於火海。"

L.aw_hug1_title = "子彈多喔！"
L.aw_hug1_text  = "用M249機槍將子彈送到 {num} 名玩家身上。"

L.aw_hug2_title = "耐心大叔"
L.aw_hug2_text  = "從未放下M249機槍的扳機，他殺戮了 {num} 名玩家。"

L.aw_msx1_title = "啪啪啪"
L.aw_msx1_text  = "用M16步槍射殺了 {num} 名玩家。"

L.aw_msx2_title = "中距離瘋子"
L.aw_msx2_text  = "了解如何用他手中的M16，射殺了敵人。共有 {num} 名不幸的亡魂。"

L.aw_tkl1_title = "拍謝"
L.aw_tkl1_text  = "瞄準自己的隊友，並不小心扣下扳機。"

L.aw_tkl2_title = "拍謝拍謝"
L.aw_tkl2_text  = "認為自己抓到了兩次叛徒，但兩次都錯了！"

L.aw_tkl3_title = "小心業值！"
L.aw_tkl3_text  = "殺死兩個同伴已不能滿足他，三個才是他的最終目標！"

L.aw_tkl4_title = "專業賣同隊！"
L.aw_tkl4_text  = "殺了所有同伴，我的天啊！砰砰砰──"

L.aw_tkl5_title = "最佳主角"
L.aw_tkl5_text  = "扮演的是瘋子，真的，因為他殺了大多數的同伴。"

L.aw_tkl6_title = "莫非閣下是...低能兒？"
L.aw_tkl6_text  = "弄不清他屬於哪一隊，並殺死了半數以上的隊友。"

L.aw_tkl7_title = "園丁"
L.aw_tkl7_text  = "好好保護著自己的草坪，並殺死了四分之一以上的隊友。"

L.aw_brn1_title = "像小汝做菜一般"
L.aw_brn1_text  = "使用燃燒彈點燃數個玩家，將他們炸得很脆！"

L.aw_brn2_title = "火化官"
L.aw_brn2_text  = "將每一具被他殺死的受害者屍體燃燒乾淨。"

L.aw_brn3_title = "好想噴火！"
L.aw_brn3_text  = "「燒死您們！」，但地圖上已沒有燃燒彈了！因為都被他用完了。"

L.aw_fnd1_title = "驗屍官"
L.aw_fnd1_text  = "在地上發現 {num} 具屍體。"

L.aw_fnd2_title = "想全部看到！"
L.aw_fnd2_text  = "在地上發現了 {num} 具屍體，做為收藏。"

L.aw_fnd3_title = "死亡的氣味"
L.aw_fnd3_text  = "在這回合被屍體絆到了 {num} 次。"

L.aw_crd1_title = "環保官"
L.aw_crd1_text  = "在同伴屍體上找到了 {num} 點剩餘的購買點。"

L.aw_tod1_title = "沒到手的勝利"
L.aw_tod1_text  = "在他的團隊即將獲得勝利的前幾秒死去。"

L.aw_tod2_title = "人家不依啦！"
L.aw_tod2_text  = "在這回合剛開始不久即被殺害。"


--- New and modified pieces of text are placed below this point, marked with the
--- version or the date in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "拒絕被選為探長"
L.set_avoid_det_tip = "開啟這個選項告訴伺服器「不要把人家選成探長嘛！」。這不代表您有更高機率被選為叛徒。"

--- v24
L.drop_no_ammo = "當武器快沒子彈的時候，點擊後將他丟掉並變成彈藥包。"

--- v31
L.set_cross_brightness = "準心亮度"
L.set_cross_size = "準心尺寸"

--- 2015-05-25
L.hat_retrieve = "您撿起了一頂探長的帽子。"
