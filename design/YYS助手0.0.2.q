
[Script]
//当前存在的问题
//0探索模式卡死
//1 御魂队员模式在退组后不会返回
//2 在退组到大地图后，会乱点探索章节
//3 狗粮星级判断需要换成找色
//4 卡住了添加确认取消界面的检测
//5 封魔会出现无定位问题
//6 封魔boss没打前，提前结束
//7 结界更换皮肤时，多次重复点击
//8 狩猎界面等待的时候boss已死，卡住
//9 寄养时 只有一个好友的情况，卡死
//10 探索时卡在妖气封印界面
//11 逢魔卡白屏界面
//12 添加无体力检测处理
//13 好友协战会卡阴阳师界面
//更换狗粮添加过期


/* 程序索引(搜索时添加空格，快速定位)
@0==================环境变量===================
@1=================依赖函数库==================
@2=================主功能函数库==================
	1【组队模式】 2【挂机模式】 3【探索模式】
@3=================次功能函数库==================
	@31主界面待机功能 @32金币副本 @33经验副本 @34石距副本
	@35年兽副本 @36联动副本 @37个人突破 @38创建寮突 @39寮突破
	@40妖气封印 @41逢魔之时 @42逢魔首领 @43地域鬼王 @44地域鬼王
	@45阴界之门 @46好友寄养 @47结界卡 @48活动副本 @49业原火
	@50好友协战 @51麒麟 @52地图体力 @53LBS副本
@4==================界面事件===================
@5==================多开相关===================
@6==================执行主体===================
@7===============结束&测试中函数===============
*/

//=====================================@0 初始化环境变量==========================================
//测试模式的变量

Dim res
Dimenv test_mode:test_mode = YS.调试模式.Value//测试模式开关 0关闭|1启动
Dimenv test_flag : test_flag = 0

//单人/多人模式变量
DimEnv process_mode:process_mode = YS.process_mode.Value
Dimenv process_list

//插件环境变量
Dimenv start_time : start_time = now()//插件初次运行的时间
Global currt_day : currt_day = day(now())
Dimenv runing_time : runing_time = 0
Dimenv game_path
DimEnv game_type
Dimenv setting_path : setting_path = Plugin.Sys.GetDir(3)//配置文件目录
Dimenv pics_path : pics_path = Plugin.Sys.GetDir(3) & "\shot"//图片查找路径
DimEnv ini_file//用户配置保存文件
Dimenv default_path//插件默认目录
Dimenv currt_mode:currt_mode = 获取下拉(YS.select_mode.list, YS.select_mode.listindex)//当前模式
Dimenv currt_page//记录当前所在页面
Dimenv fujian : fujian = 60//记录附件图片数量
Dimenv fight_res//上一次战斗结果
Dimenv tmp : tmp = 0//挂机模式的时间计算变量

//状态栏变量
Dimenv state_flag : state_flag = 0
Dimenv state_text : state_text = "程序运行中"

//=====================================@1 依赖函数库==========================================
//多线程统计数据
Sub 时间统计()
    While 1
        runing_time = DateDiff("n", start_time, now())
        YS.time.Caption = "插件已运行:" & runing_time & "分钟"
        Delay 6000
    Wend
End Sub

//!5日志记录
Sub log(str)
    If YS.log.ListCount >= ((YS.log数量.ListIndex+1)*100) Then
        YS.log.list="简要日志|-----"
    End If

    str = Time & "--" & str
    YS.log.InsertItem str, 1
    YYS_log.loglist.InsertItem str, 1
    TracePrint "记录日志：" & str
End Sub

//!6下方状态栏
Sub 下方状态栏(text)
    If test_mode = 1 Then
        YS.currt_log.TextColor = "0080FF"
    ElseIf test_mode = 0 Then
        YS.currt_log.TextColor = "40FF00"
    End If

    //最下方状态条
    If state_flag mod 3 = 0 Then
        state_text = text & "."
    Else
        state_text = state_text & ".."
    End If
    YS.currt_state.Caption = state_text
    state_flag = state_flag + 1
End Sub

//异常处理
Sub 异常处理()
    Call Lib.YYS_异常处理.go_home(pics_path)
    Call Lib.YYS_主界面.双倍开关(pics_path, "all", "关闭")
End Sub


//主界面待机开关
Event YS.home_auto_select.Click
    YS.好友寄养.Value = YS.home_auto_select.Value
    YS.个人突破.Value = YS.home_auto_select.Value
    YS.寮突破.Value = YS.home_auto_select.Value
    YS.年兽副本.Value = YS.home_auto_select.Value
    YS.逢魔之时.Value = YS.home_auto_select.Value
    YS.逢魔首领.Value = YS.home_auto_select.Value
    YS.地域鬼王.Value = YS.home_auto_select.Value
    YS.阴界之门.Value = YS.home_auto_select.Value
    YS.每日签到.Value = YS.home_auto_select.Value
    YS.早晚体力.Value = YS.home_auto_select.Value
    //    YS.地图体力.Value = YS.home_auto_select.Value
    YS.永久勾玉.Value = YS.home_auto_select.Value
    YS.同心之兰.Value = YS.home_auto_select.Value
    YS.领取邮件.Value = YS.home_auto_select.Value
    YS.周末双倍.Value = YS.home_auto_select.Value
    YS.自动接受悬赏.Value = YS.home_auto_select.Value
    YS.宠物奖励.Value = YS.home_auto_select.Value
    YS.年兽副本.Value = YS.home_auto_select.Value
    YS.地域鬼王.Value = YS.home_auto_select.Value
    YS.个人突破.Value = YS.home_auto_select.Value
    YS.逢魔之时.Value = YS.home_auto_select.Value
    YS.商店黑蛋.Value = YS.home_auto_select.Value
    YS.麒麟.Value = YS.home_auto_select.Value
    //    YS.LBS副本.Value = YS.home_auto_select.Value
End Event

sub 试胆大会计算()
    Dim 好友红心:好友红心=计算(YS.好友红心.Value,4,2,5,2)
    Dim 结界经验:结界经验=计算(YS.结界经验.Value,0,5,1,5)
    //    Dim 赠送碎片:赠送碎片=分数计算(YS.赠送碎片.Value,YS.赠送碎片数.ListIndex,2)
    //    Dim 试胆斗技:试胆斗技=分数计算(YS.试胆斗技.Value,YS.试胆斗技数.ListIndex,5)
    Dim 试胆探索:试胆探索=计算(YS.试胆探索.Value,YS.试胆探索数.ListIndex,6,3,12)
    Dim 试胆御魂:试胆御魂=计算(YS.试胆御魂.Value,YS.试胆御魂数.ListIndex,3,3,6)
    Dim 试胆觉醒:试胆觉醒=计算(YS.试胆觉醒.Value,YS.试胆觉醒数.ListIndex,2,1,6)
    Dim 试胆突破:试胆突破=计算(YS.试胆突破.Value, YS.试胆突破数.ListIndex, 2,2,5)
    Dim counts:counts = 好友红心 + 结界经验 + 试胆斗技 + 试胆探索 + 试胆御魂 + 试胆觉醒 + 试胆突破
    YS.设定值.Caption = counts
End sub

Function 计算(开关, 次数, 分值, 首次记分, 首次分值)
    次数=次数+1
    Dim res1, res2
    If 开关 = 0 Then
        分值 = 0
        首次 = 0
        次数 = 0
        首次记分 =0
        首次分值 = 0
    ElseIf 次数 <= 首次记分 Then
        计算 = 次数 * 首次分值
    ElseIf 次数 > 首次记分 Then
        res1 = 首次记分 * 首次分值
        res2 = (次数 - 首次记分) * 分值
        计算 = res1 + res2
    End If
End Function

//tar 以|分隔的字符串
//index 获取分割后第几个元素
Function 获取下拉(tar, index)
    获取下拉 = ""
    //        TracePrint "当前tar：" & tar
    //        TracePrint "当前index：" & index
    Dim res
    res = split(tar, "|")
    If vartype(res) = 8204 Then
        If UBound(res) >= index Then
            获取下拉 = res(index)
        End If
    End If
End Function

/*=====================================@2 主功能函数库==========================================
1【组队模式】 2【挂机模式】 3【探索模式】
*/

//================================!1【组队模式】================================
function team_settings()
    dim 队员人数:队员人数=获取下拉(YS.队员人数.list, YS.队员人数.listindex)
    Dim 当前身份 : 当前身份 = 获取下拉(YS.menber_mode.list, YS.menber_mode.listindex)

    Dim 创建类型:创建类型 =""
    If YS.创建队伍.Value=1 Then
        创建类型 = 获取下拉(YS.创建类型.list, YS.创建类型.listindex)
    End If


    dim 双倍开关:双倍开关=YS.定时双倍.Text
    dim 设定层数:设定层数=YS.层数.listindex + 1
    dim 邀请类型:邀请类型=获取下拉(YS.队伍权限.list, YS.队伍权限.listindex)

    dim 阵容选择
    select case 当前身份
    case "只做队长"
        阵容选择=获取下拉(YS.队长御魂阵容.list, YS.队长御魂阵容.listindex)
    case "只做队员"
        阵容选择=获取下拉(YS.队员御魂阵容.list, YS.队员御魂阵容.listindex)
    case else
        阵容选择=获取下拉(YS.队长御魂阵容.list, YS.队长御魂阵容.listindex)

    end select
    dim 是否邀请:是否邀请=YS.失败邀请.listindex

    dim 手动点怪
    select case 创建类型
    case "御魂"
        手动点怪=获取下拉(YS.御魂第一回合.list, YS.御魂第一回合.listindex) &"|"& 获取下拉(YS.御魂第二回合.list, YS.御魂第二回合.listindex) &"|"& 获取下拉(YS.御魂第三回合.list, YS.御魂第三回合.listindex)
    case "觉醒"
        手动点怪="不点怪|不点怪|不点怪"
    case "业原火"
        手动点怪="不点怪|不点怪|不点怪"
    case else
        手动点怪="不点怪|不点怪|不点怪"
    End Select

    Dim 邀请设置 : 邀请设置 = YS.自动邀请.Value & "|" & (YS.邀请人数.listindex + 1) & "|" & YS.最近组队.Value
    Dim 御魂次数
    If YS.御魂次数.Text <> "" and YS.御魂次数.Text <> 0 Then
        御魂次数 = cint(YS.御魂次数.Text)
    Else
        御魂次数 = 0
    End If

    team_settings = split(队员人数 & "-" & 当前身份 & "-" & 创建类型 & "-" & 双倍开关 & "-" & 设定层数 & "-" & 邀请类型 & "-" & 阵容选择 & "-" & 是否邀请 & "-" & 手动点怪 & "-" & 邀请设置& "-" &御魂次数, "-")
End Function

Event YS.创建类型.SelectChange
    TracePrint "创建类型："&YS.创建类型.ListIndex
    Select case YS.创建类型.ListIndex
    Case 0//御魂
        YS.层数.list = "一层|二层|三层|四层|五层|六层|八层|九层|十层|十一层"
        YS.层数.listindex = 10
    Case 1//觉醒
        YS.层数.list = "一层|二层|三层|四层|五层|六层|八层|九层|十层"
        YS.层数.listindex = 9
    Case 2//业原火
        YS.层数.list = "贪|慎|痴"
        YS.层数.listindex = 0
    End Select
End Event

Function 组队模式(当前账号, 图片路径)
    设置 = team_settings()
    Dim 御魂次数:御魂次数 = cint(设置(10))
    dim 战斗次数:战斗次数 = 0
    Dim 计数开关 : 计数开关 = 0

    TracePrint "-------御魂次数:" & 御魂次数
    While 1
        //                            (图片路径, 队员人数, 当前身份, 创建类型, 双倍开关, 层数, 邀请类型, 阵容选择, 是否邀请, 手动点怪,邀请设置)
        res = Lib.YYS_御魂模式.御魂模式(图片路径, 设置(0), 设置(1), 设置(2), 设置(3), 设置(4), 设置(5), 设置(6), 设置(7), 设置(8), 设置(9))
        TracePrint "*********--------御魂模式外部结果：" & res

        Select Case res
        Case "等待超时"
            Call Lib.YYS_异常处理.go_home(图片路径)
            Call Lib.YYS_主界面.homeTo(图片路径, "大地图")
        End Select

        If 计数开关 = 0 and res = "战斗中" Then
            计数开关 = 1

        ElseIf 计数开关 = 1 and res <> "" and res <> "战斗中" Then
            战斗次数 = 战斗次数 + 1
            YS.御魂统计.Caption = "当前御魂次数：[" & 战斗次数 & "]"
            计数开关 = 0
        End If

        If 御魂次数 > 0 Then
            TracePrint "当前战斗次数：" & 战斗次数
            TracePrint "设定战斗次数：" & 御魂次数
            If 战斗次数 >= 御魂次数 and res <> "战斗中" Then
                TracePrint "已执行到指定次数，结束御魂模式"
                Call Lib.CPS.定时关机("关机", 0, 10)
            End If
        End If

        if YS.process_mode.Value = 1 Then
            TracePrint "当前在单开模式。"
            设置=team_settings()
            If currt_mode <> "组队模式" Then
                exit function
            End If
        End If
    Wend
End function
//================================!1【组队模式】================================


//================================!2【挂机模式】================================
Function 挂机模式(account, 图片目录)
    Call log("挂机模式启动")

    //探索设置
    Dim 探索设置:探索设置=tansuo_settings()
    Dim 探索开关
    If YS.挂机探索.Value = 1 Then
        探索开关 = YS.探索转挂机.Value
    End If

    Dim 探索执行:探索执行=探索开关
    Dim 探索冷却:探索冷却=""

    //妖气封印 妖气开关|妖气执行|妖气次数|妖气体力|妖气阵容|妖气
    dim 妖气设置:妖气设置= yaoqi_settings()
    Dim 妖气开关:妖气开关= 妖气设置(0)
    dim 妖气执行:妖气执行= 妖气开关
    dim 妖气冷却:妖气冷却= ""

    //联动设置
    Dim 联动设置:联动设置= liandong_settings()
    Dim 联动开关:联动开关= 联动设置(0)
    Dim 联动执行:联动执行= 联动开关
    Dim 联动冷却 : 联动冷却 = ""

    //LBS设置
    Dim LBS开关:LBS开关= YS.LBS副本.Value
    Dim LBS执行:LBS执行= LBS开关
    Dim LBS冷却 : LBS冷却 = ""

    //经验设置
    dim 经验设置:经验设置 = jingyan_settings()
    dim 经验开关:经验开关 = 经验设置(0)
    dim 经验执行:经验执行 = 经验开关
    dim 经验冷却:经验冷却 = ""

    //石距设置
    dim 石距设置 :石距设置 = shiju_settings()
    dim 石距开关 :石距开关 = 石距设置(0)
    dim 石距执行 :石距执行 = 石距开关
    dim 石距冷却 :石距冷却 = ""

    //年兽设置
    dim 年兽设置:年兽设置 = nianshou_settings()
    dim 年兽开关:年兽开关 = 年兽设置(0)
    dim 年兽执行:年兽执行 = 年兽开关
    dim 年兽冷却:年兽冷却 = ""

    //金币设置
    dim 金币设置:金币设置 = jinbi_settings()
    dim 金币开关:金币开关 = 金币设置(0)
    dim 金币执行:金币执行 = 金币开关
    dim 金币冷却:金币冷却 = ""

    //突破设置
    dim 个突设置:个突设置 = person_tupo_settings()
    dim 个突开关:个突开关 = 个突设置(0)
    dim 个突执行:个突执行 = 个突开关
    dim 个突冷却:个突冷却 = ""

    //寮突设置
    dim 寮突设置:寮突设置 = liao_tupo_settings()
    dim 寮突开关:寮突开关 = 寮突设置(0)
    dim 寮突执行:寮突执行 = 寮突开关
    Dim 寮突冷却 : 寮突冷却 = ""

    //开启寮突
    dim 启寮设置:启寮设置 = liao_open_settings()
    dim 启寮开关:启寮开关 = 启寮设置(0)
    dim 启寮执行:启寮执行 = 启寮开关
    Dim 启寮冷却 : 启寮冷却 = ""

    //地域鬼王
    dim 地域设置:地域设置 = diyu_settings()
    dim 地域开关:地域开关 = 地域设置(0)
    dim 地域执行:地域执行 = 地域开关
    dim 地域冷却:地域冷却 = ""

    //逢魔设置
    dim 逢魔设置:逢魔设置 = fengmo_settings()
    dim 逢魔开关:逢魔开关 = 逢魔设置(0)
    dim 逢魔执行:逢魔执行 = 逢魔开关
    dim 逢魔冷却:逢魔冷却 = ""

    dim 首领设置:首领设置=fengmo_boss_settings()
    dim 首领开关:首领开关=首领设置(0)
    dim 首领执行:首领执行=首领开关
    dim 首领冷却:首领冷却=""

    //阴界之门
    dim 阴界设置:阴界设置 = yinjie_settings()
    dim 阴界开关:阴界开关 = 阴界设置(0)
    dim 阴界执行:阴界执行 = 阴界开关
    dim 阴界冷却:阴界冷却 = ""

    //狩猎战
    dim 麒麟设置:麒麟设置 = qilin_settings()
    dim 麒麟开关:麒麟开关 = 麒麟设置(0)
    dim 麒麟执行:麒麟执行 = 麒麟开关
    dim 麒麟冷却:麒麟冷却 = ""

    //结界卡
    dim 结界卡设置:结界卡设置=jiejieka_settings()
    dim 结界卡开关:结界卡开关=结界卡设置(0)
    dim 结界卡执行:结界卡执行=结界卡开关
    Dim 结界卡冷却 : 结界卡冷却 = ""

    //寄养
    dim 寄养设置:寄养设置=jiyang_settings(account)
    dim 寄养开关:寄养开关=寄养设置(0)
    dim 寄养执行:寄养执行=寄养开关
    Dim 寄养冷却 : 寄养冷却 = ""

    //@48活动副本
    dim 活动设置 :活动设置 = huodong_settings()
    dim 活动开关 :活动开关 = YS.活动开关.Value
    dim 活动执行 :活动执行 = 活动开关
    dim 活动冷却 :活动冷却 = ""

    //业原设置
    Dim 业原设置 : 业原设置 = chi_settings()
    Dim 业原开关 : 业原开关 = 业原设置(0)
    Dim 业原执行 : 业原执行 = 业原开关
    Dim 业原冷却 : 业原冷却 = ""

    //刷协战
    Dim 协战开关:协战开关=YS.好友协战.Value
    Dim 协战执行:协战执行=协战开关
    Dim 协战冷却 : 协战冷却 = ""

    //超鬼王设置
    Dim 超鬼开关 : 超鬼开关 = YS.超鬼王.Value
    Dim 超鬼执行 : 超鬼执行 = 超鬼开关
    Dim 超鬼冷却 : 超鬼冷却 = ""

    //御灵设置
    Dim 御灵设置 : 御灵设置 = yuling_settings()
    Dim 御灵开关 : 御灵开关 = YS.御灵副本.Value
    Dim 御灵执行 : 御灵执行 = 御灵开关
    Dim 御灵冷却 : 御灵冷却 = ""


    //主界面待机
    Dim 每日开关
    Dim 每日设置:每日设置=home_settings()
    If vartype(每日设置) = 8204 Then
        每日开关 = 1
    Else
        每日开关 = 0
    End If

    //13.5

    //等待间隔
    Dim tmp : tmp = 0

    //函数开始时执行一次
    Dim home_feature:home_feature=home_settings()
    call Lib.YYS_主界面.主界面奖励(图片目录)

    Dim run_flag:run_flag=0
    While 1
        run_flag = 0

        //每日任务
        //        If 每日开关 = 1 Then
        //            Call 每日任务(account, 图片目录, 超鬼设置)
        //        End If

        //御灵
        If 御灵开关 = 1 Then
            if 御灵冷却 = "完成" then
                御灵执行 = 0
            else
                res = Lib.YYS.冷却检查(御灵冷却)
                If res = "完毕" Then
                    御灵执行=1
                Else
                    御灵执行=0
                End If
            End If

            If 御灵执行 = 1 Then
                御灵冷却 = 御灵(account, 图片目录, 御灵设置)
            End If
        End If
        run_flag = run_flag + 御灵执行

        //超鬼王
        If 超鬼开关 = 1 Then
            res = Lib.YYS.冷却检查(超鬼冷却)
            If res = "完毕" Then
                超鬼执行 = 1
            Else
                超鬼执行 = 0
                Call log("1下次探索执行时间：" & 超鬼冷却)
            End If

            If 超鬼执行 = 1 Then
                超鬼冷却 = 超鬼王(account, 图片目录, 超鬼设置)
            End If
        End If


        //探索模式
        If 探索开关 = 1 Then
            res = Lib.YYS.冷却检查(探索冷却)
            If res = "完毕" Then
                探索执行 = 1
            Else
                探索执行 = 0
                Call log("1下次探索执行时间：" & 探索冷却)
            End If

            TracePrint "执行挂机模式探索。"
            If 探索执行 = 1 Then
                探索冷却 = 探索模式(account, 图片目录, 探索设置)
                If 探索冷却 = "完成" Then
                    //不再执行探索
                    个突执行 = 个突开关
                    寄养执行 = 寄养开关
                    探索开关 = 0
                    个突冷却 = ""

                ElseIf 探索冷却 = "执行挂机" Then
                    探索执行 = 1
                    个突执行 = 个突开关
                    寄养执行 = 寄养开关
                    个突冷却 = ""
                    探索冷却 = ""

                End If
                TracePrint "********-----+++++探索最外部结果：" & 探索冷却
            End If
            Call log("2下次探索执行时间：" & 探索冷却)
            TracePrint "探索执行开关：" & 探索执行
        End If
        run_flag = run_flag + 探索执行

        //开启寮突
        If 启寮开关 = 1 Then
            If 启寮执行 = 1 Then
                //                call Lib.YYS_异常处理.go_home(pics_path)
                启寮冷却 = 开启寮突(account, 图片目录, 启寮设置)
                If 启寮冷却 = "完成" Then
                    启寮执行 = 0
                Else
                    res = Lib.YYS.冷却检查(启寮冷却)
                    If res = "完毕" Then
                        启寮执行=1
                    Else
                        启寮执行=0
                    End If
                End If
            End If
        End If
        run_flag = run_flag + 启寮执行
        //        TracePrint "当前执行开关：" & run_flag

        //阴界之门
        If 阴界开关 = 1 Then
            If 阴界冷却 = "完成" Then
                阴界开关 = 0
                阴界执行 = 0
            Else
                res = Lib.YYS.冷却检查(阴界冷却)
                If res = "完毕" Then
                    阴界执行=1
                Else
                    阴界执行=0
                End If
            End If

            If 阴界执行 = 1 Then
                阴界冷却=阴界之门(account,图片目录, 阴界设置)
            End If
            Call log(account& "阴界之门下次执行时间为：" & 阴界冷却)
        End If
        run_flag = run_flag + 阴界执行
        //        TracePrint "阴界之门执行开关：" & run_flag

        //狩猎战
        If 麒麟开关 = 1 Then
            If 麒麟冷却 = "完成" Then
                麒麟开关 = 0
                麒麟执行 = 0
            Else
                res = Lib.YYS.冷却检查(麒麟冷却)
                If res = "完毕" Then
                    麒麟执行=1
                Else
                    麒麟执行 = 0
                    Call log(account& "麒麟之门下次执行时间为：" & 麒麟冷却)
                End If
            End If
            If 麒麟执行 = 1 Then
                //                    call Lib.YYS_异常处理.go_home(pics_path)
                麒麟冷却=麒麟(account,图片目录, 麒麟设置)
            End If
        End If
        run_flag = run_flag + 麒麟执行
        //        TracePrint "狩猎战执行开关：" & run_flag

        //结界卡
        If 结界卡开关 = 1 Then
            res = Lib.YYS.冷却检查(结界卡冷却)
            If res = "完毕" Then
                结界卡执行=1
            Else
                结界卡执行=0
                Call log(account & "结界卡下次执行时间为：" & 结界卡冷却)
            End If
            If 结界卡执行 = 1 Then
                结界卡冷却=结界卡(account,图片目录, 结界卡设置)
            End If
        End If
        run_flag = run_flag + 结界卡执行
        //        TracePrint "当前执行开关：" & run_flag

        //好友寄养
        If 寄养开关 = 1 Then
            res = Lib.YYS.冷却检查(寄养冷却)
            If res = "完毕" Then
                寄养执行 = 1
            Else
                寄养执行 = 0
                Call log(account& "好友寄养下次执行时间为：" & 寄养冷却)
            End If
            If 寄养执行 = 1 Then
                //                call Lib.YYS_异常处理.go_home(pics_path)
                寄养冷却 = 好友寄养(account, 图片目录, 寄养设置)
            End If
        End If
        run_flag = run_flag + 寄养执行
        //        TracePrint "寄养执行开关：" & 寄养执行

        //逢魔之时
        If 逢魔开关 = 1 Then
            if 逢魔冷却 = "完成" or 逢魔冷却 = "已过时" then
                逢魔执行=0
            else
                res = Lib.YYS.冷却检查(逢魔冷却)
                If res = "完毕" Then
                    逢魔执行=1
                Else
                    逢魔执行=0
                    Call log(account& "逢魔之时下次执行时间为：" & 逢魔冷却)
                End If
            end if
            If 逢魔执行 = 1 Then
                //                call Lib.YYS_异常处理.go_home(pics_path)
                逢魔冷却 = 逢魔奖励(account,图片目录, 逢魔设置)
            End If
        End If
        run_flag = run_flag + 逢魔执行
        //        TracePrint "逢魔执行开关：" & 逢魔执行

        //逢魔首领
        If 首领开关 = 1 Then
            if 首领冷却 = "完成" then
                首领执行=0
            else
                res = Lib.YYS.冷却检查(首领冷却)
                If res = "完毕" Then
                    首领执行=1
                Else
                    首领执行=0
                    Call log(account& "逢魔首领之时下次执行时间为：" & 首领冷却)
                End If
            End If
            If 首领执行 = 1 Then
                首领冷却 = 逢魔首领(account,图片目录, 首领设置)
            End If
        End If
        run_flag = run_flag + 首领执行
        //        TracePrint "首领执行开关：" & 首领执行

        //地域鬼王
        If 地域开关 = 1 Then
            If 地域执行 = 1 Then
                地域冷却 = 地域鬼王(account, 图片目录, 地域设置)
            end if
            select case 地域冷却
            case "完成"
                地域执行=0
            case else
                res = Lib.YYS.冷却检查(地域冷却)
                If res = "完毕" Then
                    地域执行=1
                Else
                    地域执行=0
                    Call log(account& "地域鬼王下次执行时间为：" & 地域冷却)
                End If
            end select
        End If
        run_flag = run_flag + 地域执行
        //        TracePrint "地域执行开关：" & 地域执行

        //寮突破
        If 寮突开关 = 1 Then
            res = Lib.YYS.冷却检查(寮突冷却)
            If res = "完毕" Then
                寮突执行 = 1
            Else
                寮突执行 = 0
                Call log(account& "寮突副本下次执行时间为：" & 寮突冷却)
            End If

            If 寮突执行 = 1 Then
                //call Lib.YYS_异常处理.go_home(pics_path)
                寮突冷却 = 寮突破(account, 图片目录, 寮突设置)
            End If
        End If
        run_flag = run_flag + 寮突执行
        //        TracePrint "当前执行开关寮突破：" & run_flag

        //联动
        If 联动开关 = 1 Then
            res = Lib.YYS.冷却检查(联动冷却)
            If res = "完毕" Then
                联动执行 = 1
            Else
                联动执行 = 0

            End If
            If 联动执行 = 1 Then
                联动冷却 = 联动副本(account, 图片目录, 联动设置)
            End If
            Call log(account& "联动副本下次执行时间为：" & 联动冷却)
        End If
        run_flag = run_flag + 联动执行

        //联动
        If LBS开关 = 1 Then
            res = Lib.YYS.冷却检查(LBS冷却)
            If res = "完毕" Then
                LBS执行 = 1
            Else
                LBS执行 = 0

            End If
            If LBS执行 = 1 Then
                LBS冷却 = LBS副本(account, 图片目录, LBS设置)
            End If
            Call log(account& "LBS副本下次执行时间为：" & LBS冷却)
        End If
        run_flag = run_flag + LBS执行

        //经验
        If 经验开关 = 1 Then
            res = Lib.YYS.冷却检查(经验冷却)
            If res = "完毕" Then
                经验执行 = 1
            Else
                经验执行 = 0
                Call log(account& "经验副本下次执行时间为：" & 经验冷却)
            End If
            If 经验执行 = 1 Then
                //                call Lib.YYS_异常处理.go_home(pics_path)
                经验冷却 = 经验副本(account, 图片目录, 经验设置)
            End If
        End If
        run_flag = run_flag + 经验执行
        //        TracePrint "当前执行开关：" & run_flag

        //石距
        If 石距开关 = 1 Then
            res = Lib.YYS.冷却检查(石距冷却)
            If res = "完毕" Then
                石距执行 = 1
            Else
                石距执行 = 0
                Call log(account& "石距副本下次执行时间为：" & 石距冷却)
            End If
            If 石距执行 = 1 Then
                //                call Lib.YYS_异常处理.go_home(pics_path)
                石距冷却 = 石距副本(account, 图片目录, 石距设置)
            End If
        End If
        run_flag = run_flag + 石距执行
        //        TracePrint "当前执行开关：" & run_flag


        //年兽
        If 年兽开关 = 1 Then
            res = Lib.YYS.冷却检查(年兽冷却)
            If res = "完毕" Then
                年兽执行 = 1
            Else
                年兽执行 = 0
                Call log(account& "年兽副本下次执行时间为：" & 年兽冷却)
            End If
            If 年兽执行 = 1 Then
                //                call Lib.YYS_异常处理.go_home(pics_path)
                年兽冷却 = 年兽副本(account, 图片目录, 年兽设置)
            End If
        End If
        run_flag = run_flag + 年兽执行
        //        TracePrint "当前执行开关：" & run_flag


        //@48活动副本
        If 活动开关 = 1 Then
            If 活动冷却 = "完成" Then
                活动执行 = 0
            Else
                res = Lib.YYS.冷却检查(活动冷却)
                If res = "完毕" Then
                    活动执行 = 1
                Else
                    活动执行 = 0
                End If
            End If

            If 活动执行 = 1 Then
                活动冷却 = 活动副本(account, 图片目录, 活动设置)
            End If
        End If
        run_flag = run_flag + 活动执行
        //        TracePrint "当前执行开关：" & run_flag

        //个人突破
        If 个突开关 = 1 Then
            if 个突冷却 = "完成" then
                个突执行=0
            else
                res = Lib.YYS.冷却检查(个突冷却)
                If res = "完毕" Then
                    个突执行=1
                Else
                    个突执行=0
                    Call log(account& "个人突破下次执行时间为：" & 个突冷却)
                End If
            end if
            If 个突执行 = 1 Then
                个突冷却=个人突破(account,图片目录, 个突设置)
            End If
        End If
        TracePrint "个突冷却：" & 个突冷却
        run_flag = run_flag + 个突执行
        //        TracePrint "当前执行开关：" & 个突执行


        //业原火
        If 业原开关 = 1 Then
            if 业原冷却 = "完成" then
                业原执行 = 0
            else
                res = Lib.YYS.冷却检查(业原冷却)
                If res = "完毕" Then
                    业原执行=1
                Else
                    业原执行=0

                End If
            end if
            If 业原执行 = 1 Then
                业原冷却 = 业原火(account, 图片目录, 业原设置)
            End If
            Call log(account& "个人突破下次执行时间为：" & 业原冷却)
        End If
        run_flag = run_flag + 业原执行

        //金币
        If 金币开关 = 1 Then
            res = Lib.YYS.冷却检查(金币冷却)
            If res = "完毕" Then
                金币执行 = 1
            Else
                金币执行 = 0
                Call log(账号& "金币副本下次执行时间为：" & 金币冷却)
            End If
            If 金币执行 = 1 Then
                金币冷却 = 金币副本(account, 图片目录, 金币设置)
            End If
        End If
        run_flag = run_flag + 金币执行
        TracePrint "当前执行开关：" & run_flag

        //地图体力
        If 地体开关 = 1 Then
            res = Lib.YYS.冷却检查(地体冷却)
            If res = "完毕" Then
                地体执行 = 1
            Else
                地体执行 = 0
            End If
            If 地体执行 = 1 Then
                地体冷却 = 地图体力(account, 图片目录, 地体设置)
            End If
            Call log(账号& "地体副本下次执行时间为：" & 地体冷却)
        End If
        run_flag = run_flag + 地体执行

        //刷协战
        If 协战开关 = 1 Then
            If 协战执行 = 1 Then
                协战冷却 = 好友协战(account, 图片目录, 协战设置)
                If 协战冷却 = "完成" Then
                    协战执行=0
                Else
                    res = Lib.YYS.冷却检查(协战冷却)
                    If res = "完毕" Then
                        协战执行=1
                    Else
                        协战执行=0
                    End If
                End If
            End If
        End If
        run_flag = run_flag + 协战执行

        //妖气
        If 妖气开关 = 1 Then
            If 妖气执行 = 1 Then
                妖气冷却 = 妖气封印(account, 图片目录, 妖气设置)
            end if

            If 妖气冷却 = "完成" Then
                //执行完毕
                妖气执行=0
            elseif 妖气冷却 <> "" and 妖气冷却 <> "完成" then
                res = Lib.YYS.冷却检查(妖气冷却)
                If res = "完毕" Then
                    妖气执行=1
                Else
                    妖气执行=0
                    //                    Call log(账号& "妖气鬼王下次执行时间为：" & 妖气冷却)
                End If
            End If
        End If
        run_flag = run_flag + 妖气执行

        if run_flag > 0 Then
            //既说明还有副本要执行
            //单人模式的话，检查当前模式是否改变
            Delay 2500

        ElseIf run_flag = 0 Then
            //执行主界面待机功能

            //所以副本都在冷却中，检测是否需要执行随机事件
            //如果开启了随机事件，将执行随机事件
            If tmp mod 60 = 0 or tmp=0 Then
                Call log("[" & account & "] " & time() & "==>所有模式均在冷却执行待机，当前已待机：" & tmp & "分钟")
                Call Lib.YYS_异常处理.go_home(图片目录)
            End If
            Delay 10000
            tmp = tmp + 1//记录当前已等待的时间，单位为分钟
        End If

        Call Lib.YYS_异常处理.悬赏邀请(图片目录, "")
        Call Lib.YYS_主界面.主界面奖励(图片目录)

        if YS.process_mode.Value = 1 Then
            TracePrint "更新配置。。。。。。。。。。。"
            //重新读取开关配置
            妖气开关=YS.妖气封印.value
            联动开关 = YS.联动副本.value
            LBS开关=YS.LBS副本.value
            经验开关=YS.经验副本.value
            石距开关=YS.石距副本.value
            年兽开关=YS.年兽副本.value
            金币开关=YS.金币副本.value
            个突开关=YS.个人突破.value
            寮突开关=YS.寮突破.value
            启寮开关=YS.创建寮突.value
            地域开关=YS.地域鬼王.value
            逢魔开关=YS.逢魔之时.value
            首领开关=YS.逢魔首领.value
            阴界开关=YS.阴界之门.value
            结界卡开关 = YS.结界卡.value
            寄养开关 = YS.好友寄养.value
            麒麟开关 = YS.麒麟.value
            业原开关 = YS.业原火.Value
            地体开关 = YS.地图体力.Value
            If currt_mode <> "挂机模式" Then
                exit function
            End If
        End If
    wend
End Function
//14
//================================!2【挂机模式】================================


//================================!3【探索模式】================================
Function tansuo_settings()
    //常规设置
    Dim 探索开关 : 探索开关=YS.探索转挂机.Value
    Dim 探索模式 : 探索模式 = 获取下拉(YS.组队单人.list, YS.组队单人.listindex)
    Dim 队员类型 : 队员类型 = 获取下拉(YS.队员队长.list, YS.队员队长.listindex)
    Dim 探索难度 : 探索难度 = 获取下拉(YS.探索难度.list, YS.探索难度.listindex)
    Dim 探索章节 : 探索章节 = YS.探索章节.listindex


    //特别设置
    Dim 探索双倍 : 探索双倍 = YS.探索双倍.value
    Dim 只打经验:只打经验 = YS.只打经验.value

    //狗粮设置
    Dim 狗粮开关 : 狗粮开关 = YS.更换狗粮.Value
    Dim 狗粮队长 : 狗粮队长 = 获取下拉(YS.狗粮队长.list, YS.狗粮队长.listindex)
    Dim 狗粮类型 : 狗粮类型 = 获取下拉(YS.狗粮类型.list, YS.狗粮类型.listindex)
    Dim 狗粮星级 : 狗粮星级 = YS.狗粮星级.listindex + 2
    Dim 拖动距离 : 拖动距离 = YS.拖动距离.Value
    Dim 狗粮设置 : 狗粮设置 = 狗粮队长 & "|" & 狗粮类型 & "|" & 狗粮星级 & "|" & 拖动距离

    //邀请设置
    Dim 探索邀请 : 探索邀请 = YS.探索邀请.Value
    Dim 邀请类型:邀请类型="最近"
    If 探索邀请 Then
        If YS.探索寮友.Value Then
            邀请类型=邀请类型&"@好友"
        End If
        If YS.探索跨区.Value Then
            邀请类型=邀请类型&"@跨区"
        End If
    End If
    Dim 探索邀请人数 : 探索邀请人数 = 获取下拉(YS.探索邀请人数.list, YS.探索邀请人数.listindex)
    Dim 探索邀请最近:探索邀请最近=YS.探索最近.Value
    Dim 邀请设置:邀请设置=探索邀请 & "|" & 探索邀请人数 & "|" & 探索邀请最近 & "|" & 邀请类型
    TracePrint "邀请设置：" & 邀请设置

    //突破设置
    Dim 穿插突破 : 穿插突破 = YS.穿插突破.Value
    Dim 定时挂机
    If YS.定时挂机.Value Then
        定时挂机 = 获取下拉(YS.定时挂机设置.list, YS.定时挂机设置.listindex)
        //        定时挂机 = YS.定时挂机设置.listindex
    Else
        定时挂机 = "不定时"
    End If

    突破设置 = 穿插突破 & "|" & 定时挂机
    TracePrint "突破设置：" & 突破设置
    '0				1					2			3					4				5				6				7				8					9
    tansuo_settings = split(探索模式 & "-" & 队员类型 & "-" & 探索章节 & "-" & 探索难度 & "-" & 探索双倍 & "-" &只打经验& "-" & 狗粮开关 & "-" & 狗粮设置 & "-" & 邀请设置 & "-" & 突破设置, "-")
End Function

Event YS.组队单人.SelectChange
    Select Case YS.组队单人.ListIndex
    Case 0//单人
        YS.队员队长.ListIndex = 1
        YS.队员队长.Enabled = 0

    Case 1//组队
        YS.队员队长.Enabled = 1

    End Select
End Event

Event YS.探索转挂机.Click
    YS.穿插突破.Enabled = YS.探索转挂机.Value
    YS.穿插突破.Value = YS.探索转挂机.Value
    YS.挂机探索.Value = YS.探索转挂机.Value
End Event

Event YS.穿插突破.Click
    YS.个人突破.Value = YS.穿插突破.Value
    If YS.穿插突破.Value Then
        YS.三次刷新.Value = 0
    End If
End Event

Function 探索模式(account, path,设置)
    Dim res,ret
    dim tansuo_count : tansuo_count = 0
    Dim 探索设置 : 探索设置=设置
    If 探索设置 = "" Then
        探索设置 = tansuo_settings()
    End If
    Dim exit_flag : exit_flag = 0
    Dim 挂机时间, 突破设置
    Dim 启动时间 : 启动时间 = now()
    While 1
        TracePrint "*************************探索模式*************************"
        TracePrint "启动时间：" & 启动时间

        //单人模式下，更新配置
        if YS.process_mode.Value = 1 Then
            探索设置 = tansuo_settings()
        End If

        res = Lib.YYS_探索模式.tansuo(path, 探索设置(0), 探索设置(1), 探索设置(2), 探索设置(3), 探索设置(4), 探索设置(5), 探索设置(6), 探索设置(7), 探索设置(8), 探索设置(9))
        TracePrint time() & "---探索模式结果：" & res
        Select Case res

        Case "超时等待"
            探索模式 = Lib.YYS.创建冷却(Lib.CPS.范围随机(3, 5))
            TracePrint "超时等待,为此检测时间为：" & 探索模式
            exit_flag = 1

        Case "战斗结束"
            tansuo_count = tansuo_count + 1
            TracePrint "*******探索模式成功，计算次数+1，" & tansuo_count

        Case "执行突破"
            探索模式 = Lib.YYS.创建冷却(Lib.CPS.范围随机(2, 2))
            TracePrint "执行突破,为此检测时间为：" & 探索模式
            探索模式="执行挂机"
            exit_flag = 1

        End Select

        //定时突破
        If instr(探索设置(9), "不定时") = 0 Then
            //开启了定时挂机
            TracePrint "探索突破设置：" & 探索设置(9)
            挂机时间 = DateAdd("n", Lib.CPS.范围随机(split(探索设置(9), "|")(1), 5), 启动时间)
            TracePrint "下次突破时间为：" & 挂机时间

            //判断时间
            ret = Lib.YYS.冷却检查(挂机时间)
            If ret = "完毕" Then
                TracePrint "已到挂机时间，退出探索模式"
                探索模式="执行挂机"
                exit_flag = 1
            End If
        End If

        If exit_flag Then
            Call Lib.YYS_异常处理.go_home(path)
            Exit function
        End If
        TracePrint "-------------------------探索模式-------------------------"
    Wend

End Function
//================================!3【探索模式】================================

/*=====================================@3 次功能函数库=======================================
@31主界面待机功能 @32金币副本 @33经验副本 @34石距副本 @35年兽副本 @36联动副本 @37个人突破 @38创建寮突
@39寮突破 @40妖气封印 @41逢魔之时 @42逢魔首领 @43地域鬼王 @44地域鬼王 @45阴界之门 @46好友寄养 @47结界卡
@48活动副本 @49业原火 @50好友协战 @51麒麟 @52地图体力 @53 LBS副本 */

//@31主界面待机功能
Function home_settings()
    Dim res
    res= ""
    If YS.宠物奖励.Value = 1 Then
        res = res & "|" & "宠物奖励"
    End If

    If YS.商店黑蛋.Value = 1 Then
        res = res & "|" & "商店黑蛋"
    End If

    If res = "" Then
        home_settings = ""
    Else
        res = Lib.CPS.strip(str, "|")
        home_settings = split(res, "|")
    End If

End Function

Function 每日任务(account, path, settings)
    Dim res,ret
    //单人模式下，更新配置
    if YS.process_mode.Value = 1 Then
        settings = home_settings()
    End If

    If vartype(settings) = 8204 Then
        For Each eMode In settings
            //读取配置文件
            ret = Lib.YYS.读取配置(path, account, v)
            If ret <> "" Then
                If ret = "未执行" Then
                    res = Lib.YYS_主界面.每日任务(path, v)

                ElseIf Lib.YYS.冷却检查(ret) = "完毕" Then
                    res = Lib.YYS_主界面.每日任务(path, v)

                End If

                //显示执行结果
                If res = "完成" Then
                    TracePrint v & "功能执行成功。"
                Else
                    TracePrint v & "功能执行失败。"
                End If
            End If
        Next
    End If

    Call Lib.YYS_主界面.主界面奖励(path)
End Function

//@32金币副本
//开关|开关2|冷却时间|匹配方式
function jinbi_settings()
    TracePrint "金币副本：更新设置"
    dim jinbi_flag:jinbi_flag = YS.金币副本.Value
    dim jinbi_mode:jinbi_mode = jinbi_flag
    dim jinbi_zhenrong:jinbi_zhenrong = 获取下拉(YS.金币阵容.list, YS.金币阵容.listindex)
    dim jinbi_time:jinbi_time = 0

    //金币开关|金币阵容
    jinbi_settings = split(jinbi_flag & "-" & jinbi_zhenrong, "-")
End function

Event YS.金币副本.Click
    YS.设置页.tab=1
    YS.挂机详细.Tab = 0
End Event

function 金币副本(account, 找图路径, 设置)
    金币副本 = ""
    dim res
    //执行主体
    While 1
        res = Lib.YYS_定时任务.组队副本(找图路径,"金币", "自动","")
        If res = "完成" Then
            //创建冷却
            金币副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(360, 10))
            Exit function
        End If
        Call log(account&"正在执行：金币副本")
    Wend
End Function

//@33经验副本
function jingyan_settings()
    TracePrint "经验副本：更新设置"
    dim jingyan_flag:jingyan_flag = YS.经验副本.Value
    dim jingyan_mode:jingyan_mode = jingyan_flag
    dim jingyan_zhenrong:jingyan_zhenrong = 获取下拉(YS.经验阵容.List,YS.经验阵容.ListIndex)
    dim jingyan_time:jingyan_time = 0

    //金币开关|金币阵容
    jingyan_settings = split(jingyan_mode & "-" & jingyan_zhenrong, "-")
End function

Event YS.经验副本.Click
    YS.设置页.tab=1
    YS.挂机详细.Tab = 0
End Event

//经验开关|经验阵容
function 经验副本(account, 找图路径, 设置)
    经验副本 = ""
    dim res
    //执行主体
    While 1
        res = Lib.YYS_定时任务.组队副本(找图路径,"经验", "自动","")
        If res = "完成" Then
            //创建冷却
            经验副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(360, 10))
            Exit function
        End If
        Call log(account&"正在执行：经验副本")
    Wend
End Function

//@34石距副本
function shiju_settings()
    TracePrint "石距副本：更新设置"
    dim shiju_flag:shiju_flag = YS.石距副本.Value
    dim shiju_mode:shiju_mode = shiju_flag
    dim shiju_check:shiju_check = 获取下拉(YS.石距刷新.list, YS.石距刷新.listindex)
    dim shiju_zhenrong:shiju_zhenrong = 获取下拉(YS.石距阵容.list, YS.石距阵容.listindex)
    dim shiju_time:shiju_time = 0

    shiju_settings = split(shiju_mode & "-" & shiju_check & "-" & shiju_zhenrong, "-")
End function

Event YS.石距副本.Click
    YS.设置页.tab=1
    YS.挂机详细.Tab = 0
End Event

//石距开关|匹配模式|石距阵容
function 石距副本(account, 找图路径, 设置)
    Call log(account & "正在执行：石距副本")
    dim res,exit_flag:exit_flag=0

    //执行主体
    For 600
        //单人模式下，更新配置
        if YS.process_mode.Value = 1 Then
            设置 = shiju_settings()
        End If

        res = Lib.YYS_定时任务.组队副本(找图路径,"石距", 设置(1),设置(2))
        If res = "奖励" or res="胜利" or res="战斗完成" Then
            //创建冷却
            石距副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(60, 5))

            exit_flag = 1
            Else res="冷却中"
            石距副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(15, 5))
            exit_flag = 1
        End If

        If exit_flag = 1 Then
            Call Lib.YYS_异常处理.go_home(找图路径)
            Exit Function
        End If
    Next
    Call Lib.YYS_异常处理.go_home(找图路径)
End Function

//@35年兽副本
function nianshou_settings()
    TracePrint "年兽副本：设置"
    dim nianshou_flag:nianshou_flag = YS.年兽副本.Value
    dim nianshou_mode:nianshou_mode = nianshou_flag
    dim nianshou_check:nianshou_check = 获取下拉(YS.年兽刷新.list, YS.年兽刷新.listindex)
    dim nianshou_zhenrong:nianshou_zhenrong = 获取下拉(YS.年兽阵容.list, YS.年兽阵容.listindex)
    dim nianshou_time:nianshou_time = 0
    nianshou_settings = split(nianshou_mode & "-" & nianshou_check & "-" & nianshou_zhenrong, "-")
End function

Event YS.年兽副本.Click
    YS.设置页.tab=1
    YS.挂机详细.Tab = 0
End Event

function 年兽副本(account, 找图路径, 设置)
    dim res,exit_flag:exit_flag=0
    Call log(account & "正在执行：年兽副本")

    //执行主体
    For 600
        if YS.process_mode.Value = 1 Then
            设置 = nianshou_settings()
        End If

        res = Lib.YYS_定时任务.组队副本(找图路径, "年兽", 设置(1), 设置(2))
        If res = "奖励" or res="胜利" or res="战斗完成" Then
            //创建冷却
            年兽副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(240, 30))
            exit_flag = 1

        ElseIf res = "冷却中" Then
            年兽副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(60, 30))
            exit_flag = 1

        End If

        If exit_flag = 1 Then
            Call Lib.YYS_异常处理.go_home(找图路径)
            Exit Function
        End If
    Next
    Call Lib.YYS_异常处理.go_home(找图路径)
End Function

//@36联动副本
function liandong_settings()
    dim liandong_flag:liandong_flag = YS.联动副本.Value//联动 挂机联动开关
    dim liandong_check:liandong_check = 获取下拉(YS.联动刷新.list, YS.联动刷新.listindex) // 手动/自动
    dim liandong_zhenrong:liandong_zhenrong = 获取下拉(YS.联动阵容.list, YS.联动阵容.listindex) //阵容
    dim liandong_time:liandong_time = 0
    liandong_settings = split(liandong_flag &"-"& liandong_check &"-"& liandong_zhenrong,"-")
End function

function 联动副本(account, 找图路径, 设置)
    dim res,exit_flag:exit_flag=0
    //执行主体
    For 600
        if YS.process_mode.Value = 1 Then
            设置 = liandong_settings()
        End If
        res = Lib.YYS_定时任务.组队副本(找图路径, "联动", 设置(1),设置(2))
        Select Case res
        Case "完成"
            联动副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(5,5))
            exit_flag=1

        Case "失败"
            联动副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(2, 2))
            exit_flag = 1

        Case Else
            If res = "战斗完成" or res = "奖励" Then
                联动副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(10, 5))
                exit_flag = 1
            End If

        End Select

        If exit_flag = 1 Then
            Call Lib.YYS_异常处理.go_home(找图路径)
            Exit Function
        End If
    Next

    联动副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(10, 10))
    Call Lib.YYS_异常处理.go_home(找图路径)
End Function

//@37个人突破
//打到一页都是60级的时候就退，退8次然后刷新，会匹配到59级的，一般周四过后59级中会有很多勋章多的，而且很好打
Function person_tupo_settings()
    TracePrint "个人突破：设置"
    dim person_tupo_flag:person_tupo_flag = YS.个人突破.Value
    dim person_tupo_mode:person_tupo_mode = person_tupo_flag
    Dim person_tupo_level
    Select Case YS.person_level.listindex
    Case 0
        person_tupo_level=6
    Case 1
        person_tupo_level=5
    Case 2
        person_tupo_level=0
    End Select

    dim person_tupo_check:person_tupo_check = YS.三次刷新.Value
    dim person_tupo_zhenrong1:person_tupo_zhenrong1 = YS.person_zhenrong1.ListIndex
    dim person_tupo_retry:person_tupo_retry = YS.二次挑战.Value
    dim person_tupo_zhenrong2:person_tupo_zhenrong2=YS.person_zhenrong2.ListIndex
    dim person_change_zhenrong:person_change_zhenrong=YS.失败后换阵容.Value
    dim person_tupo_time:person_tupo_time = 0

    //(account,pics_path,个突设置(0),个突设置(1), 个突设置(2),个突设置(3),个突设置(4),个突设置(5))
    //                    突破开关，突破等级，三次刷新，突破阵容1，战败重试，突破阵容2
    person_tupo_settings = split(person_tupo_flag & "-" & person_tupo_level & "-" & person_tupo_check & "-" & person_tupo_zhenrong1 & "-" & person_tupo_retry & "-" & person_tupo_zhenrong2 & "-" & person_change_zhenrong,"-")
End Function

Event YS.个人突破.Click
    YS.设置页.tab=2
    YS.挂机详细.Tab = 3
End Event

Event YS.寮突破.Click
    YS.设置页.tab=1
    YS.挂机详细.Tab = 3
End Event

Event YS.三次刷新.Click
    Select Case YS.三次刷新.Value
    Case 0
        YS.person_level.Enabled = 1
    Case 1
        YS.person_level.Enabled = 0
        YS.person_level.listindex = 0
    End Select
End Event

Function 个人突破(account, path, settings)
    //(account,pics_path,个突设置(0),个突设置(1), 个突设置(2),个突设置(3),个突设置(4),个突设置(5),个突设置(6))
    //                    突破开关， 星级等级，   三次刷新，  突破阵容1， 二次挑战，  突破阵容2,   换阵重试
    个人突破 = ""
    Dim res, ret
    dim 个突设置:个突设置=settings
    Dim 阵容 : 阵容 = 个突设置(3)
    Dim ka_flag : ka_flag = 0
    Dim exit_flag : exit_flag = 0
    Call log(account & "正在执行：个人突破")
    While 1
        //单人模式下，更新配置
        if YS.process_mode.Value = 1 Then
            TracePrint "单人模式下，更新配置"
            个突设置 = person_tupo_settings()
        End If
        //                     个人突破(path,    星级设置,   三次刷新,    阵容1,      二次挑战,   阵容2,      换阵挑战)
        个人突破 = Lib.YYS_突破相关.个人突破(path, 个突设置(1), 个突设置(2), 阵容, 个突设置(4))
        TracePrint "个人突破结果：" & 个人突破
        If 个人突破 <> "" Then
            ka_flag = 0
        End If
        Select Case 个人突破
        Case ""
            //卡屏检测
            ka_flag = ka_flag + 1
            TracePrint "卡屏次数：" & ka_flag
            If ka_flag > 50 Then
                个人突破=Lib.YYS.创建冷却(Lib.CPS.范围随机(3, 3))
                exit_flag = 1
            End If

        Case "突破卷为零"
            个人突破 = "完成"
            exit_flag = 1

        case "刷新冷却中"
            个人突破 = Lib.YYS.创建冷却(Lib.CPS.范围随机(2, 2))
            exit_flag = 1

        case "冷却中"
            个人突破 = Lib.YYS.创建冷却(Lib.CPS.范围随机(2, 2))
            exit_flag = 1

        case "失败"
            If 个突设置(6) = 1 Then
                //如果没有开启更换阵容，则把2阵容设定成1阵容
                阵容 = 个突设置(5)
            End If

        Case Else
            ka_flag = 0
        End Select

        If exit_flag = 1 Then
            Call Lib.YYS_异常处理.go_home(path)
            Exit Function
        End If
    Wend
End Function

//@38创建寮突
Function liao_open_settings()
    Dim open_flag:open_flag=YS.创建寮突.Value
    Dim stime : stime = Lib.CPS.create_datetime(YS.liao_stime_h.ListIndex, 获取下拉(YS.liao_stime_n.List, YS.liao_stime_n.ListIndex))
    Dim liao_select : liao_select = YS.寮突选择.ListIndex + 1
    liao_open_settings = split(open_flag & "-" & stime & "-" & liao_select, "-")
End Function

Function 开启寮突(account,path,settings)
    Dim res,ret
    Dim 开启时间 : 开启时间 = settings(1)
    Dim 寮突选择 : 寮突选择 = settings(2)

    //检查是否已到启动时间
    TracePrint "设置时间为：" & settings(1)
    ret = Lib.YYS.冷却检查(settings(1))
    If ret = "完毕" Then
        Call log(account&"正在执行：开启寮突")

        //已过设定好的时段，可以执行妖气
        开启寮突 = Lib.YYS_突破相关.open_liao(path, settings(2))
    Else
        开启寮突=settings(1)
    End If
End Function

//@39寮突破
Function liao_tupo_settings()
    Dim liao_flag:liao_flag=YS.寮突破.Value
    Dim liao_star_level:liao_star_level=YS.寮突破星级.ListIndex
    Dim liao_level:liao_level=(YS.寮突破等级.ListIndex*10)
    Dim liao_dir : liao_dir = 获取下拉(YS.寮突破方向.List,YS.寮突破方向.ListIndex)
    Dim liao_zhenrong:liao_zhenrong=YS.person_zhenrong1.ListIndex
    liao_tupo_settings = split(liao_flag & "-" & liao_star_level & "-" & liao_level & "-" & liao_dir & "-" &liao_zhenrong, "-")
End Function

Function 寮突破(account, path, settings)
    Dim res, ret
    Dim 寮突设置 : 寮突设置 = settings
    Dim 阵容 : 阵容 = 寮突设置(3)
    Dim exit_flag:exit_flag = 0
    Dim ka_flag:ka_flag=0

    While 1
        Call log(account&"正在执行：寮突破")

        //单人模式下，更新配置
        if YS.process_mode.Value = 1 Then
            TracePrint "单人模式下，更新配置"
            寮突设置 = liao_tupo_settings()
        End If

        寮突破 = Lib.YYS_突破相关.寮突破(path, 寮突设置(1), 寮突设置(2), 寮突设置(3), 二次挑战)
        If 寮突破 <> "" Then
            ka_flag=0
        End If
        TracePrint "寮突破外部结果：" & 寮突破
        Select Case 寮突破
        Case ""
            //卡屏检测
            ka_flag = ka_flag + 1
            TracePrint "寮突破空结果次数：" & ka_flag
            If ka_flag > 30 Then
                Call Lib.YYS_LW.点击2(Lib.YYS_坐标.战斗中("奖励"))
                exit_flag = 1
            End If

        Case "完成"//已完结，冷却7小时

            寮突破 = Lib.YYS.创建冷却(Lib.CPS.范围随机(720, 6))
            exit_flag = 1

        Case "冷却中"//次数用完，冷却30分钟
            寮突破 = Lib.YYS.创建冷却(Lib.CPS.范围随机(15, 6))
            exit_flag = 1

        Case "未启动"//未开启，冷却1小时
            寮突破 = Lib.YYS.创建冷却(Lib.CPS.范围随机(60, 6))
            exit_flag = 1

        Case "搜索失败"//异常，等待一会再试
            寮突破 = Lib.YYS.创建冷却(Lib.CPS.范围随机(5, 2))
            exit_flag = 1
        End Select

        If exit_flag = 1 Then
            call Lib.YYS_异常处理.go_home(path)
            Exit Function
        End If
    Wend
End Function

//@40妖气封印
Function yaoqi_settings()
    Dim tmp
    TracePrint "妖气设置：设置"
    dim yaoqi_flag:yaoqi_flag = YS.妖气封印.Value
    dim yaoqi_tar:yaoqi_tar = 获取下拉(YS.妖气目标.list, YS.妖气目标.listindex)
    dim yaoqi_zhenrong:yaoqi_zhenrong = 获取下拉(YS.妖气阵容.list, YS.妖气阵容.listindex)
    dim yaoqi_check:yaoqi_check= 获取下拉(YS.yaoqi_check.list, YS.yaoqi_check.listindex)

    Dim yaoqi_count : yaoqi_count = 0
    If YS.yaoqi_count_flag.Value = 1 Then
        tmp = cint(YS.yaoqi_count.Text)
        If  tmp> 0 Then
            yaoqi_count = tmp
        End If
    End If

    Dim yaoqi_time : yaoqi_time = "关闭"
    If YS.yaoqi_time.value = 1 Then
        stime = Lib.CPS.create_datetime(获取下拉(YS.yaoqi_sh.list, YS.yaoqi_sh.listindex), 获取下拉(YS.yaoqi_sn.list, YS.yaoqi_sn.listindex))
        tmp = cint(YS.yaoqi_sh.listindex)
        etime = DateAdd("n", tmp, stime)
        yaoqi_time = stime &"|"& etime
    end if

    //妖气开关|妖气目标|匹配模式|妖气阵容|妖气次数|妖气时段(开始时间|结束时间)
    yaoqi_settings = split(yaoqi_flag & "-" & yaoqi_tar & "-" & yaoqi_check & "-" & yaoqi_zhenrong & "-" & yaoqi_count & "-" &yaoqi_time & "-" & yaoqi_stime& "-" & yaoqi_etime, "-")
End function

Event YS.妖气封印.Click
    YS.设置页.tab=1
    YS.挂机详细.Tab = 4
End Event

//妖气开关|妖气目标|匹配模式|妖气阵容|妖气次数|妖气时段(开始时间|结束时间)
Function 妖气封印(account,path,settings)
    Dim res, ret
    dim 妖气设置:妖气设置 = settings
    dim 当前次数:当前次数 = 0
    Dim 妖气执行:妖气执行 = 1

    妖气封印 = ""
    While 1
        Call log(account&"正在执行：妖气副本")

        //单人模式下，更新配置
        if YS.process_mode.Value = 1 Then
            妖气设置 = yaoqi_settings()
        End If

        //时段判断
        If 妖气设置(5) <> "关闭" and 妖气设置(5) <> "" Then
            ret = split(妖气设置(5), "|")
            TracePrint "妖气封印，启动时间：" & ret(0)
            TracePrint "妖气封印，结束时间：" & ret(1)

            //检查是否已到启动时间
            res = Lib.YYS.冷却检查(ret(0))
            If res = "完毕" Then
                //已过设定好的时段，可以执行妖气
                妖气执行=1
            End If

            //检查是否已过设定时间
            res = Lib.YYS.冷却检查(ret(1))
            If res = "完毕" Then
                //已过设定好的时段，结束妖气脚本
                妖气执行="完成"
                call Lib.YYS_异常处理.go_home(pics_path)
                Exit function
            End If
        End If

        //设定次数
        ret=cint(妖气设置(4))
        If ret <> 0 and 妖气设置(4) <> "" Then
            TracePrint "当前设定了：" & 妖气设置(4) & "次妖气探索。"
            If 当前次数 > ret Then
                妖气执行=0
                妖气封印="完成"
            End If
        End If

        //执行逻辑
        If 妖气执行 = 1 Then
            res = Lib.YYS_定时任务.妖气封印(path, 妖气设置(1), 妖气设置(2), 妖气设置(3))
            If res = "完成" Then
                当前次数 = 当前次数 + 1
                TracePrint account & "完成妖气，记录次数：" & 当前次数
            End If
        End If
    Wend
End Function

//@41逢魔之时
Function fengmo_settings()
    Dim 逢魔奖励:逢魔奖励 = YS.逢魔之时.Value
    Dim 逢魔定时 : 逢魔定时 = "不定时"
    If YS.fengmo_time.Value = 1 Then
        Dim h:h = cint(获取下拉(YS.fengmo_h.list,YS.fengmo_h.listindex))
        dim m:m = cint(获取下拉(YS.fengmo_m.list,YS.fengmo_m.listindex))
        逢魔定时=Lib.CPS.create_datetime(h,m)
    End If

    //    Dim res
    //    Select Case week
    //    	Case 1
    //    		res = Ys.fengmo_zhenrong1.list
    //    		ret = Ys.fengmo_zhenrong1.listindex
    //    	Case 2
    //    		res = Ys.fengmo_zhenrong1.list
    //    		ret = Ys.fengmo_zhenrong1.listindex
    //    	Case 3
    //    		res = Ys.fengmo_zhenrong2.list
    //    		ret = Ys.fengmo_zhenrong2.listindex
    //    	Case 4
    //    		res = Ys.fengmo_zhenrong3.list
    //    		ret = Ys.fengmo_zhenrong3.listindex
    //    	Case 5
    //    		res = Ys.fengmo_zhenrong4.list
    //    		ret = Ys.fengmo_zhenrong4.listindex
    //    	Case 6
    //    		res = Ys.fengmo_zhenrong5.list
    //    		ret = Ys.fengmo_zhenrong5.listindex
    //    	Case 7
    //    		res = Ys.fengmo_zhenrong5.list
    //    		ret = Ys.fengmo_zhenrong5.listindex
    //    End Select
    //    Dim fengmo_zhenrong:fengmo_zhenrong=获取下拉(res,ret)

    fengmo_settings = split(逢魔奖励 & "-" & 逢魔定时, "-")
End Function
Event YS.逢魔之时.Click
    YS.逢魔首领.Value = YS.逢魔之时.Value
    YS.设置页.tab=1
    YS.挂机详细.Tab = 1
End Event
Event YS.逢魔首领.Click
    YS.设置页.tab=1
    YS.挂机详细.Tab = 1
End Event
Function 逢魔奖励(account,path,settings)
    Dim res
    逢魔奖励 = ""
    TracePrint "逢魔奖励"
    //逢魔时段再判断
    Dim currt_h : currt_h = hour(now())
    Dim currt_n : currt_n = Minute(now())
    TracePrint "当前时间:  "&currt_h &":"&currt_n
    If currt_h < 22 and currt_h > 17 Then
        TracePrint "合法时段"

    elseif currt_h > 21 Then
        //已过时间,
        逢魔奖励 = "完成"
        exit function
    Else
        //未到时间。半小时后在检测
        TracePrint "未到时间，退出功能2"
        逢魔奖励 = Lib.YYS.创建冷却(20)
        exit function
    End If

    //定时检测
    If settings(1) <> "不定时" Then
        res = Lib.YYS.冷却检查(settings(1))
        If res <> "完毕" Then
            逢魔奖励 = Lib.YYS.创建冷却(20)
            exit function
        End If
    End If

    Call log(account&"正在执行：逢魔奖励")

    逢魔奖励 = Lib.YYS_每日任务.逢魔奖励(path)
    If 逢魔奖励 = "完成" Then
        逢魔奖励 = "完成"
        call Lib.YYS_异常处理.go_home(pics_path)
        exit function
    End If
End Function

//@42逢魔首领
Function fengmo_boss_settings()
    Dim 首领开关:首领开关=YS.逢魔首领.Value
    Dim 首领阵容:首领阵容=YS.fengmo_zhenrong1.listindex
    Dim 点选草人:点选草人=YS.逢魔草人.Value
    fengmo_boss_settings = split(首领开关 & "-" & 首领阵容& "-" &点选草人, "-")
End Function
//获取当天boss
//function get_boss()
//    Dim res:res=Weekday(now())
//    Select Case res
//    Case 1
//        get_boss="笼车"
//    Case 2
//        get_boss="蜃气楼"
//    Case 3
//        get_boss="蜃气楼"
//    Case 4
//        get_boss="土蜘蛛"
//    Case 5
//        get_boss="荒骷髅"
//    Case 6
//        get_boss="地震鲇"
//    Case 7
//        get_boss="笼车"
//    End Select
//End Function
Function 逢魔首领(account, path, settings)
    Dim res
    逢魔首领 = ""
    //逢魔时段再判断
    Dim currt_h : currt_h = hour(now())
    Dim currt_n : currt_n = Minute(now())
    TracePrint "当前时间:  "&currt_h &":"&currt_n
    If currt_h < 22 and currt_h > 17 Then
        TracePrint "合法时段"

    elseif currt_h > 21 Then
        //已过时间,
        逢魔首领 = "完成"
        exit function
    Else
        //未到时间。半小时后在检测
        TracePrint "未到时间，退出功能2"
        逢魔首领 = Lib.YYS.创建冷却(30)
        exit function
    End If

    //定时检测
    If settings(1) <> "不定时" Then
        res = Lib.YYS.冷却检查(settings(1))
        If res <> "完毕" Then
            逢魔首领 = Lib.YYS.创建冷却(20)
            exit function
        End If
    End If

    Call log(account&"正在执行：逢魔首领")

    逢魔首领 = Lib.YYS_每日任务.逢魔首领(path,settings)
    If 逢魔首领 = "完成" Then
        逢魔首领 = "完成"
        call Lib.YYS_异常处理.go_home(path)
    End If
End Function

//@43地域鬼王
Function diyu_settings()
    TracePrint "地域鬼王：设置"
    dim diyu_flag:diyu_flag = YS.地域鬼王.Value
    Dim diyu_mode : diyu_mode = diyu_flag

    Dim diyu_tar
    If YS.地域地区.listindex = 0 Then
        diyu_tar = "自动"
    Else
        diyu_tar = 获取下拉(YS.鬼王选择.List, YS.鬼王选择.Listindex)
    End If

    dim diyu_level:diyu_level = 获取下拉(YS.鬼王等级.List, YS.鬼王等级.Listindex)
    dim diyu_time:diyu_time = 0

    //开关|目标鬼王|鬼王等级
    diyu_settings = split(diyu_flag & "-" & diyu_tar & "-" & diyu_level, "-")
End Function

Event YS.地域鬼王.Click
    YS.设置页.tab = 1
    YS.挂机详细.Tab = 4
End Event

Event YS.地域地区.SelectChange
    Select Case YS.地域地区.listindex
    Case 0
        YS.鬼王选择.List = "自动"
        YS.鬼王选择.ListIndex = 0

    Case 1//华北
        YS.鬼王选择.List="万里长城|其他"
    Case 2//华中
        YS.鬼王选择.List="少林寺藏经阁|其他"
    Case 3//华南
        YS.鬼王选择.List="丹霞山|其他"
    Case 4//西北
        YS.鬼王选择.List="万里长城|其他"
    Case 5//北美洲
        YS.鬼王选择.List="万里长城|其他"
    Case 6//南美洲
        YS.鬼王选择.List="万里长城|其他"
    Case 7//欧洲
        YS.鬼王选择.List="万里长城|其他"
    Case 8//非洲
        YS.鬼王选择.List="万里长城|其他"
    Case 9//大洋洲
        YS.鬼王选择.List = "万里长城|其他"
    End Select

End Event

//@44地域鬼王
Function 地域鬼王(account,path,settings)
    dim res
    dim 设置:设置=settings
    地域鬼王 = ""

    //单人模式下，更新配置
    if YS.process_mode.Value = 1 Then
        设置 = diyu_settings()
    End If

    Call log(account&"正在执行：地域鬼王")

    //正常执行
    If 设置(1) = "自动" Then
        地域鬼王 = Lib.YYS_主界面.地域鬼王(path, "丹霞山", "最低级")
        Delay 1000
        地域鬼王 = Lib.YYS_主界面.地域鬼王(path, "少林寺藏经阁", "最低级")
    Else
        地域鬼王 = Lib.YYS_主界面.地域鬼王(path, 设置(1), 设置(2))
    End If

    //完成后执行冷却
    Select Case 地域鬼王
    Case "未到时间"
        TracePrint "不在挑战时间（6:00~23:59）"
        地域鬼王 = Lib.YYS.创建冷却(Lib.CPS.范围随机(120, 60))
    Case else
        TracePrint "地域鬼王异常，请检查设置"
        地域鬼王 = Lib.YYS.创建冷却(Lib.CPS.范围随机(720, 60))
    End Select
End Function

//@45阴界之门
Function yinjie_settings()
    //判断如果不是周末，开关自动设置为0
    Dim 阴界开关 : 阴界开关 = YS.阴界之门.Value
    Dim 阴界阵容 : 阴界阵容 = YS.阴界阵容.ListIndex
    //  dim 是否换阵
    //  dim 五十退出:五十退出=
    //  yinjie_settings=split(阴界开关& "-" &五十退出,"-")
    yinjie_settings=split(阴界开关&"-"&阴界阵容,"-")
End Function

Event YS.阴界之门.Click
    YS.设置页.tab=1
    YS.挂机详细.Tab = 2
End Event

function 阴界之门(account,path,settings)
    Dim 设置 : 设置 = settings
    Dim currt_day
    //单人模式下，更新配置
    if YS.process_mode.Value = 1 Then
        设置 = yinjie_settings()
    End If

    //判断日期
    currt_day = Weekday(now())
    If currt_day > 1 and currt_day < 6 Then
        //当前不在周末，不执行
        阴界之门 = "完成"
        Exit function
    End If


    //时段再判断
    Dim currt_h:currt_h=hour(now())
    If currt_h < 19 Then
        //未到时间。半小时后在检测
        阴界之门 = Lib.CPS.create_datetime(19,10)
        exit function
    elseif currt_h > 20 Then
        //已过时间,
        阴界之门 = "完成"
        exit function
    End If
    阴界之门 = Lib.YYS_每日任务.阴界之门(path, 设置(1))

    Call Lib.YYS_异常处理.go_home(pics_path)
End Function

//@46好友寄养
Function jiyang_settings(当前帐号)
    Dim 寄养开关 : 寄养开关 = YS.好友寄养.Value
    Dim 结界卡选择
    Select Case YS.结界卡选择.listindex
    Case 0//自动
        结界卡选择 = "斗鱼|太鼓"
    Case 1
        结界卡选择 = "太鼓|斗鱼"
    Case Else
        结界卡选择 = "太鼓|斗鱼"
    End Select

    Dim 寄养方式:寄养方式=获取下拉(YS.寄养目标.list,YS.寄养目标.listindex)
    jiyang_settings = split(寄养开关 & "-" & 结界卡选择 & "-" & 寄养方式 & "-" & 当前帐号, "-")
End Function

Function 好友寄养(account, path, settings)
    Dim res
    dim 设置:设置 = settings
    //单人模式下，更新配置
    if YS.process_mode.Value = 1 Then
        设置 = jiyang_settings(account)
    End If
    For Each v In 设置
        TracePrint v
    Next
    res = Lib.YYS_结界相关.结界功能(path, "好友寄养", 设置)
    Select Case res
    Case "已寄养"
        //已寄养
        TracePrint "还在寄养中，记录当前时间"
        ret = Lib.CPS.局部截图(path, "309,292,531,317", 当前账号 & "寄养状态")
        If ret <> "" Then
            //记录寄养信息
            Call Lib.YYS.写入配置(path, 当前账号, "寄养状态", ret)
        End If

        For 2
            Call Lib.YYS_LW.点击2(Lib.YYS_坐标.战斗中("奖励"))
            Call Lib.YYS_LW.随机延迟(55, 222)
        Next

        TracePrint "已寄养，冷却1小时"
        好友寄养 = Lib.YYS.创建冷却(Lib.CPS.范围随机(60, 5))

    Case "完成"
        //冷却7小时
        TracePrint "已设置结界卡，冷却7小时"
        好友寄养 = Lib.YYS.创建冷却(Lib.CPS.范围随机(420, 20))

    Case "未完成"
        //冷却1小时
        TracePrint "结界卡已存在，30分钟后再检测"
        好友寄养 = Lib.YYS.创建冷却(Lib.CPS.范围随机(30, 10))

    End Select

    call Lib.YYS_异常处理.go_home(pics_path)
End Function

//@47结界卡
Function jiejieka_settings()
    Dim 结界卡开关:结界卡开关=YS.结界卡.Value
    Dim 结界卡类型:结界卡类型=获取下拉(YS.结界卡类型.list,YS.结界卡类型.listindex)
    Dim 结界卡星级
    If YS.结界卡星级.listindex = 0 Then
        结界卡星级 = YS.结界卡星级.listindex
    Else
        结界卡星级 = YS.结界卡星级.listindex + 3
    End If
    Dim 结界卡公私:结界卡公私=获取下拉(YS.公私类型.list,YS.公私类型.listindex)
    Dim 结界卡邀请 : 结界卡邀请 = YS.结界卡邀请.listindex
    Dim 无卡自动 : 无卡自动 = YS.无卡自动.Value

    jiejieka_settings = split(结界卡开关 & "-" & 结界卡类型 & "-" & 结界卡星级 & "-" & 结界卡公私 & "-" & 结界卡邀请 & "-" &无卡自动, "-")
End Function
Event YS.结界卡类型.SelectChange
    Select Case YS.结界卡类型.listindex
    Case 0
        YS.无卡自动.Enabled = 0
        YS.无卡自动.Value = 0
    Case else
        YS.无卡自动.Enabled = 1
    End Select
End Event
Event YS.无卡自动.Click
    Select Case YS.无卡自动.Value
    Case 1
        If YS.结界卡类型.listindex = 0 Then
            MsgBox "结界卡必须指定一个种类才能开启本功能。"
            YS.无卡自动.Value=0
        End If
    End Select
End Event
Function 结界卡(account,path,settings)
    Dim res
    dim 设置:设置 = settings
    //单人模式下，更新配置
    if YS.process_mode.Value = 1 Then
        设置 = jiejieka_settings()
    End If


    For Each v In 设置
        TracePrint v
    Next
    结界卡=""
    res = Lib.YYS_结界相关.结界功能(path, "结界卡", 设置)
    Select Case res
    Case "完成"
        //冷却7小时
        TracePrint "已设置结界卡，冷却7小时"
        结界卡 = Lib.YYS.创建冷却(Lib.CPS.范围随机(420, 20))

    Case "已使用"
        //冷却1小时
        TracePrint "结界卡已存在，1小时后再检测"
        结界卡 = Lib.YYS.创建冷却(Lib.CPS.范围随机(60, 10))
    End Select

    call Lib.YYS_异常处理.go_home(path)
End Function

//@48活动副本
Function huodong_settings()
	Dim 活动开关
    Dim 活动阵容 : 活动阵容 = 获取下拉(YS.活动阵容.list, YS.活动阵容.ListIndex)

    Dim 活动次数
    If YS.活动次数.Text = "不限制" or YS.活动次数.Text = "" Then
        活动次数=0
    elseIf cint(YS.活动次数.Text) > 0 Then
        活动次数 = YS.活动次数.Text
    Else
        活动次数=0
    End If

    Dim 活动时限
    If YS.活动时限.Text = "不限制" or YS.活动时限.Text = "" Then
        活动时限=0
    elseIf cint(YS.活动时限.Text) > 0 Then
        活动时限 = YS.活动时限.Text
    Else
        活动时限=0
    End If

    Dim 活动副本 : 活动副本 = 获取下拉(YS.活动副本.list, YS.活动副本.ListIndex)
    Dim 副本难度 : 副本难度 = 获取下拉(YS.副本难度.list, YS.副本难度.ListIndex)
    Dim 是否组队 : 是否组队 = 获取下拉(YS.是否组队.list, YS.是否组队.ListIndex)

    huodong_settings = split(活动阵容 & "-" & 活动次数 & "-" & 活动时限 & "-" & 活动副本 & "-副本等级" & 副本难度& "-" & 是否组队, "-")
End Function

//settings(0) 战斗阵容
//settings(1) 活动限制次数
//settings(2) 活动时限
//settings(3) 活动副本
//settings(4) 副本难度
//settings(5) 是否组队
Function 活动副本(account, path, settings)
    Dim res
    Dim huodong_count : huodong_count = 0
    Dim 设置 : 设置 = settings
    Dim 活动冷却
    Dim exit_flag:exit_flag=0

	TracePrint "活动设置："
	For Each e In 设置
		TracePrint e
	Next
    While 1
        //单人模式下，更新配置
        if YS.process_mode.Value = 1 Then
            设置 = huodong_settings()
        End If

		If cint(设置(2)) > 0 Then
			活动冷却 = cint(设置(2))
		Else
			活动冷却 = 40
		End If

        res = Lib.YYS_活动.fuben_huodong(path,设置)
        TracePrint "活动副本,外部结果：" & res

        //活动次数限制设置
        If res = "战斗结束" or res = "胜利" or res = "失败" or res = "奖励" Then
            huodong_count = huodong_count + 1
            TracePrint "已设定的战斗次数:" & 设置(4)
            TracePrint "战斗结束，当前次数:" & huodong_count
            Call log(account & "活动次数:[" & huodong_count & "]")
            If cint(设置(1)) > 0 Then
                If huodong_count >= cint(设置(1)) Then
                    活动副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(活动冷却, 10))
                    exit_flag = 1
                End If
            End If

        ElseIf res = "次数为零" Then
            活动副本 = "完成"
            exit_flag = 1

        End If

        If exit_flag = 1 Then
            Delay 4000
            Call Lib.YYS_异常处理.go_home(path)
            活动副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(活动冷却, 10))
            Exit function
        End If
    Wend

End Function

//@49业原火
Function chi_settings()
    Dim chi_flag : chi_flag = YS.业原火.Value
    Dim chi_type : chi_type = YS.chi_type.listindex + 1
    Dim chi_zhenrong : chi_zhenrong = YS.chi_zhenrong.listindex
    Dim 挑战次数 : 挑战次数 = YS.chi_count.listindex * 10
    Dim 休息间隔 : 休息间隔 = YS.chi_each_count.listindex * 10

    chi_settings = split(chi_flag & "-" & chi_type & "-" & chi_zherong & "-" & 挑战次数& "-" &休息间隔, "-")
End Function
Function 业原火(account, path, settings)
    Dim 设置:设置=chi_settings()
    Dim res, ret
    Dim currt_count:currt_count=0
    Dim exit_flag : exit_flag = 0
    Dim 休息间隔

    While 1
        //单人模式下，更新配置
        if YS.process_mode.Value = 1 Then
            设置=chi_settings()
        End If

        res = Lib.YYS_业原火.chi_mode(path, 设置(1), 设置(2), "")
        TracePrint "----++++外部结果-业原火：" & res
        If res <> "" Then
            If res = "胜利" or res = "失败" or res = "奖励" Then
                currt_count=currt_count+1
                TracePrint "战斗结束，记录次数" & currt_count
            ElseIf res = "业原卷为零" Then
                业原火 = "完成"
                exit_flag = 1
            End If
        End If

        If 设置(4) <> 0 Then
            休息间隔 = cint(Lib.CPS.范围随机(设置(4), 3))
            TracePrint "业原火休息间隔：" & 休息间隔
            If currt_count >= 休息间隔 Then
                TracePrint "已超过设定的次数，结束本功能"
                call log("业原火已超过设定的次数，结束本功能")
                业原火 = Lib.YYS.创建冷却(Lib.CPS.范围随机(3, 3))
                exit_flag=1
            End If
        End If

        If 设置(3) <> 0 Then
            TracePrint "业原火挑战次数：" & 设置(3)
            If currt_count >= cint(设置(3)) Then
                TracePrint "已超过设定的次数，结束本功能"
                call log("业原火已超过设定的次数，结束本功能")
                业原火 = "完成"
                exit_flag=1
            End If
        End If

        If exit_flag = 1 Then
            Call Lib.YYS_异常处理.go_home(path)
            Exit function
        End If
    Wend

End Function

//@50好友协战
Function 好友协战(account, path, settings)
    Dim res, ret
    Dim count:count=0
    Dim exit_flag : exit_flag = 0

    Dim run_flag:run_flag=1
    //    While run_flag
    //        res = Lib.YYS_御魂模式.御魂模式(path, "单人", "", "火麒麟", "", 1, "", "", "", "不点怪|不点怪|不点怪", "")
    //        TracePrint "+++++++++++觉醒结果：" & res
    //        If res = "奖励" Then
    //        	jutxing
    //        End If
    //        Delay 1000
    //    Wend

    dim 层数:层数=3
    While 1

        res = Lib.YYS_业原火.chi_mode(path, 层数, "", "刷协战")
        TracePrint "----++++外部结果-刷协战：" & res
        If res <> "" Then
            If res = "点击计次" Then
                currt_count=currt_count+1
                TracePrint "+++++++++++++记录次数" & currt_count &"+++++++++++++"
                If currt_count >= 18 Then
                    exit_flag = 1
                    好友协战 = "完成"
                End If
            ElseIf res = "业原卷为零" Then
                好友协战 = "完成"
                TracePrint "业原卷为零"
                exit_flag = 1
            End If
        End If

        If exit_flag = 1 Then
            call Lib.YYS_异常处理.go_home(path)
            Exit function
        End If
    Wend
End Function

//@51麒麟
Function qilin_settings()
    Dim qilin_flag : qilin_flag = YS.麒麟.Value
    //定时设置
    Dim qilin_time
    Select Case qilin_time
    Case 0
        qilin_time="不定时"
    Case 1
        qilin_time = Lib.CPS.create_datetime(获取下拉(YS.qilin_h.List, YS.qilin_h.ListIndex), 获取下拉(YS.qilin_m.List, YS.qilin_h.ListIndex))
    End Select

    Select Case Weekday(now())
    Case 2
        qilin_zhenrong=YS.qilin_zhenrong1.ListIndex
    Case 3
        qilin_zhenrong=YS.qilin_zhenrong2.ListIndex
    Case 4
        qilin_zhenrong=YS.qilin_zhenrong3.ListIndex
    Case 5
        qilin_zhenrong=YS.qilin_zhenrong4.ListIndex
    Case Else
        qilin_zhenrong = 0
    End Select

    qilin_settings = split(qilin_flag& "-" & qilin_time & "-" & qilin_zhenrong,"-")
End Function
Function 麒麟(account, path, settings)
    //周末判定
    Dim currt_day :currt_day=Weekday(now())
    If currt_day = 1 or currt_day >= 6 Then
        //周末，不执行函数
        狩猎战 = "完成"
        Exit function
    End If

    //时间段判定
    Dim currt_hour : currt_hour = hour(now())
    If currt_hour < 19 Then
        狩猎战 = Lib.CPS.create_datetime(19,01)
        Exit function
    elseif currt_hour >20 Then
        狩猎战 = "完成"
        Exit function
    End If

    Dim res, exit_flag
    Dim 设置:设置 = qilin_settings()
    For 240
        //单人模式下，更新配置
        if YS.process_mode.Value = 1 Then
            设置 = qilin_settings()
        End If

        //定时判定
        If 设置(1) <> "不定时" Then
            res = Lib.YYS.冷却检查(设置(1))
            If res <> "完毕" Then
                TracePrint "时间未到，还剩" & res & "分钟。"
                狩猎战=设置(1)
                Exit function
            End If
        End If

        res = Lib.YYS_每日任务.狩猎战(path)
        TracePrint "麒麟外部结果：" & res
        Select Case res
        Case "未开启"
            麒麟 = Lib.YYS.创建冷却(4)
            exit_flag = 1

        Case "完成"
            麒麟 = "完成"
            exit_flag = 1

        End Select

        If exit_flag = 1 Then
            call Lib.YYS_异常处理.go_home(path)
            Exit function
        End If
    Next
    麒麟 = Lib.YYS.创建冷却(4)
    call Lib.YYS_异常处理.go_home(path)
End Function

//@52地图体力
Function 地图体力(account, path, 地体设置)
    Dim res,exit_flag:exit_flag=0
    地图体力 = Lib.YYS_定时任务.地图体力(path)
    Select Case 地图体力
    Case "未领取"
        地图体力 = Lib.YYS.创建冷却(Lib.CPS.范围随机(25, 5))
        exit_flag = 1
    Case "领取成功"
        地图体力 = Lib.YYS.创建冷却(Lib.CPS.范围随机(120, 5))
        exit_flag = 1
    End Select

    If exit_flag = 1 Then
        Call Lib.YYS_异常处理.go_home(path)
    End If
End Function

//@53LBS副本
function LBS副本(account, 找图路径, 设置)
    LBS副本 = ""
    dim res

    if YS.process_mode.Value = 1 Then
        设置 = liandong_settings()
    End If

    res = Lib.YYS_定时任务.LBS副本(找图路径,"",settings)
    Select Case res
    Case "完成"
        LBS副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(120, 10))

    Case "失败"
        LBS副本 = Lib.YYS.创建冷却(Lib.CPS.范围随机(30, 10))
    End Select

    Call Lib.YYS_异常处理.go_home(找图路径)
End Function
//=====================================@4 界面事件==========================================
//身份选择
Event YS.menber_mode.SelectChange
    //    YS.mode_settings.tab = 2
    Select Case YS.menber_mode.ListIndex
    Case 0
        YS.创建队伍.Enabled = 1
    Case 1
        YS.创建队伍.Enabled = 1
        YS.队员队长.listindex = 0
    Case 2
        YS.创建队伍.Enabled = 0
        YS.创建队伍.Value = 0
        YS.队员队长.listindex = 1
    End Select
    TracePrint "身份选择："& 获取下拉(YS.menber_mode.list, YS.menber_mode.ListIndex)
End Event

//测试模式
Event YS.调试模式.Click
    test_mode = YS.调试模式.Value
    YS.提示错误.Value=YS.调试模式.Value
End Event

//截图文件夹
Event YS.set_path.Click
    RunApp pics_path
End Event

//客户端模式-自动识别
Event YS.auto_check1.Click
    If YS.auto_check1.Value = 1 Then
        YS.game_type.Enabled = 0
    ElseIf YS.auto_check1.Value = 0 Then
        YS.game_type.Enabled = 1
    End If
End Event

//插件设置界面
Event YS.auto_path.Click
    If YS.auto_path.Value = 1 Then
        YS.配置目录.Enabled = 0
        default_path = Plugin.Sys.GetDir(3)
        setting_path = Plugin.Sys.GetDir(0) & "\ini"
        YS.配置目录.path = default_path
    Else
        YS.配置目录.Enabled = 1
        YS.配置目录.path = "指定插件存放目录"
    End If
End Event

//定时关机功能
Event YS.shutdown_flag.Click
    Dim h : h = 获取下拉(YS.shutdown_h.List, YS.shutdown_h.Listindex)
    Dim n : n = 获取下拉(YS.shutdown_n.List, YS.shutdown_n.Listindex)
    Select Case YS.shutdown_flag.Value
    Case 0
        Call Lib.CPS.定时关机("取消",h,n)
    Case 1
        Call Lib.CPS.定时关机("关机",h,n)
    End Select
End Event

//模式选择
Event YS.select_mode.SelectChange
    currt_mode = 获取下拉(YS.select_mode.list, YS.select_mode.listindex)
    YS.mode_settings.Tab = YS.select_mode.ListIndex
    TracePrint "模式选择：" & currt_mode
    YS.挂机设置.tab=0
End Event

//联动按钮
Event YS.联动副本.Click
    TracePrint YS.联动副本.Value
    If YS.联动副本.Value = 1 Then
        liandong_mode = 1
        liandong_flag = 1
        liandong_check = 获取下拉(YS.联动刷新.list, YS.联动刷新.listindex)
        TracePrint "联动副本：开启"
    Else
        liandong_mode = 0
        liandong_flag = 0
        TracePrint "联动副本：关闭"
    End If
    YS.设置页.tab=1
    YS.挂机详细.Tab = 0
End Event

//联动匹配模式
Event YS.联动刷新.SelectChange
    liandong_check = 获取下拉(YS.联动刷新.list, YS.联动刷新.listindex)
    TracePrint "联动匹配模式更改："&liandong_check
End Event
Event YS.年兽刷新.SelectChange
    nianshou_check = 获取下拉(YS.年兽刷新.list, YS.年兽刷新.listindex)
    TracePrint "年兽匹配模式更改："&nianshou_check
End Event
Event YS.石距刷新.SelectChange
    shiju_check = 获取下拉(YS.石距刷新.list, YS.石距刷新.listindex)
    TracePrint "石距匹配模式更改："&shiju_check
End Event

//手动动选择试胆内容
Event YS.好友红心.Click
    Call 试胆大会计算()
End Event
Event YS.结界经验.Click
    Call 试胆大会计算()
End Event
Event YS.赠送碎片.Click
    Call 试胆大会计算()
End Event
Event YS.试胆斗技.Click
    Call 试胆大会计算()
End Event
Event YS.试胆探索.Click
    Call 试胆大会计算()
End Event
Event YS.试胆御魂.Click
    Call 试胆大会计算()
End Event
Event YS.试胆觉醒.Click
    Call 试胆大会计算()
End Event
Event YS.试胆突破.Click
    Call 试胆大会计算()
End Event
Event YS.赠送碎片数.SelectChange
    Call 试胆大会计算()
End Event
Event YS.试胆斗技数.SelectChange
    Call 试胆大会计算()
End Event
Event YS.试胆探索数.SelectChange
    Call 试胆大会计算()
End Event
Event YS.试胆御魂数.SelectChange
    Call 试胆大会计算()
End Event
Event YS.试胆觉醒数.SelectChange
    Call 试胆大会计算()
End Event
Event YS.试胆突破数.SelectChange
    Call 试胆大会计算()
End Event
//自动选择试胆内容
Event YS.帮我选择.Click
    If YS.帮我选择.Value = 1 Then
        YS.好友红心.Value=1
        YS.结界经验.Value=0
        YS.赠送碎片.Value=0
        YS.试胆斗技.Value=0
        YS.试胆探索.Value=0
        YS.试胆御魂.Value=1
        YS.试胆觉醒.Value=1
        YS.试胆突破.Value = 0
        YS.试胆御魂数.ListIndex=16
        YS.试胆觉醒数.ListIndex = 12
    Else
        YS.好友红心.Value=0
        YS.结界经验.Value=0
        YS.赠送碎片.Value=0
        YS.试胆斗技.Value=0
        YS.试胆探索.Value=0
        YS.试胆御魂.Value=0
        YS.试胆觉醒.Value=0
        YS.试胆突破.Value = 0
        YS.赠送碎片数.ListIndex=0
        YS.试胆斗技数.ListIndex=0
        YS.试胆探索数.ListIndex=0
        YS.试胆御魂数.ListIndex=0
        YS.试胆觉醒数.ListIndex=0
        YS.试胆突破数.ListIndex=0
    End If
End Event
Event YS.试胆大会.Click
    If YS.试胆大会.Value = 1 Then
        YS.挂机设置.tab = 2
    End If
End Event

Event YS.麒麟.Click
    YS.设置页.tab=1
    YS.挂机详细.Tab = 2
End Event
//=====================================@5 多开相关==========================================
Dimenv 交换句柄 //用于启动时候的交换变量
Dimenv all_hwnds//记录当前已存在的句柄
Dimenv all_state//记录对应句柄启动后的线程id num-xxx-id,num-xxx-id,num-xxx-id,num-xxx
Dimenv stop_id : stop_id = 0

//-+-+-+-+-+-+-+-+--+-+-+-多开依赖函数-+-+-+-+-+-+-+-+--+-+-+-
//返回int, 1成功，0失败
//初始化 all_hwnds
//初始化 all_state
Function init_hwnds(title)
    Dim i,tmp_arr
    all_hwnds = Lib.YYS.get_hwnds(title)
    If all_hwnds <> "" Then
        TracePrint "函数get_hwnd：" & all_hwnds & title

        //根据当前窗口初始化所有状态
        tmp_arr=split(all_hwnds, ",")
        all_state = all_hwnds
        i = 1
        For Each w In tmp_arr
            TracePrint "初始化窗口："&w
            all_state = Replace(all_state, w, "账号"& i & "-" & w & "-未启动"& "-0")
            i = i + 1
        Next
        all_state = Replace(all_state, ",", "|")

        //更新下拉
        YS.账号列表.list = "---账号列表---(" & UBound(tmp_arr)+1 &")|"& all_state
        init_hwnds = 1
    Else
        init_hwnds = 0
    End If
End Function

//检查当前句柄是否有变动
//更新当前的窗口和对应的窗口状态
Function check_hwnd(title)
    TracePrint "启动check_hwnd"
    If title = "" Then
        title=game_type
    End If

    //获取最新窗口
    new_hwnds = Lib.YYS.get_hwnds(title)
    If all_hwnds <> "" and new_hwnds = "" Then
        //关闭多余的窗口
        TracePrint "关闭多余的窗口"
    elseIf new_hwnds = "" and all_hwnds="" Then
        //当前无窗口
        Exit Function
    ElseIf new_hwnds <> "" and all_hwnds = "" Then
        //需要重新初始化
        Call init_hwnds(game_type)
    End If

    //判断是否有新增
    Dim tmp_arr : tmp_arr = split(new_hwnds, ",")
    currt_hwnds = all_hwnds
    If currt_hwnds <> "" Then
        For Each e_w In tmp_arr
            //            TracePrint e_w & "结果： " & instr(currt_hwnds,e_w)
            //如果发现有一个不在当前列表，表示有新增窗口
            If instr(currt_hwnds,e_w) = 0 Then
                //发现新窗口，更新环境变量
                Call add_hwnd(e_w)
            End If
        Next
    End If

    //判断是否有减少
    currt_hwnds = all_hwnds
    If currt_hwnds <> "" Then
        tmp_arr = split(currt_hwnds, ",")
        For Each e_w In tmp_arr
            If instr(new_hwnds,e_w) = 0 Then
                //发现已丢失的窗口，进行删除
                TracePrint "发现已丢失的窗口，进行删除"
                Call del_hwnd(e_w)
            End If
        Next
    End If
    Call 更新账号列表()
    //更新启动按钮
    TracePrint "结束check_hwnd"
End Function


//添加一个新窗口
Sub add_hwnd(hwnd)
    TracePrint "开始执行：add_hwnd"

    //添加新句柄
    all_hwnds = all_hwnds & "," & hwnd

    //添加新状态
    Dim old_id,new_id,tam_arr
    old_id = split(all_state, "|")
    old_id = split(old_id(UBound(old_id)), "-")(0)
    old_id = cint(Replace(old_id, "账号", ""))
    new_id = old_id+1
    tam_arr = split(all_state, "|")
    all_state = all_state & "|" & "账号" & new_id & "-" & hwnd & "-未启动-0"
    all_state = Lib.CPS.strip(all_state, "|")
    TracePrint "结束执行：add_hwnd"
End Sub

//删除一个窗口
Sub del_hwnd(hwnd)
    Dim res
    TracePrint "开始执行：del_hwnd：" & hwnd

    //先停止该线程
    res = get_hwnd(hwnd, "启动状态")
    If res = "已启动" Then
        Call stop_sel(hwnd)
        TracePrint "结束目标窗口" & hwnd
    End If

    //更新窗口信息
    all_hwnds = Replace(all_hwnds, hwnd, "")
    all_hwnds = Replace(all_hwnds, ",,", ",")
    all_hwnds = Lib.CPS.strip(all_hwnds, ",")

    //更新状态信息
    For Each tar_w In split(all_state, "|")
        If instr(tar_w, hwnd) > 0 Then
            all_state = Replace(all_state, tar_w, "")
            all_state = Replace(all_state, "||", "|")
            all_state = Lib.CPS.strip(all_state, "|")
            Exit for
        End If
    Next

    TracePrint "结束执行：del_hwnd"
End Sub

//更新窗口句柄状态，线程信息
//查询对应窗口/线程/账号等的对应状态
Sub change_hwnd(hwnd, 启动状态, 线程)
    TracePrint "--------------+++change_hwnd--------------+++"
    If hwnd = "" Then
        TracePrint "请检查窗口句柄"
        Exit Sub
    End If
    If 启动状态 = "未启动" Then
        线程=0
    End If

    Dim tmp_arr,ret,res
    If all_hwnds <> "" and all_state <> "" Then
        //更新
        If instr(all_state, hwnd)>0 Then
            //如果存在，则进行更新
            tmp_arr = split(all_state, "|")
            For Each e_state In tmp_arr
                //定位对应窗口
                If instr(e_state, hwnd) > 0 Then
                    ret = split(e_state, "-")
                    TracePrint "原窗口状态：" & e_state
                    //更新窗口状态
                    If 状态 <> 启动状态 Then
                        new_st = ret(0) & "-" & ret(1) & "-" & 启动状态 & "-" & 线程
                        TracePrint "更新窗口状态：" & new_st
                        all_state = Replace(all_state, e_state, new_st)
                    End If
                End If
            Next
            //更新账号列表
            Call 更新账号列表()

        End If
    End If
    TracePrint "--------------+++change_hwnd--------------+++"
End Sub

//查询一个句柄的当前状态,线程，账号信息等
//tar 可以是句柄，线程，账号id
Function get_hwnd(tar, state)
    TracePrint "-----------------启动get_hwnd---------------"
    TracePrint "tar：" & tar
    TracePrint "state：" & state
    If vartype(tar) < 1 Then
        get_hwnd = ""
        TracePrint "tar目标不合法，退出函数"
        Exit function
    End If

    If tar <> "" Then
        If instr(tar, "账号") > 0 Then
            tar = tar & "-"
        Else
            tar = "-" & tar
        End If
    Else
        TracePrint "tar为空，请检查窗口。"
        get_hwnd = ""
        Exit function
    End If

    Dim res, ret,e_w
    If all_hwnds <> "" and all_state <> "" Then
        Select Case state
        Case "启动状态"
            res=2
        Case "线程"
            res=3
        Case "账号"
            res=0
        Case ""
            //默认查询启动状态
            res=2
        End Select

        For Each e_w In split(all_state, "|")
            //            TracePrint "查找对象e_w：" & e_w
            //            TracePrint "查找目标tar：" & tar
            If instr(e_w, tar) > 0 Then
                //定位当前句柄
                ret = split(e_w, "-")
                get_hwnd = ret(res)
                Exit function
            End If
        Next
        TracePrint "没有查询到：[" & tar & "]的" & state & "信息。"
        get_hwnd=""
    Else
        get_hwnd=""
    End If
    TracePrint "-----------------结束get_hwnd---------------"
End Function

//启动按钮的状态和颜色
Sub 启动按钮(flag)
    If flag = "" Then
        If YS.账号列表.ListIndex <= 0 Then
            //如果选择的是标题，则显示提示
            flag="请选择账号"
        Else
            flag = 获取下拉(YS.账号列表.list, YS.账号列表.ListIndex)
            flag = split(flag, "-")(2)
        End If
    End If

    Select case flag
    Case "已启动"
        YS.启动按钮.BackColor = "3B2FE5"
        YS.启动按钮.NormalColor ="4539EF"
        YS.启动按钮.OverColor ="4543F4"
        YS.启动按钮.DownColor="3125DB"
        YS.启动按钮.Caption = "停  止"

    Case "未启动"
        YS.启动按钮.BackColor = "5EAB25"
        YS.启动按钮.NormalColor ="68B62F"
        YS.启动按钮.OverColor ="68BF34"
        YS.启动按钮.DownColor="54A11B"
        YS.启动按钮.Caption = "启  动"

    Case "异常"
        YS.启动按钮.Caption = "异  常"
        YS.启动按钮.BackColor = "C0C0C0"

    Case "请选择账号"
        YS.启动按钮.Caption = "请 选 择"
        YS.启动按钮.BackColor = "C0C0C0"

    Case "未发现"
        YS.启动按钮.Caption = "未发现游戏窗口"
        YS.启动按钮.BackColor = "C0C0C0"

    Case else
        YS.启动按钮.Caption = "空"
        YS.启动按钮.BackColor = "C0C0C0"
    End Select
End Sub

Function 激活窗口()
    Dim flag
    If YS.账号列表.ListIndex > 0 Then
        flag = 获取下拉(YS.账号列表.list, YS.账号列表.ListIndex)
        flag = split(flag, "-")(1)
        激活窗口 = Plugin.lw.SetWindowState(flag, 8)
        If 激活窗口 Then
            TracePrint "置顶成功" & flag
            Delay 500
            Call Plugin.lw.SetWindowState(flag, 9)
        Else
            TracePrint "置顶失败" & flag
        End If
    End If
End function

Sub 执行所有()
    Dim res,ret
    TracePrint "********************开始执行所有***************"
    If all_hwnds <> "" and all_state <> "" Then
        TracePrint "all_hwnds："&all_hwnds
        TracePrint "all_state："&all_state
        res = split(all_hwnds, ",")
        ret = split(all_state, "|")
        If UBound(res) = UBound(ret) Then
            //数量验证没问题
            For Each each_w In res
                ret = get_hwnd(each_w, "启动状态")
                If ret = "未启动" Then
                    TracePrint "当前执行：" & each_w
                    Call 启动脚本(each_w)
                    Delay 500
                End If
            Next
        End If
    End If
    TracePrint "********************结束执行所有***************"
End Sub

//保证列表更新后会选择同一个位置
Sub 更新账号列表()
    Dim res
    res = YS.账号列表.ListIndex
    YS.账号列表.list = "---账号列表---(" & UBound(split(all_hwnds, ",")) + 1 & ")|" & all_state
    If YS.账号列表.ListCount > 1 Then
        YS.账号列表.ListIndex = res
    End If
End Sub

Sub 更新头像()
    Dim res,操作账号,tmp
    If YS.账号列表.ListIndex > 0 Then
        //获取当前已选的目标
        res = 获取下拉(YS.账号列表.list, YS.账号列表.ListIndex)
        操作账号 = split(res,"_")(0)
        tmp = Lib.YYS.读取配置(path, 操作账号, "账号头像")
        If tmp <> "" Then
            YS.头像预览.Picture = t_path
        Else
            TracePrint "给出空白头像"
        End If
    End If
End Sub


//监测当前窗口，如果发现当前窗口丢失，则停止对应线程
Function 实时监测窗口()
    //	TracePrint "实时监测窗口开始"
    Dim currt_text, currt_hwnd, tmp_arr
    currt_hwnds = Lib.YYS.get_hwnds(game_type)
    //    TracePrint "最新窗口句柄：" & currt_hwnds
    //    TracePrint "当前窗口句柄：" & all_hwnds
    If all_hwnds <> "" Then
        tmp_arr = split(all_hwnds, ",")
        For Each e_w In tmp_arr
            If instr(currt_hwnds, e_w) = 0 Then
                TracePrint "发现丢失的窗口：" & e_w
                Call check_hwnd(game_type)
            End If
        Next
    End If
    //    TracePrint "实时监测窗口结束"
End Function


//结束指定得窗口线程
Sub stop_sel(tar)
    Dim res, ret
    Dim currt_state,currt_id
    //获取当前已选账号
    ret = get_hwnd(tar,"启动状态")
    If ret = "已启动" Then
        res=get_hwnd(tar,"线程")
        TracePrint "准备停止线程：" & res
        Call StopThread(res)
        Call change_hwnd(tar,"未启动",0)
    End If
    TracePrint "解除锁定按钮"
    Call ui_switch(1)
    Call 启动按钮("")
End Sub

//-+-+-+-+-+-+-+-+--+-+-+-多开界面事件-+-+-+-+-+-+-+-+--+-+-+-
Event YS.启动按钮.Click
    Select Case YS.批量操作.Value
    Case 1
        Call 执行所有()
    Case 0
        //必选不是选择标题才执行
        If YS.账号列表.ListIndex > 0 Then
            Dim hwnd
            hwnd = 获取下拉(YS.账号列表.list, YS.账号列表.ListIndex)
            hwnd = split(hwnd, "-")(1)
            TracePrint "已选目标窗口为：" & hwnd
            Call 启动脚本(hwnd)
        End If
    End Select

End Event

Event YS.账号列表.Click
    //每次选择，都刷新启动按钮
    Call 启动按钮("")

    Call 激活窗口()

    //更新头像
    Call 更新头像()
End Event

Event YS.账号列表.DblClick
    Call 激活窗口()
End Event

Event YS.刷新窗口.Click
    YS.批量操作.Value = 0
    Call check_hwnd(game_type)
End Event

Sub ui_switch(flag)
    YS.批量操作.Enabled = flag
    YS.启动按钮.Enabled = flag
    YS.账号列表.Enabled = flag
    YS.批量操作.Enabled = flag
End Sub
//=====================================@6 执行主体==========================================
//界面初始化
Event YS.Load
    Call log("页面载入")
End Event

//界面载入完成后
Event YS.LoadOver
    YS.mode.Tab=0
    YS.mode_settings.tab = YS.select_mode.ListIndex
    YS.挂机设置.tab = 0
    YS.设置页.tab = 0
    YS.currt_ver.Caption = "当前乐玩版本：" & Plugin.lw.ver()
    TracePrint "当前乐玩版本：" & Plugin.lw.ver()
    Call log("插件初始化完成。")
End Event

Sub main()
    TracePrint "开始执行main----------"
    Dim res, ret

    //先从主线程专递变量
    dim 当前模式:当前模式 = currt_mode
    dim 找图路径:找图路径 = pics_path
    dim 窗口句柄:窗口句柄 = 交换句柄
    Dim 当前帐号:当前帐号 = get_hwnd(窗口句柄,"账号")
    If 当前帐号 = "" Then
        TracePrint "请检查句柄是否合法：" & 窗口句柄
        Exit Sub
    End If

    //挂机模式中得探索
    If 当前模式 = "探索模式" and YS.探索转挂机.Value=1 Then
        当前模式="挂机模式"
    End If

    //检测窗口尺寸
    res = Lib.CPS.get_windows_size(窗口句柄, 854, 480)
    If res <> "符合" Then
        TracePrint "目标窗口尺寸：【" & res & "】不是插件匹配的尺寸【854x480】，如果功能失效，请重启游戏客户端。"
    End If

    //绑定指定的窗口
    res = Lib.CPS.乐玩绑定窗口(窗口句柄, 1, 1, 1, 0, 0)
    If res = 1 Then
        //判断是否打开错误提示
        Call Plugin.lw.SetShowErrorMsg(YS.提示错误.Value)

        //更新状态信息
        Dim currt_id:currt_id = GetThreadID()
        If currt_id > 0 Then
            TracePrint 当前帐号&"绑定成功：" & 窗口句柄
            TracePrint 当前帐号&"执行模式：" & 当前模式
            TracePrint 当前帐号 &"得线程id为：" & currt_id
            Call change_hwnd(窗口句柄, "已启动", currt_id)
            Call check_hwnd("")
        Else
            MsgBox "启动线程失败"
            Exit sub
        End If

        //记录相关信息
        Dim 当前配置文件
        当前配置文件 = Lib.YYS.创建配置(找图路径, 当前帐号)
        If 当前配置文件<>"" Then //创建配置文件，创建成功则记录
            Call Lib.YYS.写入配置(找图路径, 当前账号, "账号启动时间", now())
            Call Lib.YYS.写入配置(找图路径, 当前账号, "账号模式", 当前模式)
            Call Lib.YYS.写入配置(找图路径, 当前账号, "账号线程", currt_id)
            //更新配置文件下拉
        Else
            Call log(当前帐号&"配置文件创建失败。。")
            Delay 1500
        End If

        //判断是否成功，返回1/0
        //记录当前账号图标-建议在主界面调用
        If YS.记录头像.Value = 1 Then
            Call Lib.YYS_异常处理.go_home(找图路径)
            res = Lib.CPS.局部截图(找图路径, "0,0,100,100", 当前帐号 & "头像")
            If res <> "" Then
                Call Lib.YYS.写入配置(找图路径, 当前账号, "账号头像", res)
            End If
            Call 更新头像()

            //记录头像特征码

        End If

        //更新状态按钮
        Call 启动按钮("已启动")

        //启动成功，解锁按钮
        If YS.批量操作.Value Then
            If 当前账号 = "账号" & (YS.账号列表.ListCount - 1) Then
                YS.批量操作.Value = 0
                Call ui_switch(1)
            End If
        Else
            Call ui_switch(1)
        End If

        //主线程
        While 1
            //实时更新功能
            If YS.process_mode.Value Then
                当前模式=currt_mode
            End If

            TracePrint 当前帐号&"当前模式：" & 当前模式
            Select Case 当前模式

            Case "挂机模式"
                Call 挂机模式(当前帐号,找图路径)

            Case "探索模式"
                Call 探索模式(当前帐号,找图路径,"")

            Case "组队模式"
                Call 组队模式(当前帐号,找图路径)

            Case "定制模式"
                TracePrint 当前模式

            Case "贴心功能"
                //获取当前的选择
                If YS.阴阳寮招人.Value Then
                    Call Lib.YYS_贴心功能.阴阳寮收人(找图路径,settings)
                ElseIf YS.自动升星.Value Then
                    Call Lib.YYS_贴心功能.狗粮升星(找图路径, tar)
                End If

            Case "待机模式"
                Call 异常处理()
                Delay 60000

            End Select
        Wend
    End If
    TracePrint "结束执行main----------"
End Sub

//按钮调用入口
Function 启动脚本(hwnd)
    //先判断是启动还是关闭
    TracePrint "***********启动脚本启动************"
    TracePrint "锁定启动按钮"
    YS.启动按钮.Enabled = 0
    YS.账号列表.Enabled = 0
    Dim res,ret

    //先检查交换句柄的当前状态
    res = get_hwnd(hwnd, "")
    TracePrint "启动脚本res：" & res
    Select Case res
    Case "未启动"//启动线程
        交换句柄 = hwnd
        //此处监测是否执行测试模式
        If test_mode = 1 Then
            //执行测试模式
            ret = BeginThread(test)
        Else
            ret = BeginThread(main)
        End If

        If ret Then
            TracePrint "外部结果，已启动线程：" & ret
        End If

    Case "已启动"//关闭线程
        TracePrint "当前句柄已启动"
        //手动结束线程
        Call stop_sel(hwnd)

    Case ""
        MsgBox "游戏窗口异常1."
        TracePrint " 当前句柄状态：" & 交换句柄
        Call ui_switch(1)

    End Select
    TracePrint "***********启动脚本结束************"
End Function


//init() 主体入口
Sub init(title)
    TracePrint "开始执行init----------"
    Dim res
    //1获取插件目录
    //手动选择
    If YS.auto_path.Value = 0 Then
        res = Lib.CPS.IsFolderExists(YS.配置目录.path)
        If res=1 Then
            TracePrint "路径合法"
            setting_path = YS.配置目录.path
        Else
            TracePrint "路径不合法,分配临时目录"
            setting_path = Plugin.Sys.GetDir(0)
        End If
    End If

    Call log("配置文件存放目录：" & setting_path)

    //2解压附件到临时目录
    If YS.临时目录.value = 0 Then
        Call Lib.YYS.release_pics(pics_path, fujian)//释放附件图片到临时目录
        Call Lib.YYS.release_ini(setting_path, "default.ini")
    Else
        TracePrint "启用临时目录"
        If YS.temp_path.path = "" Then
            If Lib.CPS.IsFolderExists("D:\CPS\YYS\YYS\Pictrues\2019\00附件") Then
                pics_path = "D:\CPS\YYS\YYS\Pictrues\2019\00附件"

            ElseIf Lib.CPS.IsFolderExists("E:\YYS\YYS\Pictrues\2019\00附件") Then
                pics_path = "E:\YYS\YYS\Pictrues\2019\00附件"

            ElseIf Lib.CPS.IsFolderExists("D:\CPS\MyProject\YYS\Pictrues\2019\00附件") Then
                pics_path = "D:\CPS\MyProject\YYS\Pictrues\2019\00附件"

            End If
        Else
            pics_path = YS.temp_path.path
        End If
    End If
    If pics_path = "" Then
        MsgBox "没发现有效的元素目录，请配置"
        Exit Sub
    Else
        Call log("当前元素目录：" & pics_path)
    End If

    //3读取ini，读取用户ini
    call get_settings()
    res = Lib.CPS.IsFileExists(setting_path & "default.ini")//先读取默认配置文件
    res = Lib.CPS.IsFileExists(setting_path & "config.ini")//如果有，读取用户配置文件

    //4首次执行，检测当前有效窗口
    ret = init_hwnds(title)
    If ret = 1 Then
        Dim run_time : run_time = 0
        TracePrint time() & "初始化成功：" & all_state
        Call ui_switch(1)
        While 1
            If run_time mod 100 = 0 Then
                TracePrint time() & "--脚本执行中"
            End If

            //实时监测对应的窗口是否存在
            Call 实时监测窗口()

            If stop_id > 0 Then
                TracePrint "监测到需要停止的线程id：" & stop_id
                Call StopThread(stop_id)
                Delay 200
                Call check_hwnd("")
                stop_id =0
            End If

            run_time = run_time + 1
            Delay 100
        Wend
    Else
        TracePrint "获取窗口失败"
        Call ui_switch(0)
        Call 启动按钮("未发现")
    End If

    TracePrint "结束执行init----------"
End Sub


//程序退出时执行的函数
Sub OnScriptExit()
    Call stop_YYS()
    ret = Plugin.lw.UnBindWindow()
    TracePrint ret
End Sub

Sub stop_YYS()
    TracePrint "stop_YYS"
    Dim res
    If all_hwnds <> "" Then
        For Each e_w In split(all_hwnds, ",")
            res = get_hwnd(e_w, "启动状态")
            If res = "已启动" Then
                Call StopThread(get_hwnd(e_w, "线程"))
                Call change_hwnd(e_w,"未启动","")
                Delay 200
                Call 更新账号列表()
            End If
        Next

        //检查所有id，如果全是未启动，则清零
        all_hwnds = ""
        all_state = ""
        Call 启动按钮("")
        Call check_hwnd(game_type)
        Call ui_switch(0)
    End If
End Sub

//==================================================================测试中功能======================================


Event YS.挂机探索.Click
    YS.探索转挂机.Value = YS.挂机探索.Value
    YS.个人突破.Value = YS.挂机探索.Value
    YS.穿插突破.Value = YS.挂机探索.Value
    YS.年兽副本.Value = YS.挂机探索.Value
    YS.好友寄养.Value = YS.挂机探索.Value

End Event

Function liao_invaite_settings()
    Dim func_flag
    func_flag = YS.阴阳寮招人.Value
End Function


Function 超鬼王(account, path, settings)
    超鬼王 = Lib.YYS_超鬼王.超鬼王退治(path,tar,settings)
End Function


//御灵副本
Function yuling_settings()
    Dim yuling_zhenrong : yuling_zhenrong = YS.御灵阵容.ListIndex
    Dim yuling_type : yuling_type = 获取下拉(YS.御灵类型.List, YS.御灵类型.ListIndex)
    Dim yuling_level:yuling_level = 获取下拉(YS.御灵层数.List, YS.御灵层数.ListIndex)

    Dim yuling_count
    If YS.御灵次数1.ListIndex = 0 Then
        yuling_count = 0
    Else
        Select Case YS.御灵次数2.ListIndex
        Case 0//个
            yuling_count = YS.御灵次数1.ListIndex
        Case 1//十
            yuling_count = (YS.御灵次数1.ListIndex + 1) * 10
        Case 2//百
            yuling_count = (YS.御灵次数1.ListIndex + 1) * 100
        Case 3//千
            yuling_count = (YS.御灵次数1.ListIndex + 1) * 1000
        End Select
    End If
    yuling_settings = split(yuling_zhenrong & "-" & yuling_type & "-" & yuling_level & "-" & yuling_count, "-")
End Function

Function 御灵(account, path, settings)
    Dim res, ret
    Dim 御灵次数 : 御灵次数 = 0
    Dim exit_flag : exit_flag = 0
    Dim 设置 : 设置 = settings
    Dim 设定次数

    While 1
        //实时更新配置
        if YS.process_mode.Value = 1 Then
            设置 = yuling_settings()
        End If
        设定次数 = cint(设置(3))

        res = Lib.YYS_业原火.御灵(path, 设置)
        TracePrint "御灵外部结果："&res
        Select Case res
        Case "御灵计次"
            御灵次数 = 御灵次数 + 1
            Call log(account & "当前御灵次数：" & 御灵次数)
            If 设定次数 > 0 and 御灵次数 >= 设定次数 Then
                //完成设定次数，退出
                exit_flag = 1
            End If

        Case "御灵为零"
            exit_flag = 1

        Case "完成"
            exit_flag = 1

        End Select

        If exit_flag = 1 Then
            Call Lib.YYS_异常处理.go_home(path)
            御灵 = "完成"
            Exit function
        End If
    Wend

End Function

//测试模式
Sub test()
    Call ui_switch(0)
    Dim path
    Dim hwnd
    hwnd = Lib.CPS.获取句柄("Find|Win32Window0|阴阳师-网易游戏")
    If hwnd > 0 Then
        //查找窗口成功，进行绑定
        res = Lib.CPS.乐玩绑定窗口(hwnd, 1, 1, 1, 0, 0)
        If res = 0 Then
            //绑定失败
            MsgBox "绑定失败"
            Call ui_switch(1)
            Exit Sub
        End If
    End If
    TracePrint "开始测试模式：。。。"
    Call Plugin.lw.SetShowErrorMsg(YS.提示错误.Value)
    //启动成功，解锁按钮
    Call ui_switch(1)
    path = pics_path
    While 1
        //查找体力
        //        ret = Lib.YYS_定时任务.LBS副本(path,settings)
        //        返回值 = 地图体力(account, path, 地体设置)
        //		返回值 = Lib.YYS_探索模式.更换狗粮(path,"左边","1|N卡|4|1","队员")
        //        返回值 = Lib.YYS.check_page(Lib.YYS_界面.探索模式(path))

        ret=liandong_settings()
        Call 联动副本("", path, ret)

        TracePrint "测试模式外部：" & 返回值

        Delay 3000
    Wend
End Sub

DimEnv show_log
show_log=0
//主函数
Call init(game_type)

Event YS.批量操作.Click
    If YS.批量操作.Value = 0 Then
        Call ui_switch(1)
    End If
End Event

Event YS.log.DblClick
    TracePrint show_log
    Select Case show_log
    Case 1
        YYS_log.Show
        show_log=0
    Case 0
        YYS_log.Close
        show_log=1
    End Select
End Event
