---- Traditional Chinese language strings

local L = LANG.CreateLanguage("简体")

--- General text used in various places
L.traitor = "叛徒 "
L.detective = "探长 "
L.innocent = "无辜者 "
L.last_words = "遗言 "

L.terrorists = "恐怖分子 "
L.spectators = "旁观者 "

--- Round status messages
L.round_minplayers = "没有足够的玩家开始新的回合… "
L.round_voting = "投票进行中，新的回合延迟至{num} 秒后 "
L.round_begintime = "新回合将在{num} 秒后开始。请做好准备。 "
L.round_selected = "叛徒玩家已选出 "
L.round_started = "回合开始！ "
L.round_restart = "游戏被管理员强制重新开始。 "

L.round_traitors_one = "叛徒，你得自己顶住了。 "
L.round_traitors_more = "叛徒，你的队友是： {names} 。 "

L.win_time = "时间用尽，叛徒失败了。 "
L.win_traitor = "叛徒取得了胜利！ "
L.win_innocent = "叛徒们被击败了！ "
L.win_showreport = "一起观看观看{num} 秒的回合总结吧！ "

L.limit_round = "已达游戏回合上限，接着将读取进入{mapname} "
L.limit_time = "已达游戏时间上限，接着将读取进入{mapname} "
L.limit_vote = "游戏回合或时间已达上限。投票时间来啰！ "
L.limit_left = "在地图读取进入{mapname} 前，还有{num} 回合或者{time} 分钟的剩余时间。 "

--- Credit awards
L.credit_det_all = "探长，依据你的表现，将获得{num} 点购买余额。 "
L.credit_tr_all = "叛徒，依据你的表现，将获得{num} 点购买余额。 "

L.credit_kill = "你杀死{role} 而获得了{num} 点购买余额 "

--- Karma
L.karma_dmg_full = "你的业值为{amount} ，此回合你拥有造成百分之百伤害的待遇！ "
L.karma_dmg_other = "你的业值为{amount} ，因此本回合你造成的伤害将减少{num} % "

--- Body identification messages
L.body_found = " {finder} 发现了{victim} 的尸体。 {role} "

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t = "他是一位叛徒！ "
L.body_found_d = "他是一位探长。 "
L.body_found_i = "他是一位无辜者。 "

L.body_confirm = " {finder} 确认了{victim} 的死。 "

L.body_call = "{player}呼唤探长前来检查{victim} 的尸体！ "
L.body_call_error = "你必须确认该玩家的死，才能呼唤探长！ "

L.body_burning = "噢！这尸体着火了！ "
L.body_credits = "你在尸体上找到{num} 点购买余额！ "

--- Menus and windows
L.close = "关闭 "
L.cancel = "取消 "

-- For navigation buttons
L.next = "下一个 "
L.prev = "上一个 "

-- Equipment buying menu
L.equip_title = "装备 "
L.equip_tabtitle = "购买装备 "

L.equip_status = "购买选单 "
L.equip_cost = "你剩下{num} 个购买余额。 "
L.equip_help_cost = "你买的每一件装备都花费一点购买余额。 "

L.equip_help_carry = "你只能在拥有空位时购买物品。 "
L.equip_carry = "你能携带这件装备。 "
L.equip_carry_own = "你已拥有这件装备。 "
L.equip_carry_slot = "已拥有第{slot} 武器栏的武器。 "

L.equip_help_stock = "每回合你只能购买一件相同的物品。 "
L.equip_stock_deny = "这件物品不会再有库存。 "
L.equip_stock_ok = "这件物品已有库存。 "

L.equip_custom = "自订物品添加于伺服器中。 "

L.equip_spec_name = "名字 "
L.equip_spec_type = "类型 "
L.equip_spec_desc = "描述 "

L.equip_confirm = "购买装备 "

-- Disguiser tab in equipment menu
L.disg_name = "伪装物 "
L.disg_menutitle = "伪装控制器 "
L.disg_not_owned = "你无法持有伪装物！ "
L.disg_enable = "执行伪装 "

L.disg_help1 = "伪装开启后，别人瞄准你时，将不会看见你的名字，生命以及业值。除此之外，你也能躲避探长的雷达。 "
L.disg_help2 = "可直接在主选单外，使用数字键来切换伪装。你也可以用控制台指令绑定一个按键（ttt_toggle_disguise）。 "

-- 探测器 tab in equipment menu
L.radar_name = "雷达 "
L.radar_menutitle = "雷达控制器 "
L.radar_not_owned = "你未持有雷达！ "
L.radar_scan = "执行扫描 "
L.radar_auto = "自动重覆扫描 "
L.radar_help = "扫描结果将显示{num} 秒，接着雷达充电后你便可以再次使用。 "
L.radar_charging = "你的雷达尚在充电中！ "

-- Transfer tab in equipment menu
L.xfer_name = "传送器 "
L.xfer_menutitle = "传送余额 "
L.xfer_no_credits = "你没有传送余额了 "
L.xfer_send = "发送传送余额 "
L.xfer_help = "你只能转移传送余额给{role} 玩家。 "

L.xfer_no_recip = "接收者无效，传送余额转移失败。 "
L.xfer_no_credits = "传送余额不足，无法转移 "
L.xfer_success = "传送点数成功转移给{player} ！ "
L.xfer_received = " {player} 给予你{num} 点传送余额。 "

-- Radio tab in equipment menu
L.radio_name = "收音机 "
L.radio_help = "点击按钮，让收音机播放音乐。 "
L.radio_notplaced = "你必须放置收音机以播放音乐。 "

-- Radio soundboard buttons
L.radio_button_scream = "尖叫 "
L.radio_button_expl = "爆炸 "
L.radio_button_pistol = "手枪射击 "
L.radio_button_m16 = "M16步枪射击 "
L.radio_button_deagle = "沙漠之鹰射击 "
L.radio_button_mac10 = "MAC10冲锋枪射击 "
L.radio_button_shotgun = "散弹射击 "
L.radio_button_rifle = "狙击步枪射击 "
L.radio_button_huge = "M249机枪连发 "
L.radio_button_c4 = "C4哔哔声 "
L.radio_button_burn = "燃烧 "
L.radio_button_steps = "脚步声 "


-- Intro screen shown after joining
L.intro_help = "若你是游戏初学者，可按下F1查看游戏教学！ "

-- "Continue playing" vote
L.contvote_continue = "继续进行游戏 "
L.contvote_change = "发起投票 "

-- Radiocommands/quickchat
L.quick_title = "快速聊天按键 "

L.quick_yes = "是。 "
L.quick_no = "不是。 "
L.quick_help = "救命！ "
L.quick_imwith = "我和 {player} 在一起。 "
L.quick_see = "我看到了 {player} 。 "
L.quick_suspect = " {player} 行迹可疑。 "
L.quick_traitor = " {player} 是叛徒！ "
L.quick_inno = " {player} 是无辜者。 "
L.quick_check = "还有人活着吗？ "

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below. Keep these lowercase.
L.quick_nobody = "没有人 "
L.quick_disg = "有人伪装了 "
L.quick_corpse = "一具未搜索过的尸体 "
L.quick_corpse_id = " {player} 的尸体 "


--- Body search window
L.search_title = "尸体搜索结果 "
L.search_info = "讯息 "
L.search_confirm = "确认死亡 "
L.search_call = "呼叫探长 "

-- Descriptions of pieces of information found
L.search_nick = "这是 {player} 的尸体。 "

L.search_role_t = "这人是叛徒！ "
L.search_role_d = "这人是探长。 "
L.search_role_i = "这人是无辜的恐怖分子。 "

L.search_words = "某些事物让你了解到此人的遗言： {lastwords} "
L.search_armor = "他穿戴非标准装甲。 "
L.search_disg = "他持有一个能隐匿身份的设备 "
L.search_radar = "他持有像是雷达的物品。已经无法使用了。 "
L.search_c4 = "你在他口袋中找到了一本笔记。记载着线路{num} 是解除炸弹须剪除的一条。 "

L.search_dmg_crush = "他多处骨折。看起来是某种重物的冲击撞死了他。 "
L.search_dmg_bullet = "他很明显是被射杀身亡的。 "
L.search_dmg_fall = "他是坠落身亡的。 "
L.search_dmg_boom = "他的伤口以及烧焦的衣物，应是爆炸导致其死亡。 "
L.search_dmg_club = "他的身体有许多擦伤打击痕迹，明显是被殴打致死的。 "
L.search_dmg_drown = "他身上的蛛丝马迹显示是溺死的。 "
L.search_dmg_stab = "他是被刺击与挥砍后，迅速失血致死的。 "
L.search_dmg_burn = "闻起来有烧焦的恐怖分子在附近.. "
L.search_dmg_tele = "看起来他的DNA以超光速粒子之形式散乱在附近。 "
L.search_dmg_car = "他穿越马路时被一个粗心的驾驶碾死了。 "
L.search_dmg_other = "你无法找到这恐怖份子的具体死因。 "

L.search_weapon = "这显示死者是被{weapon} 所杀。 "
L.search_head = "最严重的伤口在头部。完全没机会叫喊。 "
L.search_time = "他大约死于你进行搜索的{time} 前。 "
L.search_dna = "用DNA扫描器检索凶手的DNA标本，DNA样本大约在{time} 前开始衰退。 "

L.search_kills1 = "你找到一个名单，记载着他发现的死者： {player} "
L.search_kills2 = "你找到了一个名单，记载着他杀的这些人: "
L.search_eyes = "通过你的探查技能，你确信他临死前见到的最后一个人： {player} 。是凶手，还是巧合？ ​​"


-- Scoreboard
L.sb_playing = "你正在玩的伺服是.. "
L.sb_mapchange = "地图将于{num} 个回合或是{time} 后更换 "

L.sb_mia = "下落不明 "
L.sb_confirmed = "确认死亡 "

L.sb_ping = "Ping "
L.sb_deaths = "死亡数 "
L.sb_score = "分数 "
L.sb_karma = "业值 "

L.sb_info_help = "搜索此玩家的尸体，可以获取一些线索。 "

L.sb_tag_friend = "可信任者 "
L.sb_tag_susp = "有嫌疑者 "
L.sb_tag_avoid = "应回避者 "
L.sb_tag_kill = "已死者 "
L.sb_tag_miss = "失踪者 "

--- Help and settings menu (F1)

L.help_title = "帮助与设定 "

-- Tabs
L.help_tut = "游戏教学 "
L.help_tut_tip = "游玩TTT的六步心法 "

L.help_settings = "设定 "
L.help_settings_tip = "客户端设定 "

-- Settings
L.set_title_gui = "介面设置 "

L.set_tips = "旁观时，在萤幕下方显示游戏提示 "

L.set_startpopup = "开局提示延迟 "
L.set_startpopup_tip = "当回合开始时，小提示将显示在萤幕下方一段时间，此参数可更改讯息的停留时间 "

L.set_cross_opacity = "准心透明度 "
L.set_cross_disable = "关闭准心 "
L.set_minimal_id = "只在准心下显示所对准之目标的ID（如业值，提示等） "
L.set_healthlabel = "在生命条旁显示健康状态（如受伤，接近死亡等） "
L.set_lowsights = "开启瞄准器时隐蔽武器 "
L.set_lowsights_tip = "开启瞄准器时隐蔽武器模组，这会让你更容易看见目标，但会减少游戏真实程度。 "
L.set_fastsw = "快速切换武器 "
L.set_fastsw_tip = "允许你直接用滑鼠滚轮切换武器（注：将不开启武器选单，直接取出）。 "
L.set_wswitch = "关闭武器切换自动关闭 "
L.set_wswitch_tip = "预设中，使用滑鼠滚轮切换武器时，停留数秒后会选择该被选中之武器并关闭。选此项将关闭预设。 "
L.set_cues = "在回合开始或结束时发出指示声音 "


L.set_title_play = "游戏设定 "

L.set_specmode = "旁观者模式（始终作为观察者） "
L.set_specmode_tip = "在你离开本模式前，新回合开始时你仍会以旁观者加入游戏。 "
L.set_mute = "死亡后不再听到活人的语音（仅作用于你） "
L.set_mute_tip = "当你是死者／旁观者时，将听不见活人的语音。 "


L.set_title_lang = "语言设定 "

L.set_lang = "选择语言： "


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock = "无法购买此武器：你已拥有它了。 "
L.buy_pending = "你已订购此物品，请等待配送。 "
L.buy_received = "你已收到此装备。 "

L.drop_no_room = "你没有足够空间存放新武器！ "

L.disg_turned_on = "伪装开启！ "
L.disg_turned_off = "伪装关闭。 "

-- Equipment item descriptions
L.item_passive = "被动效果型物品 "
L.item_active = "主动操作型物品 "
L.item_weapon = "武器 "

L.item_armor = "身体装甲 "
L.item_armor_desc = [[

拥有它，你将减少30%的射击伤害。

探长的预设装备。 ]]

L.item_radar = "雷达 "
L.item_radar_desc = [[

允许你扫描生命讯号。

一旦持有，它将自动扫描。
需要启用时，可在选单配置它]]

L.item_disg = "伪装 "
L.item_disg_desc = [[
启用时，你的ID将被隐藏；也可避免探长在
尸体上找到死者生前见到的最后一个人。

需要启用时：在选单里标记伪装选项，或是按下
相关数字键。 ]]

-- C4
L.c4_hint = "按下{usekey} 来装置或拆除C4。 "
L.c4_no_disarm = "在其他叛徒死前，你无法拆除他的C4。 "
L.c4_disarm_warn = "你所装置的C4已被拆除。 "
L.c4_armed = "C4装置成功。 "
L.c4_disarmed = "你成功拆除了C4。 "
L.c4_no_room = "你无法携带C4。 "

L.c4_desc = "C4爆炸！ "

L.c4_arm = "装置C4。 "
L.c4_arm_timer = "计时器 "
L.c4_arm_seconds = "引爆秒数： "
L.c4_arm_attempts = "拆除C4时，六条引线中有{num} 条会立即引发爆炸。 "

L.c4_remove_title = "移除 "
L.c4_remove_pickup = "捡起C4 "
L.c4_remove_destroy1 = "销毁C4 "
L.c4_remove_destroy2 = "确认：销毁 "

L.c4_disarm = "拆除C4 "
L.c4_disarm_cut = "点击以剪断{num} 号引线 "

L.c4_disarm_t = "剪断引线以拆除C4。你是叛徒，当然每条引线都是安全的，但其他人可就没那么容易了！ "
L.c4_disarm_owned = "剪断引线以拆除C4。你是装置此C4的人，细节了然于胸，任一条引线都可成功拆除。 "
L.c4_disarm_other = "剪断正确的引线以拆除C4。倘若你犯了错，后果将不堪设想唷！ "

L.c4_status_armed = "装置 "
L.c4_status_disarmed = "拆除 "

-- Visualizer
L.vis_name = "显像器 "
L.vis_hint = "按下{usekey} 键捡起它（仅限于侦探）。 "

L.vis_help_pri = " {primaryfire} 扔出已启动的仪器。 "

L.vis_desc = [[
可让犯罪现场显像化的仪器。

分析尸体，显像出死者被杀害时的情况，
但仅限于死者遭到射杀时。 ]]

-- Decoy
L.decoy_name = "雷达诱饵 "
L.decoy_no_room = "你无法携带雷达诱饵。 "
L.decoy_broken = "你的雷达诱饵已被摧毁！ "

L.decoy_help_pri = " {primaryfire} 装置了雷达诱饵 "


L.decoy_desc = [[
显示假的雷达信号给探长，

探长执行DNA扫描时，
将会显示雷达诱饵的位置作为代替。 ]]

-- Defuser
L.defuser_name = "拆弹器 "
L.defuser_help = " {primaryfire} 拆除目标炸弹。 "

L.defuser_desc = [[
迅速拆除一个C4。

不限制使用次数。若你持有此设备，
拆除C4时会轻松许多。 ]]

-- Flare gun
L.flare_name = "信号枪 "
L.flare_desc = [[
可用来烧毁尸体，使它们永远不会被发现。该武器有弹药限制
有弹药限制。

燃烧尸体时，会发出极度明显的声音。 ]]

-- Health station
L.hstation_name = "医疗站 "
L.hstation_hint = "按下{usekeu} 恢复健康。剩余存量： {num} "
L.hstation_broken = "你的医疗站已被摧毁！ "
L.hstation_help = " {primaryfire} 装置了一个医疗站。 "

L.hstation_desc = [[
设置后，允许人们前来治疗。

充能速度相当缓慢。
所有人都可以使用，且医疗站本身也会受损。
不仅如此，它亦可以检验每位使用者的DNA样本。 ]]

-- Knife
L.knife_name = "刀子 "
L.knife_thrown = "飞刀 "

L.knife_desc = [[
可以迅速、无声的杀死受伤的目标，但只能使用一次。

按下右键即可使用飞刀。 ]]

-- Poltergeist
L.polter_desc = [[
放置震动器在物体上，
使它们粗暴地四处乱跑、乱跳。

能量爆炸，
会使接近的人受到伤害。 ]]

-- Radio
L.radio_broken = "你的收音机已被摧毁！ "
L.radio_help_pri = " {primaryfire} 装置了收音机。 "

L.radio_desc = [[
播放音乐使人们分心、误导。

将收音机置于某处，
在选单使用收音机并播放音乐。 ]]


-- Silenced pistol
L.sipistol_name = "消音手枪 "

L.sipistol_desc = [[
噪音极小的手枪。
使用一般的手枪弹药。
被害者被射杀时不会喊叫。 ]]


-- Newton launcher
L.newton_name = "牛顿发射器 "

L.newton_desc = [[
推击一个人，以换取安全距离。
弹药无限，但射击间隔较长。 ]]


-- Binoculars
L.binoc_name = "双筒望远镜 "
L.binoc_desc = [[
拉近镜头，可远距离观察并确认尸体。

不限使用次数，但确认尸体时会更花时间。 ]]


L.binoc_help_pri = " {primaryfire} 确认尸体。 "
L.binoc_help_sec = " {secondaryfire} 改变望远镜的放大倍率。 "


-- UMP
L.ump_desc = [[
实验型冲锋枪，容易失去控制。

使用标准冲锋枪弹药。 ]]


-- DNA scanner
L.dna_name = "DNA扫描器 "
L.dna_identify = "检索尸体将能确认凶手身分。 "
L.dna_notfound = "目标上没有DNA样本。 "
L.dna_limit = "已达最大采集额度，新增前请先移除旧样本。 "
L.dna_decayed = "凶手的DNA样本发生衰变。 "
L.dna_killer = "成功采集到凶手的DNA样本！ "
L.dna_no_killer = "DNA样本无法检索（凶手已断线？） "
L.dna_armed = "炸弹已启动！赶紧拆除它！ "
L.dna_object = "在目标上采集到{num} 个新DNA样本。 "
L.dna_gone = "区域内没侦测到可采集之DNA样本。 "

L.dna_desc = [[
采集物体上的DNA样本，并用其找寻对应的主人。

使用在尸体上，采集杀手的DNA并追踪他。 ]]



L.dna_menu_title = "DNA扫描控制器 "
L.dna_menu_sample = "这是{source} 的DNA样本 "
L.dna_menu_remove = "移除所选样本 "
L.dna_menu_help1 = "这些是你采集的DNA样本 "
L.dna_menu_help2 = [[
充电完毕后，你可以选取之DNA样本，扫描其主人之准确位置。
找寻远距离的目标将消耗更多能量。 ]]


L.dna_menu_scan = "扫描 "
L.dna_menu_repeat = "自动重复 "
L.dna_menu_ready = "准备中. "
L.dna_menu_charge = "充电中 "
L.dna_menu_select = "选择样本 "

L.dna_help_primary = " {primaryfire} 来采集DNA样本 "
L.dna_help_secondary = " {secondaryfire} 来启动扫​​描控制器 "

-- Magneto stick
L.magnet_name = "电磁棍 "
L.magnet_help = " {primaryfire} 用于尸体以将之吸附。 "

-- Grenades and misc
L.grenade_smoke = "烟雾弹 "
L.grenade_fire = "燃烧弹 "

L.unarmed_name = "收起武器 "
L.crowbar_name = "铁撬 "
L.pistol_name = "手枪 "
L.rifle_name = "狙击枪 "
L.shotgun_name = "霰弹枪 "

-- Teleporter
L.tele_name = "传送装置 "
L.tele_failed = "传送失败 "
L.tele_marked = "传送地点已标记 "

L.tele_no_ground = "你必须站在地面上来才能进行传送！ "
L.tele_no_crouch = "蹲着的时候不能传送！ "
L.tele_no_mark = "请先标记传送地点，才能进行传送。 "

L.tele_no_mark_ground = "你必须站在地面上才能标记传送地点！ "
L.tele_no_mark_crouch = "你必须站起来才能标记传送点！ "

L.tele_help_pri = " {primaryfire} 传送到已标记之传送地点。 "
L.tele_help_sec = " {scondaryfire} 标记传送地点。 "

L.tele_desc = [[
可以传送到先前标记的地点。

传送器会产生噪音，而且使用次数是有限的。
]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm手枪弹药 "

L.ammo_smg1 = "冲锋枪弹药 "
L.ammo_buckshot = "散弹枪弹药 "
L.ammo_357 = "步枪弹药 "
L.ammo_alyxgun = "沙漠之鹰弹药 "
L.ammo_ar2altfire = "信号弹药 "
L.ammo_gravity = "捣蛋鬼弹药 "


--- HUD interface text

-- Round status
L.round_wait = "等待中 "
L.round_prep = "准备中 "
L.round_active = "游戏进行中 "
L.round_post = "回合结束 "

-- Health, ammo and time area
L.overtime = "延长时间 "
L.hastemode = "急速模式 "

-- TargetID health status
L.hp_healthy = "健康的 "
L.hp_hurt = "轻伤的 "
L.hp_wounded = "轻重伤的 "
L.hp_badwnd = "重伤的 "
L.hp_death = "近乎死亡 "


-- TargetID karma status
L.karma_max = "名声好 "
L.karma_high = "有点粗鲁 "
L.karma_med = "扣扳机爱好者 "
L.karma_low = "危险人物 "
L.karma_min = "负人命债累累 "

-- TargetID misc
L.corpse = "尸体 "
L.corpse_hint = "按下{usekey} 来搜索，用{walkkey} + {usekey} 进行无声搜索。 "

L.target_disg = " （伪装状态） "
L.target_unid = "未确认的尸体 "

L.target_traitor = "叛徒同伙 "
L.target_detective = "探长 "

L.target_credits = "搜索尸体以获取未被消耗的购买余额 "

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single = "单独使用 "
L.tbut_reuse = "重覆使用 "
L.tbut_retime = "在 {num} 秒后重覆使用 "
L.tbut_help = "按下 {key} 键启动 "

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud = "开始伪装，你的名字已隐藏。 "
L.radar_hud = "雷达将在{time} 后进行下一次扫描。 "

-- Spectator muting of living/dead
L.mute_living = "将生存的玩家设定静音 "
L.mute_specs = "将旁观者设定静音 "
L.mute_off = "取消静音 "

-- Spectators and prop possession
L.punch_title = "重击测量器" --"PUNCH-O-METER "
L.punch_help = "按下行走键或跳跃键以推撞物品；按蹲下键则离开物品控制。 "
L.punch_bonus = "你的分数较低，重击测量器上限减少{num} "
L.punch_malus = "你的分数较高，重击测量器上限增加{num} ！ "

L.spec_help = "点击以观察玩家，或按下{usekey} 来控制并持有物体。 "

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[
你是位无辜的恐怖分子！但你的周围存在着叛徒...
你能相信谁？谁又会乘你不备杀害你？
注意背后并与同伴合作，努力生存下来！ ]]

L.info_popup_detective = [[
你是位探长！恐怖分子总部给予你许多特殊资源以揪出叛徒。
用它们来确保无辜者的生命，但请小心：叛徒将优先杀害你！
按下 {menukey} 取得装备！ ]]


L.info_popup_traitor_alone = [[你是位叛徒！这回合中你没有同伴！

杀死所有其他玩家，以获得胜利！

按下 {menukey} 取得装备！ ]]

L.info_popup_traitor = [[
你是位叛徒！和其他叛徒合作杀害其他所有人，以获得胜利。
但请小心，你的身份可能会暴露...
你的同伴有:
{traitorlist}

按下{menukey}取得装备！ ]]

--- Various other text
L.name_kick = "一名玩家因于此回合中改变了名字而被自动踢出游戏。 "

L.idle_popup = [[你闲置了{num} 秒，所以被转往观察者模式。
当你位于此模式时，将不会在回合开始时重生。
你可在任何时间取消观察者模式，按下{helpkey} 并在选单取消勾选「观察者模式」即可。当然，你也可以选择立刻关闭它。 ]]

L.idle_popup_close = "什么也不做 "
L.idle_popup_off = "立刻关闭观察者模式 "

L.idle_warning = "警告：你已闲置一段时间，将转往观察者模式。活着就要动！ "

L.spec_mode_warning = "你位于观察者模式故将不会在回合开始时重生。若要关闭此模式，按下F1并取消勾选「观察者模式」即可。 "


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "提示 "
L.tips_panel_tip = "提示： "

-- Tip texts

L.tip1 = "叛徒不用确认其死亡即可悄悄检查尸体，只需对着尸体按着{walkkey} 键后再按{usekey} 键即可。 "

L.tip2 = "将C4爆炸时间设置更长，可增加引线数量，使拆弹者失败之可能性大幅上升，且能让C4的哔哔声更轻柔、更缓慢。 "

L.tip3 = "探长能在尸体查出谁是「死者最后看见的人」。若是遭到背后攻击，最后看见的将不会是凶手。 "

L.tip4 = "被你的尸体被发现并确认之前，没人知道你已经死亡。 "

L.tip5 = "叛徒杀死探长时，会立即得到一点购买余额。 "

L.tip6 = "一名叛徒死后，所以探长将得到一点购买余额作为奖励。 "

L.tip7 = "叛徒杀害无辜者，有了绝好进展时，所有叛徒将获得一点购买余额作为奖励。 "

L.tip8 = "叛徒和探长能从伙伴尸体上，取得未被消耗的购买余额。 "

L.tip9 = "捣蛋鬼将使物体变得极其危险。捣蛋鬼调整过的物体将产生爆炸能量伤害接近它的人。 "

L.tip10 = "叛徒与探长应保持注意萤幕右上方的红色讯息，这对你无比重要。 "

L.tip11 = "若叛徒与探长能和同伴配合得好，将拥有额外的购买余额。请将它用在对的地方！ "

L.tip12 = "探长的DNA扫描器可使用在武器或道具上，找到曾使用它的玩家的位置。用在尸体或C4上效果将更好！ "

L.tip13 = "太靠近你杀害的人的话，DNA将残留在尸体上，探长的DNA扫描器会以此找到你的正确位置。切记，杀了人最好将尸体藏好！ "

L.tip14 = "杀人时离被害者越远，残留在尸体上的DNA就会越快衰变！ "

L.tip15 = "你是叛徒而且想进行狙击？试试伪装吧！若你狙杀失准，逃到安全的地方，取消伪装，就没人知道是你开的枪啰！ "

L.tip16 = "作为叛徒，传送器可帮助你逃脱追踪，并让你得以迅速穿过整个地图。请随时确保有个安全的传送标记。 "

L.tip17 = "是否遇过无辜者群聚在一起而难以下手？请试试用收音机发出C4哔哔声或交火声，让他们分散。 "

L.tip18 = "叛徒可以在选单使用已放置的收音机，依序点击想播放的声音，就会按顺序排列播放。 "

L.tip19 = "探长若有多余的购买余额，可将拆弹器交给一位可信任的无辜者，将危险的C4交给他们，自己全神贯注地调查与处决叛徒。 "

L.tip20 = "探长的望远镜可让你远距离搜索并确认尸体，坏消息是叛徒总是会用诱饵欺骗你。当然，使用望远镜的探长全身都是破绽。 "

L.tip21 = "探长的医疗站可让受伤的玩家恢复健康，当然，其中也包括叛徒... "

L.tip22 = "治疗站将遗留每位前来治疗的人的DNA样本，探长可将其用在DNA扫描器上，寻找究竟谁曾受过治疗。 "

L.tip23 = "与武器、C4不同，收音机并不会留下你的DNA样本，不用担心探长会在上头用DNA识破你的身分。 "

L.tip24 = "按下{helpkey} 阅读教学或变更设定，比如说，你可以永远关掉现在所看到的提示唷～ "

L.tip25 = "探长确认尸体后，相关讯息将在计分板公布，如要查看只需点击死者之名字即可。. "

L.tip26 = "计分板上，人物名字旁的放大镜图样可以查看关于他的信息，若图样亮着，代表是某位探长确认后的结果。 "

L.tip27 = "探长调查尸体后的结果将公布在计分板，供所有玩家查看。 "

L.tip28 = "观察者可以按下{mutekey} 循环调整对其他观察者或游戏中的玩家静音。 "

L.tip29 = "若伺服器有安装其他语言，你可以在任何时间开启F1选单，启用不同语言。 "

L.tip30 = "若要使用语音或无线电，可以按下{zoomkey} 使用。 "

L.tip31 = "作为观察者，按下{duckkey} 能使视角固定，可在游戏内移动游标，也可以点击提示栏里的按钮。此外，再次按下{duckkey} 会解除之，恢复预设视角控制。 "

L.tip32 = "使用撬棍时，按下右键可推开其他玩家。 "

L.tip33 = "使用武器瞄准器射击将些微提升你的精准度，并降低后座力。蹲下则不会。 "

L.tip34 = "烟雾弹于室内相当有效，尤其是在拥挤的房间中制造混乱。 "

L.tip35 = "叛徒，请记住你能搬运尸体并将它们藏起来，避开无辜者与探长的耳目。 "

L.tip36 = "按下{helpkey} 可以观看教学，其中包含了重要的游戏关键。 "

L.tip37 = "在计分板上，点击活人玩家的名字，可以选择一个标记（如令人怀疑的或友好的）记录这位玩家。此标志会在你的准心指向该玩家时显示。 "

L.tip38 = "许多需放置的装备（如C4或收音机），可以使用右键将其置于墙上。 "

L.tip39 = "拆除C4时失误导致的爆炸，比起直接引爆时来得小。 "

L.tip40 = "若时间上显示「急速模式」，此回合的时间会很短，但每位玩家的死亡都将延长时间（就像TF2的占领点模式）。延长时间将迫使叛徒加紧脚步。 "


--- Round report

L.report_title = "回合报告 "

-- Tabs
L.report_tab_hilite = "重头戏 "
L.report_tab_hilite_tip = "回合重头戏 "
L.report_tab_events = "事件 "
L.report_tab_events_tip = "发生在此回合的指标性事件 "
L.report_tab_scores = "分数 "
L.report_tab_scores_tip = "本回合单一玩家获得的点数 "

-- Event log saving
L.report_save = "储存Log.txt "
L.report_save_tip = "将事件记录并储存在txt档内 "
L.report_save_error = "没有可供储存的事件记录 "
L.report_save_result = "事件记录已存在： "

-- Big title window
L.hilite_win_traitors = "叛徒获得胜利 "
L.hilite_win_innocent = "无辜者获得胜利 "

L.hilite_players1 = " {numplayers} 名玩家加入游戏， {numtraitors} 名玩家是叛徒 "
L.hilite_players2 = " {numplayers} 名玩家加入游戏，其中一人是叛徒 "

L.hilite_duration = "回合持续了 {time} "

-- Columns
L.col_time = "时间 "
L.col_event = "事件 "
L.col_player = "玩家 "
L.col_role = "角色 "
L.col_kills1 = "无辜者杀敌数 "
L.col_kills2 = "叛徒杀敌数 "
L.col_points = "点数 "
L.col_team = "团队红利 "
L.col_total = "总分 "

-- Name of a trap that killed us that has not been named by the mapper
L.something = "某事 "

-- Kill events
L.ev_blowup = "{victim} 被自己炸飞 "
L.ev_blowup_trap = "{victim} 被 {trap} 炸飞 "

L.ev_tele_self = "{victim} 被自己给传送杀了 "
L.ev_sui = "{victim} 不能拿取并杀死自己！ "
L.ev_sui_using = "{victim} 用{tool} 杀了自己 "

L.ev_fall = "{victim} 坠落而死 "
L.ev_fall_pushed = "{victim} 因为{attacker} 推下，坠落而死 "
L.ev_fall_pushed_using = "{victim} 被{attacker} 用{trap} 推下，坠落而死 "

L.ev_shot = "{victim} 被{attacker} 射杀 "
L.ev_shot_using = "{victim} 被{attacker} 用{weapon} 射杀 "

L.ev_drown = "{victim} 被{attacker} 推入水中溺死 "
L.ev_drown_using = "{victim} 被{attacker} 用{trap} 推入水中溺死 "

L.ev_boom = "{victim} 被{attacker} 炸死 "
L.ev_boom_using = "{victim} 被{attacker} 用{trap} 炸烂 "

L.ev_burn = "{victim} 被{attacker} 烧死 "
L.ev_burn_using = "{victim} 被{attacker} 用{trap} 烧成焦尸 "

L.ev_club = "{victim} 被{attacker} 打死 "
L.ev_club_using = "{victim} 被{attacker} 用{trap} 打成烂泥 "

L.ev_slash = "{victim} 被{attacker} 砍死 "
L.ev_slash_using = "{victim} 被{attacker} 用{trap} 砍成两半 "

L.ev_tele = "{victim} 被{attacker} 传送杀 "
L.ev_tele_using = "{victim} 被{attacker} 用{trap} 传送时之能量分裂成原子 "

L.ev_goomba = "{victim} 被{attacker} 用巨大物体压烂 "

L.ev_crush = "{victim} 被{attacker} 压烂 "
L.ev_crush_using = "{victim} 被{attacker} 用{trap} 压碎 "

L.ev_other = "{victim} 被{attacker} 杀死 "
L.ev_other_using = "{victim} 被{attacker} 用{trap} 杀死 "

-- Other events
L.ev_body = "{finder} 发现了{victim} 的尸体 "
L.ev_c4_plant = "{player} 安装了C4 "
L.ev_c4_boom = "{player} 安装的C4爆炸了 "
L.ev_c4_disarm1 = "{player} 拆除了{owner} 安装的C4 "
L.ev_c4_disarm2 = "{player} 因拆除失误而引爆了{owner} 安装的C4 "
L.ev_credit = "{finder} 在{player} 的尸体上找到{num} 点购买余额 "

L.ev_start = "游戏开始 "
L.ev_win_traitor = "叛徒成功完成了阴谋 "
L.ev_win_inno = "无辜者成功在这场危机中幸存 "
L.ev_win_time = "叛徒因超时而无法实现阴谋 "

--- Awards/highlights

L.aw_sui1_title = "自杀教团的团长 "
L.aw_sui1_text = "向其他自杀者展示如何自杀并率先实践。 "

L.aw_sui2_title = "孤独沮丧者 "
L.aw_sui2_text = "就他一人自杀，无比哀戚。 "

L.aw_exp1_title = "炸弹研究的第一把交椅 "
L.aw_exp1_text = "决心研究C4， {num} 名受试者证明了他的学说。 "

L.aw_exp2_title = "田野研究 "
L.aw_exp2_text = "在自家研究C4，威力完全不够。 "

L.aw_fst1_title = "第一滴血 "
L.aw_fst1_text = "将第一位无辜者的生命送到伙伴手边。 "

L.aw_fst2_title = "就爱黑色幽默 "
L.aw_fst2_text = "击杀一名叛徒同伴而得到第一杀，干得好啊！ "

L.aw_fst3_title = "首杀大挫折 "
L.aw_fst3_text = "第一杀便将无辜者同伴误认为叛徒，真是挫折啊！ "

L.aw_fst4_title = "吹响号角 "
L.aw_fst4_text = "杀害一名叛徒，为无辜者阵营吹响了号角。 "

L.aw_all1_title = "致命的平等 "
L.aw_all1_text = "得为所有人的死负责的无辜者。 "

L.aw_all2_title = "孤独之狼 "
L.aw_all2_text = "得为所有人的死负责的叛徒。 "

L.aw_nkt1_title = "老大！我抓到一个！ "
L.aw_nkt1_text = "在一名无辜者落单时策划一场谋杀，漂亮！ "

L.aw_nkt2_title = "一石二鸟 "
L.aw_nkt2_text = "用另一具尸体证明上一枪不是巧合。 "

L.aw_nkt3_title = "连续杀人魔 "
L.aw_nkt3_text = "在今天结束了三名无辜者的生命。 "

L.aw_nkt4_title = "穿梭在批着羊皮的狼之间的狼 "
L.aw_nkt4_text = "将无辜者们作为晚餐吃了。共吃了{num} 人。 "

L.aw_nkt5_title = "反恐特工 "
L.aw_nkt5_text = "每一杀都能拿到报酬，现在他已经买得起豪华游艇了！ "

L.aw_nki1_title = "背叛死亡吧！ "
L.aw_nki1_text = "找出叛徒，将子弹送到他脑袋，简单吧！ "

L.aw_nki2_title = "申请进入正义连队 "
L.aw_nki2_text = "成功将两名叛徒送下地狱。 "

L.aw_nki3_title = "叛徒梦到过叛徒羊吗？ "
L.aw_nki3_text = "让三名叛徒得到平静。 "

L.aw_nki4_title = "复仇者联盟 "
L.aw_nki4_text = "每一杀都能拿到报酬。你已经够格加入复仇者联盟了！ "

L.aw_fal1_title = "不，庞德先生，我希望你跳下去 "
L.aw_fal1_text = "将某人推下足以致死的高度。 "

L.aw_fal2_title = "地板人 "
L.aw_fal2_text = "使他的身体从极端无尽的高度上落地，打入地板成为地板人。 "

L.aw_fal3_title = "人体流星 "
L.aw_fal3_text = "'让一名玩家从高处落下，摔成烂泥。 "

L.aw_hed1_title = "高效能 "
L.aw_hed1_text = "发现爆头的乐趣，并击杀了{num} 名敌人。 "

L.aw_hed2_title = "脑神经科学 "
L.aw_hed2_text = "近距离将{num} 名玩家的脑袋取出，完成脑神经研究。 "

L.aw_hed3_title = "是游戏使我这么做的 "
L.aw_hed3_text = "应用他高超模仿的技巧，爆了{num} 颗头 "

L.aw_cbr1_title = "铿铿铿 "
L.aw_cbr1_text = "拥有相当规律的铁撬舞动， {num} 名受害者能证明这点。 "

L.aw_cbr2_title = "高登•弗里曼 "
L.aw_cbr2_text = "离开黑山，用喜爱的撬棍杀了至少{num} 名玩家。 "

L.aw_pst1_title = "死亡之握 "
L.aw_pst1_text = "用手枪杀死{num} 名玩家前，都上前握了手。 "

L.aw_pst2_title = "小口径屠杀 "
L.aw_pst2_text = "用手枪杀了{num} 人的小队。我们推测他枪管里头有个微型散弹枪。 "

L.aw_sgn1_title = "简单模式 "
L.aw_sgn1_text = "用霰弹枪近距离杀了{num} 名玩家。 "

L.aw_sgn2_title = "一千个小子弹 "
L.aw_sgn2_text = "不喜欢自己的散弹，打算送人。但已有{num} 名受赠人无法享受礼物了。 "

L.aw_rfl1_title = "瞄准，射击！ "
L.aw_rfl1_text = "稳定的手上，那把狙击枪夺去了{num} 名玩家的生命。 "

L.aw_rfl2_title = "我在这就看到你的头了啦！ "
L.aw_rfl2_text = "十分了解他的狙击枪，其他{num} 名玩家随即也了解了他的狙击枪。 "

L.aw_dgl1_title = "这简直像是小型狙击枪 "
L.aw_dgl1_text = "「沙鹰在手，天下我有！」，用沙漠之鹰杀了{num} 名玩家。 "

L.aw_dgl2_title = "老鹰大师 "
L.aw_dgl2_text = "用他手中的沙漠之鹰杀了{num} 名玩家。 "

L.aw_mac1_title = "祈祷，然后趴倒 "
L.aw_mac1_text = "用MAC10冲锋枪杀了{num} 名玩家，但别提他需要多少发子弹。 "

L.aw_mac2_title = "大麦克的起司 "
L.aw_mac2_text = "想知道他持有两把冲锋枪会发生什么事？那大概是{num} 杀的两倍啰？ "

L.aw_sip1_title = "黑人给我闭嘴！ "
L.aw_sip1_text = "用消声手枪射杀了{num} 人。 "

L.aw_sip2_title = "艾吉欧•奥狄托利 "
L.aw_sip2_text = "杀死{num} 个人，但没有任何人会听到它们的死前呢喃。见识刺客大师的风骨吧！ "

L.aw_knf1_title = "刀子懂你 "
L.aw_knf1_text = "在网路上用刀子捅人。 "

L.aw_knf2_title = "你从哪弄来的啊？ "
L.aw_knf2_text = "不是叛徒，但仍然用刀子杀了一些人。 "

L.aw_knf3_title = "开膛手杰克 "
L.aw_knf3_text = "在地上捡到{num} 把匕首，并使用它们。 "

L.aw_knf4_title = "我是赤尸藏人 "
L.aw_knf4_text = "通过刀子杀死了{num} 个人。我只是个医生。 "

L.aw_flg1_title = "玩火少年 "
L.aw_flg1_text = "用燃烧弹导致{num} 人死亡。 "

L.aw_flg2_title = "汽油加上番仔火 "
L.aw_flg2_text = "使{num} 名玩家葬身于火海。 "

L.aw_hug1_title = "子弹多喔！ "
L.aw_hug1_text = "用M249机枪将子弹送到{num} 名玩家身上。 "

L.aw_hug2_title = "耐心大叔 "
L.aw_hug2_text = "从未放下M249机枪的扳机，他杀戮了{num} 名玩家。 "

L.aw_msx1_title = "啪啪啪 "
L.aw_msx1_text = "用M16步枪射杀了{num} 名玩家。 "

L.aw_msx2_title = "中距离疯子 "
L.aw_msx2_text = "了解如何用他手中的M16，射杀了敌人。共有{num} 名不幸的亡魂。 "

L.aw_tkl1_title = "拍谢 "
L.aw_tkl1_text = "瞄准自己的队友，并不小心扣下扳机。 "

L.aw_tkl2_title = "拍谢拍谢 "
L.aw_tkl2_text = "认为自己抓到了两次叛徒，但两次都错了！ "

L.aw_tkl3_title = "小心业值！ "
L.aw_tkl3_text = "杀死两个同伴已不能满足他，三个才是他的最终目标！ "

L.aw_tkl4_title = "专业卖同队！ "
L.aw_tkl4_text = "杀了所有同伴，我的天啊！砰砰砰── "

L.aw_tkl5_title = "最佳主角 "
L.aw_tkl5_text = "扮演的是疯子，真的，因为他杀了大多数的同伴。 "

L.aw_tkl6_title = "莫非阁下是...低能儿？ "
L.aw_tkl6_text = "弄不清他属于哪一队，并杀死了半数以上的队友。 "

L.aw_tkl7_title = "园丁 "
L.aw_tkl7_text = "好好保护着自己的草坪，并杀死了四分之一以上的队友。 "

L.aw_brn1_title = "像小汝做菜一般 "
L.aw_brn1_text = "使用燃烧弹点燃数个玩家，将他们炸得很脆！ "

L.aw_brn2_title = "火化官 "
L.aw_brn2_text = "将每一具被他杀死的受害者尸体燃烧干净。 "

L.aw_brn3_title = "好想喷火！ "
L.aw_brn3_text = "「烧死你们！」，但地图上已没有燃烧弹了！因为都被他用完了。 "

L.aw_fnd1_title = "验尸官 "
L.aw_fnd1_text = "在地上发现{num} 具尸体。 "

L.aw_fnd2_title = "想全部看到！ "
L.aw_fnd2_text = "在地上发现了{num} 具尸体，做为收藏。 "

L.aw_fnd3_title = "死亡的气味 "
L.aw_fnd3_text = "在这回合被尸体绊到了{num} 次。 "

L.aw_crd1_title = "环保官 "
L.aw_crd1_text = "在同伴尸体上找到了{num} 点剩余的购买点。 "

L.aw_tod1_title = "没到手的胜利 "
L.aw_tod1_text = "在他的团队即将获得胜利的前几秒死去。 "

L.aw_tod2_title = "人家不依啦！ "
L.aw_tod2_text = "在这回合刚开始不久即被杀害。 "


--- New and modified pieces of text are placed below this point, marked with the
--- version in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det = "拒绝被选为探长 "
L.set_avoid_det_tip = "开启这个选项告诉服务器「不要把人家选成探长嘛！」。这不代表你有更高几率被选为叛徒。 "

--- v24
L.drop_no_ammo = "当武器快没子弹的时候，点击后将他丢掉并变成弹药包。 "

--- v31
L.set_cross_brightness = "准心亮度 "
L.set_cross_size = "准心尺寸 "
