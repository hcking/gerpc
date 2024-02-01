-- 场景变换FadeIn Time
MATCH_CHANGE_FADE_IN_TIME = 1.0

--- 镜头移动的
m_tMatchMapCameraPosY = {
    [1] = -580,
    [2] = -505,
    [3] = 485,
    [4] = 425,
}

--admin
E_MATCH_TYPE = {
    ORDINARY = 0, --普通副本pve
    PATA = 1, --爬塔pve
    YICIYAUN = 2, --异次元pve
    EVENT = 3, --事件副本pve
    JIANYU = 4, --监狱暴动pve
    GUARD = 5, --警备队pve
    QIECUO = 6, --玩家切磋
    JINGYING = 10, --精英副本pve

}

--Enum ==================================================================
MATCH_MAX_ZORDER = 15000

function test(a, b)
    print("test" .. a .. b)
end

MatchConditionCtrl = {}

local function ProbabilityHandle(card, data, goalCard)
    -- body
    print("fuck")
end

