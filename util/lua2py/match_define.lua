--Number ==================================================================
MATCH_PATH_MAP = "match/background/match_map_%d.plist"
MATCH_PATH_MAP2 = "match/background/match_map_0%d.plist"
MATCH_PATH_MAP3 = "match/background/match_map_shadow.plist"

MATCH_PATH_MAP_SHADOW = "match_map_shadow.png"
MATCH_PATH_MAP_SKY = "match_map_%d_sky.png"
MATCH_PATH_MAP_MIST = "match_map_%d_mist.png"
MATCH_PATH_MAP_ROAD1 = "match_map_%d_bg01.png"
MATCH_PATH_MAP_ROAD2 = "match_map_%d_bg02.png"
MATCH_PATH_MAP_ROAD3 = "match_map_%d_bg03.png"

MATCH_PATH_ITEM_HOUSE1 = "match_map_1_house01.png"
MATCH_PATH_ITEM_HOUSE2 = "match_map_1_house02.png"
MATCH_PATH_ITEM_HOUSE3 = "match_map_1_house03.png"
MATCH_PATH_ITEM_HOUSE4 = "match_map_1_house04.png"

MATCH_PATH_ITEM_TREE1 = "match_map_2_tree_01.png"
MATCH_PATH_ITEM_TREE2 = "match_map_2_tree_02.png"
MATCH_PATH_ITEM_ROCK1 = "match_map_3_rock01.png"
MATCH_PATH_ITEM_ROCK2 = "match_map_3_rock02.png"
MATCH_PATH_ITEM_ROCK3 = "match_map_3_smalltrees.png"
MATCH_PATH_ITEM_ROCK4 = "match_map_3_walls.png"
MATCH_PATH_ITEM_SEA1 = "match_map_4_mountain01.png"
MATCH_PATH_ITEM_SEA2 = "match_map_4_mountain02.png"
MATCH_PATH_ITEM_SEA3 = "match_map_4_mountain03.png"
MATCH_PATH_ITEM_SEA4 = "match_map_4_mountain04.png"
MATCH_PATH_ITEM_KINGDOM = "match_map_5_rock_01.png"
MATCH_PATH_ITEM_OUTPLANET1 = "match_map_6_rock_01.png"
MATCH_PATH_ITEM_OUTPLANET2 = "match_map_6_rock_02.png"
MATCH_PATH_ITEM_OUTPLANET3 = "match_map_6_rock_03.png"
MATCH_PATH_ITEM_PRISION1 = "match_map_7_rock_01.png"
MATCH_PATH_ITEM_PRISION2 = "match_map_7_rock_02.png"

MATCH_PATH_ITEM_MEITA1 = "match_map_8_rock01.png"
MATCH_PATH_ITEM_MEITA2 = "match_map_8_rock02.png"

MATCH_PATH_ITEM_YUANGU1 = "match_map_9_rock_01.png"
MATCH_PATH_ITEM_YUANGU2 = "match_map_9_rock_02.png"
MATCH_PATH_ITEM_YUANGU3 = "match_map_9_rock_03.png"
MATCH_PATH_ITEM_YUANGU4 = "match_map_9_rock_04.png"

MATCH_PATH_ITEM_XUNI1 = "match_map_10_rock_01.png"
MATCH_PATH_ITEM_XUNI2 = "match_map_10_rock_02.png"
MATCH_PATH_ITEM_XUNI3 = "match_map_10_rock_03.png"
MATCH_PATH_ITEM_XUNI4 = "match_map_10_rock_04.png"

MATCH_PATH_ITEM_YJCS1 = "match_map_11_rock_01.png"
MATCH_PATH_ITEM_YJCS2 = "match_map_11_rock_02.png"
MATCH_PATH_ITEM_YJCS3 = "match_map_11_rock_03.png"
MATCH_PATH_ITEM_YJCS4 = "match_map_11_rock_04.png" 

MATCH_PATH_ITEM_BEHS1 = "match_map_12_rock_01.png"
MATCH_PATH_ITEM_BEHS2 = "match_map_12_rock_02.png"
MATCH_PATH_ITEM_BEHS3 = "match_map_12_rock_03.png"
MATCH_PATH_ITEM_BEHS4 = "match_map_12_rock_04.png"

MATCH_PATH_ITEM_NLKLY1 = "match_map_13_tree_01.png"

MATCH_PATH_BULIDING_ARM_NAME_1 = nil--"match/background/scene_smoke01.plist"

-- 场景变换FadeIn Time
MATCH_CHANGE_FADE_IN_TIME = 1.0

--- 镜头移动的
m_tMatchMapCameraPosY= {
    [1] = -580,
    [2] = -505,
    [3] = -485,
    [4] = -425,
}

E_MATCH_TYPE = {
	ORDINARY = 0, 	--普通副本pve
    PATA 	 = 1, 	--爬塔pve
    YICIYAUN = 2, 	--异次元pve
    EVENT	 = 3,	--事件副本pve
    JIANYU   = 4, 	--监狱暴动pve 
    GUARD    = 5, 	--警备队pve 
    QIECUO   = 6,   --玩家切磋
    JINGYING = 10,	--精英副本pve
    YINCANG  = 11,	--隐藏副本pve
    JINGJI   = 12,	--竞技场类型pvp
    BAOWU    = 13,	--宝物争夺pvp
    YABIAO   = 14,  --押镖pvp
    YUANZHENG= 15,	--远征
    ZHANBAO	 = 16,	--战报
    ZUDUI	 = 17,	--组队副本
    YINPAKE	 = 18,  --因帕克
    ORB		 = 20,	--欧布副本
    ORB_HARD = 21,  --欧布精英本
    SHIKONG	 = 22,  --时空城
	YISTAGE	 = 26,  --异宇宙试炼
	ENEMY	 = 35,  --强敌
	ZHANBAOtext	 = 36,  --强敌
	COSMIC_REMNANTS = 37 -- 宇宙遗迹
}
--Enum ==================================================================
MATCH_MAX_ZORDER = 15000

E_MATCH_BG_ZORDER = 
{
	MATCH_BG_Z_SKY = 11,
	MATCH_BG_Z_MIST = 100,
	MATCH_BG_Z_ROAD = 99,
	MATCH_BG_Z_SHADOW = 10000,
	MATCH_BG_Z_COLORBG = 10,
	MATCH_BG_Z_SIDE = 9999,
	MATCH_BG_Z_SIDE_FIRST = 12,
}

E_MATCH = 
{
	--队伍
	TEAM_MY = 1, --本方
	TEAM_OPPO = 2, --敌方怪物
	TEAM_FRIEND = 3,--好友助阵

	ATTRIBUTE_MONSTER = 1, --怪物
	ATTRIBUTE_PLAYER = 2, --玩家
	
	--角色阵营
	ROLE_CAMP_ULTRAMAN = 1,  --1奥特曼
	ROLE_CAMP_MONSTER = 2,  --2怪兽
	ROLE_CAMP_COSMICMAN = 3,  --3宇宙人
	ROLE_CAMP_MECHANICS = 4,  --4机械

	RESULT_FAIL = 0, --战斗失败
	RESULT_WIN = 1, --战斗胜利

	BTN_INVAILD = 0, --无效
	BTN_AUTO = 1,
	BTN_CANNEL = 2,
	BTN_LOCK = 3,

	APPEAR_INVAILD = 0, --无效
	APPEAR_ENTERMATCH = 1, --进场
	APPEAR_NEXTBATTLE = 2, --过场

	APPEAR_INOUT_IN1 = 1,
	APPEAR_INOUT_IN2 = 2,
	APPEAR_INOUT_OUT = 3,

	MATCH_ZORDER_MAP = 10,
	MATCH_ZORDER_SHADOW = 15, --影子
	MATCH_ZORDER_CARD = 20,
	MATCH_ZORDER_DROP = 50,
	MATCH_ZORDER_BUFF = 60, --异常效果动画
	MATCH_ZORDER_CHARACTER = 400, --（受击效果 居中； 攻击效果 最上；受击文字 最下）
	MATCH_ZORDER_BLACKSCREEN = 180, --好友助阵用到的黑幕层
	MATCH_ZORDER_ENTERMATCH = 190, --进场冲天层级
	MATCH_ZORDER_ATTRIBUTE = 200, --属性相克
	MATCH_ZORDER_CARD_STEP = 250, --战斗中卡牌的层级
	MATCH_ZORDER_CCBI = 300,
	MATCH_ZORDER_HIGHENERGY = 399, --跳过战斗的动画
	MATCH_ZORDER_SKIPANIM = 400, --跳过战斗的动画


	--攻击类型（物理、特技、治疗）
	ATK_TYPE_PHYSICS = 1,
	ATK_TYPE_SPECIAL = 2,
	ATK_TYPE_TREAT = 3,

	--技能类型
	SKILL_TYPE_BASIC = 1,
	SKILL_TYPE_SPECIAL = 2,
	SKILL_TYPE_FULL = 3,

	ATTCOMPARE_WEAK = -1, --弱
	ATTCOMPARE_EQUAL = 0, --平
	ATTCOMPARE_SUPPRESS = 1, --克 

	MODE_FIRSTATTACK = 1, --先攻角色
	MODE_NORMAL = 2, --普通方式

	HITORDODGE_INVAILD = 0, --无效
	HITORDODGE_HIT = 1,	--命中
	HITORDODGE_DODGE = 2, --闪避

	--战斗地图
	MAP_TIME_MOVE = 0.8, --地图移动的时间(每秒40帧时为1.0, 60帧时为1.5)
	MAP_TIME_PART = 0.8, --战斗地图移动每一段时间
	MAP_TIME_FRAME = 0.035, --战斗地图移动时间间隔(每秒40帧时为0.03, 60帧时为0.017)
	MAP_INTERVAL_SCALE = 0.001, --战斗地图拉伸大小
	MAP_BUILDING_INIT = 10,
	MAP_BUILDING_MOVE = 1,

	CARD_LOWER_X = 125,
	CARD_LOWER_Y = 78,
	CARD_SHADOW_X = 125,
	CARD_SHADOW_Y = 58,

	--闪烁类型
	BLINK_NO = 0, --大于30%血量
	BLINK_30 = 1, --30%血量
	BLINK_10 = 2, --10%血量

	
	TIME_BREATHE = 1.5, --呼吸时间
	TIME_SUSPEND = 0.8, --悬浮时间
	TAG_BREATHE = 100999, --呼吸Action的tag
	TAG_SUSPEND = 100888, --悬浮Action的tag
	TAG_BLINK   = 100777, --闪烁Action的tag 
	DISTANCE_SUSPEND = 4, --悬浮移动位置


	--Effect Action
	EA_NUMBER = 1, --显示数字
	EA_CHARACTER = 2, --显示文字
	EA_CHARACTER_NUMBER = 3, --显示文字和数字
	EA_CHARACTER_CHARACTER = 4, --显示文字和文字

	--约定固定技能
	SKILL_ID_CHAOS = 9000, --混乱技能
	SKILL_ID_COUNTERATTACK = 9001, --反击技能


	--常量
	CONST_MEMBER_MAX = 6, --一队最多的上场队员数
	CONST_LOOP_MAX = 15, --一场战斗最大回合数，超过本方失败
	CONST_SCENE_MAX = 50, --场景最大个数
	CONST_LINE_MAX = 3, --一横排队员最大个数
	CONST_FURY_MAX = 4, --释放满能量所需的怒气值
	CONST_SPEED_MIN = 1.2, --加速最小值  --> 一倍速
	CONST_SPEED_MID = 3.0, --加速最中值  --> 三倍速
	CONST_SPEED_MAX = 6.3, --加速最大值  --> 六倍速
	CONST_SPEED_SUPERMAX = 10.0, --加速最大值  --> N倍速
	CONST_SCALE_CARD = 0.65, --卡牌缩放比例
	CONST_SCALE_EFFECT = 1.0, --effect字体大小
	CONST_COMPARE_ATTRIBUTE = 0.2, --属性相克的加成
}

--剧情
E_MATCH_STORY = 
{
	MS_SKIP_ROW = 1, --跳过当前行 
	MS_LOCATION = 2, --定位
	MS_EXCHAGE = 3, --过场

	MS_WIN = 7,
	MS_FAIL = 8,

	MS_DIALOG = 10, --对话 

	MS_LOGIN = 20, --登录账号
	MS_CREATE_PLAYER = 21, --卡牌上阵
	MS_GOTO_MATCH = 22, --进入指定关卡

	MS_MATCH = 30, --战斗开始标记
	MS_CARD_APPEAR = 31, --卡牌进场
	MS_CARD_MOVE = 32, --卡牌移动
	MS_FIGHTING = 33, --开始攻击
	MS_SKIP_REWARD = 35, --跳过结算
	MS_TRANSFORM = 36, --换人
	MS_ENTERFILE = 37, --播放变身动画
}

E_MATCH_STORY_RESULT = 
{
	MSR_NO_EXIST = 0, --失败，不存在
	MSR_NO_MATCH = 1, --失败，不匹配
	MSR_SUCCESS = 2, --成功
}

--攻击目标
ATKTARGET =
{
	MIN 				= 0, --不能小于最小值  

	SAME 				= 1, --同目标1

	POINT_OPPO 			= 2, --敌方对位点
	LINE_OPPO 			= 3, --敌方竖线
	ROWFRONT_OPPO 		= 4,  --敌方前排
	ROWBACK_OPPO 		= 5,  --敌方后排
	POINTBACK_OPPO 		= 6, --敌方后排单体
	CROSS_OPPO 			= 7, --敌方十字
	MAXHP_OPPO 			= 8, --敌方血多
	MINHP_OPPO 			= 9, --敌方血少
	RANDOM2_OPPO 		= 10, --敌方随机2人
	RANDOM3_OPPO 		= 11, --敌方随机3人
	ALL_OPPO 			= 12, --敌方全体

	SELF 				= 13, --自己
	RANDOM1_MY 			= 14, --本方随机一人
	MINHP_MY 			= 15, --本方生命最低
	ROWFRONT_MY 		= 16,  --本方前排
	ROWBACK_MY 			= 17,  --本方后排
	ALL_MY 				= 18, --本方全体

	ALL 				= 19, --双方全体
	RANDOM1_ALL 		= 20, --双方随机一人

	ROUND_ATK 			= 21, --回合攻击方
	ROUND_ROW 			= 22, --回合攻击方 横排	
	ROUND_LINE 			= 23, --回合攻击方 竖排	
	ROUND_CROSS 		= 24, --回合攻击方 十字

	ANOMALY_MY			= 25, --本方有异常状态的卡牌

	MINHP_WITHOUT_MY	= 26, --除自己外本方生命值最低

	MAXHURTADD_OPPO		= 27, --敌方全伤加值最多一人
	MAXHURTADD_MY		= 28, --我方全伤加值最多一人
	RANDOM1_OPPO 		= 29, --敌方随机一人
	HURTRAISEADD_OPPO 	= 30, --敌方受伤率最多一人
	HURTRAISEADD_MY 	= 31, --我方受伤率最多一人
	DODGE_OPPO			= 32, --敌方闪避（敌方闪避我方主动技后，在触发技中可用的目标）
	PARRY_OPPO			= 33, --敌方格挡（敌方格挡我方主动技后，在触发技中可用的目标）
	ATKMAX_OPPO			= 34, --敌方攻击最高

	RANDOMCAMP_MY		= 35, --己方随机一名怪兽，宇宙人
	OLDENEMY			= 36, --宿敌(目前专用于终极赛罗攻击贝利亚)
	RANDOMULTRAMAN_OPPO	= 37, --敌方随机两名奥特曼
	RANDOM2_MY	        = 38, --己方随机两名

	ESSENCEMARK_MY		= 39, --己方真谛之善持有
	ESSENCEMARK_OPPO	= 40, --敌方真谛之恶持有

	ATKMAX_MY			= 41, -- 己方攻击最高
	ATKMIN_MY			= 42, -- 己方攻击最低
	ENERGYMAX_MY		= 43, -- 己方能量最高
	ENERGYMAX_OPPO		= 44, -- 敌方能量最高
	RANDOMEXCEPTSELF_MY	= 45, -- 本方除自己外随机一人
	CAMP_MY_MONS_COSMIC_MECHAN	= 46; -- 己方怪兽，宇宙人，机械角色
	CROSS_BACK_OPPO		= 47; -- 敌方后排十字
	CAMP_ULTRAMAN_MY	= 48, -- 己方所有奥特曼
	ALL_EXCEPT_SELF		= 49, -- 双方全体除自身外
	CRIT_CHECK_YES		= 50, -- 对敌方造成伤害且被暴击后(我方主动技中可用的目标)
	CRIT_CHECK_NO		= 51, -- 对敌方造成伤害但未被暴击(我方主动技中可用的目标)
	DESIGNATED_BUFF_ROLE = 52, --敌方带有指定buff的角色
	TARGET_EXCEPT_EFFECT1 = 53,  --排除效果1的目标后队伍中的其他目标
	CAMP_COSMICMAN_MY 	= 54, --己方所有宇宙人角色
	GAINBUFF_COUNT_MAX_OPPO = 55, --敌方增益buff数量最多的目标
	BLACKTURTLE_AND_RAND_OTHER_MY = 56, --随机一名己方黑蜧，若无黑蜧，则随机一名己方其他目标
	TARGET_BY_ANOMALY_GIFT = 57, --己方拥有恩赐buff的一名目标
	CAMP_MY_MONS_AND_MACH = 58; -- 己方怪兽，机械角色	
	CAMP_MONSTER_MY 	= 59, --己方所有怪兽
	CAMP_MECHANICS_MY 	= 60, --己方所有机械
	TARGET_BY_ANOMALY_DEMARCHES = 61, --己方拥有<合纵联横>buff的另外一名目标
	TARGET_ANOMALY_FLAME_PATTERN = 62, --敌方拥有<火炎之纹>效果的目标
	TARGET_MAX_CRITDAMAGE = 63, --己方暴伤最高的目标
	
	MAX 				= 64, --不能大于最大值  
}

--附加效果类型
EFFECTTYPE = 
{
	HURT = 1, --直接伤害
	POWER_REDUCE = 2, --降低能量
	POWER_ADD = 3, --增加能量
	GIDDY = 4, --眩晕
	POISONED = 5, --毒
	FIRE = 6, --灼烧
	PARRY_ADD = 7, --增加格挡
	DEFENSE = 8, --绝对防御
	RECOVERHP = 9, --恢复生命
	STOPSKILL = 10, --封技
	FOLLOWUP = 11, --追击
	CHAOS = 12, --混乱
	CRIT_ADD = 13, --增加暴击
	HIT_ADD = 14, --增加命中
	EVASION_ADD = 15, --增加闪避
	RESILENCE_ADD = 16, --增加抗爆
	EXPERTISE_ADD  = 17, --增加破挡
	HURT_ADD = 18, --增加伤害(全伤加值)
	SUCKHP = 19, --吸血
	STOPTREAT = 20, --治疗封印
	REMOVEANOMALY = 21, --解除异常状态
	HURT_REDUCE = 22, --免伤
	HURT_RAISE = 23, --伤害(受伤)
	SPECIAL = 24,--第二段能量技
	CRITDAMAGE_ADD = 25, --增加暴伤
	SPECIALDEFENSE = 26, --绝对防御(免眩晕，封技，混乱)
	PERCENTFRIENDATK = 27, --每有一个队友攻击力百分比加值
	PERCENTFRIENDPHYDEF = 28, --每有一个队友物防百分比加值
	PERCENTFRIENDSPECDEF = 29, --每有一个队友特防百分比加值
	DAMAGETRANSFER = 30, --伤害转移（帮队友承担伤害，实际是直接把目标替换）
	DOLL = 31, --人偶标记（减少攻击力和双防御的百分比，三种属性减少的值为一致的）
	REMOVEDEBUFF = 32, --解除Debuff（非毒、烧、眩晕、封技、眩晕、混乱）
	PARAGGI = 33, --帕拉吉之光（增加免伤和全伤加值）
	SPATIAL_REINFORCE = 34, --空间强化
	SPATIAL_WARP = 35, --空间扭曲
	SPECIALBUFF = 36, --特殊buff（用来配合【自身特殊buff X 次时】触发）
	HURT_MAXHP = 37, --最大生命值的百分比伤害
	ATK_RATE_HURT = 38, --造成自己的攻击*一定系数的真实伤害
	GLASS_SEAL = 39, --镜之封印
	CHANGE_POSITION = 40, --交换位置
	REMOVEALLBUFF = 41, --清除所有debuff+异常
	TREATMENTSEALCERTAINLY = 42, --必定重伤(优先级低于重伤免疫)
	BEEN_HURT_ADD = 43, --角色受到过全伤降低的debuff(全伤加值为负)
	REMOVEBUFF = 44, --解除增益buff
	ENDMARK = 45, --终结印记
	TREATMENTADD = 46, --治疗加值
	PERCENTATK = 47, --攻击加值百分比
	PHYSICALDEFADD = 48, --物理减免加值
	SPECIALDEFADD = 49, --特伤减免加值
	GEMIZE = 50, --宝石化(无法行动，无法驱散，增加双防，可以触发回血触发技)
	DATAIZE = 51, --数据化(降低目标40%攻击、30%物防、30%特防，不可驱散，同一单位不可被重复数据化)
	GALACTRON = 52, --加拉特隆召唤
	PERCENTPHYSICALDEF = 53, --物防加值百分比
	PERCENTSPECIALDEF  = 54, --特防加值百分比
	GENECHANGE = 55, --基因篡改
	RINGFORCE  = 56, --光轮之力
	TRISHEEN   = 57, --三重光辉
	DODGEADD   = 58, --施放能量技额外消耗1点能量增加闪避率，至多消耗2点
	DOUBLE_DEF = 59, --双防加值百分比
	IMPRISON   = 60, --禁锢
	CRITDAMAGEFREEADD = 61, --暴伤减免（韧性）
	RESILENCE_ADD_WULA = 62, --乌拉专属抗暴
	SHININGSHANYAO  = 63,	 -- 光辉闪耀
	REVIVEALL  		= 64,	 -- 光辉赛罗群体复活，这个是给服务端战报用的
	ULTIMATEPARAGGI = 65,	 -- 光辉赛罗终极巴拉吉
	REDSTEELBREATH = 66, 	 -- 赤钢之息
	DARKSPELL = 67,	--暗之咒术
	LIGHT_EROSION = 68, --光明侵蚀
	HURT_RAISE_NOT_DISPEL = 69, --受伤率不可驱散
	HIT_ADD_NOT_DISPEL = 70, --命中率不可驱散
	CRIT_ADD_NOT_DISPEL = 71, --暴击率不可驱散
	CRITDAMAGE_ADD_NOT_DISPEL = 72, --暴击伤害不可驱散
	EXPERTISE_ADD_NOT_DISPEL  = 73, --破挡不可驱散
	EVASION_ADD_NOT_DISPEL = 74, --闪避不可驱散
	PARRY_ADD_NOT_DISPEL = 75, --格挡率不可驱散
	SOUL_IMMORTAL = 76, 	--亡魂不灭
	SPUTTERING = 77,	--溅射
	POWERADD_AND_COSMICMAN = 78, --给目标队伍成员增加能量，并且成员中的宇宙人角色额外再增加一次
	ABSOLUTE_POWER = 79, --绝对力量
	ADJUDICATION_END = 80, --裁决终焉
	CHAOS_OF_SOURCE = 81, --混沌之源
	PHOTON_SMASHING = 82, --光子粉碎
	POWER_OF_INHERIT = 83, --传承之力
	PERCENTFRIENDATK_EXT = 84, --每有一个队友攻击力百分比加值,附加条件：人数上限
	PERCENTFRIENDPHYDEF_EXT = 85, --每有一个队友物防百分比加值,附加条件：人数上限
	PERCENTFRIENDSPECDEF_EXT = 86, --每有一个队友特防百分比加值,附加条件：人数上限
	EXILE = 87,  --放逐
	IMPRISONMENT = 88, --囚禁
	POWERADD_ALL_MON_OR_MCH_AGAIN = 89, --给目标队伍成员增加能量，并且成员中的怪兽和机械角色额外再增加一次
	SPLIT_OF_DIE_YOUNG = 90, --分裂之殇
	DIMENSION_LIGHT = 91, --次元之光
	IDEA_CTRL = 92,  --意念操控
	SOUL_DEVOURING = 93, --噬魂
	TIME_WARP = 94, --时空扭曲
	SPACE_ADD_RATIO = 95, --空间增幅
	HURT_ADD_NOT_DISPEL = 96, --全伤增幅不可驱散
	HURT_FREE_NOT_DISPEL = 97, --全伤减免不可驱散
	LIMIT_SEALING = 98, --极限封印2
	NO_PHASE = 99, --无相
	PHANT_BEASTS_REALM = 100, --幻兽之界
	FLAME_PATTERN = 101, --火炎之纹
	ELECTRICITY = 102, --感电
	SHINING_STRIKE = 103,  --闪耀破击
	GOLDEN_TANG = 104,  --黄金气息
	
	
}

--异常状态
E_Anomaly = {
	--被动技能产生
	EA_LifeAdd 				= 1,         --生命加值
	EA_AttackAdd 			= 2,         --攻击加值
	EA_PhysicalDefAdd 		= 3,         --物防加值
	EA_SpecialDefAdd 		= 4,         --特防加值
	EA_FinalDamage 			= 5,         --最终伤害
	EA_InjuryFree 			= 6,         --最终免伤
	EA_CritRateAdd 			= 7,         --暴击率加值
	EA_CritDamageAdd 		= 8,         --暴击伤害加值
	EA_AntiknockCritAdd 	= 9,         --抗爆率加值
	EA_HitRateAdd 			= 10,         --命中率加值
	EA_DodgeRateAdd 		= 11,         --闪避率加值
	EA_BlockRateAdd 		= 12,         --格挡率加值
	EA_BrokenBlockRateAdd 	= 13,         --破挡率加值
	EA_DamageFreeAdd 		= 14,         --全伤减免加值
	EA_PhysicalFreeAdd 		= 15,         --物理减免加值
	EA_SpecialFreeAdd 		= 16,         --特伤减免加值
	EA_AllDamageAdd 		= 17,         --全伤加值
	EA_PhysicalDamageAdd 	= 18,         --物伤加值
	EA_SpecialDamageAdd 	= 19,         --特伤加值
	EA_TreatmentAdd 		= 20,         --治疗加值
	EA_GiddyImmune 			= 21,         --眩晕免疫
	EA_ChaosImmune 			= 22,         --混乱免疫
	EA_ReduceFuryImmune 	= 23,         --减少怒免疫
	EA_StopSkillImmune 		= 24,         --封技免疫
	EA_TreatmentSeal 		= 25,         --治疗封印
	-- EA_ProbabilityPoisoned	= 26,		  --概率毒
	-- EA_ProbabilityFire		= 27,		  --概率灼烧
	-- EA_ProbabilityGiddy 	= 28,         --概率晕
	-- EA_ProbabilityChaos 	= 29,         --概率混乱
	-- EA_ProbabilityStopSkill = 30,         --概率封技
	-- EA_RelieveAnomaly 		= 31,         --解除异常

	--技能产生
	EA_Giddy 				= 26, 		  --眩晕
	EA_Chaos 				= 27, 		  --混乱
	EA_StopSkill 			= 28, 		  --封技
	EA_Poisoned 			= 29, 		  --中毒
	EA_Fire 				= 30, 		  --灼烧
	EA_Defense 				= 31, 		  --防御
	EA_ReduceHurt			= 32,		  --免伤
	EA_RaiseHurt			= 33,		  --伤害
	EA_PowerAdd				= 34,		  --能量加值
	EA_FireImmune			= 35,		  --灼烧免疫
	EA_PoisonImmune			= 36,		  --中毒免疫
	EA_CritDamageFreeAdd	= 37,		  --暴击伤害减免加值
	EA_RelieveAnomaly 		= 38,         --解除异常
	EA_FollowUp				= 39,		  --追击
	EA_SuckHp				= 40,		  --吸血
	EA_PowerReduce			= 41,		  --能量减免
	EA_Dodge 				= 42,		  --闪避
	EA_Crit 				= 43,		  --暴击
	EA_Parry				= 44,		  --格挡
	EA_RecoveryHp			= 45,		  --恢复生命
	EA_TriggerSkill			= 46,		  --触发主动技能
	EA_Special 				= 47,		  --第二段能量技
	EA_PercentDamage		= 48,		  --承受伤害最大百分比（基于自己最大生命值）
	EA_PowerSkillBuffer		= 49,		  --第二段能量技伤害系数加值
	EA_Revive				= 50,		  --死亡复活
	EA_SpecialDefense 		= 51, 		  --免硬控绝对防御
	EA_PercentFriendAtk		= 52,		  --每有一个队友攻击力百分比加值
	EA_PercentFriendPhyDef	= 53,		  --每有一个队友物防百分比加值
	EA_PercentFriendSpecDef	= 54,		  --每有一个队友特防百分比加值
	EA_DamageTransfer		= 55,		  --伤害转移（帮队友承担伤害，实际是直接把目标替换）
	EA_FeignDeath			= 56,		  --诈死（受到致命伤害时，强制设置剩余血量）
	EA_Doll					= 57,		  --人偶标记（减少攻击力和双防御的百分比，三种属性减少的值为一致的）
	EA_RelieveDebuff 		= 58,         --解除Debuff（非毒、烧、眩晕、封技、眩晕、混乱）
	EA_Paraggi		 		= 59,         --帕拉吉之光（增加免伤和全伤加值）
	EA_SpatialReinforce		= 60,         --空间强化
	EA_SpatialWarp	 		= 61,         --空间扭曲
	EA_Transform			= 62,		  --切换形态，回满血量
	EA_HPMaxAdd				= 63,		  --血量上限加值
	EA_SpecialBuff			= 64,		  --特殊buff（用来配合【自身特殊buff X 次时】触发）
	EA_HPMaxPerDamage		= 65,		  --最大生命值百分比自残（回血或扣血，不修改上限，只能做常驻buff，在卡牌初始化时生效，其他地方不生效）
	EA_PhysicalImmune		= 66,		  --物理免疫
	EA_SpecialImmune		= 67,		  --特技免疫
	EA_TreatmentSealImmune	= 68,		  --重伤(治疗封印)免疫
	EA_GlassSeal			= 69,		  --镜之封印
	EA_Copypuppet			= 70,		  --复活傀儡(客户端读战报时使用 客户端战斗时不用这个)
	EA_RemoveAllBuff		= 71,		  --清除所有debuff+异常
	EA_DotAdd				= 72,		  --dot伤害增幅
	EA_OppoTeamAura			= 73,		  --敌方特定阵营洗脑
	EA_DamageFreeAddNoCap	= 74,		  --减免伤害(不计算cap值，区别于全伤减免)
	EA_Nibble	   			= 75,		  --恶意蚕食(奇美拉)
	EA_RelieveBuff	   		= 76,		  --解除增益buff
	EA_EndMark	   			= 77,		  --终结印记
	EA_Delay	   			= 78,		  --buff延迟生效
	EA_PercentAtk	   		= 79,		  --攻击加值百分比
	EA_PowerSkillImmune	   	= 80,		  --能量技免疫
	EA_Gemize				= 81,		  --宝石化
	EA_Dataize 				= 82, 		  --数据化
	EA_Galactron			= 83, 		  --加拉特隆召唤
	EA_EssenceMercyMark		= 84,	 	  --真谛之善
	EA_EssenceEvilMark		= 85,	 	  --真谛之恶
	EA_SupportOfForce		= 86,	 	  --应援之力
	EA_MindLinking			= 87,	 	  --心意连结
	EA_SOFAbsorbDamage		= 88,	 	  --将奥特曼阵营对自身的伤害转化为治疗
	EA_CreationShield		= 89,		  --创世屏障
	EA_PercentPhysicalDef	= 90,		  --物防百分比加值
	EA_PercentSpecialDef	= 91,		  --特防百分比加值
	EA_DarkForce			= 92,		  --暗黑原力
	EA_GeneChange			= 93,		  --基因篡改
	EA_EvilTemptation		= 94,		  --邪念蛊惑
	EA_SkillPowerUp			= 95,		  --技能伤害百分比提升
	EA_RedSteelForce		= 96,		  --赤钢之力（by捷德专属被动）
	EA_UltimateForce		= 97,		  --终极之力（同上）
	EA_DamageFreePercent    = 98,		  --减免技能伤害百分比提升
	EA_RingForce			= 99,		  --光轮之力
	EA_DataHacking			= 100,		  --数据入侵
	EA_TriPower				= 101,		  --三重能源
	EA_TriSheen				= 102,		  --三重光辉
	EA_DodgeAdd				= 103,		  --增加闪避
	EA_DoubleDefPer			= 104,		  --双防加值百分比
	EA_LifeLink				= 105,		  --生命链接
	EA_MyTeamAura			= 106,		  --狂暴化
	EA_GigaBattleNizer 		= 107,		  --终极战斗仪
	EA_DemonGene	 		= 108,		  --恶魔因子
	EA_ResentmentErosion	= 109,		  --怨念侵蚀
	EA_Imprison				= 110,		  --禁锢
	EA_AbsorbAtk			= 111,		  --吸取
	EA_DarkField			= 112,		  --黑暗领域
	EA_Explosion			= 113,		  --引爆
	EA_Possessed			= 114,		  --附身
	EA_Resonance			= 115,		  --共鸣
	EA_AntiknockCritAddWula = 116,        --乌拉专属抗爆率加值
	EA_ShiningShanyao		= 117,        --光辉赛罗 光辉闪耀
	EA_Awaking				= 118,        --光辉赛罗 唤醒
	EA_Reverse				= 119,        --光辉赛罗 逆转
	EA_UltimateParaggi		= 120,        --光辉赛罗 终极巴拉吉
	EA_ParaggiGuard			= 121,        --光辉赛罗 巴拉吉庇佑
	EA_UltimateLight		= 122,        --光辉赛罗 终极之光
	EA_AtomicCore			= 123, 		  --原子核心
	EA_Collapse				= 124,		  --崩坏
	EA_D4Energy				= 125,		  --D4能量
	EA_DieRuined			= 126, 		  --死之破败
	EA_Primarylight 		= 127,		  --原生之光
	EA_RedsteelBreath		= 128,		  --赤钢之息
	EA_MonsterCartri		= 129, 		  --怪兽弹夹
	EA_Darkspell			= 130, 		  --暗之咒术
	EA_DevourCurse			= 131,		  --吞噬诅咒
	EA_Shackles				= 132, 		  --束缚
	EA_LightErosion			= 133,		  --光明侵蚀
	EA_Balance				= 134,		  --平衡
	EA_LightdarkMark		= 135,		  --光暗之痕
	EA_TruthEnergy			= 136,		  --真理能量
	EA_RaiseHurtNotDispel   = 137,		  --受伤率不可驱散
	EA_HitRateAddNotDispel	= 138,		  --命中率不可驱散
	EA_CritRateAddNotDispel	= 139,        --暴击率不可驱散
	EA_CritDamageAddNotDispel = 140,	  --暴击伤害不可驱散
	EA_BrokenBlockRateAddNotDispel = 141, --破当率不可驱散
	EA_DodgeRateAddNotDispel = 142,       --闪避率不可驱散
	EA_BlockRateAddNotDispel = 143,       --格挡率不可驱散
	EA_SoulImmortal			= 144,		  --亡魂不灭
	EA_Appendage			= 145,		  --附体
	EA_SoulForm				= 146,	 	  --灵魂形态
	EA_AbsolutePower		= 147,		  --绝对力量
	EA_NalecPower			= 148,		  --纳拉克能量
	EA_AbsoluteForgive		= 149,		  --绝对宽恕
	EA_AbsoluteSanction		= 150,		  --绝对制衡
	EA_AbsoluteHeart		= 151,		  --绝对之心
	EA_AbuSoleutParticle	= 152,		  --阿布索留特粒子效果
	EA_SuckHpEqualDivide	= 153,		  --吸血并均分
	EA_AbsoluteAbyss		= 154,		  --绝对深渊
	EA_AdjudicationEnd		= 155, 		  --裁决终焉
	EA_RunTriggerSkillExtension = 156,	  --执行额外的触发技buff标记
	EA_ChaosOfSource		= 157,		  --混沌之源
	EA_DarkForceMaxValue	= 158,		  --用于永久记录暗黑原力的最大值,其他啥也不干,除非拥有此buff的角色死亡
	EA_DevourCurseMaxValue	= 159,		  --吞噬诅咒:用于记录达到最大层数时的主数值,此后层数变化不影响此值的变化
	EA_TruthNeverDie		= 160,		  --不灭真理
	EA_SpallingForce		= 161,		  --崩裂之力
	EA_PollutionSeal		= 162,		  --污染之章
	EA_G_Crystal			= 163,		  --G水晶
	EA_G_Crystal_Attack		= 164,		  --G水晶攻势
	EA_G_Crystal_Defend		= 165,		  --G水晶守备
	EA_PhotonSmashing		= 166,		  --光子粉碎
	EA_FireAndPoisonImmune	= 167, 		  --燃烧和中毒免疫合体
	EA_NewPowerOfRebirth	= 168,		  --新生代之力
	EA_PowerOfInherit		= 169,		  --传承之力
	EA_AutorHorn			= 170,		  --奥特之角
	EA_HoldOn				= 171,		  --招架
	EA_NewLightOfRebirth	= 172,		  --新生代之光
	EA_NewRallyOfRebirth	= 173,		  --新生代集结
	EA_TripleBarrier		= 174,		  --三重屏障
	EA_TripleSpark			= 175,		  --三重火花
	EA_PercentFriendAtkExt	= 176,		  --每有一个队友攻击力百分比加值,附加人数上限条件
	EA_PercentFriendPhyDefExt = 177,	  --每有一个队友物防百分比加值,附加人数上限条件
	EA_PercentFriendSpecDefExt = 178,	  --每有一个队友特防百分比加值,附加人数上限条件
	EA_Exile				= 179,		  --放逐
	EA_Imprisonment			= 180,		  --囚禁
	EA_HammerKing			= 181,		  --王者之锤
	EA_Gift					= 182,		  --恩赐
	EA_Blessing				= 183,		  --祝福
	EA_KingOfRoyalcrown		= 184,		  --王之冠冕
	EA_SplitOfDieYoung		= 185,		  --分裂之殇
	EA_Hollowing			= 186,		  --空翼
	EA_GroundFissure		= 187,		  --地裂
	EA_WishingMark			= 188,		  --愿痕
	EA_GreedSpirit			= 189,		  --贪欲之灵
	EA_NightmareWish		= 190,		  --噩愿
	EA_BoneCrushed			= 191,		  --骨碎
	EA_HardPalate			= 192,		  --裂颚
	EA_BoneShield			= 193,		  --骨盾
	EA_HopeOfRuby			= 194,		  --愿之红玉
	EA_DarkFieldExt			= 195,		  --黑暗领域额外buff效果
	EA_ElegyOfBeasts		= 196,		  --融合兽之哀歌
	EA_ShineStar			= 197,		  --耀星
	EA_DimensionLight		= 198,		  --次元之光
	EA_ShiningPower			= 199,		  --闪亮动力
	EA_StrengthPower		= 200,		  --强壮动力
	EA_MiraclesPower		= 201,		  --奇迹动力
	EA_UltraDoubleJudge		= 202,		  --奥特双重裁决
	EA_UltraDimension		= 203,		  --奥特次元
	EA_KeyOfTranscend		= 204,		  --超越之钥
	EA_ShieldAndSword		= 205,		  --德凯盾剑
	EA_SwordMode			= 206,		  --利剑模式
	EA_ShieldMode			= 207,		  --盾牌模式
	EA_LegendShined			= 208,		  --传说闪亮复合
	EA_DimensionForce		= 209,		  --次元之力
	EA_Demarches			= 210,		  --合纵连横
	EA_DemarchesExt			= 211,		  --<合纵连横-辅助buff:用于关联保存相关数据,避免全局变量>
	EA_TimeSpaceCrack		= 212,		  --时空裂痕
	EA_TimeSpaceJump		= 213,		  --时空跃迁
	EA_IdeaCtrl				= 214,		  --意念操控
	EA_Annihilate			= 215,		  --湮灭
	EA_SuperZhidunBarrier	= 216,		  --超级芝顿屏障
	EA_DeathOverture		= 217,		  --灭亡序曲
	EA_SoulDevouring		= 218,		  --噬魂
	EA_DistortAbyss			= 219,		  --扭曲深渊
	EA_CurseSuppress		= 220,		  --诅咒抑制
	EA_CurseSuppressExt		= 221,		  --诅咒抑制扩展数据
	EA_PowerZeda			= 222,		  --宙达之力
	EA_PowerMolde			= 223,		  --莫尔德之力
	EA_PowerGina			= 224,		  --吉娜之力
	EA_TimeWarp 			= 225, 		  --时空扭曲
	EA_SpaceAddRatio 		= 226, 		  --空间增幅
	EA_EmperorsPower		= 227,		  --帝王之威
	EA_SoulCursePressing	= 228,		  --灵咒制压
	EA_EnergyCore			= 229,		  --光辉能量核心
	EA_QuickRecover			= 230,		  --急速恢复
	EA_LimitFullOpen		= 231,		  --极限全开
	EA_NewExplosion			= 232,		  --新生代爆炸
	EA_NewDawn				= 233,		  --新生曙光
	EA_AllDamageAddNotDispel = 234,		  --全伤增幅不可驱散
	EA_DamageFreeAddNotDispel = 235,	  --全伤减免不可驱散
	EA_HellInflamation		= 236,		  --地狱烈炎
	EA_Infect				= 237,		  --侵染
	EA_LimitSealing			= 238,		  --极限封印2
	EA_NoPhase				= 239,		  --无相
	EA_PhantomBeastsRealm	= 240,		  --幻兽之界
	EA_FlyCrane				= 241,		  --飞翔之精鹤
	EA_FlameShock			= 242,		  --火炎之电击
	EA_FlamePattern			= 243,		  --火炎之纹
	EA_Electricity			= 244,		  --感电
	EA_FrozenLeopard		= 245,		  --高速冻豹
	EA_Frost				= 246,		  --冰冻
	EA_PhantomWaterSnake	= 247,		  --幻影之水蛇
	EA_WaterSnakeTwine		= 248,		  --幻影之缠
	EA_PhantomBeastOverlord = 249,		  --幻兽之霸王
	EA_PhantomBeastSource	= 250,		  --幻兽之源
	EA_PhantomBeastSourceEx	= 251,		  --幻兽之源辅助buff, 用于保存相关的数据
	EA_BigDipper			= 252,		  --天罡
	EA_GoldenBellProt		= 253,		  --金钟护体
	EA_ShiningStrike		= 254,		  --闪耀破击
	EA_GoldenTang			= 255,		  --黄金气息
	
	count                   = 256
};

--状态描述
--valueType 1为数值,0为状态
E_AnomalyDesc = {
	[E_Anomaly.EA_LifeAdd] 				= {name = "生命", icon = "hfsm", valueType = 1, desc = "生命%d。",},        
	[E_Anomaly.EA_AttackAdd] 			= {name = "攻击力", icon = "zjnl", valueType = 1, desc = "攻击力%d。",},          --攻击加值
	[E_Anomaly.EA_PhysicalDefAdd] 		= {name = "物理防御", icon = "fy", valueType = 1, desc = "物理防御%d。",},          --物防加值
	[E_Anomaly.EA_SpecialDefAdd] 		= {name = "特技类防御", icon = "fy", valueType = 1, desc = "特技类防御%d。",},          --特防加值
	[E_Anomaly.EA_FinalDamage] 			= {name = "最终伤害", icon = "zjsh", valueType = 1, desc = "最终伤害%d。",},          --最终伤害
	[E_Anomaly.EA_InjuryFree] 			= {name = "最终免伤", icon = "fy", valueType = 1, desc = "最终免伤%d。",},          --最终免伤
	[E_Anomaly.EA_CritRateAdd] 			= {name = "暴击", icon = "zjbj", valueType = 1, desc = "暴击几率%d%%。",},          --暴击率加值
	[E_Anomaly.EA_CritDamageAdd] 		= {name = "暴击伤害", icon = "zjbj", valueType = 1, desc = "暴击伤害%d%%。",},          --暴击伤害加值
	[E_Anomaly.EA_AntiknockCritAdd] 	= {name = "抗暴", icon = "zjbj", valueType = 1, desc = "抗暴几率%d%%。",},          --抗爆率加值
	[E_Anomaly.EA_HitRateAdd] 			= {name = "命中", icon = "zjmz", valueType = 1, desc = "命中几率%d%%。",},          --命中率加值
	[E_Anomaly.EA_DodgeRateAdd] 		= {name = "闪避", icon = "sanbi", valueType = 1, desc = "闪避几率%d%%。",},          --闪避率加值
	[E_Anomaly.EA_BlockRateAdd] 		= {name = "格挡", icon = "1zjpd", valueType = 1, desc = "格挡几率%d%%。",},          --格挡率加值
	[E_Anomaly.EA_BrokenBlockRateAdd] 	= {name = "破挡", icon = "zjpd", valueType = 1, desc = "破挡几率%d%%。",},          --破挡率加值
	[E_Anomaly.EA_DamageFreeAdd] 		= {name = "伤害减免", icon = "fy", valueType = 1, desc = "所有伤害减免%d%%。",},          --全伤减免加值
	[E_Anomaly.EA_PhysicalFreeAdd] 		= {name = "物伤减免", icon = "wsjm", valueType = 1, desc = "物理类伤害减免%d%%。",},          --物理减免加值
	[E_Anomaly.EA_SpecialFreeAdd] 		= {name = "特伤减免", icon = "tsjm", valueType = 1, desc = "特技类伤害减免%d%%。",},          --特伤减免加值
	[E_Anomaly.EA_AllDamageAdd] 		= {name = "伤害", icon = "fy", valueType = 1, desc = "所有伤害%d%%。",},          --全伤加值
	[E_Anomaly.EA_PhysicalDamageAdd] 	= {name = "物理伤害", icon = "zjsh", valueType = 1, desc = "物理类伤害%d%%。",},          --物伤加值
	[E_Anomaly.EA_SpecialDamageAdd] 	= {name = "特技类伤害", icon = "zjsh", valueType = 1, desc = "特技类伤害%d%%。",},          --特伤加值
	[E_Anomaly.EA_TreatmentAdd] 		= {name = "治疗加值", icon = "hfsm", valueType = 1, desc = "治疗生命值%d%%。",},          --治疗加值
	[E_Anomaly.EA_GiddyImmune] 			= {name = "眩晕免疫", icon = "zjnl", valueType = 0, desc =  "免受眩晕状态。",},          --眩晕免疫
	[E_Anomaly.EA_ChaosImmune] 			= {name = "混乱免疫", icon = "zjnl", valueType = 0, desc = "免受混乱状态。",},          --混乱免疫
	[E_Anomaly.EA_ReduceFuryImmune]		= {name = "减少怒气免疫", icon = "zjnl", valueType = 0, desc = "免受减少怒气状态。",},          --减少怒免疫
	[E_Anomaly.EA_StopSkillImmune] 		= {name = "封技免疫", icon = "zjnl", valueType = 0, desc = "免受封技状态。",},          --封技免疫
	[E_Anomaly.EA_TreatmentSeal] 		= {name = "治疗封印", icon = "zlfy", valueType = 0, desc = "治疗封印状态，该角色受到的治疗全部无效。",},          --治疗封印
	[E_Anomaly.EA_Giddy] 				= {name = "眩晕", icon = "xy", valueType = 0, desc = "眩晕状态，无法行动。"},  		  --眩晕
	[E_Anomaly.EA_Chaos] 				= {name = "混乱", icon = "hl", valueType = 0, desc = "混乱状态，行动时有一定几率对任意一名角色造成100%伤害。",},  		  --混乱
	[E_Anomaly.EA_StopSkill] 			= {name = "封技", icon = "fj", valueType = 0, desc = "封技状态，无法使用能量技。",},  		  --封技
	[E_Anomaly.EA_Poisoned] 			= {name = "中毒", icon = "du", valueType = 1, desc = "中毒状态，每次行动后受到施放者%d的特技伤害。",},  		  --中毒
	[E_Anomaly.EA_Fire] 				= {name = "灼烧", icon = "zs", valueType = 1, desc = "灼烧状态，每次行动后受到施放者%d的特技伤害。",},  		  --灼烧 		  --属性
	[E_Anomaly.EA_Defense] 				= {name = "无敌", icon = "fy", valueType = 0, desc = "无敌状态，最多受到1点伤害。",},  		  --防御
	[E_Anomaly.EA_ReduceHurt]    		= {name = "免伤", icon = "fy", valueType = 1, desc = "免伤%d%%。",},	--免伤
	[E_Anomaly.EA_RaiseHurt]    		= {name = "受伤", icon = "zjpd", valueType = 1, desc = "受伤%d%%。",},	--伤害
	[E_Anomaly.EA_PowerAdd] 			= {name = "怒气", icon = "zjnl", valueType = 1, desc = "怒气值%d。"},          --能量加值
	[E_Anomaly.EA_FireImmune] 			= {name = "灼烧免疫", icon = "zjnl", valueType = 0, desc = "免受灼烧状态。"},          --灼烧免疫
	[E_Anomaly.EA_PoisonImmune] 		= {name = "中毒免疫", icon = "zjnl", valueType = 0, desc = "免受中毒状态。"},          --中毒免疫
	[E_Anomaly.EA_CritDamageFreeAdd]	= {name = "暴击伤害减免", icon = "fy", valueType = 1, desc = "暴击伤害减免%d%%。",},	--暴击伤害减免加值
	[E_Anomaly.EA_RelieveAnomaly] 		= {name = "净化", icon = "cleansing", valueType = 1, desc = ""},          --解除异常
	[E_Anomaly.EA_FollowUp] 			= {name = "", icon = "", valueType = 1, desc = ""},          --追击
	[E_Anomaly.EA_SuckHp] 				= {name = "", icon = "", valueType = 1, desc = ""},          --吸血
	[E_Anomaly.EA_PowerReduce] 			= {name = "", icon = "", valueType = 1, desc = ""},          --减少能量
	[E_Anomaly.EA_Dodge] 				= {name = "", icon = "", valueType = 1, desc = ""},          --闪避
	[E_Anomaly.EA_Crit] 				= {name = "", icon = "", valueType = 1, desc = ""},          --暴击
	[E_Anomaly.EA_Parry] 				= {name = "", icon = "", valueType = 1, desc = ""},          --格挡
	[E_Anomaly.EA_RecoveryHp] 			= {name = "", icon = "", valueType = 1, desc = ""},          --恢复生命
	[E_Anomaly.EA_TriggerSkill] 		= {name = "", icon = "", valueType = 1, desc = ""},          --触发主动技能
	[E_Anomaly.EA_Special] 				= {name = "", icon = "", valueType = 1, desc = ""},          --
	[E_Anomaly.EA_PercentDamage] 		= {name = "", icon = "", valueType = 1, desc = ""},          --
	[E_Anomaly.EA_PowerSkillBuffer] 	= {name = "", icon = "", valueType = 1, desc = ""},          --
	[E_Anomaly.EA_Revive] 				= {name = "", icon = "", valueType = 1, desc = ""},          --
	[E_Anomaly.EA_SpecialDefense] 		= {name = "特殊防御", icon = "fy", valueType = 0, desc = "无敌状态，最多受到1点伤害，并且免疫眩晕，封技和混乱。",},  		  --防御
	[E_Anomaly.EA_PercentFriendAtk]		= {name = "攻击百分比", icon = "aotezhijiao", valueType = 1, desc = "攻击百分比共%d%%",},  		  --每有一个队友攻击力百分比加值
	[E_Anomaly.EA_PercentFriendPhyDef]	= {name = "物防百分比", icon = "aotezhijiao", valueType = 1, desc = "物防百分比共%d%%",},		  --每有一个队友物防百分比加值
	[E_Anomaly.EA_PercentFriendSpecDef]	= {name = "特防百分比", icon = "aotezhijiao", valueType = 1, desc = "特防百分比共%d%%",},		  --每有一个队友特防百分比加值
	[E_Anomaly.EA_DamageTransfer]		= {name = "伤害转移", icon = "bihu", valueType = 0, desc = "下次受击受到保护",},		  --伤害转移（帮队友承担伤害，实际是直接把目标替换）
	[E_Anomaly.EA_FeignDeath] 			= {name = "", icon = "", valueType = 1, desc = ""},          --诈死（受到致命伤害时，强制设置剩余血量）
	[E_Anomaly.EA_Doll] 				= {name = "人偶标记", icon = "renou", valueType = 1, desc = "攻击力和双防%d%%"},          --人偶标记（减少攻击力和双防御的百分比，三种属性减少的值为一致的）
	[E_Anomaly.EA_RelieveDebuff]		= {name = "驱散", icon = "qusan", valueType = 1, desc = ""},          --解除Debuff（非毒、烧、眩晕、封技、眩晕、混乱）
	[E_Anomaly.EA_Paraggi]				= {name = "巴拉吉之光", icon = "plj", valueType = 1, desc = "免伤和所有伤害%d%%"},          --帕拉吉之光（增加免伤和全伤加值）
	[E_Anomaly.EA_SpatialReinforce]		= {name = "空间强化", icon = "kjqh", valueType = 1, desc = "伤害%d%%"},          --帕拉吉之光（增加免伤和全伤加值）
	[E_Anomaly.EA_SpatialWarp]			= {name = "空间扭曲", icon = "kjnq", valueType = 1, desc = "伤害%d%%"},          --帕拉吉之光（增加免伤和全伤加值）
	[E_Anomaly.EA_Transform]			= {name = "", icon = "", valueType = 1, desc = ""},          --切换形态，回满血量
	[E_Anomaly.EA_HPMaxAdd]				= {name = "", icon = "", valueType = 1, desc = ""},          --血量上限加值
	[E_Anomaly.EA_SpecialBuff]			= {name = "", icon = "", valueType = 1, desc = ""},          --特殊buff（用来配合【自身特殊buff X 次时】触发）
	[E_Anomaly.EA_HPMaxPerDamage]		= {name = "", icon = "", valueType = 1, desc = ""},          --最大生命值百分比自残（回血或扣血，不修改上限，只能做常驻buff，在卡牌初始化时生效，其他地方不生效）
	[E_Anomaly.EA_PhysicalImmune]		= {name = "物理免疫", icon = "fy", valueType = 0, desc = "物理免疫，最多受到1点物理伤害"},          --物理免疫
	[E_Anomaly.EA_SpecialImmune]		= {name = "特技免疫", icon = "fy", valueType = 0, desc = "特技免疫，最多受到1点特技伤害"},          --特技免疫
	[E_Anomaly.EA_TreatmentSealImmune]	= {name = "重伤免疫", icon = "zjnl", valueType = 0, desc = "免受重伤状态"},          --重伤(治疗封印)免疫
	[E_Anomaly.EA_GlassSeal]			= {name = "镜之封印", icon = "jzfy", valueType = 0, desc = "重伤时受到主动治疗效果，受伤率提高40%，持续2回合。"},          --镜之封印
	[E_Anomaly.EA_RemoveAllBuff]		= {name = "驱散", icon = "", valueType = 1, desc = ""},          --清除所有debuff+异常
	[E_Anomaly.EA_DotAdd]				= {name = "dot增幅", icon = "ds", valueType = 1, desc = "毒烧伤害%d%%"},          --dot伤害增幅
	[E_Anomaly.EA_OppoTeamAura]			= {name = "洗脑", icon = "xn", valueType = 0, desc = "一定概率将指定阵营对自身的伤害转化为治疗"},          --敌方特定阵营洗脑
	[E_Anomaly.EA_DamageFreeAddNoCap]	= {name = "伤害减免2", icon = "fy", valueType = 1, desc = "少承受%d%%伤害。不计入全伤减免"},          --减免伤害(不计算cap值，区别于全伤减免)
	[E_Anomaly.EA_Nibble]				= {name = "恶意蚕食", icon = "eycs", valueType = 1, desc = "当前%d层, 攻击力/所有防御/闪避率/命中率/韧性%d%%"},          --恶意蚕食
	[E_Anomaly.EA_RelieveBuff]			= {name = "驱散", icon = "qusan", valueType = 1, desc = ""},          --解除增益buff
	[E_Anomaly.EA_EndMark]				= {name = "终结印记", icon = "zjyj", valueType = 1, desc = "%d层"},          --终结印记
	[E_Anomaly.EA_Delay]				= {name = "极限封印", icon = "jxfy", valueType = 0, desc = "增益失效，重新获得的增益也视同失效"},          --终结印记
	[E_Anomaly.EA_PercentAtk]			= {name = "攻击百分比", icon = "zjnl", valueType = 1, desc = "攻击百分比%d%%",},  		  --攻击力百分比加值
	[E_Anomaly.EA_PowerSkillImmune]		= {name = "能量技免疫", icon = "fy", valueType = 1, desc = "%d%%能量技免疫",},  		  --能量技免疫
	[E_Anomaly.EA_Gemize]		        = {name = "宝石化", icon = "bsh", valueType = 0, desc = "无法行动,防御力增加",},  		  --宝石化
	[E_Anomaly.EA_Dataize]		        = {name = "数据化", icon = "sjh", valueType = 1, desc = "攻击防御%d%%",},  		  --数据化
	[E_Anomaly.EA_EssenceMercyMark]		= {name = "真谛之善", icon = "zdzs", valueType = 1, desc = "异常抗性增加%d%%",},     --真谛之善
	[E_Anomaly.EA_EssenceEvilMark]		= {name = "真谛之恶", icon = "zdze", valueType = 1, desc = "异常抗性%d%%",},     --真谛之恶
	[E_Anomaly.EA_SupportOfForce]		= {name = "应援之力", icon = "yyzl", valueType = 1, desc = "全伤减免/抗暴率/韧性/格挡率/闪避率+%d%%",},     --应援之力
	[E_Anomaly.EA_MindLinking]			= {name = "心意连结", icon = "xylj", valueType = 0, desc = "心意连结,普通技攻击后追加一次普通技",},     	--心意连结
	[E_Anomaly.EA_SOFAbsorbDamage]		= {name = "真谛之力", icon = "zdzl", valueType = 0, desc = "一定概率将奥特曼阵营角色对自身的伤害转化为治疗",},     --应援之力
	[E_Anomaly.EA_CreationShield]		= {name = "创世屏障", icon = "zjbj", valueType = 1, desc = "将所受伤害值的%d%%转化为最终伤害,当前增加%d",},     --创世屏障
	[E_Anomaly.EA_PercentPhysicalDef]	= {name = "物防百分比", icon = "zjnl", valueType = 1, desc = "物防百分比共%d%%",},     --物防百分比加值
	[E_Anomaly.EA_PercentSpecialDef]	= {name = "特防百分比", icon = "zjnl", valueType = 1, desc = "特防百分比共%d%%",},     --特防百分比加值
	[E_Anomaly.EA_DarkForce]			= {name = "暗黑原力", icon = "ahyl", valueType = 1, desc = "破挡率/命中率/暴击率/暴击伤害/攻击力%d%%, 当前%d层",},     --破挡率/命中率/暴击率/暴击伤害/攻击力百分比加值
	[E_Anomaly.EA_GeneChange]			= {name = "基因篡改", icon = "jycg", valueType = 1, desc = "暴击率/全伤增幅%d%%",},     --暴击率/伤害百分比加值
	[E_Anomaly.EA_EvilTemptation]		= {name = "邪念之种", icon = "xnzz", valueType = 0, desc = "免疫<眩晕>、<混乱>",},   --免疫<眩晕>、<混乱>
	[E_Anomaly.EA_SkillPowerUp]			= {name = "技伤增幅", icon = "zjnl", valueType = 1, desc = "技伤增幅%d%%",},   --技能伤害百分比提升
	[E_Anomaly.EA_RedSteelForce]		= {name = "赤钢之力", icon = "cgwy", valueType = 1, desc = "格挡率/抗暴率%d%%",},   --赤钢之力（by捷德专属被动）
	[E_Anomaly.EA_UltimateForce]		= {name = "终极之力", icon = "zjzl", valueType = 1, desc = "攻击力/暴击率/破挡率/命中率%d%%",},   --终极之力（同上）
	[E_Anomaly.EA_DamageFreePercent]	= {name = "技伤减免", icon = "zjnl", valueType = 1, desc = "技伤减免%d%%",},   --减免技能伤害百分比提升
	[E_Anomaly.EA_RingForce]			= {name = "光轮羁绊之力", icon = "gljb", valueType = 1, desc = "韧性/免伤率/暴击率/暴击伤害/攻击力%d%%",},   --光轮羁绊之力
	[E_Anomaly.EA_DataHacking]		    = {name = "数据入侵", icon = "sjqr", valueType = 1, desc = "攻击力/物理防御/特技防御%d%%",},--数据入侵
	[E_Anomaly.EA_TriPower]		    	= {name = "能源", icon = "ny", valueType = 1, desc = "抗暴%d%%",},--三重能源
	[E_Anomaly.EA_TriSheen]		    	= {name = "三重光辉", icon = "scgh", valueType = 0, desc = "获得三重光辉效果",},--三重光辉
	[E_Anomaly.EA_DodgeAdd] 			= {name = "闪避", icon = "sanbi", valueType = 1, desc = "闪避几率%d%%。",},          --闪避率加值
	[E_Anomaly.EA_DoubleDefPer]		 	= {name = "双防加值百分比", icon = "zjnl", valueType = 1, desc = "物理和特技防御%d%%",},     --双防百分比加值
	[E_Anomaly.EA_LifeLink]		 		= {name = "雷杰多屏障", icon = "ljdpz", valueType = 0, desc = "获得生命链接效果",},     --获得生命链接效果
	[E_Anomaly.EA_MyTeamAura]		 	= {name = "狂暴化", icon = "xn", valueType = 1, desc = "命中率/破挡率/暴击率/暴击伤害/全伤增幅%d%%",},     --获得狂暴化效果
	[E_Anomaly.EA_GigaBattleNizer]		= {name = "终极战斗仪", icon = "zjzdy", valueType = 0, desc = "获得终极战斗仪效果",},     --获得终极战斗仪效果
	[E_Anomaly.EA_DemonGene]			= {name = "恶魔因子", icon = "emyz", valueType = 0, desc = "受到控制类异常时消耗一层使该效果无效",},     --获得恶魔因子效果
	[E_Anomaly.EA_ResentmentErosion]	= {name = "怨念侵蚀", icon = "ynqs", valueType = 1, desc = "获得怨念侵蚀效果，当前%d层",},     --获得怨念侵蚀效果
	[E_Anomaly.EA_Imprison]				= {name = "禁锢", icon = "jingu", valueType = 0, desc = "禁锢状态，目标无法行动，无法受到治疗效果",},     --禁锢
	[E_Anomaly.EA_AbsorbAtk]			= {name = "吸取", icon = "xiqu", valueType = 1, desc = "当前吸取的攻击力%d",},     --吸取
	[E_Anomaly.EA_DarkField]			= {name = "邪神黑暗领域", icon = "xshaly", valueType = 1, desc = "获得<邪神黑暗领域>效果。技伤增幅/技伤减免%d%%，持续%d回合。",},     --邪神黑暗领域
	[E_Anomaly.EA_Explosion]			= {name = "", icon = "", valueType = 1, desc = "",},   --引爆
	[E_Anomaly.EA_Possessed]			= {name = "附身", icon = "fushen", valueType = 1, desc = "攻击力/物理防御/特技防御%s%d%%，当前护盾值%d",},     --附身
	[E_Anomaly.EA_Resonance]			= {name = "共鸣", icon = "gongming", valueType = 0, desc = "当任意一方恢复生命时，为另外一方恢复生命值",},     --共鸣
	[E_Anomaly.EA_AntiknockCritAddWula] = {name = "抗暴率-不可驱散", icon = "zjbj", valueType = 1, desc = "抗暴几率%d%%。",},          --抗暴率加值
	[E_Anomaly.EA_ShiningShanyao] 		= {name = "光辉闪耀", icon = "ghsy", valueType = 1, desc = "技伤增幅/技伤减免%d%%。",},
	[E_Anomaly.EA_Awaking] 				= {name = "唤醒", icon = "huanxing", valueType = 0, desc = "获得唤醒效果",},
	[E_Anomaly.EA_Reverse] 				= {name = "逆转", icon = "nizhuan", valueType = 1, desc = "逆转概率%d%%",},
	[E_Anomaly.EA_UltimateParaggi] 		= {name = "终极巴拉吉", icon = "zjblj", valueType = 1, desc = "攻击力/闪避率/命中率%d%%",},
	[E_Anomaly.EA_ParaggiGuard] 		= {name = "巴拉吉庇佑", icon = "bljdby", valueType = 1, desc = "闪避率/韧性/所有防御%d%%, 剩余免疫次数%d次",},
	[E_Anomaly.EA_UltimateLight] 		= {name = "终极之光", icon = "zjzg", valueType = 1, desc = "破挡率/命中率/暴击率/攻击力/暴击伤害%d%%",},
	[E_Anomaly.EA_AtomicCore] 			= {name = "原子核心", icon = "yzhx", valueType = 1, desc = "攻击力/所有防御/格挡率/命中率/全伤减免%s%d%%",},
	[E_Anomaly.EA_Collapse] 			= {name = "崩坏", icon = "benghuai", valueType = 1, desc = "受到的最终治疗效果%d%%,视同<重伤>效果",},
	[E_Anomaly.EA_D4Energy] 			= {name = "D4能量", icon = "D4nl", valueType = 1, desc = "格挡率/抗暴率%d%%",},
	[E_Anomaly.EA_DieRuined] 			= {name = "死之破败", icon = "szpb", valueType = 0, desc = "治疗效果%s%d%%，防御%s%d%%",},
	[E_Anomaly.EA_Primarylight] 		= {name = "原生之光", icon = "yszg", valueType = 1, desc = "攻击力%d%%",},
	[E_Anomaly.EA_RedsteelBreath] 		= {name = "赤钢之息", icon = "cgzx", valueType = 0, desc = "视同<重伤>效果",},
	[E_Anomaly.EA_MonsterCartri]		= {name = "怪兽弹夹", icon = "gsdj", valueType = 1, desc = "所有异常增幅%d%%",},
	[E_Anomaly.EA_Darkspell]			= {name = "暗之咒术", icon = "azzs", valueType = 1, desc = "使目标攻击力降低%d%%，受伤率提高%d%%",},
	[E_Anomaly.EA_DevourCurse]			= {name = "吞噬诅咒", icon = "tszz", valueType = 0, desc = "降低目标所有异常抗性%d%%，当叠加到3层时会转化为束缚",},
	[E_Anomaly.EA_Shackles]				= {name = "束缚", icon = "shufu", valueType = 0, desc = "目标无法触发闪避类的反击技与治疗技",},
	[E_Anomaly.EA_LightErosion]			= {name = "光明侵蚀", icon = "gmqs", valueType = 1, desc = "闪避率/韧性%d%%",},
	[E_Anomaly.EA_Balance]				= {name = "平衡", icon = "pingheng", valueType = 1, desc = "当前增加%s%d；当前增加攻击力%d。",},
	[E_Anomaly.EA_LightdarkMark]		= {name = "光暗之痕", icon = "gazh", valueType = 0, desc = "获得<光暗之痕>效果",},
	[E_Anomaly.EA_TruthEnergy]			= {name = "真理计时器能量", icon = "zljsqnl", valueType = 1, desc = "获得<真理计时器能量>效果,当前能量值%d",},
	[E_Anomaly.EA_RaiseHurtNotDispel]   = {name = "受伤率-不可驱散", icon = "zjpd", valueType = 1, desc = "受伤%d%%。",},		--受伤率不可驱散
	[E_Anomaly.EA_HitRateAddNotDispel]	= {name = "命中率-不可驱散", icon = "zjmz", valueType = 1, desc = "命中几率%d%%。",},   --命中率不可驱散
	[E_Anomaly.EA_CritRateAddNotDispel]	= {name = "暴击率-不可驱散", icon = "zjbj", valueType = 1, desc = "暴击几率%d%%。",},   --暴击率不可驱散
	[E_Anomaly.EA_CritDamageAddNotDispel] = {name = "暴击伤害-不可驱散", icon = "zjbj", valueType = 1, desc = "暴击伤害%d%%。",},  --暴击伤害不可驱散
	[E_Anomaly.EA_BrokenBlockRateAddNotDispel] = {name = "破挡-不可驱散", icon = "zjpd", valueType = 1, desc = "破挡几率%d%%。",}, --破挡率不可驱散
	[E_Anomaly.EA_DodgeRateAddNotDispel] = {name = "闪避-不可驱散", icon = "sanbi", valueType = 1, desc = "闪避几率%d%%。",},    --闪避率不可驱散
	[E_Anomaly.EA_BlockRateAddNotDispel] = {name = "格挡-不可驱散", icon = "1zjpd", valueType = 1, desc = "格挡几率%d%%。",},    --格挡率不可驱散
	[E_Anomaly.EA_SoulImmortal] 		= {name = "亡魂不灭", icon = "whbm", valueType = 1, desc = "闪避率/暴击率/抗暴率%d%%",},
	[E_Anomaly.EA_Appendage] 			= {name = "附体", icon = "futi", valueType = 1, desc = "%s攻击力/物理防御/特技防御%d%%；%s护盾值%d",}, --附体
	[E_Anomaly.EA_SoulForm] 			= {name = "灵魂形态", icon = "lhxt", valueType = 0, desc = "免疫物理和特技伤害，免疫减益状态和异常效果",}, --灵魂形态
	[E_Anomaly.EA_AbsolutePower] 		= {name = "绝对力量", icon = "jdll", valueType = 1, desc = "技伤增幅%d%%",}, --绝对力量
	[E_Anomaly.EA_NalecPower] 			= {name = "纳拉克能量", icon = "nlknl", valueType = 1, desc = "攻击力%d%%",}, --维拉克能量
	[E_Anomaly.EA_AbsoluteForgive] 		= {name = "绝对宽恕", icon = "jdks", valueType = 1, desc = "攻击力/全伤增幅/暴击伤害/闪避率/所有防御%d%%",}, --绝对宽恕
	[E_Anomaly.EA_AbsoluteSanction] 	= {name = "绝对制衡", icon = "jdzh", valueType = 1, desc = "目标格挡率和闪避率%d%%",}, --绝对制衡
	[E_Anomaly.EA_AbsoluteHeart] 		= {name = "绝对之心", icon = "jdzx", valueType = 0, desc = "获得<绝对之心>效果",}, --绝对之心
	[E_Anomaly.EA_AbuSoleutParticle] 	= {name = "阿布索留特粒子", icon = "absltlz", valueType = 1, desc = "获得<阿布索留特粒子>效果，当前护盾值%d",}, --阿布索留特粒子
	[E_Anomaly.EA_SuckHpEqualDivide] 	= {name = "", icon = "", valueType = 1, desc = "",}, --吸血并均分
	[E_Anomaly.EA_AbsoluteAbyss] 		= {name = "绝对深渊", icon = "jdsy", valueType = 1, desc = "获得<绝对深渊>效果",}, --绝对深渊
	[E_Anomaly.EA_AdjudicationEnd] 		= {name = "裁决终焉", icon = "cjzy", valueType = 1, desc = "受到的治疗效果%s%d%%，无法获得增益状态",}, --裁决终焉
	[E_Anomaly.EA_RunTriggerSkillExtension] = {name = "", icon = "", valueType = 1, desc = "",}, --执行额外的触发技buff标记
	[E_Anomaly.EA_ChaosOfSource] 		= {name = "混沌之源", icon = "hdzy", valueType = 1, desc = "暴击率/暴击伤害%s%%",}, --混沌之源
	[E_Anomaly.EA_DarkForceMaxValue] = {name = "", icon = "", valueType = 1, desc = "",}, --用于永久记录暗黑原力的最大值,其他啥也不干,除非拥有此buff的角色死亡
	[E_Anomaly.EA_DevourCurseMaxValue] = {name = "", icon = "", valueType = 1, desc = "",}, --吞噬诅咒:用于记录达到最大层数时的主数值,此后层数变化不影响此值的变化
	[E_Anomaly.EA_TruthNeverDie] 		= {name = "不灭真理", icon = "bmzl", valueType = 1, desc = "格挡率/抗暴率%s%d%%",}, --不灭真理
	[E_Anomaly.EA_SpallingForce] 		= {name = "崩裂之力", icon = "blzl", valueType = 1, desc = "破挡率/命中率%s%d%%",}, --崩裂之力
	[E_Anomaly.EA_PollutionSeal] 		= {name = "污染之章", icon = "wrzz", valueType = 1, desc = "受到额外%d%%的伤害&&增加%d%%的攻击力和暴击伤害",}, --污染之章
	[E_Anomaly.EA_G_Crystal] 			= {name = "G水晶", icon = "Gshuijing", valueType = 1, desc = "自身攻击力%d%%, 且可获得G水晶攻势和G水晶守备效果",}, --G水晶
	[E_Anomaly.EA_G_Crystal_Attack] 	= {name = "G水晶攻势", icon = "Gsjgs", valueType = 1, desc = "攻击力/暴击伤害%d%%",}, --G水晶攻势
	[E_Anomaly.EA_G_Crystal_Defend] 	= {name = "G水晶守备", icon = "Gsjsb", valueType = 1, desc = "所有防御/韧性%d%%",}, --G水晶守备
	[E_Anomaly.EA_PhotonSmashing] 		= {name = "光子粉碎", icon = "gzfs", valueType = 1, desc = "受伤率%d%%,额外受到一次真实伤害",}, --光子粉碎
	[E_Anomaly.EA_FireAndPoisonImmune]	= {name = "免疫中毒和燃烧", icon = "zjnl", valueType = 0, desc = "免疫<中毒>和<燃烧>效果"}, --免疫中毒和燃烧
	[E_Anomaly.EA_NewPowerOfRebirth]	= {name = "新生代之力", icon = "xsdzl", valueType = 1, desc = "攻击力%d%%"}, --新生代之力
	[E_Anomaly.EA_PowerOfInherit]		= {name = "传承之力", icon = "cczl", valueType = 1, desc = "攻击力/暴击率/暴击伤害/所有防御/格挡率%d%%"}, --传承之力
	[E_Anomaly.EA_AutorHorn]			= {name = "奥特之角", icon = "ljatzj", valueType = 1, desc = "格挡率/暴击率/抗暴率%d%%"}, --奥特之角
	[E_Anomaly.EA_HoldOn]				= {name = "招架", icon = "zhaojia", valueType = 1, desc = "招架概率%d%%"}, --招架
	[E_Anomaly.EA_NewLightOfRebirth]	= {name = "新生代之光", icon = "xsdzg", valueType = 1, desc = "当前%d层；当前累积伤害%d；当前增加攻击力%d%%"}, --新生代之光
	[E_Anomaly.EA_NewRallyOfRebirth]	= {name = "新生代集结", icon = "xsdjj", valueType = 1, desc = "获得<新生代集结>效果; 获得免疫<眩晕>效果。&&获得<新生代集结>效果;当前免疫<眩晕>效果概率%d%%"}, --新生代集结
	[E_Anomaly.EA_TripleBarrier]		= {name = "三重屏障", icon = "scpz", valueType = 1, desc = "技伤减免/全伤减免/抗暴率%d%%"}, --三重屏障
	[E_Anomaly.EA_TripleSpark]			= {name = "三重火花", icon = "schh", valueType = 1, desc = "技伤增幅/全伤增幅/暴击率%d%%。&&免疫<减能>效果，对自身施加<封技>效果"}, --三重火花
	[E_Anomaly.EA_PercentFriendAtkExt]	= {name = "攻击百分比", icon = "aotezhijiao", valueType = 1, desc = "攻击百分比共%d%%,至多生效4名队友",},   --每有一个队友攻击力百分比加值,附带人数限制条件
	[E_Anomaly.EA_PercentFriendPhyDefExt] = {name = "物防百分比", icon = "aotezhijiao", valueType = 1, desc = "物防百分比共%d%%,至多生效4名队友",},	--每有一个队友物防百分比加值,附带人数限制条件
	[E_Anomaly.EA_PercentFriendSpecDefExt]= {name = "特防百分比", icon = "aotezhijiao", valueType = 1, desc = "特防百分比共%d%%,至多生效4名队友",},	--每有一个队友特防百分比加值,附带人数限制条件
	[E_Anomaly.EA_Exile] 				= {name = "放逐", icon = "fangzhu", valueType = 0, desc = "无法行动，无法获得增益状态，仅可触发治疗类触发技和专属类触发技",},	--放逐
	[E_Anomaly.EA_Imprisonment]			= {name = "囚禁", icon = "qiujin", valueType = 1, desc = "受到的治疗效果%s%d%%，无法获得增益状态，仅可触发治疗类触发技和专属类触发技",}, --囚禁
	[E_Anomaly.EA_HammerKing]			= {name = "王者之锤", icon = "wzzc", valueType = 1, desc = "攻击力/所有防御/技伤减免%d%%",}, --王者之锤	
	[E_Anomaly.EA_Gift]					= {name = "恩赐", icon = "enci", valueType = 0, desc = "获得<恩赐>效果",}, --恩赐
	[E_Anomaly.EA_Blessing]				= {name = "祝福", icon = "zhufu", valueType = 0, desc = "获得<祝福>效果",}, --祝福
	[E_Anomaly.EA_KingOfRoyalcrown]		= {name = "王之冠冕", icon = "wzgm", valueType = 1, desc = "当前护盾值%d",}, --王之冠冕
	[E_Anomaly.EA_SplitOfDieYoung]		= {name = "分裂之殇", icon = "flzs", valueType = 1, desc = "毒烧伤害增幅/所有异常增幅%d%%",}, --分裂之殇
	[E_Anomaly.EA_Hollowing]			= {name = "空翼", icon = "kongyi", valueType = 1, desc = "攻击力%d%%",}, --空翼
	[E_Anomaly.EA_GroundFissure]		= {name = "地裂", icon = "dilie", valueType = 1, desc = "生命值%d%%",}, --地裂
	[E_Anomaly.EA_WishingMark]			= {name = "愿痕", icon = "yuanhen", valueType = 1, desc = "暴击率%d%%",}, --愿痕
	[E_Anomaly.EA_GreedSpirit]			= {name = "贪欲之灵", icon = "tyzl", valueType = 1, desc = "攻击力/所有防御/命中率/抗暴率/韧性%d%%",}, --贪欲之灵
	[E_Anomaly.EA_NightmareWish]		= {name = "噩愿", icon = "eyuan", valueType = 0, desc = "受主动技攻击时叠加<骨碎>效果",}, --噩愿
	[E_Anomaly.EA_BoneCrushed]			= {name = "骨碎", icon = "gusui", valueType = 1, desc = "攻击力/所有防御%s%d%%, 当前骨碎%d层",}, --骨碎
	[E_Anomaly.EA_HardPalate]			= {name = "裂颚", icon = "liee", valueType = 1, desc = "技伤增幅/技伤减免%d%%, 回合开始时受到伤害",}, --裂颚
	[E_Anomaly.EA_BoneShield]			= {name = "骨盾", icon = "gudun", valueType = 1, desc = "造成的非暴击伤害增加/受到的非暴击伤害减少%d%%",}, --骨盾
	[E_Anomaly.EA_HopeOfRuby]			= {name = "愿之红玉", icon = "yzhy", valueType = 1, desc = "获得<愿之红玉>效果, 当前储存值%d",}, --愿之红玉
	[E_Anomaly.EA_DarkFieldExt]			= {name = "", icon = "", valueType = 1, desc = "",}, --黑暗领域额外buff效果
	[E_Anomaly.EA_ElegyOfBeasts]		= {name = "融合兽之哀歌", icon = "rhszag", valueType = 1, desc = "攻击力%d%%",}, --融合兽之哀歌
	[E_Anomaly.EA_ShineStar]			= {name = "耀星", icon = "yaoxing", valueType = 0, desc = "获得<耀星>效果",}, --耀星
	[E_Anomaly.EA_DimensionLight]		= {name = "次元之光", icon = "cyzg", valueType = 0, desc = "获得<次元之光>效果",}, --次元之光
	[E_Anomaly.EA_ShiningPower]			= {name = "闪亮之力", icon = "slzl", valueType = 1, desc = "受到的治疗效果/全伤减免%d%%",}, --闪亮动力
	[E_Anomaly.EA_StrengthPower]		= {name = "强壮之力", icon = "qzzl", valueType = 1, desc = "格挡率/破挡率%d%%",}, --强壮动力
	[E_Anomaly.EA_MiraclesPower]		= {name = "奇迹之力", icon = "qjzl", valueType = 1, desc = "闪避率/命中率%d%%",}, --奇迹动力
	[E_Anomaly.EA_UltraDoubleJudge]		= {name = "奥特双重裁决", icon = "atsccj", valueType = 0, desc = "根据能量奇数或偶数的不同，分别触发不同效果",}, --奥特双重裁决
	[E_Anomaly.EA_UltraDimension]		= {name = "德凯-奥特次元", icon = "dkatcy", valueType = 1, desc = "2=攻击力,8=暴击伤害,17=全伤增幅,95=技伤增幅",}, --德凯-奥特次元
	[E_Anomaly.EA_KeyOfTranscend]		= {name = "特利迦-超越之钥", icon = "tljcyzy", valueType = 1, desc = "3=所有防御,37=韧性,14=全伤减免,98=技伤减免",}, --特利迦-超越之钥
	[E_Anomaly.EA_ShieldAndSword]		= {name = "德凯盾剑", icon = "dkdj", valueType = 1, desc = "攻击力/所有防御%d%%。当前积攒伤害%d",}, --德凯盾剑
	[E_Anomaly.EA_SwordMode]			= {name = "利剑模式", icon = "ljms", valueType = 1, desc = "最终暴击率%d%%。当前增加物理防御和特技防御%d",}, --利剑模式
	[E_Anomaly.EA_ShieldMode]			= {name = "盾牌模式", icon = "dpms", valueType = 1, desc = "最终抗暴率%d%%。当前增加攻击力%d",}, --盾牌模式
	[E_Anomaly.EA_LegendShined]			= {name = "传说复合闪亮", icon = "csfhsl", valueType = 0, desc = "获得<传说复合闪亮>效果",}, --传说复合闪亮
	[E_Anomaly.EA_DimensionForce]		= {name = "次元之力", icon = "cyzl", valueType = 1, desc = "当前%d层,技伤增幅/全伤增幅%s%d%%,免疫<眩晕>效果,免疫所有控制效果",}, --次元之力
	[E_Anomaly.EA_Demarches]			= {name = "合纵连横", icon = "hzlh", valueType = 0, desc = "获得<合纵连横>效果",}, --合纵连横
	[E_Anomaly.EA_DemarchesExt]			= {name = "", icon = "", valueType = 1, desc = "",}, --合纵连横:辅助buff
	[E_Anomaly.EA_TimeSpaceCrack]		= {name = "时空裂痕", icon = "sklh", valueType = 1, desc = "当前%s暴击率%d%%; %s所有异常抗性%d%%",}, --时空裂痕
	[E_Anomaly.EA_TimeSpaceJump]		= {name = "时空跃迁", icon = "skyq", valueType = 1, desc = "免疫<眩晕>效果。当前暴击率/抗暴率%s%d%%",}, --时空跃迁
	[E_Anomaly.EA_IdeaCtrl]				= {name = "意念操控", icon = "ynck", valueType = 1, desc = "施放主动技时将当前技能进行替换; 降低%d%%攻击力和%d%%命中率",}, --意念操控
	[E_Anomaly.EA_Annihilate]			= {name = "湮灭", icon = "yanmie", valueType = 1, desc = "攻击力/命中率/技伤增幅%d%%; 当前%d层",}, --湮灭	
	[E_Anomaly.EA_SuperZhidunBarrier]	= {name = "超级芝顿屏障", icon = "cjzdpz", valueType = 1, desc = "所有防御/闪避率/技伤减免%d%%。剩余反弹%d次",}, --超级芝顿屏障
	[E_Anomaly.EA_DeathOverture]		= {name = "灭亡序曲", icon = "mwxq", valueType = 1, desc = "当前所有异常抗性%d%%&&生命比例相较于最大值每减少1%，受到的伤害额外增加1%",}, --灭亡序曲
	[E_Anomaly.EA_SoulDevouring]		= {name = "噬魂", icon = "shihun", valueType = 1, desc = "抗暴率%d%%",}, --噬魂
	[E_Anomaly.EA_DistortAbyss]			= {name = "扭曲深渊", icon = "nqsy", valueType = 1, desc = "当前%d层，攻击力/暴击伤害/所有防御/韧性/暴击率%s%d%%",}, --扭曲深渊
	[E_Anomaly.EA_CurseSuppress]		= {name = "诅咒抑制", icon = "zzyz", valueType = 1, desc = "获得<诅咒抑制>效果&&当前攻击力%d",}, --诅咒抑制
	[E_Anomaly.EA_CurseSuppressExt]		= {name = "", icon = "", valueType = 1, desc = "",}, --诅咒抑制扩展数据
	[E_Anomaly.EA_PowerZeda]			= {name = "宙达之力", icon = "zhoudazhili", valueType = 1, desc = "攻击力/技伤增幅%d%%, 免疫<眩晕>效果",}, --宙达之力
	[E_Anomaly.EA_PowerMolde]			= {name = "莫尔德之力", icon = "medzl", valueType = 1, desc = "所有防御/技伤减免%d%%, 免疫<混乱>效果",}, --莫尔德之力
	[E_Anomaly.EA_PowerGina]			= {name = "吉娜之力", icon = "jnzl", valueType = 1, desc = "受到的治疗效果/暴击伤害%d%%, 免疫<重伤>效果",}, --吉娜之力
	[E_Anomaly.EA_TimeWarp]				= {name = "时空扭曲", icon = "sknq", valueType = 1, desc = "造成的所有伤害%d%%",}, --时空扭曲
	[E_Anomaly.EA_SpaceAddRatio]		= {name = "空间增幅", icon = "kjzf", valueType = 1, desc = "造成的所有伤害%d%%",}, --空间增幅
	[E_Anomaly.EA_EmperorsPower]		= {name = "帝王之威", icon = "dwzw", valueType = 1, desc = "技伤减免%s%d%%; 当前所有异常抗性%s%d%%",}, --帝王之威
	[E_Anomaly.EA_SoulCursePressing]	= {name = "灵咒制压", icon = "lzzy", valueType = 1, desc = "当前灵咒值%d&&受到的「受伤率增加」效果额外%s%d%%",}, --灵咒制压
	[E_Anomaly.EA_EnergyCore]			= {name = "光辉能量核心", icon = "ghnlhx", valueType = 1, desc = "闪避率/所有防御/技伤减免%d%%；当前护盾值%d",}, --光辉能量核心
	[E_Anomaly.EA_QuickRecover]			= {name = "急速恢复", icon = "jshf", valueType = 1, desc = "闪避率/免伤率%d%%; 当前增加防御力%d%%",}, --急速恢复
	[E_Anomaly.EA_LimitFullOpen]		= {name = "极限全开", icon = "jxqk", valueType = 1, desc = "攻击力/全伤增幅/暴击伤害%d%%, 技伤增幅%d%%",}, --极限全开
	[E_Anomaly.EA_NewExplosion]			= {name = "新生代爆炸", icon = "xsdbz", valueType = 0, desc = "获得<新生代爆炸>效果",}, --新生代爆炸
	[E_Anomaly.EA_NewDawn]				= {name = "新生曙光", icon = "xssg", valueType = 1, desc = "攻击力/暴击率/暴击伤害/闪避率/命中率%d%%，当前%d层",}, --新生曙光
	[E_Anomaly.EA_AllDamageAddNotDispel] = {name = "全伤增幅-不可驱散", icon = "fy", valueType = 1, desc = "全伤增幅%d%%, 不可驱散。",},  --不可驱散全伤增幅
	[E_Anomaly.EA_DamageFreeAddNotDispel] = {name = "全伤减免-不可驱散", icon = "fy", valueType = 1, desc = "全伤减免%d%%, 不可驱散",}, --不可驱散全伤减免
	[E_Anomaly.EA_HellInflamation]	 	= {name = "地狱烈炎", icon = "dyly", valueType = 0, desc = "获得<地狱烈炎>效果",}, --地狱烈炎
	[E_Anomaly.EA_Infect]	 			= {name = "侵染", icon = "qinran", valueType = 1, desc = "所有防御/韧性/所有异常抗性%d%%",}, --侵染
	[E_Anomaly.EA_LimitSealing]			= {name = "极限封印", icon = "jxfy", valueType = 0, desc = "封印目标所有增益状态",}, --极限封印2
	[E_Anomaly.EA_NoPhase]				= {name = "无相", icon = "wuxiang", valueType = 0, desc = "获得<无相>效果: 造成伤害时根据目标生命百分比额外增伤",}, --无相
	[E_Anomaly.EA_PhantomBeastsRealm]	= {name = "幻兽之界", icon = "hszj", valueType = 0, desc = "封印目标所有增益状态",}, --幻兽之界
	[E_Anomaly.EA_FlyCrane]				= {name = "飞翔之精鹤", icon = "fxzjh", valueType = 1, desc = "全伤增幅/全伤减免%d%%",}, --飞翔之精鹤
	[E_Anomaly.EA_FlameShock]			= {name = "火炎之电击", icon = "hyzdj", valueType = 1, desc = "破挡率/命中率/暴击率%d%%",}, --火炎之电击
	[E_Anomaly.EA_FlamePattern]			= {name = "火炎之纹", icon = "hyzw", valueType = 1, desc = "攻击力/暴击伤害%d%%",}, --火炎之纹
	[E_Anomaly.EA_Electricity]			= {name = "感电", icon = "gandian", valueType = 0, desc = "回合开始时受到一次真实伤害",}, --感电	
	[E_Anomaly.EA_FrozenLeopard]		= {name = "高速之冻豹", icon = "gszdb", valueType = 0, desc = "施放主动技时，有概率使目标<冰冻>",}, --高速冻豹	
	[E_Anomaly.EA_Frost]				= {name = "冰冻", icon = "bingdong", valueType = 0, desc = "处于<冰冻>效果，无法行动",}, --冰冻
	[E_Anomaly.EA_PhantomWaterSnake]	= {name = "幻影之水蛇", icon = "hyzss", valueType = 1, desc = "技伤增幅/技伤减免%d%%, 当前护盾值 %d",}, --幻影之水蛇
	[E_Anomaly.EA_WaterSnakeTwine]		= {name = "水蛇之缠", icon = "sszc", valueType = 1, desc = "物理防御增加%d；特技防御增加%d",}, --水蛇之缠
	[E_Anomaly.EA_PhantomBeastOverlord]	= {name = "幻兽之霸王", icon = "hszbw", valueType = 1, desc = "当前增加攻击力：%d, 护盾值：%d",}, --幻兽之霸王
	[E_Anomaly.EA_PhantomBeastSource]	= {name = "幻兽之源", icon = "hszy", valueType = 1, desc = "攻击力/全伤增幅/暴击伤害%d%%, 当前%d层",}, --幻兽之源
	[E_Anomaly.EA_PhantomBeastSourceEx] = {name = "", icon = "", valueType = 1, desc = "",}, --幻兽之源辅助buff标记
	[E_Anomaly.EA_BigDipper] 			= {name = "天罡", icon = "tiangang", valueType = 0, desc = "免疫所有异常效果",}, --天罡
	[E_Anomaly.EA_GoldenBellProt]		= {name = "金钟护体", icon = "jzht", valueType = 0, desc = "受到暴击伤害时减免一定伤害",}, --金钟护体
	[E_Anomaly.EA_ShiningStrike] 		= {name = "闪耀破击", icon = "sknq", valueType = 0, desc = "闪耀破击",}, --闪耀破击
	[E_Anomaly.EA_GoldenTang]	 		= {name = "黄金气息", icon = "jshf", valueType = 0, desc = "黄金气息",}, --黄金气息
}

E_BUFFID = {
	EBI_LifeAdd 			= E_Anomaly.EA_LifeAdd,         --生命加值(对应被动技能E_Effect.EE_LifeAdd)
	EBI_AttackAdd 			= E_Anomaly.EA_AttackAdd,         --攻击加值
	EBI_PhysicalDefAdd 		= E_Anomaly.EA_PhysicalDefAdd,         --物防加值
	EBI_SpecialDefAdd 		= E_Anomaly.EA_SpecialDefAdd,         --特防加值
	EBI_FinalDamage 		= E_Anomaly.EA_FinalDamage,         --最终伤害
	EBI_InjuryFree 			= E_Anomaly.EA_InjuryFree,         --最终免伤
	EBI_CritRateAdd 		= E_Anomaly.EA_CritRateAdd,         --暴击率加值
	EBI_CritDamageAdd 		= E_Anomaly.EA_CritDamageAdd,         --暴击伤害加值
	EBI_AntiknockCritAdd 	= E_Anomaly.EA_AntiknockCritAdd,         --抗爆率加值
	EBI_HitRateAdd 			= E_Anomaly.EA_HitRateAdd,         --命中率加值
	EBI_DodgeRateAdd 		= E_Anomaly.EA_DodgeRateAdd,         --闪避率加值
	EBI_BlockRateAdd 		= E_Anomaly.EA_BlockRateAdd,         --格挡率加值
	EBI_BrokenBlockRateAdd 	= E_Anomaly.EA_BrokenBlockRateAdd,         --破挡率加值
	EBI_DamageFreeAdd 		= E_Anomaly.EA_DamageFreeAdd,         --全伤减免加值
	EBI_PhysicalFreeAdd 	= E_Anomaly.EA_PhysicalFreeAdd,         --物理减免加值
	EBI_SpecialFreeAdd 		= E_Anomaly.EA_SpecialFreeAdd,         --特伤减免加值
	EBI_AllDamageAdd 		= E_Anomaly.EA_AllDamageAdd,         --全伤加值
	EBI_PhysicalDamageAdd 	= E_Anomaly.EA_PhysicalDamageAdd,         --物伤加值
	EBI_SpecialDamageAdd 	= E_Anomaly.EA_SpecialDamageAdd,         --特伤加值
	EBI_TreatmentAdd 		= E_Anomaly.EA_TreatmentAdd,         --治疗
	EBI_GiddyImmune 		= E_Anomaly.EA_GiddyImmune,         --眩晕免疫
	EBI_ChaosImmune 		= E_Anomaly.EA_ChaosImmune,         --混乱免疫
	EBI_ReduceFuryImmune 	= E_Anomaly.EA_ReduceFuryImmune,         --减少怒免疫
	EBI_StopSkillImmune 	= E_Anomaly.EA_StopSkillImmune,         --封技免疫
	EBI_TreatmentSeal 		= E_Anomaly.EA_TreatmentSeal,         --治疗封印
	EBI_Giddy 				= E_Anomaly.EA_Giddy, 		  --眩晕
	EBI_Chaos 				= E_Anomaly.EA_Chaos, 		  --混乱
	EBI_StopSkill 			= E_Anomaly.EA_StopSkill, 		  --封技
	EBI_Poisoned 			= E_Anomaly.EA_Poisoned, 		  --中毒
	EBI_Fire 				= E_Anomaly.EA_Fire, 		  --灼烧
	EBI_Defense 			= E_Anomaly.EA_Defense, 		  --防御
	EBI_HURT_REDUCE 		= E_Anomaly.EA_ReduceHurt,  	   --免伤
	EBI_HURT_RAISE 			= E_Anomaly.EA_RaiseHurt,  		   --伤害
	EBI_EnergyAdd			= E_Anomaly.EA_PowerAdd,		   --增加能量
	EBI_FireImmune			= E_Anomaly.EA_FireImmune,		   --灼烧免疫
	EBI_PoisonImmune		= E_Anomaly.EA_PoisonImmune,	   --中毒免疫
	EBI_CritDamageFree		= E_Anomaly.EA_CritDamageFreeAdd,  --暴击伤害减免
	EBI_RelieveAnomaly 		= E_Anomaly.EA_RelieveAnomaly,     --解除异常

	EBI_zhuiJi              = E_Anomaly.EA_FollowUp,  --追击
	EBI_xiXue               = E_Anomaly.EA_SuckHp,  --吸血
	EBI_EnergyReduce        = E_Anomaly.EA_PowerReduce,  --减少能量
	EBI_Dodge        		= E_Anomaly.EA_Dodge,  --闪避
	EBI_Crit        		= E_Anomaly.EA_Crit,  --暴击
	EBI_Parry        		= E_Anomaly.EA_Parry,  --格挡
	EBI_HFSM        		= E_Anomaly.EA_RecoveryHp,  --恢复生命(对应主动技能EFFECTTYPE.RECOVERHP)
	EBI_TriggerSkill		= E_Anomaly.EA_TriggerSkill,  --触发主动技能
	EBI_SpecialDefense		= E_Anomaly.EA_SpecialDefense, 		  --免硬控绝对防御（眩晕，混乱，封技）
	EBI_PercentFriendAtk	= E_Anomaly.EA_PercentFriendAtk,		--每有一个队友攻击力百分比加值
	EBI_PercentFriendPhyDef	= E_Anomaly.EA_PercentFriendPhyDef,		--每有一个队友物防百分比加值
	EBI_PercentFriendSpecDef= E_Anomaly.EA_PercentFriendSpecDef,		--每有一个队友特防百分比加值
	EBI_DamageTransfer		= E_Anomaly.EA_DamageTransfer,		--伤害转移（帮队友承担伤害，实际是直接把目标替换）
	EBI_Doll				= E_Anomaly.EA_Doll,				--人偶标记（减少攻击力和双防御的百分比，三种属性减少的值为一致的）
	EBI_RelieveDebuff		= E_Anomaly.EA_RelieveDebuff,				--解除Debuff（非毒、烧、眩晕、封技、眩晕、混乱）
	EBI_Paraggi				= E_Anomaly.EA_Paraggi,				--帕拉吉之光（增加免伤和全伤加值）
	EBI_SpatialReinforce	= E_Anomaly.EA_SpatialReinforce,				--空间强化
	EBI_SpatialWarp			= E_Anomaly.EA_SpatialWarp,				--空间扭曲
	EBI_SpecialBuff			= E_Anomaly.EA_SpecialBuff,				--特殊buff（用来配合【自身特殊buff X 次时】触发）
	EBI_HPMaxPerDamage		= E_Anomaly.EA_HPMaxPerDamage,				--最大生命值百分比自残（回血或扣血，不修改上限，只能做常驻buff，在卡牌初始化时生效，其他地方不生效）
	EBI_PhysicalImmune		= E_Anomaly.EA_PhysicalImmune,				--物理免疫
	EBI_SpecialImmune		= E_Anomaly.EA_SpecialImmune,				--特技免疫
	EBI_TreatmentSealImmune	= E_Anomaly.EA_TreatmentSealImmune,				--重伤(治疗封印)免疫
	EBI_GlassSeal			= E_Anomaly.EA_GlassSeal,					--镜之封印
	EBI_RemoveAllBuff		= E_Anomaly.EA_RemoveAllBuff,				--清除所有debuff+异常
	EBI_DotAdd				= E_Anomaly.EA_DotAdd,				--dot伤害增幅
	EBI_OppoTeamAura		= E_Anomaly.EA_OppoTeamAura,				--敌方特定阵营洗脑
	EBI_DamageFreeAddNoCap	= E_Anomaly.EA_DamageFreeAddNoCap,				--减免伤害(不计算cap值，区别于全伤减免)
	EBI_Nibble				= E_Anomaly.EA_Nibble,				--恶意蚕食
	EBI_RelieveBuff			= E_Anomaly.EA_RelieveBuff,				--解除增益buff
	EBI_EndMark				= E_Anomaly.EA_EndMark,				--终结印记
	EBI_Delay				= E_Anomaly.EA_Delay,				--buff延迟生效
	EBI_PercentAtk			= E_Anomaly.EA_PercentAtk,			--攻击力百分比加值
	EBI_PowerSkillImmune	= E_Anomaly.EA_PowerSkillImmune,	--能量技伤害免疫
	EBI_Gemize	            = E_Anomaly.EA_Gemize,	            --宝石化
	EBI_Dataize	            = E_Anomaly.EA_Dataize,	            --数据化
	EBI_EssenceMercyMark	= E_Anomaly.EA_EssenceMercyMark,	--真谛之善
	EBI_EssenceEvilMark	    = E_Anomaly.EA_EssenceEvilMark,	    --真谛之恶
	EBI_SupportOfForce	    = E_Anomaly.EA_SupportOfForce,	    --应援之力
	EBI_MindLinking	    	= E_Anomaly.EA_MindLinking,	    	--心意连结
	EBI_SOFAbsorbDamage	    = E_Anomaly.EA_SOFAbsorbDamage,	    --将奥特曼阵营对自身的伤害转化为治疗
	EBI_CreationShield	    = E_Anomaly.EA_CreationShield,	    --创世屏障
	EBI_PercentPhysicalDef	= E_Anomaly.EA_PercentPhysicalDef,	--物防百分比加值
	EBI_PercentSpecialDef	= E_Anomaly.EA_PercentSpecialDef,	--特防百分比加值
	EBI_DarkForce			= E_Anomaly.EA_DarkForce,			--暗黑原力
	EBI_GeneChange			= E_Anomaly.EA_GeneChange,			--基因篡改
	EBI_EvilTemptation		= E_Anomaly.EA_EvilTemptation,		--邪念蛊惑
	EBI_SkillPowerUp		= E_Anomaly.EA_SkillPowerUp,		--技能伤害百分比提升
	EBI_DamageFreePercent	= E_Anomaly.EA_DamageFreePercent,	--减免技能伤害百分比提升
	EBI_RedSteelForce		= E_Anomaly.EA_RedSteelForce,		--赤钢之力（by捷德专属被动）
	EBI_UltimateForce		= E_Anomaly.EA_UltimateForce,		--终极之力（同上）
	EBI_RingForce			= E_Anomaly.EA_RingForce,			--光轮羁绊之力
	EBI_DataHacking			= E_Anomaly.EA_DataHacking,			--数据入侵
	EBI_TriPower			= E_Anomaly.EA_TriPower,			--三重能源
	EBI_TriSheen			= E_Anomaly.EA_TriSheen,			--三重光辉
	EBI_DodgeAdd			= E_Anomaly.EA_DodgeAdd,			--闪避加成
	EBI_DoubleDefPer		= E_Anomaly.EA_DoubleDefPer,		--双防百分比加值
	EBI_LifeLink			= E_Anomaly.EA_LifeLink,			--生命链接
	EBI_MyTeamAura			= E_Anomaly.EA_MyTeamAura,			--狂暴化
	EBI_GigaBattleNizer		= E_Anomaly.EA_GigaBattleNizer,		--终极战斗仪
	EBI_DemonGene			= E_Anomaly.EA_DemonGene,			--恶魔因子
	EBI_ResentmentErosion	= E_Anomaly.EA_ResentmentErosion,	--怨念侵蚀
	EBI_Imprison			= E_Anomaly.EA_Imprison,			--禁锢
	EBI_AbsorbAtk			= E_Anomaly.EA_AbsorbAtk,			--吸取
	EBI_DarkField			= E_Anomaly.EA_DarkField,			--邪神黑暗领域
	EBI_Explosion			= E_Anomaly.EA_Explosion,			--引爆
	EBI_Possessed			= E_Anomaly.EA_Possessed,			--附身
	EBI_Resonance			= E_Anomaly.EA_Resonance,			--共鸣
	EBI_AntiknockCritAddWula= E_Anomaly.EA_AntiknockCritAddWula,--乌拉专属抗爆率加值
	EBI_ShiningShanyao	 	= E_Anomaly.EA_ShiningShanyao,		--光辉闪耀
	EBI_Awaking	 			= E_Anomaly.EA_Awaking,				--唤醒
	EBI_Reverse	 			= E_Anomaly.EA_Reverse,				--逆转
	EBI_UltimateParaggi	 	= E_Anomaly.EA_UltimateParaggi,		--终极巴拉吉
	EBI_ParaggiGuard	 	= E_Anomaly.EA_ParaggiGuard,		--巴拉吉庇佑
	EBI_Collapse			= E_Anomaly.EA_Collapse,			--崩坏
	EBI_RedsteelBreath		= E_Anomaly.EA_RedsteelBreath, 		--赤钢之息
	EBI_Darkspell			= E_Anomaly.EA_Darkspell,			--暗之咒术
	EBI_LightErosion		= E_Anomaly.EA_LightErosion,		--光明侵蚀
	EBI_RaiseHurtNotDispel  = E_Anomaly.EA_RaiseHurtNotDispel,	--受伤率不可驱散
	EBI_HitRateAddNotDispel	= E_Anomaly.EA_HitRateAddNotDispel, --命中率不可驱散
	EBI_CritRateAddNotDispel = E_Anomaly.EA_CritRateAddNotDispel, --暴击率不可驱散
	EBI_CritDamageAddNotDispel = E_Anomaly.EA_CritDamageAddNotDispel, --暴击伤害不可驱散
	EBI_BrokenBlockRateAddNotDispel	= E_Anomaly.EA_BrokenBlockRateAddNotDispel, --破挡率不可驱散
	EBI_DodgeRateAddNotDispel = E_Anomaly.EA_DodgeRateAddNotDispel, --闪避率不可驱散
	EBI_BlockRateAddNotDispel = E_Anomaly.EA_BlockRateAddNotDispel,   --格挡率不可驱散
	EBI_SoulImmortal		= E_Anomaly.EA_SoulImmortal,		--亡魂不灭
	EBI_SoulForm			= E_Anomaly.EA_SoulForm,			--灵魂形态
	EBI_AbsolutePower		= E_Anomaly.EA_AbsolutePower,		--绝对力量
	EBI_AdjudicationEnd		= E_Anomaly.EA_AdjudicationEnd,		--裁决终焉
	EBI_AbsoluteSanction	= E_Anomaly.EA_AbsoluteSanction,	--绝对制衡
	EBI_AbuSoleutParticle	= E_Anomaly.EA_AbuSoleutParticle,	--阿布索留特粒子
	EBI_ChaosOfSource		= E_Anomaly.EA_ChaosOfSource,		--混沌之源
	EBI_PhotonSmashing		= E_Anomaly.EA_PhotonSmashing,		--光子粉碎
	EBI_FireAndPoisonImmune = E_Anomaly.EA_FireAndPoisonImmune, --燃烧和中毒免疫合体
	EBI_PowerOfInherit		= E_Anomaly.EA_PowerOfInherit,		--传承之力
	EBI_PercentFriendAtkExt = E_Anomaly.EA_PercentFriendAtkExt,			--每有一个队友攻击力百分比加值,附加人数上限条件
	EBI_PercentFriendPhyDefExt = E_Anomaly.EA_PercentFriendPhyDefExt, 	--每有一个队友物防百分比加值,附加人数上限条件
	EBI_PercentFriendSpecDefExt = E_Anomaly.EA_PercentFriendSpecDefExt,	--每有一个队友特防百分比加值,附加人数上限条件
	EBI_Exile				= E_Anomaly.EA_Exile,				--放逐
	EBI_Imprisonment		= E_Anomaly.EA_Imprisonment,		--囚禁
	EBI_KingOfRoyalcrown	= E_Anomaly.EA_KingOfRoyalcrown,	--王之冠冕
	EBI_SplitOfDieYoung		= E_Anomaly.EA_SplitOfDieYoung,		--分裂之殇
	EBI_DimensionLight		= E_Anomaly.EA_DimensionLight,		--次元之光
	EBI_IdeaCtrl			= E_Anomaly.EA_IdeaCtrl,			--意念操控
	EBI_SoulDevouring		= E_Anomaly.EA_SoulDevouring,		--噬魂
	EBI_TimeWarp			= E_Anomaly.EA_TimeWarp,			--时空扭曲
	EBI_SpaceAddRatio		= E_Anomaly.EA_SpaceAddRatio,		--空间增幅
	EBI_AllDamageAddNotDispel = E_Anomaly.EA_AllDamageAddNotDispel, --全伤加值不可驱散
	EBI_DamageFreeAddNotDispel = E_Anomaly.EA_DamageFreeAddNotDispel, --全伤减免不可驱散
	EBI_LimitSealing		= E_Anomaly.EA_LimitSealing, 		--极限封印2
	EBI_NoPhase				= E_Anomaly.EA_NoPhase,				--无相
	EBI_PhantomBeastsRealm	= E_Anomaly.EA_PhantomBeastsRealm,  --幻兽之界
	EBI_FlamePattern		= E_Anomaly.EA_FlamePattern,   		--火炎之纹
	EBI_Electricity			= E_Anomaly.EA_Electricity,   		--感电
	EBI_Frost				= E_Anomaly.EA_Frost, 				--冰冻
	EBI_ShiningStrike		= E_Anomaly.EA_ShiningStrike, 		--闪耀破击
	EBI_GoldenTang			= E_Anomaly.EA_GoldenTang, 			--黄金气息
}


--被动条件
E_PSKILLCONDITIONS = {
	EPC_NOTTRIGGER 			= 0,		--非触发
	EPC_X_ATTACK 			= 1,		--前x攻击(buff施加目标为攻击卡牌自身，所有该触发条件的被动技能应该是为攻击卡牌添加增强属性的异常buff)
	EPC_X_ATTACKED 			= 2,		--前x受攻
	EPC_ATTACKED 			= 3,		--受到攻击时
	EPC_POWER_ATTACKED 		= 4,		--受到能量攻击时
	EPC_BEEN_TREATMENT 		= 5,		--受到治疗时
	EPC_DEAD 				= 6, 		--死亡后触发
	EPC_KILL 				= 7,		--击杀后触发
	EPC_EVASION 			= 8, 		--闪避触发
	EPC_PARRY 				= 9, 		--格挡触发
	EPC_POWER_SKILL 		= 10,    	--能量技触发
	EPC_MYSELFLIFE_JUDGE 	= 11, 		--自身生命判断
	EPC_GOALLIFE_JUDGE  	= 12, 		--目标生命判断
	EPC_GOALLIFE_COMPARISON = 13,   	--目标生命比较
	EPC_GOAL_POISONED 		= 14,		--目标中毒状态
	EPC_GOAL_FIRE 			= 15,		--目标灼烧状态
	EPC_GOAL_GIDDY 			= 16,		--目标眩晕状态
	EPC_GOAL_CHAOS 			= 17,		--目标混乱状态
	EPC_GOAL_STOPSKILL 		= 18,		--目标封技状态
	EPC_GOAL_HAVESKILL 		= 19,		--目标拥有被动技能
	EPC_GOAL_POWER 			= 20,		--目标拥有能量
	EPC_ROUND_START 		= 21,		--回合开始
	EPC_All_ATTACK 			= 22,		--所有攻击时触发
	EPC_BATTLE_START 		= 23,		--战斗开始时
	EPC_X_ATTACK_EFFECT1TARGET = 24,	--前x攻击(buff施加目标与释放技能的第一效果攻击目标相同)
	EPC_SPECIAL_POWER_SKILL = 25,		--特殊能量技触发(释放第二段能量技时检测)
	EPC_X_NORATTACK 		= 26,		--前x普通技攻击
	EPC_FATAL_DAMAGE 		= 27,		--受到致命伤害时
	EPC_ALL_ANOMALY			= 28,		--全体异常状态
	EPC_CRIT				= 29,		--暴击时
	EPC_SELF_POWER			= 30,		--自身每有一点能量（释放能量技时）
	EPC_SELF_POWER_ATTACKED	= 31,		--自身每有一点能量（受到攻击技时）
	EPC_GOAL_ANOMALY		= 32,		--目标异常状态
	EPC_X_ROUND				= 33,		--在场第X回合
	EPC_GOAL_EVASION		= 34,		--目标闪避时
	EPC_GOAL_PARRY			= 35,		--目标格挡时
	EPC_X_MYSELF_SPECIALBUFF = 36, 		--自身特殊buff次数判断(满足次数后移除buff)
	EPC_NORATTACK 			= 37,		--普通技攻击
	EPC_FIRST_POWER_ATTACKED= 38,		--每回合第1次受能量技攻击时
	EPC_BATTLE_START_CAMP 	= 39,		--战斗开始时·每有1名X阵营
	EPC_MYTEAM_ALIVE 		= 40, 		--本方存活角色人数判断
	EPC_PHYSICS_ATTACKED 	= 41, 		--受到物理攻击时
	EPC_FATAL_DAMAGE_TEAMMATE  = 42, 	--队友受到致命伤害时
	EPC_START_CAMP_ALL 		= 43,		--上场时·全场每有1名特定阵营
	EPC_DEAD_CAMP_JUDGE 	= 44,		--死亡时阵营判断
	EPC_BATTLE_START_CAMP_JUDGE = 45,	--上场时友方阵营判断
	EPC_GOAL_ANOMALY_DEBUFF = 46,	    --目标所有异常状态和减益效果
	EPC_GOAL_ANOMALY_MYTEAM = 47,	    --每次行动时，己方全体异常判断
	EPC_ATTACK_CAMP_ALL     = 48,	    --攻击时，全场存在特定阵营角色个数
	EPC_ATTACK_CAMP_ONE     = 49,	    --攻击时，全场若存在特定阵营角色
	EPC_ATTACKED_CAMP     	= 50,	    --受到特定阵营攻击时（造成伤害后的触发）
	EPC_POWER_SKILL_CAMP    = 51,	    --特定阵营角色施放能量技时
	EPC_AFTER_FIRST_POWER_ATTACKED  = 52,	--每回合第1次受能量技攻击后（区分条件38 在主动技3段效果后判断）
	EPC_DEAD_ENEMY          = 53,	    --敌方死亡时触发
	EPC_MYSELFLIFE_JUDGE_TREATMENT 	= 54, --自身行动时以及受到主动技治疗时生命值判断（给自己加buff）
	EPC_JUDGE_ANOMALY		= 55, 		--持有指定异常的角色行动后（目前配合托雷基亚超越技使用）
	EPC_SELF_POWER_NORATTACK= 56,		--自身每有一点能量（普通技攻击时）
	EPC_SELF_POWER_JUDGE	= 57,		--自身能量数量判断，根据奇偶触发不同的效果
	EPC_ATK_CHECK_ENEMYLESS	= 58,		--攻击时，检测敌方死亡人数，根据人数强化属性
	EPC_ATK_CHECK_ENEMYMORE	= 59,		--受击时，检测敌方存活人数，根据人数强化属性
	EPC_ATTACKED_NOCRIT		= 60,		--受击且没有暴击时
	EPC_GETHURT_PHYSICS		= 61, 		--受到物理类型的攻击（只检测主动技）
	EPC_GETHURT_ENERGY		= 62, 		--受到能量类型的攻击（只检测主动技）
	EPC_ATK_CHECK_ANOMALY   = 63,		--能量技攻击时，检测自身持有的状态id
	EPC_STEP_START_ALIVE	= 64,		--每回合行动时检测场上存活人数
	EPC_POWER_SKILL_CAMP_SELF	= 65,	--特定阵营同队角色施放能量技时
	EPC_DEAD_SELF_TEAM		= 66,		--己方死亡时触发
	EPC_SELF_POWER_NUM		= 67,		--自身能量数检测,每有X点能量时触发 (提升自身攻击力,物理防御,特技防御 x%, 上限50%)
	EPC_POWER_SKILL_X_Times = 68,	    --第X次释放能量技时触发
	EPC_ACTION_MEMBERS_COUNT = 69,		--行动成员数量每达到X人时触发,触发后计数清0
	EPC_CURRENT_OPPOTEM_MEMBERS = 70,	--敌方当前在场人数
	EPC_CHECK_CRIT			= 71,		--暴击检测
	EPC_MAINSKILL_ATK_FIRST_CRIT_NO = 72, --首次受到主动技攻击且未被暴击时
	EPC_MAINSKILL_ATK_FIRST_CRIT_YES = 73, --首次受到主动技攻击且被暴击时
	EPC_MAINSKILL_ATTACK	= 74,		--每次施放主动技能时
	EPC_CONDITION_BUFF_TRIGGER = 75, --触发条件发生转移，由buff触发，不再由原来的条件触发
	EPC_MY_ALL_ANOMALY 			= 76,	--我方异常状态检测
	EPC_OPPO_ALL_ANOMALY		= 77,	--敌方异常状态检测
	EPC_POWER_SKILL_CAMP_COSMICMAN = 78, --本方宇宙人角色能量技能检测
	EPC_TARGET_HP_CHECK 	= 79, 		--目标血量值检测
	EPC_TARGET_RUNTRIGGERSKILL_EXTENSION = 80, --攻击力最高的目标本次攻击结束时额外再执行N个触发技
	EPC_COSMICMAN_POWERSKILL_OR_CARDSDIE_CHECK = 81, --本方宇宙人能量技检测或角色目标阵亡检测
	EPC_ROLE_CAMP_COUNT_CHECK = 82, --本方阵营角色数量检测(比如：检测本方场上存在的奥特曼数量)
	EPC_POWER_SKILL_CAMP_OPPO = 83, --攻击卡角色施放能量技时，对其进行阵营检测,是否满足被攻击卡一方中相关条件的卡牌阵营，若满足，则被攻击一方的条件角色执行某个效果
	EPC_SELF_POWER_HIGHER_THAN_NUM = 84, --将要施放能量技时，检测自身能量数是否高于指定值
	EPC_STEP_WILL_FINISHED_SOON = 85, --本次行动即将结束时触发
	EPC_ROLE_STEP_START = 86,  --角色小回合开始行动时
	EPC_ROLE_ACTION_START = 87, --角色即将开始施放主动技能时
}

--被动技能效果
E_Effect = {
	EE_Initiative  			= 1,		  --触发主动技能
	EE_LifeAdd 				= 2,          --生命加值
	EE_AttackAdd 			= 3,          --攻击加值
	EE_PhysicalDefAdd 		= 4,          --物防加值
	EE_SpecialDefAdd 		= 5,          --特防加值
	EE_FinalDamage 			= 6,          --最终伤害
	EE_InjuryFree 			= 7,          --最终免伤
	EE_CritRateAdd 			= 8,          --暴击率加值
	EE_CritDamageAdd 		= 9,          --暴击伤害加值
	EE_AntiknockCritAdd 	= 10,         --抗爆率加值
	EE_HitRateAdd 			= 11,         --命中率加值
	EE_DodgeRateAdd 		= 12,         --闪避率加值
	EE_BlockRateAdd 		= 13,         --格挡率加值
	EE_BrokenBlockRateAdd 	= 14,         --破挡率加值
	EE_DamageFreeAdd 		= 15,         --全伤减免加值
	EE_PhysicalFreeAdd 		= 16,         --物理减免加值
	EE_SpecialFreeAdd 		= 17,         --特伤减免加值
	EE_AllDamageAdd 		= 18,         --全伤加值
	EE_PhysicalDamageAdd 	= 19,         --物伤加值
	EE_SpecialDamageAdd 	= 20,         --特伤加值
	EE_TreatmentAdd 		= 21,         --治疗加值
	EE_GiddyImmune 			= 25,         --眩晕免疫
	EE_ChaosImmune 			= 26,         --混乱免疫
	EE_ReduceFuryImmune 	= 27,         --减少怒免疫
	EE_StopSkillImmune 		= 28,         --封技免疫
	EE_TreatmentSeal 		= 30,         --治疗封印
	EE_ProbabilityPoison 	= 31,         --概率毒
	EE_ProbabilityFire 		= 32,         --概率灼烧
	EE_ProbabilityGiddy 	= 33,         --概率晕
	EE_ProbabilityChaos 	= 34,         --概率混乱
	EE_ProbabilityStopSkill = 35,         --概率封技
	EE_CampDamage 			= 36, 		  --阵营伤害
	EE_CampLife 			= 37, 		  --阵营生命
	EE_CampDefense 			= 38, 		  --阵营防御
	EE_RelieveAnomaly 		= 39,         --解除异常
	EE_PowerAdd				= 40,		  --能量加值
	EE_FireImmune			= 41,		  --灼烧免疫
	EE_PoisonImmune			= 42,		  --中毒免疫
	EE_CritDamageFreeAdd	= 43,		  --暴击伤害减免加值
	EE_PercentDamage		= 44,		  --承受伤害最大百分比（基于自己最大生命值）
	EE_PowerSkillBuffer		= 45,		  --第二段能量技伤害系数加值
	EE_Revive				= 46,		  --死亡复活
	EE_FeignDeath			= 47,		  --诈死（受到致命伤害时，强制设置剩余血量）
	EE_Doll					= 48,		  --人偶标记（减少攻击力和双防御的百分比，三种属性减少的值为一致的）
	EE_RemoveAnomaly		= 49,		  --移除指定异常状态
	EE_RelieveDebuff		= 50,		  --解除Debuff（非毒、烧、眩晕、封技、眩晕、混乱）
	EE_Transform			= 51,		  --切换形态，回满血量
	EE_HPMaxAdd				= 52,		  --血量上限加值
	EE_SpecialBuff			= 53,		  --特殊buff（用来配合【自身特殊buff X 次时】触发）
	EE_HPMaxPerDamage		= 54,		  --最大生命值百分比自残（回血或扣血，不修改上限，只能做常驻buff，在卡牌初始化时生效，其他地方不生效）
	EE_PhysicalImmune 		= 55,         --物理免疫
	EE_SpecialImmune 		= 56,         --特技免疫
	EE_TreatmentSealImmune 	= 57,         --重伤(治疗封印)免疫
	EE_ReviveSameFaction	= 58,         --随机复活本方一名同阵营角色
	EE_DamageTransform		= 59,         --代替队友承受伤害
	EE_DotAdd				= 60,         --dot(毒烧)增幅
	EE_MyTeamAura			= 61,         --己方特定阵营狂暴化
	EE_OppoTeamAura			= 62,         --敌方特定阵营洗脑
	EE_ThreeInOneImmune 	= 63,         --免疫晕眩 混乱 封技
	EE_DamageFreeAddNoCap 	= 64,         --减免伤害(不计算cap值，区别于全伤减免)
	EE_Nibble 				= 65,         --恶意蚕食
	EE_DamageTeamFreeAdd 	= 66,         --全队全伤减免加值
	EE_EndMark 				= 67,         --终结印记
	EE_CampTreatmentAdd 	= 68, 		  --阵营治疗加值
	EE_Delay 				= 69, 		  --buff延迟生效
	EE_Regain 				= 70, 		  --buff还原生效
	EE_PercentAtk 			= 71, 		  --攻击力百分比加值
	EE_PowerSkillImmune 	= 72, 		  --能量技伤害免疫
	EE_EssenceMercyMark     = 73,		  --真谛之善（异常抗性+）
	EE_EssenceEvilMark      = 74,		  --真谛之恶（异常抗性-）
	EE_SupportOfForce       = 75,		  --应援之力
	EE_MindLinking	        = 76,		  --心意连结
	EE_SOFAbsorbDamage		= 77,		  --将奥特曼阵营对自身的伤害转化为治疗(效果与洗脑一样,阵营不同)
	EE_CreationShield		= 78,		  --创世屏障（将伤害转化为最终伤害加成）
	EE_PercentPhysicalDef	= 79,		  --物防百分比加值
	EE_PercentSpecialDef	= 80,		  --特防百分比加值
	EE_DarkForce			= 81,		  --暗黑原力
	EE_EvilTemptation		= 82,		  --邪念蛊惑
	EE_SkillPowerUp			= 83,		  --技能伤害百分比提升
	EE_RedSteelForce		= 84,		  --赤钢之力（by捷德专属被动）
	EE_UltimateForce		= 85,		  --终极之力（同上）
	EE_DamageFreePercent	= 86,		  --减免技能伤害百分比提升
	EE_DataHacking			= 87,		  --数据入侵
	EE_TriPower				= 88,		  --三重能源
	EE_DoubleDefPer			= 89,		  --双防百分比加值
	EE_LifeLink				= 90,		  --生命链接
	EE_GigaBattleNizer		= 91,		  --终极战斗仪
	EE_DemonGene			= 92,		  --恶魔因子
	EE_ResentmentErosion	= 93,		  --怨念侵蚀
	EE_AbsorbAtk			= 94,		  --吸取
	EE_DarkField			= 95,		  --邪神黑暗领域
	EE_Explosion			= 96,		  --引爆
	EE_Possessed			= 97,		  --附身
	EE_Resonance			= 98,		  --共鸣
	EE_Awaking				= 99,		  --光辉赛罗 唤醒
	EE_Reverse				= 100,		  --光辉赛罗 逆转
	EE_ReviveAll			= 101,		  --光辉赛罗 复活
	EE_UltimateParaggi		= 102,		  --光辉赛罗 终极巴拉吉
	EE_ParaggiGuard			= 103,		  --光辉赛罗 巴拉吉庇佑
	EE_UltimateLight		= 104,		  --光辉赛罗 终极之光
	EE_TheEnd				= 105,		  --光辉赛罗 终焉之光
	
	EE_AtomicCore			= 106,		  --原子核心
	EE_Collapse				= 107,		  --崩坏
	EE_D4Energy 			= 108,	 	  --D4能量
	EE_DieRuined			= 109, 		  --死之破败
	EE_Primarylight			= 110,		  --原生之光
	EE_MonsterCartri		= 111,		  --怪兽弹夹
	EE_Darkspell			= 112,		  --暗之咒术
	EE_DevourCurse			= 113,		  --吞噬诅咒
	EE_Shackles				= 114,	 	  --束缚
	EE_Balance				= 115,		  --平衡
	EE_LightdarkMark		= 116,		  --光暗之痕
	EE_TruthEnergy			= 117,		  --真理能量
	EE_HitRateAddNotDispel	= 118,		  --命中率不可驱散
	EE_CritRateAddNotDispel	= 119,        --暴击率不可驱散
	EE_CritDamageAddNotDispel = 120,      --暴击伤害不可驱散
	EE_BrokenBlockRateAddNotDispel = 121, --破挡率不可驱散
	EE_DodgeRateAddNotDispel = 122,       --闪避率不可驱散
	EE_BlockRateAddNotDispel = 123,         --格挡率不可驱散
	EE_SoulImmortal			= 124,		  --亡魂不灭
	EE_Appendage			= 125,		  --附体
	EE_SoulForm				 = 126, 	  --灵魂形态
	EE_NalecPower			= 127,		  --纳拉克能量
	EE_AbsoluteForgive		= 128,		  --绝对宽恕
	EE_AbsoluteSanction		= 129, 		  --绝对制衡
	EE_AbsoluteHeart		= 130,		  --绝对之心
	EE_AbuSoleutParticle	= 131,		  --阿索布留特粒子效果
	EE_SuckHpEqualDivide	= 132,		  --吸血并均分
	EE_AbsoluteAbyss		= 133,		  --绝对深渊
	EE_GoldenManRunSkillExt = 134,	  	  --小金人额外执行一个触发技
	EE_TruthNeverDie		= 135,		  --不灭真理
	EE_SpallingForce		= 136,		  --崩裂之力
	EE_PollutionSeal		= 137,		  --污染之章
	EE_G_Crystal			= 138,		  --G水晶
	EE_FireAndPoisonImmune  = 139,		  --燃烧和中毒免疫合体
	EE_NewPowerOfRebirth	= 140,		  --新生代之力
	EE_PowerOfInherit		= 141,		  --传承之力
	EE_AutorHorn			= 142,		  --奥特之角
	EE_HoldOn				= 143,		  --招架
	EE_NewLightOfRebirth	= 144,		  --新生代之光
	EE_NewRallyOfRebirth	= 145,		  --新生代集结
	EE_TripleBarrier		= 146,		  --三重屏障
	EE_TripleSpark			= 147,		  --三重火花
	EE_HammerKing			= 148,		  --王者之锤
	EE_Gift					= 149,		  --恩赐
	EE_Blessing				= 150,		  --祝福
	EE_KingOfRoyalcrown		= 151,		  --王之冠冕
	EE_Hollowing			= 152,		  --空翼
	EE_GroundFissure		= 153,		  --地裂
	EE_WishingMark			= 154,		  --愿痕
	EE_GreedSpirit			= 155,		  --贪欲之灵
	EE_NightmareWish		= 156,		  --噩愿
	EE_BoneCrushed			= 157,		  --骨碎
	EE_HardPalate			= 158,		  --裂颚
	EE_BoneShield			= 159,		  --骨盾
	EE_HopeOfRuby			= 160,		  --愿之红玉
	EE_ElegyOfBeasts		= 161,		  --融合兽之哀歌
	EE_AllDamageAddMainValue = 162,		  --给攻击卡满足阵营条件的队友提升全伤增幅buff值,结合条件48使用
	EE_ShineStar			= 163,		  --耀星
	EE_DimensionLight		= 164,		  --次元之光
	EE_ShiningPower			= 165,		  --闪亮动力
	EE_StrengthPower		= 166,		  --强壮动力
	EE_MiraclesPower		= 167,		  --奇迹动力
	EE_UltraDoubleJudge		= 168,		  --奥特双重裁决
	EE_ShieldAndSword		= 169,		  --德凯盾剑
	EE_LegendShined			= 170,		  --传说闪亮复合
	EE_Demarches			= 171,		  --合纵连横
	EE_TimeSpaceCrack		= 172,		  --时空裂痕
	EE_TimeSpaceJump		= 173,		  --时空跃迁
	EE_Annihilate			= 174,		  --湮灭
	EE_SuperZhidunBarrier	= 175,		  --超级芝顿屏障
	EE_DeathOverture		= 176,		  --灭亡序曲
	EE_DistortAbyss			= 177,		  --扭曲深渊
	EE_CurseSuppress		= 178,		  --诅咒抑制
	EE_EmperorsPower		= 179,		  --帝王之威
	EE_SoulCursePressing	= 180,		  --灵咒制压
	EE_EnergyCore			= 181,		  --光辉能量核心
	EE_QuickRecover			= 182,		  --急速恢复
	EE_LimitFullOpen		= 183,		  --极限全开
	EE_NewExplosion			= 184,		  --新生代爆炸
	EE_NewDawn				= 185,		  --新生曙光
	EE_AllDamageAddNotDispel = 186,		  --全伤增幅不可驱散
	EE_DamageFreeAddNotDispel = 187,	  --全伤减免不可驱散
	EE_HellInflamation		= 188,		  --地狱烈炎
	EE_Infect				= 189,		  --侵染
	EE_LimitSealing			= 190,		  --极限封印
	EE_PhantomBeastsRealm	= 191,		  --幻兽之界buff还原
	EE_FlyCrane				= 192,		  --飞翔之精鹤
	EE_FlameShock			= 193,		  --火炎之电击
	EE_FrozenLeopard		= 194,		  --高速冻豹
	EE_PhantomWaterSnake	= 195,		  --幻影之水蛇
	EE_WaterSnakeTwine		= 196,		  --水蛇之缠
	EE_PhantomBeastOverlord = 197,		  --幻兽之霸王
	EE_PhantomBeastSource	= 198,		  --幻兽之源
	EE_BigDipper			= 199,		  --天罡
	EE_GoldenBellProt		= 200,		  --金钟护体
	EE_ShiningStrikeEx		= 201,		  --闪耀破击buff额外辅助之用
	EE_GoldenTangEx			= 202,		  --黄金气息buff额外辅助之用
	
	count					= 203,
}

--免疫
E_IMMUNE = {
	EI_GiddyImmune 			= 1,         --眩晕免疫
	EI_ChaosImmune 			= 2,         --混乱免疫
	EI_ReduceFuryImmune 	= 3,         --减少怒免疫
	EI_StopSkillImmune 		= 4,         --封技免疫
	EI_FireImmune 			= 5,		 --灼烧免疫
	EI_PoisonImmune 		= 6,		 --中毒免疫	
	EI_PhysicalImmune 		= 7,		 --物理免疫
	EI_SpecialImmune 		= 8,		 --特技免疫
	EI_TreatmentSealImmune 	= 9,		 --重伤免疫
	EI_PowerSkillImmune 	= 10,		 --能量技免疫
}


--卡牌坐标
POS_MATCHCARDS_X = {140, 320, 500}
POS_MATCHCARDS_Y = {-161, 208, 248, 368, 408, 737, 777, 897, 937}
POS_MATCHCARDS = 
{
	--本队
	ccp(POS_MATCHCARDS_X[1], POS_MATCHCARDS_Y[4]),
	ccp(POS_MATCHCARDS_X[2], POS_MATCHCARDS_Y[5]),
	ccp(POS_MATCHCARDS_X[3], POS_MATCHCARDS_Y[4]),
	ccp(POS_MATCHCARDS_X[1], POS_MATCHCARDS_Y[2]),
	ccp(POS_MATCHCARDS_X[2], POS_MATCHCARDS_Y[3]),
	ccp(POS_MATCHCARDS_X[3], POS_MATCHCARDS_Y[2]),

	--敌队
	ccp(POS_MATCHCARDS_X[1], POS_MATCHCARDS_Y[6]),
	ccp(POS_MATCHCARDS_X[2], POS_MATCHCARDS_Y[7]),
	ccp(POS_MATCHCARDS_X[3], POS_MATCHCARDS_Y[6]),
	ccp(POS_MATCHCARDS_X[1], POS_MATCHCARDS_Y[8]),
	ccp(POS_MATCHCARDS_X[2], POS_MATCHCARDS_Y[9]),
	ccp(POS_MATCHCARDS_X[3], POS_MATCHCARDS_Y[8]),

	--好友助阵
	ccp(POS_MATCHCARDS_X[2], POS_MATCHCARDS_Y[1]),
}

--卡牌层级
ZORDER_MATCHCARDS = 
{
	E_MATCH.MATCH_ZORDER_CARD + 30, --1,2,3
	E_MATCH.MATCH_ZORDER_CARD + 40, --4,5,6
	E_MATCH.MATCH_ZORDER_CARD + 20, --7,8,9
	E_MATCH.MATCH_ZORDER_CARD + 10,  --10,11,12
	E_MATCH.MATCH_ZORDER_CARD + 48, --13(好友)
}

MATCH_ZORDER_MUD = 
{
	E_MATCH.MATCH_ZORDER_CARD + 30 + 1, --1,2,3
	E_MATCH.MATCH_ZORDER_CARD + 40 + 1, --4,5,6
	E_MATCH.MATCH_ZORDER_CARD + 20 + 1, --7,8,9
	E_MATCH.MATCH_ZORDER_CARD + 10 + 1,  --10,11,12
}


--[[
ATKPOS_SPECIAL_1
ATKPOS_SPECIAL_2
ATKPOS_SPECIAL_3
ATKPOS_BASIC
ATKPOS_FULL


local skillInfo = {
	
	id = 1,
	min = 2,
	max = 3,
}
--]]

--场景类型
SceneType = {
	E_City 				= 1,         --城市
	E_water			    = 2,         --水面
	E_Desert 		    = 3,         --沙漠
	E_Forest 		    = 4,         --森林
	E_Universe 			= 5,         --宇宙星球
};

MATCH_RESULT_TYPE = {
	TEAMDAMAGE = 1,
	TEAMGETDAMAGE = 2,
	TEAMCURE = 3,
	TEAMGETCURE = 4,
}

