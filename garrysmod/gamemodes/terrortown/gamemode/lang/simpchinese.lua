---- Simplified Chinese language strings

local L = LANG.CreateLanguage("简体中文")

--- General text used in various places
L.traitor    = "叛徒"
L.detective  = "探长"
L.innocent   = "无辜者"
L.last_words = "遗言"

L.terrorists = "恐怖分子"
L.spectators = "观察者"

--- Round status messages
L.round_minplayers = "没有足够的玩家来开始新的回合…"
L.round_voting     = "投票进行中，新的回合将推迟到 {num} 秒后开始…"
L.round_begintime  = "新回合将在 {num} 秒后开始。请做好准备。"
L.round_selected   = "叛徒玩家已选出"
L.round_started    = "回合开始！"
L.round_restart    = "游戏被管理员强制重新开始。"

L.round_traitors_one  = "叛徒，你将孤身奋斗。"
L.round_traitors_more = "叛徒，你的队友是： {names} 。"

L.win_time         = "时间用尽，叛徒失败了。"
L.win_traitor      = "叛徒取得了胜利！"
L.win_innocent     = "叛徒们被击败了！"
L.win_showreport   = "来看一下 {num} 秒的回合总结吧！"

L.limit_round      = "已达游戏回合上限，即将载入地图 {mapname}"
L.limit_time       = "已达游戏时间上限，即将载入地图 {mapname}"
L.limit_left       = "在载入地图 {mapname} 前，还有 {num} 回合或者 {time} 分钟的剩余时间。"

--- Credit awards
L.credit_det_all   = "探长，你的表现让你获得了 {num} 积分。"
L.credit_tr_all    = "叛徒，你的表现让你获得了 {num} 积分。"

L.credit_kill      = "你杀死 {role} 获得了 {num} 点的积分"

--- Karma
L.karma_dmg_full   = "你的人品为 {amount} ，因此本回合你将造成正常伤害。"
L.karma_dmg_other  = "你的人品为 {amount} ，因此本回合你造成的伤害将减少 {num} %"

--- Body identification messages
L.body_found       = " {finder} 发现了 {victim} 的尸体。 {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "他是一位叛徒！"
L.body_found_d     = "他是一位探长。"
L.body_found_i     = "他是一位无辜者。"

L.body_confirm     = "{finder} 确认了 {victim} 的死亡。"

L.body_call        = "{player} 请求探长前来检查 {victim} 的尸体！"
L.body_call_error  = "你必须先确定该玩家的死才能呼叫探长！"

L.body_burning     = "好烫！这个尸体着火了！"
L.body_credits     = "你在尸体上找到 {num} 积分！"

--- Menus and windows
L.close = "关闭"
L.cancel = "取消"

-- For navigation buttons
L.next = "下一个"
L.prev = "上一个"

-- Equipment buying menu
L.equip_title     = "装备"
L.equip_tabtitle  = "购买装备"

L.equip_status    = "购买选单"
L.equip_cost      = "你的积分剩下 {num} 点。"
L.equip_help_cost = "每一件装备都需要花费 1 点积分。"

L.equip_help_carry = "你只能在拥有空位时购买物品。"
L.equip_carry      = "你能携带这件装备。"
L.equip_carry_own  = "你已拥有这件装备。"
L.equip_carry_slot = "已拥有武器栏第 {slot} 项的武器。"

L.equip_help_stock = "每回合你只能购买一件相同的物品。"
L.equip_stock_deny = "这件物品卖空了。"
L.equip_stock_ok   = "这件物品有库存。"

L.equip_custom     = "服务器的自定义物品。"

L.equip_spec_name  = "名字"
L.equip_spec_type  = "类型"
L.equip_spec_desc  = "描述"

L.equip_confirm    = "购买装备"

-- Disguiser tab in equipment menu
L.disg_name      = "伪装器"
L.disg_menutitle = "伪装器控制"
L.disg_not_owned = "你没有伪装器！"
L.disg_enable    = "执行伪装"

L.disg_help1     = "伪装开启后，别人瞄准你时将不会看见你的名字，生命以及人品。除此之外，你也能躲避探长的雷达。"
L.disg_help2     = "可直接在主选单外，使用数字键来切换伪装。你也可以用控制台指令绑定指令 ttt_toggle_disguise。"

-- Radar tab in equipment menu
L.radar_name      = "雷达"
L.radar_menutitle = "雷达控制"
L.radar_not_owned = "你没有雷达！"
L.radar_scan      = "执行扫描"
L.radar_auto      = "自动重复扫描"
L.radar_help      = "扫描结果将显示 {num} 秒，接着雷达充电后你便可以再次使用。"
L.radar_charging  = "你的雷达还在充电中！"

-- Transfer tab in equipment menu
L.xfer_name       = "转移"
L.xfer_menutitle  = "转移积分"
L.xfer_no_credits = "你没有积分了"
L.xfer_send       = "发送积分"
L.xfer_help       = "你只能发送积分给 {role} 玩家。"

L.xfer_no_recip   = "接收者无效，发送失败。"
L.xfer_no_credits = "积分不足，无法转移"
L.xfer_success    = "成功向 {player} 发送积分！"
L.xfer_received   = "{player} 给予你 {num} 积分。"

-- Radio tab in equipment menu
L.radio_name      = "收音机"
L.radio_help      = "点击按钮，让收音机播放音效。"
L.radio_notplaced = "你必须放置收音机以播放音效。"

-- Radio soundboard buttons
L.radio_button_scream  = "尖叫"
L.radio_button_expl    = "爆炸"
L.radio_button_pistol  = "手枪射击"
L.radio_button_m16     = "M16步枪射击"
L.radio_button_deagle  = "沙漠之鹰射击"
L.radio_button_mac10   = "MAC10冲锋枪射击"
L.radio_button_shotgun = "霰弹射击"
L.radio_button_rifle   = "狙击步枪射击"
L.radio_button_huge    = "M249机枪连发"
L.radio_button_c4      = "C4哔哔声"
L.radio_button_burn    = "燃烧"
L.radio_button_steps   = "脚步声"


-- Intro screen shown after joining
L.intro_help     = "若你是游戏初学者，可按下F1查看游戏教学！"

-- Radiocommands/quickchat
L.quick_title   = "快速聊天按键"

L.quick_yes     = "是。"
L.quick_no      = "不是。"
L.quick_help    = "救命！"
L.quick_imwith  = "我和 {player} 在一起。"
L.quick_see     = "我看到了 {player} 。"
L.quick_suspect = " {player} 行迹可疑。"
L.quick_traitor = " {player} 是叛徒！"
L.quick_inno    = " {player} 是无辜者。"
L.quick_check   = "还有人活着吗？"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody    = "没有人"
L.quick_disg      = "伪装着的人"
L.quick_corpse    = "一具未搜索过的尸体"
L.quick_corpse_id = " {player} 的尸体"


--- Body search window
L.search_title  = "尸体搜索结果"
L.search_info   = "信息"
L.search_confirm = "确认死亡"
L.search_call   = "呼叫探长"

-- Descriptions of pieces of information found
L.search_nick   = "这是 {player} 的尸体。"

L.search_role_t = "这个人是叛徒！"
L.search_role_d = "这个人是探长。"
L.search_role_i = "这个人是无辜的恐怖分子。"

L.search_words  = "直觉告诉你这个人的遗言： {lastwords}"
L.search_armor  = "他穿着非标准装甲。"
L.search_disg   = "他持有一个能隐匿身份的设备"
L.search_radar  = "他持有像是雷达的物品，已经无法使用了。"
L.search_c4     = "你在他口袋中找到了一本笔记。记载着第 {num} 根线才能解除炸弹。"

L.search_dmg_crush  = "他多处骨折。看起来是某种重物的冲击撞死了他。"
L.search_dmg_bullet = "他很明显是被射杀身亡的。"
L.search_dmg_fall   = "他是坠落身亡的。"
L.search_dmg_boom   = "他的伤口以及烧焦的衣物，应是爆炸导致其死亡。"
L.search_dmg_club   = "他的身体有许多擦伤打击痕迹，明显是被殴打致死的。"
L.search_dmg_drown  = "他身上的蛛丝马迹显示是溺死的。"
L.search_dmg_stab   = "他是被刺击与挥砍后，迅速失血致死的。"
L.search_dmg_burn   = "闻起来像烧焦的恐怖分子.."
L.search_dmg_tele   = "看起来他的DNA以超光速粒子之形式散乱在附近。"
L.search_dmg_car    = "他穿越马路时被一个粗心的驾驶碾死了。"
L.search_dmg_other  = "你无法找到这恐怖份子的具体死因。"

L.search_weapon = "死者是被 {weapon} 所杀。"
L.search_head   = "最后一击打在头上。完全没机会叫喊。"
L.search_time   = "他大约死于你进行搜索的 {time} 前。"
L.search_dna    = "用DNA扫描器检索凶手的DNA标本，DNA样本大约在 {time} 前开始衰退。"

L.search_kills1 = "你找到一个名单，记载着他发现的死者： {player}"
L.search_kills2 = "你找到了一个名单，记载着他杀的这些人:"
L.search_eyes   = "透过你的探查技能，你确信他临死前见到的最后一个人是 {player} 。凶手，还是巧合？"


-- Scoreboard
L.sb_playing    = "你正在玩的伺服是.."
L.sb_mapchange  = "地图将于 {num} 个回合或是 {time} 后更换"

L.sb_mia        = "下落不明"
L.sb_confirmed  = "确认死亡"

L.sb_ping       = "延迟"
L.sb_deaths     = "死亡数"
L.sb_score      = "分数"
L.sb_karma      = "人品"

L.sb_info_help  = "搜索此玩家的尸体，可以获取一些线索。"

L.sb_tag_friend = "可信"
L.sb_tag_susp   = "可疑"
L.sb_tag_avoid  = "躲避"
L.sb_tag_kill   = "死亡"
L.sb_tag_miss   = "失踪"

--- Help and settings menu (F1)

L.help_title = "帮助与设定"

-- Tabs
L.help_tut     = "游戏教学"
L.help_tut_tip = "游玩TTT的六步教程"

L.help_settings = "设定"
L.help_settings_tip = "客户端设定"

-- Settings
L.set_title_gui = "界面设置"

L.set_tips      = "旁观时，在屏幕下方显示游戏提示"

L.set_startpopup = "开局提示延迟"
L.set_startpopup_tip = "当回合开始时，提示将在屏幕下方显示一段时间，此参数可更改信息的停留时间"

L.set_cross_opacity = "准心透明度"
L.set_cross_disable = "关闭准心"
L.set_minimal_id    = "只在准心下显示所对准目标的ID（如人品，提示等）"
L.set_healthlabel   = "在生命条旁显示健康状态（如受伤，接近死亡等）"
L.set_lowsights     = "开启瞄准器时隐蔽武器"
L.set_lowsights_tip = "开启瞄准器时隐蔽武器模组，这会让你更容易看见目标。"
L.set_fastsw        = "快速切换武器"
L.set_fastsw_tip    = "允许你直接用滑鼠滚轮切换武器（注：将不开启武器选单，直接取出）。"
L.set_fastsw_menu     = "启用快速切换武器选单"
L.set_fastswmenu_tip  = "当启用快速武器切换功能，会出现弹出式切换选单。"
L.set_wswitch       = "关闭武器切换自动关闭"
L.set_wswitch_tip   = "默认设定下使用滑鼠滚轮切换武器时，停留数秒后会选择当前武器并关闭。这个选项开启后不会自动关闭。"
L.set_cues          = "在回合开始或结束时发出提示音"


L.set_title_play    = "游戏设定"

L.set_specmode      = "观察者模式（始终作为观察者）"
L.set_specmode_tip  = "在你离开本模式前，新回合开始时你仍会以观察者加入游戏。"
L.set_mute          = "死亡后不再听到活人的语音（仅作用于你）"
L.set_mute_tip      = "当你是死者／观察者时，将听不见活人的语音。"


L.set_title_lang    = "语言设定"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "选择语言 (Select language)："


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock    = "无法购买此武器：你已拥有它了。"
L.buy_pending     = "你已订购此物品，请等待配送。"
L.buy_received    = "你已收到此装备。"

L.drop_no_room    = "你没有足够空间存放新武器！"

L.disg_turned_on  = "伪装开启！"
L.disg_turned_off = "伪装关闭。"

-- Equipment item descriptions
L.item_passive    = "被动效果型物品"
L.item_active     = "主动操作型物品"
L.item_weapon     = "武器"

L.item_armor      = "护甲"
L.item_armor_desc = [[
抵抗收到子弹伤害的30%。

探长的自带装备。]]

L.item_radar      = "雷达"
L.item_radar_desc = [[
允许你扫描存活着的玩家。

一旦持有，雷达会开始自动扫描。
使用该页面的雷达菜单来设置。]]

L.item_disg       = "伪装"
L.item_disg_desc  = [[
启用时，你的ID将被隐藏；也可避免探长在
尸体上找到死者生前见到的最后一个人。

需要启用时，使用本页面的伪装菜单
或按下小键盘回车键。]]

-- C4
L.c4_hint         = "按下 {usekey} 来安放或拆除C4。"
L.c4_no_disarm    = "在其他叛徒死前，你无法拆除他的C4。"
L.c4_disarm_warn  = "你所安放的C4已被拆除。"
L.c4_armed        = "C4安放成功。"
L.c4_disarmed     = "你成功拆除了C4。"
L.c4_no_room      = "你无法携带C4。"

L.c4_desc         = "C4爆炸！"

L.c4_arm          = "安放C4。"
L.c4_arm_timer    = "计时器"
L.c4_arm_seconds  = "引爆秒数："
L.c4_arm_attempts = "拆除C4时，六条引线中有 {num} 条会立即引发爆炸。"

L.c4_remove_title    = "移除"
L.c4_remove_pickup   = "捡起C4"
L.c4_remove_destroy1 = "销毁C4"
L.c4_remove_destroy2 = "确认：销毁"

L.c4_disarm       = "拆除C4"
L.c4_disarm_cut   = "点击以剪断 {num} 号引线"

L.c4_disarm_t     = "剪断引线以拆除C4。你是叛徒，因此每条引线都是安全的，但其他人可就没那么容易了！"
L.c4_disarm_owned = "剪断引线以拆除C4。你是安放此C4的人，所以任何引线都能成功拆除。"
L.c4_disarm_other = "剪断正确的引线以拆除C4。如果你剪错的话，后果不堪设想！"

L.c4_status_armed    = "安放"
L.c4_status_disarmed = "拆除"

-- Visualizer
L.vis_name        = "显像器"
L.vis_hint        = "按下 {usekey} 键捡起它（仅限侦探）。"

L.vis_help_pri    = " {primaryfire} 扔出已启动的仪器。"

L.vis_desc        = [[
可让犯罪现场显像化的仪器。
分析尸体，显出死者被杀害时的情况，
但仅限于死者被枪杀时。]]

-- Decoy
L.decoy_name      = "雷达诱饵"
L.decoy_no_room   = "你无法携带雷达诱饵。"
L.decoy_broken    = "你的雷达诱饵已被摧毁！"

L.decoy_help_pri  = " {primaryfire} 安放了雷达诱饵"


L.decoy_desc      = [[
显示假的雷达信号给探长，
探长执行DNA扫描时，
将会显示雷达诱饵的位置作为代替。]]

-- Defuser
L.defuser_name    = "拆弹器"
L.defuser_help    = " {primaryfire} 拆除目标炸弹。"

L.defuser_desc    = [[
迅速拆除一个C4。
不限制使用次数。若你持有此设备，
拆除C4时会轻松许多。]]

-- Flare gun
L.flare_name      = "信号枪"
L.flare_desc      = [[
可用来烧毁尸体，使它们永远不会被发现。
该武器有有弹药限制。

燃烧尸体会发出十分明显的声音。]]

-- Health station
L.hstation_name   = "医疗站"
L.hstation_hint   = "按下 {usekeu} 恢复健康。剩馀存量： {num}"
L.hstation_broken = "你的医疗站已被摧毁！"
L.hstation_help   = " {primaryfire} 安放了一个医疗站。"

L.hstation_desc   = [[
安放后，允许人们用其治疗自己。

充能速度相当缓慢。
所有人都可以使用，而且医疗站可以受到伤害。
每位使用者会留下可采集的DNA样本。]]

-- Knife
L.knife_name      = "刀子"
L.knife_thrown    = "飞刀"

L.knife_desc      = [[
可以迅速、无声的杀死受伤的目标，但只能使用一次。

按下右键即可使用飞刀。]]

-- Poltergeist
L.polter_desc     = [[
放置震动器在物体上，
使它们危险地四处飞动。

能量爆炸会使附近的人受到伤害。]]

-- Radio
L.radio_broken    = "你的收音机已被摧毁！"
L.radio_help_pri  = " {primaryfire} 安放了收音机。"

L.radio_desc      = [[
播放音效来误导或欺骗玩家。

将收音机安放下来，
然后用该页面的收音机菜单播放。]]


-- Silenced pistol
L.sipistol_name   = "消音手枪"

L.sipistol_desc   = [[
噪音极小的手枪。使用普通手枪弹药。

被害者被射杀时不会喊叫。]]


-- Newton launcher
L.newton_name     = "牛顿发射器"

L.newton_desc     = [[
在安全的距离推他人。

弹药无限，但射击间隔较长。]]


-- Binoculars
L.binoc_name      = "双筒望远镜"
L.binoc_desc      = [[
可以放大并远距离确认尸体。

不限使用次数，但确认尸体需要一些时间。]]

L.binoc_help_pri  = " {primaryfire} 确认尸体。"
L.binoc_help_sec  = " {secondaryfire} 改变放大倍率。"


-- UMP
L.ump_desc        = [[
实验型冲锋枪，能阻扰目标视角。

使用普通冲锋枪弹药。]]


-- DNA scanner
L.dna_name        = "DNA扫描器"
L.dna_identify    = "检索尸体将能确认凶手身分。"
L.dna_notfound    = "目标上没有DNA样本。"
L.dna_limit       = "已达最大采集额度，请先移除旧样本。"
L.dna_decayed     = "凶手的DNA样本已经消失。"
L.dna_killer      = "成功采集到凶手的DNA样本！"
L.dna_no_killer   = "DNA样本无法检索（凶手已离线？）"
L.dna_armed       = "炸弹已启动！赶紧拆除它！"
L.dna_object      = "在目标上采集到 {num} 个新DNA样本。"
L.dna_gone        = "区域内没侦测到可采集之DNA样本。"

L.dna_desc        = [[
采集物体上的DNA样本，并用其找寻对应的主人。
使用在尸体上，采集杀手的DNA并追踪他。]]



L.dna_menu_title  = "DNA扫描控制器"
L.dna_menu_sample = "这是 {source} 的DNA样本"
L.dna_menu_remove = "移除所选样本"
L.dna_menu_help1  = "这些是你采集的DNA样本"
L.dna_menu_help2  = [[
充电完毕后，你可以选取之DNA样本，扫描其主人的准确位置。
远距离目标将消耗更多能量。]]


L.dna_menu_scan   = "扫描"
L.dna_menu_repeat = "自动重复"
L.dna_menu_ready  = "准备中."
L.dna_menu_charge = "充电中"
L.dna_menu_select = "选择样本"

L.dna_help_primary   = " {primaryfire} 来采集DNA样本"
L.dna_help_secondary = " {secondaryfire} 来启动扫描控制器"

-- Magneto stick
L.magnet_name     = "电磁棍"
L.magnet_help     = " {primaryfire} 用于尸体以将之吸附。"

-- Grenades and misc
L.grenade_smoke   = "烟雾弹"
L.grenade_fire    = "燃烧弹"

L.unarmed_name    = "收起武器"
L.crowbar_name    = "撬棍"
L.pistol_name     = "手枪"
L.rifle_name      = "狙击枪"
L.shotgun_name    = "霰弹枪"

-- Teleporter
L.tele_name       = "传送安放"
L.tele_failed     = "传送失败"
L.tele_marked     = "传送地点已标记"

L.tele_no_ground  = "你必须站在地面上来才能进行传送！"
L.tele_no_crouch  = "蹲着的时候不能传送！"
L.tele_no_mark    = "请先标记传送地点，才能进行传送。"

L.tele_no_mark_ground = "你必须站在地面上才能标记传送地点！"
L.tele_no_mark_crouch = "你必须站起来才能标记传送点！"

L.tele_help_pri   = " {primaryfire} 传送到已标记的传送地点。"
L.tele_help_sec   = " {scondaryfire} 标记传送地点。"

L.tele_desc       = [[
可以传送到先前标记的地点。
传送器会产生噪音，而且使用次数是有限的。
]]

-- Ammo names, shown when picked up
L.ammo_pistol     = "手枪弹药"

L.ammo_smg1       = "冲锋枪弹药"
L.ammo_buckshot   = "霰弹枪弹药"
L.ammo_357        = "步枪弹药"
L.ammo_alyxgun    = "沙漠之鹰弹药"
L.ammo_ar2altfire = "信号弹药"
L.ammo_gravity    = "促狭鬼弹药"


--- HUD interface text

-- Round status
L.round_wait   = "等待中"
L.round_prep   = "准备中"
L.round_active = "游戏进行中"
L.round_post   = "回合结束"

-- Health, ammo and time area
L.overtime     = "延长时间"
L.hastemode    = "急速模式"

-- TargetID health status
L.hp_healthy   = "健康"
L.hp_hurt      = "轻伤"
L.hp_wounded   = "受伤"
L.hp_badwnd    = "重伤"
L.hp_death     = "濒死"


-- TargetID karma status
L.karma_max    = "良好"
L.karma_high   = "粗鲁"
L.karma_med    = "不可靠"
L.karma_low    = "危险人物"
L.karma_min    = "滥杀者"

-- TargetID misc
L.corpse       = "尸体"
L.corpse_hint  = "按下 {usekey} 来搜索，用 {walkkey} + {usekey} 进行无声搜索。"

L.target_disg  = " （伪装状态）"
L.target_unid  = "未确认的尸体"

L.target_traitor = "叛徒同伙"
L.target_detective = "探长"

L.target_credits = "搜索尸体以获取未被消耗积分"

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single  = "单独使用"
L.tbut_reuse   = "重复使用"
L.tbut_retime  = "在 {num} 秒后重复使用"
L.tbut_help    = "按下 {key} 键启动"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "开始伪装，你的名字已隐藏。"
L.radar_hud    = "雷达将在 {time} 后进行下一次扫描。"

-- Spectator muting of living/dead
L.mute_living  = "将生存的玩家设定静音"
L.mute_specs   = "将观察者设定静音"
L.mute_all     = "全部静音"
L.mute_off     = "取消静音"

-- Spectators and prop possession
L.punch_title  = "飞击量表" --"PUNCH-O-METER"
L.punch_help   = "按下行走键或跳跃键以推撞物品；按蹲下键则离开物品控制。"
L.punch_bonus  = "你的分数较低，飞击量表上限减少 {num}"
L.punch_malus  = "你的分数较高，飞击量表上限增加 {num} ！"

L.spec_help    = "点击以观察玩家，或按下 {usekey} 来控制并持有物体。"

--- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[
你是位无辜的恐怖分子！但你的周围存在着叛徒...
你能相信谁？谁又想把你打成柿子？
看好你的背后并与同伴合作，争取活下来！]]

L.info_popup_detective = [[
你是位探长！恐怖分子总部给予你许多特殊资源以揪出叛徒。
用它们来确保无辜者的生命，不过要当心：叛徒会优先杀害你！
按 {menukey} 获得装备！]]


L.info_popup_traitor_alone = [[你是位叛徒！这回合中你没有同伴。
杀死所有其他玩家，以获得胜利！
按 {menukey} 取得装备！]]

L.info_popup_traitor = [[
你是位叛徒！和其他叛徒合作杀害其他所有人，以获得胜利。
但请小心，你的身份可能会暴露...
这些是你的同伴们:
{traitorlist} 
按 {menukey} 取得装备！]]

--- Various other text
L.name_kick = "一名玩家因于此回合中改变了名字而被自动踢出游戏。"

L.idle_popup = [[你挂机了 {num} 秒，所以被转往观察者模式。
当你位于此模式时，将不会在回合开始时重生。
你可在任何时间取消观察者模式，按下 {helpkey} 并在选单取消勾选\"观察者模式\"即可。当然，你也可以选择立刻关闭它。]]

L.idle_popup_close = "什么也不做"
L.idle_popup_off   = "立刻关闭观察者模式"

L.idle_warning = "警告：你已挂机一段时间，如果接下来没有动作将进入观察者模式。"

L.spec_mode_warning = "你位于观察者模式所以不会在回合开始时重生。若要关闭此模式，按下F1并取消勾选\"观察者模式\"即可。"


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "提示"
L.tips_panel_tip   = "提示："

-- Tip texts

L.tip1 = "叛徒不用确认其死亡即可悄悄检查尸体，只需对着尸体按着 {walkkey} 键后再按 {usekey} 键即可。"

L.tip2 = "将C4爆炸时间设置更长，可增加引线数量，使拆弹者失败可的能性大幅上升，且能让C4的哔哔声更轻更慢。"

L.tip3 = "探长能在尸体查出谁是\"死者最后看见的人\"。若是遭到背后攻击，最后看见的将不会是凶手。"

L.tip4 = "被你的尸体被发现并确认之前，没人知道你已经死亡。"

L.tip5 = "叛徒杀死探长时会立即得到一点积分。"

L.tip6 = "一名叛徒死后，探长将得到一点积分作为奖励。"

L.tip7 = "叛徒杀害一定数量的无辜者后，全体都会获得一点积分作为奖励。"

L.tip8 = "叛徒和探长能从同伴尸体上取得未被消耗的积分。"

L.tip9 = "促狭鬼将使物体变得极其危险。促狭鬼调整过的物体将产生爆炸能量伤害接近它的人。"

L.tip10 = "叛徒与探长应保持注意屏幕右上方的红色信息，这对你无比重要。"

L.tip11 = "叛徒或探长和同伴配合得好时会获得额外积分。请善用这些积分！"

L.tip12 = "探长的DNA扫描器可使用在武器或道具上，找到曾使用它的玩家的位置。用在尸体或C4上效果将更好！"

L.tip13 = "太靠近你杀害的人的话，DNA将残留在尸体上，探长的DNA扫描器会以此找到你的正确位置。切记，杀了人最好将尸体藏好！"

L.tip14 = "杀人时离被害者越远，残留在尸体上的DNA就会越快消失！"

L.tip15 = "你是叛徒而且想进行狙击？试试伪装吧！若你狙杀失手，逃到安全的地方，取消伪装，就没人知道是你开的枪了！"

L.tip16 = "作为叛徒，传送器可帮助你逃脱追踪，并让你得以迅速穿过整个地图。请随时确保有个安全的传送标记。"

L.tip17 = "是否遇过无辜者群聚在一起而难以下手？请试试用收音机发出C4哔哔声或交火声，让他们分散。"

L.tip18 = "叛徒可以在选单使用已放置的收音机，依序点击想播放的声音，就会按顺序排列播放。"

L.tip19 = "探长若有多余积分，可将拆弹器交给一位可信任的无辜者，将危险的C4交给他们，自己全神贯注地调查与处决叛徒。"

L.tip20 = "探长的望远镜可让你远距离搜索并确认尸体，坏消息是叛徒总是会用诱饵欺骗你。当然，使用望远镜的探长全身都是破绽。"

L.tip21 = "探长的医疗站可让受伤的玩家恢复健康，当然，其中也包括叛徒..."

L.tip22 = "治疗站将遗留每位前来治疗的人的DNA样本，探长可将其用在DNA扫描器上，寻找究竟谁曾受过治疗。"

L.tip23 = "与武器、C4不同，收音机并不会留下你的DNA样本，不用担心探长会在上头用DNA识破你的身分。"

L.tip24 = "按下 {helpkey} 阅读教学或变更设定，比如说，你可以永远关掉现在所看到的提示唷～"

L.tip25 = "探长确认尸体后，相关信息将在计分板公布，如要查看只需点击死者之名字即可。."

L.tip26 = "计分板上，人物名字旁的放大镜图样可以查看关于他的信息，若图样亮着，代表是某位探长确认后的结果。"

L.tip27 = "探长调查尸体后的结果将公布在计分板，供所有玩家查看。"

L.tip28 = "观察者可以按下 {mutekey} 循环调整对其他观察者或游戏中的玩家静音。"

L.tip29 = "若服务器有安装其他语言，你可以在任何时间开启F1选单，启用不同语言。"

L.tip30 = "若要使用语音或无线电，可以按下 {zoomkey} 使用。"

L.tip31 = "作为观察者，按下 {duckkey} 能固定视角并在游戏内移动光标，可以点击提示栏里的按钮。此外，再次按下 {duckkey} 会解除并恢复默认视角控制。"

L.tip32 = "使用撬棍时，按下右键可推开其他玩家。"

L.tip33 = "使用武器瞄准器射击将些微提升你的精准度，并降低后座力。蹲下则不会。"

L.tip34 = "烟雾弹在室内相当有效，尤其是在拥挤的房间中制造混乱。"

L.tip35 = "叛徒，请记住你能搬运尸体并将它们藏起来，避开无辜者与探长的耳目。"

L.tip36 = "按下 {helpkey} 可以观看教学，其中包含了重要的游戏信息。"

L.tip37 = "在计分板上，点击活人玩家的名字，可以选择一个标记（如令人怀疑的或友好的）记录这位玩家。此标志会在你的准心指向该玩家时显示。"

L.tip38 = "许多需放置的装备（如C4或收音机）可以使用右键放在墙上。"

L.tip39 = "拆除C4时失误导致的爆炸，比起直接引爆时来得小。"

L.tip40 = "若时间上显示\"急速模式\"，此回合的时间会很短，但每位玩家的死亡都将延长时间（就像TF2的占点模式）。延长时间将迫使叛徒加紧脚步。"


--- Round report

L.report_title = "回合报告"

-- Tabs
L.report_tab_hilite = "亮点"
L.report_tab_hilite_tip = "回合亮点"
L.report_tab_events = "事件"
L.report_tab_events_tip = "发生在此回合的亮点事件"
L.report_tab_scores = "分数"
L.report_tab_scores_tip = "本回合单个玩家获得的点数"

-- Event log saving
L.report_save     = "保存 Log.txt"
L.report_save_tip = "将事件记录并保存在txt档内"
L.report_save_error  = "没有可供保存的事件记录"
L.report_save_result = "事件记录已存在："

-- Big title window
L.hilite_win_traitors = "叛徒获得胜利"
L.hilite_win_innocent = "无辜者获得胜利"

L.hilite_players1 = " {numplayers} 名玩家加入游戏， {numtraitors} 名玩家是叛徒"
L.hilite_players2 = " {numplayers} 名玩家加入游戏，其中一人是叛徒"

L.hilite_duration = "回合持续了 {time}"

-- Columns
L.col_time   = "时间"
L.col_event  = "事件"
L.col_player = "玩家"
L.col_role   = "角色"
L.col_kills1 = "无辜者杀敌数"
L.col_kills2 = "叛徒杀敌数"
L.col_points = "点数"
L.col_team   = "团队奖励"
L.col_total  = "总分"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "某件物品"

-- Kill events
L.ev_blowup      = "{victim} 被自己炸飞"
L.ev_blowup_trap = "{victim} 被 {trap} 炸飞"

L.ev_tele_self   = "{victim} 被自己给传送杀了"
L.ev_sui         = "{victim} 受不了然后自杀了！"
L.ev_sui_using   = "{victim} 用 {tool} 杀了自己"

L.ev_fall        = "{victim} 摔死了"
L.ev_fall_pushed = "{victim} 因为 {attacker} 而摔死了"
L.ev_fall_pushed_using = "{victim} 被 {attacker} 用 {trap} 推下摔死"

L.ev_shot        = "{victim} 被 {attacker} 射杀"
L.ev_shot_using  = "{victim} 被 {attacker} 用 {weapon} 射杀"

L.ev_drown       = "{victim} 被 {attacker} 推入水中溺死"
L.ev_drown_using = "{victim} 被 {attacker} 用 {trap} 推入水中溺死"

L.ev_boom        = "{victim} 被 {attacker} 炸死"
L.ev_boom_using  = "{victim} 被 {attacker} 用 {trap} 炸烂"

L.ev_burn        = "{victim} 被 {attacker} 烧死"
L.ev_burn_using  = "{victim} 被 {attacker} 用 {trap} 烧成焦尸"

L.ev_club        = "{victim} 被 {attacker} 打死"
L.ev_club_using  = "{victim} 被 {attacker} 用 {trap} 打成烂泥"

L.ev_slash       = "{victim} 被 {attacker} 砍死"
L.ev_slash_using = "{victim} 被 {attacker} 用 {trap} 砍成两半"

L.ev_tele        = "{victim} 被 {attacker} 传送杀"
L.ev_tele_using  = "{victim} 被 {attacker} 用 {trap} 传送时之能量分裂成原子"

L.ev_goomba      = "{victim} 被 {attacker} 用巨大物体压烂"

L.ev_crush       = "{victim} 被 {attacker} 压烂"
L.ev_crush_using = "{victim} 被 {attacker} 用 {trap} 压碎"

L.ev_other       = "{victim} 被 {attacker} 杀死"
L.ev_other_using = "{victim} 被 {attacker} 用 {trap} 杀死"

-- Other events
L.ev_body        = "{finder} 发现了 {victim} 的尸体"
L.ev_c4_plant    = "{player}  安装了C4"
L.ev_c4_boom     = "{player} 安装的C4爆炸了"
L.ev_c4_disarm1  = "{player} 拆除了 {owner} 安装的C4"
L.ev_c4_disarm2  = "{player} 因拆除失误而引爆了 {owner} 安装的C4"
L.ev_credit      = "{finder} 在 {player} 的尸体上找到 {num} 点积分"

L.ev_start       = "回合开始"
L.ev_win_traitor = "卑鄙的叛徒赢了这回合！"
L.ev_win_inno    = "无辜的恐怖分子赢了这回合！"
L.ev_win_time    = "叛徒因为超过时间而输了这回合！"

--- Awards/highlights

L.aw_sui1_title = "自杀邪教教主"
L.aw_sui1_text  = "率先向其他自杀者展示如何自杀。"

L.aw_sui2_title = "孤独沮丧者"
L.aw_sui2_text  = "就他一人自杀，无比哀戚。"

L.aw_exp1_title = "炸弹研究的第一把交椅"
L.aw_exp1_text  = "决心研究C4。{num} 名受试者证明了他的理论。"

L.aw_exp2_title = "田野研究"
L.aw_exp2_text  = "测试自己的抗暴性，显然完全不够高。"

L.aw_fst1_title = "第一滴血"
L.aw_fst1_text  = "将第一位无辜者的生命送到叛徒手上。"

L.aw_fst2_title = "愚蠢的血腥首杀"
L.aw_fst2_text  = "击杀一名叛徒同伴而得到首杀，做得好啊！"

L.aw_fst3_title = "首杀大挫折"
L.aw_fst3_text  = "第一杀便将无辜者同伴误认为叛徒，真是乌龙。"

L.aw_fst4_title = "吹响号角"
L.aw_fst4_text  = "杀害一名叛徒，为无辜者阵营吹响了号角。"

L.aw_all1_title = "鹤立鸡群"
L.aw_all1_text  = "对无辜者团队的每一个击杀负责。"

L.aw_all2_title = "孤狼"
L.aw_all2_text  = "对叛徒团队的每一个击杀负责。"

L.aw_nkt1_title = "老大！我干掉一个！"
L.aw_nkt1_text  = "在一名无辜者落单时策划一场谋杀，漂亮！"

L.aw_nkt2_title = "一石二鸟"
L.aw_nkt2_text  = "用另一具尸体证明上一枪不是巧合。"

L.aw_nkt3_title = "连续杀人魔"
L.aw_nkt3_text  = "在今天结束了三名无辜者的生命。"

L.aw_nkt4_title = "穿梭在批着羊皮的狼之间的狼"
L.aw_nkt4_text  = "将无辜者们作为晚餐吃了。共吃了 {num} 人。"

L.aw_nkt5_title = "反恐特工"
L.aw_nkt5_text  = "按恐怖分子人头收钱。现在已经买得起豪华游艇了。"

L.aw_nki1_title = "背叛这个试试！"
L.aw_nki1_text  = "找出了一个叛徒，然后杀死了一个叛徒。简单吧？"

L.aw_nki2_title = "申请进入正义连队"
L.aw_nki2_text  = "将两名叛徒送下地狱。"

L.aw_nki3_title = "恐怖分子会梦到叛徒羊吗？"
L.aw_nki3_text  = "让三名叛徒安息。"

L.aw_nki4_title = "人事部门"
L.aw_nki4_text  = "按叛徒人头收钱。现在已经买得起第五个游泳池了。"

L.aw_fal1_title = "不，庞德先生，我希望你跳下去"
L.aw_fal1_text  = "将一个人推下致死的高度。"

L.aw_fal2_title = "地板人"
L.aw_fal2_text  = "让自己的身体从极端无尽的高度上落地。"

L.aw_fal3_title = "人体流星"
L.aw_fal3_text  = "让一名玩家从高处落下，摔成烂泥。"

L.aw_hed1_title = "高效能"
L.aw_hed1_text  = "发现爆头的乐趣，并击杀了 {num} 名敌人。"

L.aw_hed2_title = "神经内科"
L.aw_hed2_text  = "近距离将 {num} 名玩家的脑袋取出，完成自己的脑神经研究。"

L.aw_hed3_title = "从游戏里学来的"
L.aw_hed3_text  = "好好应用了暴力游戏的经验，爆了 {num} 颗头。"

L.aw_cbr1_title = "物理学圣剑"
L.aw_cbr1_text  = "应用了物理学原理，向 {num} 证明了自己的毕业论文。"

L.aw_cbr2_title = "戈登•弗里曼"
L.aw_cbr2_text  = "离开黑山，用喜爱的撬棍杀了至少 {num} 名玩家。"

L.aw_pst1_title = "死亡之握"
L.aw_pst1_text  = "用手枪杀死 {num} 名玩家前，都上前握了手。"

L.aw_pst2_title = "小口径屠杀"
L.aw_pst2_text  = "用手枪杀了 {num} 人的小队。我们推测他枪管里头有个微型霰弹枪。"

L.aw_sgn1_title = "简单模式"
L.aw_sgn1_text  = "用霰弹枪近距离杀了 {num} 名玩家。切。"

L.aw_sgn2_title = "一千颗小弹丸"
L.aw_sgn2_text  = "不喜欢自己的霰弹，打算送人。已经有 {num} 名受赠人接受了这个礼物。"

L.aw_rfl1_title = "把准心对准目标扣下扳机……"
L.aw_rfl1_text  = "用一把好枪和一个沉稳的手终结了 {num} 名玩家的生命。"

L.aw_rfl2_title = "你的脑袋冒出来了！"
L.aw_rfl2_text  = "十分了解他的狙击枪，其他 {num} 名玩家随即也了解了他的狙击枪。"

L.aw_dgl1_title = "这简直像是小型狙击枪"
L.aw_dgl1_text  = "用沙漠之鹰娴熟地杀了 {num} 名玩家。"

L.aw_dgl2_title = "老鹰大师"
L.aw_dgl2_text  = "用他手中的沙漠之鹰杀了 {num} 名玩家。"

L.aw_mac1_title = "按下扳机，然后祈祷"
L.aw_mac1_text  = "用MAC10冲锋枪杀了 {num} 名玩家，但别提他需要多少发子弹。"

L.aw_mac2_title = "单枪老太婆"
L.aw_mac2_text  = "好奇如果他能有两把冲锋枪会发生什么事。大概是 {num} 个人头再翻倍？"

L.aw_sip1_title = "嘘！"
L.aw_sip1_text  = "用消音手枪射杀了 {num} 人。"

L.aw_sip2_title = "光头杀手"
L.aw_sip2_text  = "用消音手枪无声地杀死了 {num} 个人。不愧是专业的。"

L.aw_knf1_title = "很刀兴见到你"
L.aw_knf1_text  = "隔着网线捅死了一个人。"

L.aw_knf2_title = "管制刀具"
L.aw_knf2_text  = "不是叛徒，却找到刀子并用它杀了人。"

L.aw_knf3_title = "开膛手杰克"
L.aw_knf3_text  = "在地上捡到 {num} 把匕首，并好好利用了它们。"

L.aw_knf4_title = "女仆长的执著"
L.aw_knf4_text  = "用刀子杀死了 {num} 个人。这些刀子都是裙底下找出来的吗？"

L.aw_flg1_title = "买根烟吗？"
L.aw_flg1_text  = "用燃烧弹点燃了 {num} 人的香烟。"

L.aw_flg2_title = "火上浇油"
L.aw_flg2_text  = "使 {num} 名玩家葬身于火海。"

L.aw_hug1_title = "子弹龙头"
L.aw_hug1_text  = "和自己的M249很合得来，不知道怎么打中了 {num} 名玩家。"

L.aw_hug2_title = "耐心机枪手"
L.aw_hug2_text  = "从未抛弃心爱的M249，最终用其杀戮了 {num} 名玩家。"

L.aw_msx1_title = "啪啪啪"
L.aw_msx1_text  = "用M16步枪射杀了 {num} 名玩家。"

L.aw_msx2_title = "中距离疯子"
L.aw_msx2_text  = "了解如何用他手中的M16，射杀了敌人。共有 {num} 名不幸的亡魂。"

L.aw_tkl1_title = "抱歉"
L.aw_tkl1_text  = "瞄准自己的队友，并不小心扣下扳机。"

L.aw_tkl2_title = "抱歉抱歉"
L.aw_tkl2_text  = "认为自己抓到了两次叛徒，但两次都错了！"

L.aw_tkl3_title = "小心人品！"
L.aw_tkl3_text  = "杀死两个同伴已不能满足他，三个才是他的最终目标！"

L.aw_tkl4_title = "专业卖队友！"
L.aw_tkl4_text  = "杀了所有同伴！快踢了他！"

L.aw_tkl5_title = "角色扮演"
L.aw_tkl5_text  = "在扮演一个疯子，所以把自己大部分的同伴杀死了。"

L.aw_tkl6_title = "痛击队友"
L.aw_tkl6_text  = "弄不清他属于哪一队，并杀死了半数以上的队友。"

L.aw_tkl7_title = "园丁"
L.aw_tkl7_text  = "好好保护着自己的草坪，并杀死了四分之一以上的队友。"

L.aw_brn1_title = "炭烤恐怖分子"
L.aw_brn1_text  = "使用燃烧弹点燃数个玩家，把他们烤熟了！"

L.aw_brn2_title = "火化官"
L.aw_brn2_text  = "将每一具被他杀死的受害者尸体燃烧乾淨。"

L.aw_brn3_title = "纵火狂"
L.aw_brn3_text  = "十分喜欢火焰，以至于用掉了地图上每一颗燃烧弹。也许应该去看一下医生。"

L.aw_fnd1_title = "验尸官"
L.aw_fnd1_text  = "在地上发现 {num} 具尸体。"

L.aw_fnd2_title = "尸体收藏家"
L.aw_fnd2_text  = "在地上发现了 {num} 具尸体，大概是要搞收藏。"

L.aw_fnd3_title = "死亡的气味"
L.aw_fnd3_text  = "在这回合偶遇尸体共 {num} 次。"

L.aw_crd1_title = "回收利用"
L.aw_crd1_text  = "在同伴尸体上找到了 {num} 点积分。"

L.aw_tod1_title = "痛失胜利"
L.aw_tod1_text  = "在他的团队即将获得胜利的前几秒死去。"

L.aw_tod2_title = "垃圾游戏！"
L.aw_tod2_text  = "在这回合刚开始不久即被杀害。"


--- New and modified pieces of text are placed below this point, marked with the
--- version or the date in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "拒绝被选为探长"
L.set_avoid_det_tip = "开启这个选项让服务器尽量不要把你选成侦探。这不代表你有更高机率被选为叛徒。"

--- v24
L.drop_no_ammo = "你弹夹内的子弹不足以丢弃成弹药盒。"

--- v31
L.set_cross_brightness = "准心亮度"
L.set_cross_size = "准心尺寸"

--- 2015-05-25
L.hat_retrieve = "你捡起了一顶探长的帽子。"

--- 2017-03-09
L.sb_sortby = "排序方法:"

--- 2018-07-24
L.equip_tooltip_main = "装备菜单"
L.equip_tooltip_radar = "雷达控制"
L.equip_tooltip_disguise = "伪装器控制"
L.equip_tooltip_radio = "收音机控制"
L.equip_tooltip_xfer = "转移积分"

L.confgrenade_name = "眩晕弹"
L.polter_name = "促狭鬼"
L.stungun_name = "实验型 UMP"

L.knife_instant = "必杀"

L.dna_hud_type = "类型"
L.dna_hud_body = "尸体"
L.dna_hud_item = "物品"

L.binoc_zoom_level = "放大"
L.binoc_body = "发现尸体"

L.idle_popup_title = "挂机"
