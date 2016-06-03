local StringDB=
{
stringName = {            ["run"]="跑酷",
            ["justplay"]="随便玩玩",
            ["clickwant2Equip"]="点击更换你想要的装备",
            ["DemageAttack"]="致命打击",
            ["DemageDes"]="狠狠的打对方一下，造成伤害",
            ["Roleprofession"]="职业",
            ["Race"]="种族",
            ["Harm"]="伤害",
            ["RoleName"]="名称",
            ["RoleExp"]="经验",
            ["RoleHp"]="血量",
            ["RoleStrong"]="力量",
            ["Defend"]="护甲",
            ["RoleQuick"]="敏捷",
            ["Defend1"]="防御",
            ["All"]="全部",
            ["legend"]="传说",
            ["epic"]="史诗",
            ["rare"]="稀有",
            ["qldpf"]="强力党评分",
            ["XSQ"]="星神器",
            ["BJL"]="暴击率",
            ["SJH"]="升级后",
            ["areadyEquip"]="已经装备",
            ["Attacktype"]="攻击类型",
            ["NearAtc"]="近战",
            ["DistantAtc"]="远程",
            ["RoleMan"]="男",
            ["RoleWoman"]="女",
            ["Sex"]="性别",
            ["Congratulations"]="恭喜",
            ["Get"]="获得",
            ["Cmoney"]="金币",
            ["Nowtime"]="本次",
            ["CopyList"]="副本列表",
            ["HeroDif"]="英雄难度",
            ["MonsterLevel"]="怪物等级",
            ["PassAward"]="通关奖励",
            ["GeneralSiation"]="概况",
            ["Level"]="等级",
            ["FightingGS"]="战斗力(GS)",
            ["Physics"]="物理",
            ["MagicArt"]="法术",
            ["LiveHp"]="生命值",
            ["Strongthly"]="强度",
            ["AttackD"]="攻击",
            ["Intelligence"]="智力",
            ["Patience"]="耐力",
            ["hitcirl"]="暴击",
            ["tenacity"]="韧性",
            ["hit"]="命中",
            ["avoid"]="闪避",
            ["QuickLevel"]="急速等级",
            ["MoveSpeed"]="移动速度",
            ["AtaackBack"]="击退",
            ["Stone"]="稳固",
            ["RolePRF1"]="战士",
            ["RolePRF2"]="法师",
            ["RolePRF3"]="牧师",
            ["RolePRF4"]="骑士",
            ["RolePRF5"]="猎人",
            ["RolePRF6"]="萨满",
            ["RoleRare1"]="人类",
            ["RoleRare2"]="矮人",
            ["RoleRare3"]="德莱尼",
            ["RoleRare4"]="侏儒",
            ["RoleRare5"]="暗夜精灵",
            ["RoleRare6"]="兽族",
            ["RoleRare7"]="牛头人",
            ["RoleRare8"]="血精灵",
            ["RoleRare9"]="熊猫人",
            ["UP_QUILITY_MAKE_SKILL"]="提升随从的品质,就可以获得更多技能",
            ["surplusSkillNums"]="剩余技能点数",
            ["Overtop"]="(满)",
            ["MainHand"]="主手武器",
            ["OffHand"]="副手物品",
            ["Clothes"]="胸部",
            ["Helm"]="头盔",
            ["Shoulder"]="肩膀",
            ["Glove"]="手套",
            ["Shoes"]="鞋子",
            ["CleanFight1"]="清理地图中的小怪",
            ["Dopant"]="杂物",
            ["SkillName1"]="基础",
            ["SkillName2"]="爆发",
            ["SkillName3"]="战吼",
            ["SkillName4"]="亡语",
            ["NeedPore"]="需先打孔",
            ["ClickInlay"]="点击镶嵌",
            ["EquipDetailInT"]="装备简介",
            ["Wave"]="波",
            ["day"]="天",
            ["hour"]="小时",
            ["minute"]="分钟",
            ["second"]="秒",
            ["countdown"]="倒计时:",
            ["hour2"]="时",
            ["minute2"]="分",
            ["PleaseClick"]="请点选一个宝箱",
            ["PleaseClickOne"]="再选1次吧",
            ["OneDayFree"]="每日免费",
            ["Times"]="次",
            ["tavernchat1"]="颤抖吧,凡人!",
            ["tavernchat2"]="最后，我终于解放了我自己……",
            ["tavernchat3"]="你能把我喝倒吗？",
            ["tavernchat4"]="把我喝开心了送你英雄！",
            ["tavernchat5"]="多买多送哦，亲",
            ["tavernchat6"]="不要光看，陪我喝一杯吧！",
            ["tavernchat7"]="",
            ["tavernchat8"]="",
            ["tavernchat9"]="",
            ["fight_wave_1"]="当前波数:第%d/%d波",
            ["fight_wave_2"]="下一波怪物即将到来",
            ["shopchat1"]="客官，这次又要什么服务",
            ["shopchat2"]="你在点哪里~~~",
            ["shopchat3"]="全买了会自动刷新哦",
            ["shopchat4"]="土豪我们做朋友吧",
            ["shopchat5"]="你一定是来看我的吧",
            ["shopchat6"]="幸运值越高，刷新的物品越好哦",
            ["shopchat7"]="每天早上6点幸运值重置，快来买哦",
            ["CalculateNumberItem"]="当前拥有数量:",
            ["auto_fight_start"]="战斗开始",
            ["auto_fight_win"]="胜利",
            ["auto_fight_lose"]="失败",
            ["auto_fight_next"]="遭遇下一波对手",
            ["auto_fight_countdown"]="%d秒",
            ["auto_fight_addmoney"]="金币+%d",
            ["auto_fight_addexp"]="经验+%d",
            ["DefeatBoss"]="击杀地图中的BOSS",
            ["auto_fight_setting_1"]="你的随从们正在G团里辛苦的打工",
            ["auto_fight_setting_2"]="预计获得经验值:%d/小时",
            ["auto_fight_setting_3"]="金团的老板们会付给你:%d金币/小时",
            ["fast_fight_1"]="你是VIP%d,今日还可快速战斗%d次",
            ["fast_fight_2"]="消耗<st=Sprite image=res#csb#ui#main#ingot></>:%d个",
            ["no_enough_ingot"]="钻石不足",
            ["Equip_nums"]="%d个",
            ["offline_fight_1"]="%d小时%d分钟",
            ["offline_fight_2"]="在你下线的%s内",
            ["offline_fight_3"]="你的随从们不知疲倦的进行了%s场战斗",
            ["offline_fight_4"]="你获得了金币%s",
            ["offline_fight_5"]="你获得了经验值%s",
            ["offline_fight_6"]="随从们捡到了大量装备奖励",
            ["offline_fight_6"]="白色装备%s个",
            ["offline_fight_7"]="绿色装备%s个",
            ["offline_fight_8"]="蓝色装备%s个",
            ["offline_fight_9"]="紫色装备%s个",
            ["resolvechata1"]="小伙子是不是背包放不下啦？",
            ["resolvechata2"]="来吧，把没用的装备都给我吧",
            ["resolvechata3"]="你看你这个装备不够厉害啊！",
            ["resolvechata4"]="不要的装备都扔进去",
            ["resolvechatb1"]="女神的装备都是我这里出去的",
            ["resolvechatb2"]="要变得更厉害吗",
            ["resolvechatb3"]="分解装备可以得到各种精华。",
            ["resolvechatb4"]="你看你这么low的装备，分解了吧",
            ["RoleNotHaveLevel"]="英雄等级不够！",
            ["ItemNotHaveEnough"]="道具不足！",
            ["AreadyMaxLevel"]="达到最大等级！",
            ["no_enough_gold"]="金币不足",
            ["Up_Gem_Faild"]="宝石合成失败",
            ["No_Store_Refreshtime"]="今日刷新次数不足",
            ["Aready_To_ForMation"]="已经上阵",
            ["offline_fight_10"]="橙色装备%s个",
            ["Equip_Package_Enough"]="背包已满！",
            ["Congradulation_Buy"]="恭喜你购买成功",
            ["Refresh_Succeed"]="刷新成功",
            ["Gem_reslove_Succeed"]="宝石合成成功",
            ["Strong_Succeed"]="强化成功",
            ["Sophistication_S"]="洗练成功",
            ["OpenCore_S"]="开孔成功",
            ["Sell_S"]="出售成功",
            ["Gem_Discharge"]="宝石全部卸下",
            ["Inlay_S"]="镶嵌成功",
            ["Reslove_S"]="分解成功",
            ["Auto_Equip_S"]="一键装备成功",
            ["DisMiss_S"]="遣散成功",
            ["Rebuild_S"]="打造成功",
            ["Award_S"]="领取奖励",
            ["Package_S"]="成功增加背包上限为%d",
            ["Up_Skill_Level_S"]="升级技能成功",
            ["Equip_None"]="无效",
            ["unknowError"]="无对应错误信息",
            ["input_name_and_password_please"]="请输入名字或密码",
            ["write_a_name"]="请输入名字",
            ["please_select_serverinfo"]="请选择服务器",
            ["please_add_equip"]="请添加装备",
            ["not_equip_strong"]="没有装备可以强化",
            ["socket_disconnected"]="网络断开",
            ["Skill_not_Enough"]="技能点数不足",
            ["Sorry_not_Equip_Sell"]="抱歉，当前没有可出售装备",
            ["Please_Click_Sell_Equip"]="请勾选要出售的装备",
            ["AttackRange"]="攻击力",
            ["No_Need_Equip"]="没有可对应的装备",
            ["Physical_damage"]="随从造成物理伤害的能力,同时提高物理技能的伤害.",
            ["Magic_damage"]="随从造成法术伤害的能力,同时提高法术技能的伤害和治疗技能的效果.",
            ["Ammor_damage"]="减少随从受到的所有类型伤害.",
            ["Life_Value"]="随从的生命上限,受到伤害生命减少为0时,随从就挂了~",
            ["Strong_effect_1"]="物理伤害提高%.1f点,对最大值最小值都有效.",
            ["Strong_effect_2"]="无法从这个属性上获得收益.",
            ["Agile_effect_1"]="物理伤害提高%.1f点,对最大值最小值都有效.",
            ["Agile_effect_2"]="无法从这个属性上获得收益.",
            ["Wisdom_effect_1"]="法术强度提高%.1f点.",
            ["Wisdom_effect_2"]="无法从这个属性上获得收益.",
            ["stamina"]="生命值提高%.1f点",
            ["Hit_effect"]="影响随从造成暴击的能力,暴击可以造成200%的伤害.",
            ["Toughness_effect"]="降低随从被暴击的几率.",
            ["HitTar_effect"]="提高随从攻击命中目标的几率.",
            ["Avoid_effect"]="降低随从被攻击命中的几率,闪避成功则完全不会受伤.",
            ["Rapid_effect"]="提高随从战斗施放技能的速度.",
            ["Move_effect"]="影响随从战斗中移动的速度.",
            ["ABack_effect"]="提高随从战斗中击退对手的距离.",
            ["Solid_effect"]="降低随从战斗中被击退的距离.",
            ["C_Level_achieve"]="恭喜！升级到%d级",
            ["C_Power_achieve"]="恭喜！获得%d体力！",
            ["Power_Error"]="体力已达上线，请先使用掉一些再来吧",
            ["Pass_First"]="第一关",
            ["Pass_Second"]="第二关",
            ["Pass_Third"]="第三关",
            ["Pass_Four"]="第四关",
            ["Pass_Five"]="Boss关",
            ["Please_Pass_Before_Level"]="当前关卡未开放，请通关前面关卡",
            ["HeroName1"]="老头侏儒术士",
            ["HeroName2"]="驼背射手达西卡",
            ["HeroName3"]="冷月葬花吟",
            ["HeroName4"]="布加迪威牛",
            ["HeroName5"]="今夜菊部小雨",
            ["HeroName6"]="天才琪露诺",
            ["HeroName7"]="博丽灵梦",
            ["HeroName8"]="佐拉血蹄",
            ["HeroName9"]="吸烟的龙",
            ["HeroName10"]="索瑞森王子",
            ["HeroName11"]="阿那利斯",
            ["HeroName12"]="水妙淼",
            ["HeroName13"]="古雷格利",
            ["HeroName14"]="歌罢满帘风",
            ["HeroName15"]="繁花旧时梦",
            ["HeroName16"]="安格莉丝塔",
            ["HeroName17"]="站海边等猫的鱼",
            ["HeroName18"]="风吹屁屁凉",
            ["HeroName19"]="坑边等你来",
            ["HeroName20"]="德玛东亚",
            ["HeroName21"]="劈开的大腿",
            ["HeroName21"]="躲草丛看不到",
            ["No_Battle_Role"]="无法上阵，当前人物等级不够",
            ["Level_upup"]="升级",
            ["Now_Server_Deque"]="%d-%d区",
            ["QuickServer"]="流畅",
            ["Please_Req"]="请先注册",
            ["update_1"]="更新客户端",
            ["update_2"]="整合资源",
            ["update_3"]="检测新版本",
            ["Click_have_three"]="最多只能选3个箱子哦",
            ["init_edit_username"]="点击输入账号",
            ["init_edit_password"]="点击输入密码",
            ["init_edit_name"]="点击输入名字",
            ["exit_dlg_str"]="是否确定退出",
            ["Formation_up"]="战队等级:%d",
            ["Current_power"]="当前体力:%d",
            ["power_Max"]="体力上限:%d",
            ["Hero_level"]="英雄等级上限:%d",
            ["Fight_Level"]="上阵英雄数量:%d",
            ["New_Function"]="新功能开启:%s",
            ["Before_Money"]="原价:%d",
            ["The_Is_Strong_Stone"]="这是能够打造装备的精华",
            ["Award_All_Gem"]="找到图中所有的宝箱",
            ["Can_Fight_Begin_Nums"]="剩余挑战次数:%d/%d",
            ["Award_Place"]="皓金之地",
            ["Not_Achieve_Award"]="未获得",
            ["Add_Money_Use"]="<st=Sprite image=res#csb#ui#main#ingot></>:%d    <st=Sprite image=res#csb#ui#upgrade#arrow></>   <st=Sprite image=res#csb#ui#main#gold></>:%d",
            ["Add_Money_Use1"]="连续使用点金手3次",
            ["Add_Money_Not_Enough"]="点金手次数不足",
            ["AreadyMaxExp"]="随从经验已满，无法再使用经验药水",
            ["Fight_Begin_Des1"]="小提示:掉落的奖励会自动收起来,连捡都不用捡!",
            ["Fight_Begin_Des2"]="小提示:不要踩到炸弹,也不要掉下去.",
            ["Fight_Begin_Des3"]="小提示:看准时机施放技能,好了就用,无脑滥用效果不一定好.",
            ["Fight_Begin_Des4"]="小提示:近战碰到敌人造成伤害,同时自己也被击退.",
            ["Fight_Begin_Des5"]="小提示:在法术吟唱时如果被击退,法术会被打断",
            ["Fight_Begin_Des6"]="小提示:你是指挥官,队伍都是你的随从,听你的指挥.",
            ["Fight_Begin_Des7"]="小提示:随从有多种技能,只有爆发技能需要手动施放.",
            ["Fight_Begin_Des8"]="小提示:随从有多个职业,有近战有远程,请合理搭配.",
            ["Fight_Begin_Des9"]="小提示:打副本过关,队伍里带一个治疗职业是个不错的选择.",
            ["Fight_Begin_Des10"]="小提示:带五个远程击退对手,或者带五个近战砍翻对手,都是很BT的行为.\n        强烈建议你这样做.",
            ["Fight_Begin_Des11"]="小提示:当你空虚寂寞的时候,不妨去酒馆和熊猫喝上一杯.\n       也许会有新的发现.",
            ["Fight_Begin_Des12"]="小提示:随从换装备有外形,强化装备会发光.",
            ["Fight_Begin_Des13"]="小提示:拍卖行可以买到装备.",
            ["Fight_Begin_Des14"]="小提示:任务里每天都有很多任务可以完成,它们会奖励队伍的等级.",
            ["Fight_Begin_Des15"]="小提示:随从的等级不能超过队伍的等级.",
            ["Fight_Begin_Des16"]="小提示:副本除了普通模式以外,还有boss战,防守,宝藏等多种模式的玩法.",
            ["Fight_Begin_Des17"]="小提示:分解可以得到打造材料,消耗的强化精华也会全部返还",
            ["Fight_Begin_Des18"]="小提示:如果装备背包满了,就赶快分解掉.",
            ["Fight_Begin_Des19"]="小提示:15级开启挂机,随从对抗敢来要塞里捣乱的敌人.\n      获得经验,掉落装备,离线也有效!",
            ["Fight_Begin_Des20"]="小提示:队伍里的人物和装备不会出现在背包里.",
            ["Fight_Begin_Des21"]="小提示:按钮上出现了小红点,那就是可以搞一下啦,点点看.",
            ["Fight_Begin_Des22"]="小提示:不同职业具有不同的属性追求,战士是力量型的,敏捷和智力没用.",
            ["Fight_Begin_Des23"]="小提示:战吼技能会在战斗开始时施放,为所有随从增加有益状态.",
            ["Fight_Begin_Des24"]="小提示:一个或两个敌人都可以跳过去,三个我还没有成功过.",
            ["cannot_exit"]="你暂时还不能退出",
            ["gold_name"]="%d金"},
Name = {            [1]="2B",
            [2]="HOLD住",
            [3]="神马浮云",
            [4]="甄嬛",
            [5]="杜甫",
            [6]="高富帅",
            [7]="屌丝",
            [8]="奇葩",
            [9]="忐忑",
            [10]="犀利哥",
            [11]="囧囧",
            [12]="杜拉拉",
            [13]="李刚",
            [14]="章鱼帝",
            [15]="鸭梨",
            [16]="李毅",
            [17]="黑木耳",
            [18]="绿茶",
            [19]="江南style",
            [20]="郭美美",
            [21]="乔布斯",
            [22]="正能量",
            [23]="莫言",
            [24]="菜鸟",
            [25]="苹果",
            [26]="香蕉",
            [27]="雪梨",
            [28]="猕猴桃",
            [29]="樱桃",
            [30]="西瓜",
            [31]="奶茶",
            [32]="豆你玩",
            [33]="姜你军",
            [34]="糖高宗",
            [35]="煤超疯",
            [36]="闹太套",
            [37]="霹雳",
            [38]="葫芦娃",
            [39]="喜羊羊",
            [40]="美羊羊",
            [41]="灰太狼",
            [42]="懒羊羊",
            [43]="最美",
            [44]="大虾",
            [45]="接地气",
            [46]="华南虎",
            [47]="巨人",
            [48]="后青春",
            [49]="势力价",
            [50]="苏打水",
            [51]="凹凸曼",
            [52]="优乐美",
            [53]="小酒窝",
            [54]="致青春",
            [55]="棉花糖",
            [56]="飞天猪",
            [57]="黑白式",
            [58]="蜘蛛侠",
            [59]="小雏菊",
            [60]="无名指",
            [61]="骨点美",
            [62]="太阳花",
            [63]="败金女",
            [64]="卡哇伊",
            [65]="小蜜糖",
            [66]="本山",
            [67]="北纬",
            [68]="科技世界",
            [69]="星旗世界",
            [70]="互通",
            [71]="吐槽",
            [72]="查水表",
            [73]="卖萌",
            [74]="坑爹",
            [75]="泰囧",
            [76]="猥琐",
            [77]="逆袭",
            [78]="碉堡了",
            [79]="打酱油",
            [80]="怪蜀黍",
            [81]="萝莉",
            [82]="重口味",
            [83]="纠结",
            [84]="你懂的",
            [85]="油菜",
            [86]="宅男",
            [87]="腐女",
            [88]="内涵",
            [89]="烧饼",
            [90]="给力",
            [91]="走你",
            [92]="锄禾",
            [93]="当午",
            [94]="菊花",
            [95]="歇菜",
            [96]="标题党",
            [97]="炫富",
            [98]="抠门",
            [99]="钛合金",
            [100]="抓狂",
            [101]="超人",
            [102]="钢铁侠",
            [103]="绿巨人",
            [104]="拍砖",
            [105]="蜘蛛侠",
            [106]="蝙蝠侠",
            [107]="机器猫",
            [108]="悟空",
            [109]="八戒",
            [110]="唐僧",
            [111]="沙僧",
            [112]="如来",
            [113]="彪悍",
            [114]="杨梅",
            [115]="酸梅",
            [116]="红薯",
            [117]="哪尼",
            [118]="叉烧包",
            [119]="酱紫",
            [120]="五毛",
            [121]="绿灯侠",
            [122]="夜魔侠",
            [123]="恶灵骑士",
            [124]="雷神",
            [125]="刀锋战士",
            [126]="敢死队",
            [127]="波斯王子",
            [128]="异形",
            [129]="未来战士",
            [130]="忍者神龟",
            [131]="风之圣痕",
            [132]="隐之王",
            [133]="零之使魔",
            [134]="草莓",
            [135]="情剩",
            [136]="白骨精",
            [137]="火星人",
            [138]="馆里猿",
            [139]="牛人",
            [140]="小白",
            [141]="淡定",
            [142]="伤不起",
            [143]="基友",
            [144]="鸡冻",
            [145]="穿越",
            [146]="嫩模",
            [147]="捉急",
            [148]="海贼王",
            [149]="宫崎骏",
            [150]="火影忍者",
            [151]="圣斗士",
            [152]="Baby",
            [153]="dota",
            [154]="lol",
            [155]="撸啊撸",
            [156]="倒塔",
            [157]="偷塔",
            [158]="英霸",
            [159]="死机",
            [160]="团灭",
            [161]="补刀",
            [162]="反补",
            [163]="穿越",
            [164]="基友",
            [165]="前女友",
            [166]="王道",
            [167]="御宅",
            [168]="宅男",
            [169]="腐女",
            [170]="搞基",
            [171]="断背",
            [172]="SM",
            [173]="女王",
            [174]="菊花",
            [175]="残念",
            [176]="肉山",
            [177]="roshan",
            [178]="CD",
            [179]="兄贵",
            [180]="御姐",
            [181]="正太",
            [182]="萝莉",
            [183]="腹黑",
            [184]="十动然拒",
            [185]="累感不爱",
            [186]="人艰不拆",
            [187]="攻受",
            [188]="黑化",
            [189]="大坑",
            [190]="脑补",
            [191]="平田",
            [192]="真悲剧",
            [193]="逆袭",
            [194]="进击的",
            [195]="二次元",
            [196]="伸手党",
            [197]="分手",
            [198]="天然呆",
            [199]="天然萌",
            [200]="逆推",
            [201]="伪娘",
            [202]="cosplay",
            [203]="女汉子",
            [204]="逆天",
            [205]="怨念",
            [206]="先知",
            [207]="白牛",
            [208]="神牛",
            [209]="跳刀",
            [210]="羊刀",
            [211]="推推",
            [212]="圣剑",
            [213]="大根",
            [214]="草丛",
            [215]="楼主",
            [216]="撸主",
            [217]="沙发",
            [218]="板凳",
            [219]="不作死",
            [220]="崩溃",
            [221]="灭团",
            [222]="奇葩",
            [223]="元芳",
            [224]="纠结",
            [225]="诚意",
            [226]="法王",
            [227]="毁三观",
            [228]="何弃疗",
            [229]="躺枪",
            [230]="高清",
            [231]="马赛克",
            [232]="秒杀",
            [233]="笑点",
            [234]="撸点低",
            [235]="一血",
            [236]="超神",
            [237]="暴走",
            [238]="三杀",
            [239]="坦克",
            [240]="内涵",
            [241]="干货",
            [242]="五姑娘",
            [243]="右手",
            [244]="射手",
            [245]="捡肥皂",
            [246]="初恋",
            [247]="体制内",
            [248]="黑出翔",
            [249]="节操",
            [250]="无底线",
            [251]="秀下限",
            [252]="福利",
            [253]="转基因",
            [254]="黑枪",
            [255]="女神",
            [256]="男神",
            [257]="搬砖",
            [258]="码农",
            [259]="蛋疼",
            [260]="小伙伴",
            [261]="火星",
            [262]="碉堡",
            [263]="土豪",
            [264]="壕友乎",
            [265]="打脸",
            [266]="猪队友",
            [267]="态度",
            [268]="苹果粉",
            [269]="单身",
            [270]="魔法师",
            [271]="休闲",
            [272]="梅球王",
            [273]="漂移",
            [274]="部落",
            [275]="重口味",
            [276]="联盟",
            [277]="真心",
            [278]="开挂",
            [279]="猪脚",
            [280]="神队友",
            [281]="跪舔",
            [282]="觉醒",
            [283]="史诗",
            [284]="高潮",
            [285]="霸气",
            [286]="咸湿",
            [287]="尼玛",
            [288]="草泥马",
            [289]="春哥",
            [290]="原味",
            [291]="无敌",
            [292]="炉石",
            [293]="沙县",
            [294]="直男",
            [295]="丁丁",
            [296]="弯男",
            [297]="呵呵",
            [298]="矫情",
            [299]="宝器",
            [300]="骚年",
            [301]="小伙伴",
            [302]="嫩模",
            [303]="钢铁侠",
            [304]="金刚狼",
            [305]="蜘蛛侠",
            [306]="蝙蝠侠",
            [307]="谢耳朵",
            [308]="接盘",
            [309]="小明",
            [310]="天然呆",
            [311]="天然萌",
            [312]="卖萌",
            [313]="呆萌",
            [314]="网恋",
            [315]="禽兽",
            [316]="高达",
            [317]="明日香",
            [318]="凌波丽",
            [319]="三无",
            [320]="零号机",
            [321]="初号机",
            [322]="黑水",
            [323]="蛋刀",
            [324]="橙弓",
            [325]="风剑",
            [326]="多大仇",
            [327]="专业",
            [328]="龙骑士",
            [329]="三国XX",
            [330]="火星",
            [331]="那美克星",
            [332]="笑点低",
            [333]="负情商",
            [334]="图真相",
            [335]="图森破",
            [336]="黑店",
            [337]="躺枪",
            [338]="跪舔",
            [339]="福利",
            [340]="摇一摇",
            [341]="piapia",
            [342]="啪啪啪",
            [343]="毁一生",
            [344]="呵呵",
            [345]="闺蜜",
            [346]="男闺蜜",
            [347]="XXOO",
            [348]="OOXX",
            [349]="正能量",
            [350]="中国梦",
            [351]="猎人",
            [352]="风筝",
            [353]="玩脱",
            [354]="无脑",
            [355]="脑残",
            [356]="坑爹",
            [357]="大丧失",
            [358]="种子",
            [359]="泥垢了",
            [360]="土掉渣",
            [361]="娇喘",
            [362]="小苹果",
            [363]="火火火",
            [364]="不嫌多",
            [365]="改日",
            [366]="ntr",
            [367]="牛头人",
            [368]="很难受",
            [369]="恩基爱",
            [370]="手撕",
            [371]="春晚",
            [372]="大漩涡",
            [373]="高端",
            [374]="风筝",
            [375]="城乡结合",
            [376]="广场舞",
            [377]="男闺蜜",
            [378]="暗恋",
            [379]="表白",
            [380]="作死",
            [381]="咸党",
            [382]="甜党",
            [383]="极品"},
Prefix = {            [1]="指挥官",
            [2]="队长",
            [3]="元帅",
            [4]="大元帅",
            [5]="督军",
            [6]="排长",
            [7]="连长",
            [8]="班长",
            [9]="大队长",
            [10]="首领",
            [11]="头领",
            [12]="酋长",
            [13]="头目",
            [14]="头头",
            [15]="大哥",
            [16]="大姐",
            [17]="一哥",
            [18]="一姐",
            [19]="扛把子",
            [20]="司令",
            [21]="船长",
            [22]="舰长",
            [23]="老大",
            [24]="领队",
            [25]="领班",
            [26]="小队长",
            [27]="指导员",
            [28]="辅导员",
            [29]="教头",
            [30]="大王",
            [31]="班主任",
            [32]="女王",
            [33]="寨主",
            [34]="村长",
            [35]="太师",
            [36]="小学生",
            [37]="丁丁",
            [38]="大妈",
            [39]="姨妈",
            [40]="领带",
            [41]="海绵"}
};
return StringDB;
