
[Script]
//��ǰ���ڵ�����
//0̽��ģʽ����
//1 �����Աģʽ������󲻻᷵��
//2 �����鵽���ͼ�󣬻��ҵ�̽���½�
//3 �����Ǽ��ж���Ҫ������ɫ
//4 ��ס�����ȷ��ȡ������ļ��
//5 ��ħ������޶�λ����
//6 ��ħbossû��ǰ����ǰ����
//7 ������Ƥ��ʱ������ظ����
//8 ���Խ���ȴ���ʱ��boss��������ס
//9 ����ʱ ֻ��һ�����ѵ����������
//10 ̽��ʱ����������ӡ����
//11 ��ħ����������
//12 �����������⴦��
//13 ����Эս�Ῠ����ʦ����
//����������ӹ���


/* ��������(����ʱ��ӿո񣬿��ٶ�λ)
@0==================��������===================
@1=================����������==================
@2=================�����ܺ�����==================
	1�����ģʽ�� 2���һ�ģʽ�� 3��̽��ģʽ��
@3=================�ι��ܺ�����==================
	@31������������� @32��Ҹ��� @33���鸱�� @34ʯ�ั��
	@35���޸��� @36�������� @37����ͻ�� @38�����ͻ @39�ͻ��
	@40������ӡ @41��ħ֮ʱ @42��ħ���� @43������� @44�������
	@45����֮�� @46���Ѽ��� @47��翨 @48����� @49ҵԭ��
	@50����Эս @51���� @52��ͼ���� @53LBS����
@4==================�����¼�===================
@5==================�࿪���===================
@6==================ִ������===================
@7===============����&�����к���===============
*/

//=====================================@0 ��ʼ����������==========================================
//����ģʽ�ı���

Dim res
Dimenv test_mode:test_mode = YS.����ģʽ.Value//����ģʽ���� 0�ر�|1����
Dimenv test_flag : test_flag = 0

//����/����ģʽ����
DimEnv process_mode:process_mode = YS.process_mode.Value
Dimenv process_list

//�����������
Dimenv start_time : start_time = now()//����������е�ʱ��
Global currt_day : currt_day = day(now())
Dimenv runing_time : runing_time = 0
Dimenv game_path
DimEnv game_type
Dimenv setting_path : setting_path = Plugin.Sys.GetDir(3)//�����ļ�Ŀ¼
Dimenv pics_path : pics_path = Plugin.Sys.GetDir(3) & "\shot"//ͼƬ����·��
DimEnv ini_file//�û����ñ����ļ�
Dimenv default_path//���Ĭ��Ŀ¼
Dimenv currt_mode:currt_mode = ��ȡ����(YS.select_mode.list, YS.select_mode.listindex)//��ǰģʽ
Dimenv currt_page//��¼��ǰ����ҳ��
Dimenv fujian : fujian = 60//��¼����ͼƬ����
Dimenv fight_res//��һ��ս�����
Dimenv tmp : tmp = 0//�һ�ģʽ��ʱ��������

//״̬������
Dimenv state_flag : state_flag = 0
Dimenv state_text : state_text = "����������"

//=====================================@1 ����������==========================================
//���߳�ͳ������
Sub ʱ��ͳ��()
    While 1
        runing_time = DateDiff("n", start_time, now())
        YS.time.Caption = "���������:" & runing_time & "����"
        Delay 6000
    Wend
End Sub

//!5��־��¼
Sub log(str)
    If YS.log.ListCount >= ((YS.log����.ListIndex+1)*100) Then
        YS.log.list="��Ҫ��־|-----"
    End If

    str = Time & "--" & str
    YS.log.InsertItem str, 1
    YYS_log.loglist.InsertItem str, 1
    TracePrint "��¼��־��" & str
End Sub

//!6�·�״̬��
Sub �·�״̬��(text)
    If test_mode = 1 Then
        YS.currt_log.TextColor = "0080FF"
    ElseIf test_mode = 0 Then
        YS.currt_log.TextColor = "40FF00"
    End If

    //���·�״̬��
    If state_flag mod 3 = 0 Then
        state_text = text & "."
    Else
        state_text = state_text & ".."
    End If
    YS.currt_state.Caption = state_text
    state_flag = state_flag + 1
End Sub

//�쳣����
Sub �쳣����()
    Call Lib.YYS_�쳣����.go_home(pics_path)
    Call Lib.YYS_������.˫������(pics_path, "all", "�ر�")
End Sub


//�������������
Event YS.home_auto_select.Click
    YS.���Ѽ���.Value = YS.home_auto_select.Value
    YS.����ͻ��.Value = YS.home_auto_select.Value
    YS.�ͻ��.Value = YS.home_auto_select.Value
    YS.���޸���.Value = YS.home_auto_select.Value
    YS.��ħ֮ʱ.Value = YS.home_auto_select.Value
    YS.��ħ����.Value = YS.home_auto_select.Value
    YS.�������.Value = YS.home_auto_select.Value
    YS.����֮��.Value = YS.home_auto_select.Value
    YS.ÿ��ǩ��.Value = YS.home_auto_select.Value
    YS.��������.Value = YS.home_auto_select.Value
    //    YS.��ͼ����.Value = YS.home_auto_select.Value
    YS.���ù���.Value = YS.home_auto_select.Value
    YS.ͬ��֮��.Value = YS.home_auto_select.Value
    YS.��ȡ�ʼ�.Value = YS.home_auto_select.Value
    YS.��ĩ˫��.Value = YS.home_auto_select.Value
    YS.�Զ���������.Value = YS.home_auto_select.Value
    YS.���ｱ��.Value = YS.home_auto_select.Value
    YS.���޸���.Value = YS.home_auto_select.Value
    YS.�������.Value = YS.home_auto_select.Value
    YS.����ͻ��.Value = YS.home_auto_select.Value
    YS.��ħ֮ʱ.Value = YS.home_auto_select.Value
    YS.�̵�ڵ�.Value = YS.home_auto_select.Value
    YS.����.Value = YS.home_auto_select.Value
    //    YS.LBS����.Value = YS.home_auto_select.Value
End Event

sub �Ե�������()
    Dim ���Ѻ���:���Ѻ���=����(YS.���Ѻ���.Value,4,2,5,2)
    Dim ��羭��:��羭��=����(YS.��羭��.Value,0,5,1,5)
    //    Dim ������Ƭ:������Ƭ=��������(YS.������Ƭ.Value,YS.������Ƭ��.ListIndex,2)
    //    Dim �Ե�����:�Ե�����=��������(YS.�Ե�����.Value,YS.�Ե�������.ListIndex,5)
    Dim �Ե�̽��:�Ե�̽��=����(YS.�Ե�̽��.Value,YS.�Ե�̽����.ListIndex,6,3,12)
    Dim �Ե�����:�Ե�����=����(YS.�Ե�����.Value,YS.�Ե�������.ListIndex,3,3,6)
    Dim �Ե�����:�Ե�����=����(YS.�Ե�����.Value,YS.�Ե�������.ListIndex,2,1,6)
    Dim �Ե�ͻ��:�Ե�ͻ��=����(YS.�Ե�ͻ��.Value, YS.�Ե�ͻ����.ListIndex, 2,2,5)
    Dim counts:counts = ���Ѻ��� + ��羭�� + �Ե����� + �Ե�̽�� + �Ե����� + �Ե����� + �Ե�ͻ��
    YS.�趨ֵ.Caption = counts
End sub

Function ����(����, ����, ��ֵ, �״μǷ�, �״η�ֵ)
    ����=����+1
    Dim res1, res2
    If ���� = 0 Then
        ��ֵ = 0
        �״� = 0
        ���� = 0
        �״μǷ� =0
        �״η�ֵ = 0
    ElseIf ���� <= �״μǷ� Then
        ���� = ���� * �״η�ֵ
    ElseIf ���� > �״μǷ� Then
        res1 = �״μǷ� * �״η�ֵ
        res2 = (���� - �״μǷ�) * ��ֵ
        ���� = res1 + res2
    End If
End Function

//tar ��|�ָ����ַ���
//index ��ȡ�ָ��ڼ���Ԫ��
Function ��ȡ����(tar, index)
    ��ȡ���� = ""
    //        TracePrint "��ǰtar��" & tar
    //        TracePrint "��ǰindex��" & index
    Dim res
    res = split(tar, "|")
    If vartype(res) = 8204 Then
        If UBound(res) >= index Then
            ��ȡ���� = res(index)
        End If
    End If
End Function

/*=====================================@2 �����ܺ�����==========================================
1�����ģʽ�� 2���һ�ģʽ�� 3��̽��ģʽ��
*/

//================================!1�����ģʽ��================================
function team_settings()
    dim ��Ա����:��Ա����=��ȡ����(YS.��Ա����.list, YS.��Ա����.listindex)
    Dim ��ǰ��� : ��ǰ��� = ��ȡ����(YS.menber_mode.list, YS.menber_mode.listindex)

    Dim ��������:�������� =""
    If YS.��������.Value=1 Then
        �������� = ��ȡ����(YS.��������.list, YS.��������.listindex)
    End If


    dim ˫������:˫������=YS.��ʱ˫��.Text
    dim �趨����:�趨����=YS.����.listindex + 1
    dim ��������:��������=��ȡ����(YS.����Ȩ��.list, YS.����Ȩ��.listindex)

    dim ����ѡ��
    select case ��ǰ���
    case "ֻ���ӳ�"
        ����ѡ��=��ȡ����(YS.�ӳ���������.list, YS.�ӳ���������.listindex)
    case "ֻ����Ա"
        ����ѡ��=��ȡ����(YS.��Ա��������.list, YS.��Ա��������.listindex)
    case else
        ����ѡ��=��ȡ����(YS.�ӳ���������.list, YS.�ӳ���������.listindex)

    end select
    dim �Ƿ�����:�Ƿ�����=YS.ʧ������.listindex

    dim �ֶ����
    select case ��������
    case "����"
        �ֶ����=��ȡ����(YS.�����һ�غ�.list, YS.�����һ�غ�.listindex) &"|"& ��ȡ����(YS.����ڶ��غ�.list, YS.����ڶ��غ�.listindex) &"|"& ��ȡ����(YS.��������غ�.list, YS.��������غ�.listindex)
    case "����"
        �ֶ����="�����|�����|�����"
    case "ҵԭ��"
        �ֶ����="�����|�����|�����"
    case else
        �ֶ����="�����|�����|�����"
    End Select

    Dim �������� : �������� = YS.�Զ�����.Value & "|" & (YS.��������.listindex + 1) & "|" & YS.������.Value
    Dim �������
    If YS.�������.Text <> "" and YS.�������.Text <> 0 Then
        ������� = cint(YS.�������.Text)
    Else
        ������� = 0
    End If

    team_settings = split(��Ա���� & "-" & ��ǰ��� & "-" & �������� & "-" & ˫������ & "-" & �趨���� & "-" & �������� & "-" & ����ѡ�� & "-" & �Ƿ����� & "-" & �ֶ���� & "-" & ��������& "-" &�������, "-")
End Function

Event YS.��������.SelectChange
    TracePrint "�������ͣ�"&YS.��������.ListIndex
    Select case YS.��������.ListIndex
    Case 0//����
        YS.����.list = "һ��|����|����|�Ĳ�|���|����|�˲�|�Ų�|ʮ��|ʮһ��"
        YS.����.listindex = 10
    Case 1//����
        YS.����.list = "һ��|����|����|�Ĳ�|���|����|�˲�|�Ų�|ʮ��"
        YS.����.listindex = 9
    Case 2//ҵԭ��
        YS.����.list = "̰|��|��"
        YS.����.listindex = 0
    End Select
End Event

Function ���ģʽ(��ǰ�˺�, ͼƬ·��)
    ���� = team_settings()
    Dim �������:������� = cint(����(10))
    dim ս������:ս������ = 0
    Dim �������� : �������� = 0

    TracePrint "-------�������:" & �������
    While 1
        //                            (ͼƬ·��, ��Ա����, ��ǰ���, ��������, ˫������, ����, ��������, ����ѡ��, �Ƿ�����, �ֶ����,��������)
        res = Lib.YYS_����ģʽ.����ģʽ(ͼƬ·��, ����(0), ����(1), ����(2), ����(3), ����(4), ����(5), ����(6), ����(7), ����(8), ����(9))
        TracePrint "*********--------����ģʽ�ⲿ�����" & res

        Select Case res
        Case "�ȴ���ʱ"
            Call Lib.YYS_�쳣����.go_home(ͼƬ·��)
            Call Lib.YYS_������.homeTo(ͼƬ·��, "���ͼ")
        End Select

        If �������� = 0 and res = "ս����" Then
            �������� = 1

        ElseIf �������� = 1 and res <> "" and res <> "ս����" Then
            ս������ = ս������ + 1
            YS.����ͳ��.Caption = "��ǰ���������[" & ս������ & "]"
            �������� = 0
        End If

        If ������� > 0 Then
            TracePrint "��ǰս��������" & ս������
            TracePrint "�趨ս��������" & �������
            If ս������ >= ������� and res <> "ս����" Then
                TracePrint "��ִ�е�ָ����������������ģʽ"
                Call Lib.CPS.��ʱ�ػ�("�ػ�", 0, 10)
            End If
        End If

        if YS.process_mode.Value = 1 Then
            TracePrint "��ǰ�ڵ���ģʽ��"
            ����=team_settings()
            If currt_mode <> "���ģʽ" Then
                exit function
            End If
        End If
    Wend
End function
//================================!1�����ģʽ��================================


//================================!2���һ�ģʽ��================================
Function �һ�ģʽ(account, ͼƬĿ¼)
    Call log("�һ�ģʽ����")

    //̽������
    Dim ̽������:̽������=tansuo_settings()
    Dim ̽������
    If YS.�һ�̽��.Value = 1 Then
        ̽������ = YS.̽��ת�һ�.Value
    End If

    Dim ̽��ִ��:̽��ִ��=̽������
    Dim ̽����ȴ:̽����ȴ=""

    //������ӡ ��������|����ִ��|��������|��������|��������|����
    dim ��������:��������= yaoqi_settings()
    Dim ��������:��������= ��������(0)
    dim ����ִ��:����ִ��= ��������
    dim ������ȴ:������ȴ= ""

    //��������
    Dim ��������:��������= liandong_settings()
    Dim ��������:��������= ��������(0)
    Dim ����ִ��:����ִ��= ��������
    Dim ������ȴ : ������ȴ = ""

    //LBS����
    Dim LBS����:LBS����= YS.LBS����.Value
    Dim LBSִ��:LBSִ��= LBS����
    Dim LBS��ȴ : LBS��ȴ = ""

    //��������
    dim ��������:�������� = jingyan_settings()
    dim ���鿪��:���鿪�� = ��������(0)
    dim ����ִ��:����ִ�� = ���鿪��
    dim ������ȴ:������ȴ = ""

    //ʯ������
    dim ʯ������ :ʯ������ = shiju_settings()
    dim ʯ�࿪�� :ʯ�࿪�� = ʯ������(0)
    dim ʯ��ִ�� :ʯ��ִ�� = ʯ�࿪��
    dim ʯ����ȴ :ʯ����ȴ = ""

    //��������
    dim ��������:�������� = nianshou_settings()
    dim ���޿���:���޿��� = ��������(0)
    dim ����ִ��:����ִ�� = ���޿���
    dim ������ȴ:������ȴ = ""

    //�������
    dim �������:������� = jinbi_settings()
    dim ��ҿ���:��ҿ��� = �������(0)
    dim ���ִ��:���ִ�� = ��ҿ���
    dim �����ȴ:�����ȴ = ""

    //ͻ������
    dim ��ͻ����:��ͻ���� = person_tupo_settings()
    dim ��ͻ����:��ͻ���� = ��ͻ����(0)
    dim ��ͻִ��:��ͻִ�� = ��ͻ����
    dim ��ͻ��ȴ:��ͻ��ȴ = ""

    //�ͻ����
    dim �ͻ����:�ͻ���� = liao_tupo_settings()
    dim �ͻ����:�ͻ���� = �ͻ����(0)
    dim �ͻִ��:�ͻִ�� = �ͻ����
    Dim �ͻ��ȴ : �ͻ��ȴ = ""

    //�����ͻ
    dim �������:������� = liao_open_settings()
    dim ��弿���:��弿��� = �������(0)
    dim ���ִ��:���ִ�� = ��弿���
    Dim �����ȴ : �����ȴ = ""

    //�������
    dim ��������:�������� = diyu_settings()
    dim ���򿪹�:���򿪹� = ��������(0)
    dim ����ִ��:����ִ�� = ���򿪹�
    dim ������ȴ:������ȴ = ""

    //��ħ����
    dim ��ħ����:��ħ���� = fengmo_settings()
    dim ��ħ����:��ħ���� = ��ħ����(0)
    dim ��ħִ��:��ħִ�� = ��ħ����
    dim ��ħ��ȴ:��ħ��ȴ = ""

    dim ��������:��������=fengmo_boss_settings()
    dim ���쿪��:���쿪��=��������(0)
    dim ����ִ��:����ִ��=���쿪��
    dim ������ȴ:������ȴ=""

    //����֮��
    dim ��������:�������� = yinjie_settings()
    dim ���翪��:���翪�� = ��������(0)
    dim ����ִ��:����ִ�� = ���翪��
    dim ������ȴ:������ȴ = ""

    //����ս
    dim ��������:�������� = qilin_settings()
    dim ���뿪��:���뿪�� = ��������(0)
    dim ����ִ��:����ִ�� = ���뿪��
    dim ������ȴ:������ȴ = ""

    //��翨
    dim ��翨����:��翨����=jiejieka_settings()
    dim ��翨����:��翨����=��翨����(0)
    dim ��翨ִ��:��翨ִ��=��翨����
    Dim ��翨��ȴ : ��翨��ȴ = ""

    //����
    dim ��������:��������=jiyang_settings(account)
    dim ��������:��������=��������(0)
    dim ����ִ��:����ִ��=��������
    Dim ������ȴ : ������ȴ = ""

    //@48�����
    dim ����� :����� = huodong_settings()
    dim ����� :����� = YS.�����.Value
    dim �ִ�� :�ִ�� = �����
    dim ���ȴ :���ȴ = ""

    //ҵԭ����
    Dim ҵԭ���� : ҵԭ���� = chi_settings()
    Dim ҵԭ���� : ҵԭ���� = ҵԭ����(0)
    Dim ҵԭִ�� : ҵԭִ�� = ҵԭ����
    Dim ҵԭ��ȴ : ҵԭ��ȴ = ""

    //ˢЭս
    Dim Эս����:Эս����=YS.����Эս.Value
    Dim Эսִ��:Эսִ��=Эս����
    Dim Эս��ȴ : Эս��ȴ = ""

    //����������
    Dim ������ : ������ = YS.������.Value
    Dim ����ִ�� : ����ִ�� = ������
    Dim ������ȴ : ������ȴ = ""

    //��������
    Dim �������� : �������� = yuling_settings()
    Dim ���鿪�� : ���鿪�� = YS.���鸱��.Value
    Dim ����ִ�� : ����ִ�� = ���鿪��
    Dim ������ȴ : ������ȴ = ""


    //���������
    Dim ÿ�տ���
    Dim ÿ������:ÿ������=home_settings()
    If vartype(ÿ������) = 8204 Then
        ÿ�տ��� = 1
    Else
        ÿ�տ��� = 0
    End If

    //13.5

    //�ȴ����
    Dim tmp : tmp = 0

    //������ʼʱִ��һ��
    Dim home_feature:home_feature=home_settings()
    call Lib.YYS_������.�����潱��(ͼƬĿ¼)

    Dim run_flag:run_flag=0
    While 1
        run_flag = 0

        //ÿ������
        //        If ÿ�տ��� = 1 Then
        //            Call ÿ������(account, ͼƬĿ¼, ��������)
        //        End If

        //����
        If ���鿪�� = 1 Then
            if ������ȴ = "���" then
                ����ִ�� = 0
            else
                res = Lib.YYS.��ȴ���(������ȴ)
                If res = "���" Then
                    ����ִ��=1
                Else
                    ����ִ��=0
                End If
            End If

            If ����ִ�� = 1 Then
                ������ȴ = ����(account, ͼƬĿ¼, ��������)
            End If
        End If
        run_flag = run_flag + ����ִ��

        //������
        If ������ = 1 Then
            res = Lib.YYS.��ȴ���(������ȴ)
            If res = "���" Then
                ����ִ�� = 1
            Else
                ����ִ�� = 0
                Call log("1�´�̽��ִ��ʱ�䣺" & ������ȴ)
            End If

            If ����ִ�� = 1 Then
                ������ȴ = ������(account, ͼƬĿ¼, ��������)
            End If
        End If


        //̽��ģʽ
        If ̽������ = 1 Then
            res = Lib.YYS.��ȴ���(̽����ȴ)
            If res = "���" Then
                ̽��ִ�� = 1
            Else
                ̽��ִ�� = 0
                Call log("1�´�̽��ִ��ʱ�䣺" & ̽����ȴ)
            End If

            TracePrint "ִ�йһ�ģʽ̽����"
            If ̽��ִ�� = 1 Then
                ̽����ȴ = ̽��ģʽ(account, ͼƬĿ¼, ̽������)
                If ̽����ȴ = "���" Then
                    //����ִ��̽��
                    ��ͻִ�� = ��ͻ����
                    ����ִ�� = ��������
                    ̽������ = 0
                    ��ͻ��ȴ = ""

                ElseIf ̽����ȴ = "ִ�йһ�" Then
                    ̽��ִ�� = 1
                    ��ͻִ�� = ��ͻ����
                    ����ִ�� = ��������
                    ��ͻ��ȴ = ""
                    ̽����ȴ = ""

                End If
                TracePrint "********-----+++++̽�����ⲿ�����" & ̽����ȴ
            End If
            Call log("2�´�̽��ִ��ʱ�䣺" & ̽����ȴ)
            TracePrint "̽��ִ�п��أ�" & ̽��ִ��
        End If
        run_flag = run_flag + ̽��ִ��

        //�����ͻ
        If ��弿��� = 1 Then
            If ���ִ�� = 1 Then
                //                call Lib.YYS_�쳣����.go_home(pics_path)
                �����ȴ = �����ͻ(account, ͼƬĿ¼, �������)
                If �����ȴ = "���" Then
                    ���ִ�� = 0
                Else
                    res = Lib.YYS.��ȴ���(�����ȴ)
                    If res = "���" Then
                        ���ִ��=1
                    Else
                        ���ִ��=0
                    End If
                End If
            End If
        End If
        run_flag = run_flag + ���ִ��
        //        TracePrint "��ǰִ�п��أ�" & run_flag

        //����֮��
        If ���翪�� = 1 Then
            If ������ȴ = "���" Then
                ���翪�� = 0
                ����ִ�� = 0
            Else
                res = Lib.YYS.��ȴ���(������ȴ)
                If res = "���" Then
                    ����ִ��=1
                Else
                    ����ִ��=0
                End If
            End If

            If ����ִ�� = 1 Then
                ������ȴ=����֮��(account,ͼƬĿ¼, ��������)
            End If
            Call log(account& "����֮���´�ִ��ʱ��Ϊ��" & ������ȴ)
        End If
        run_flag = run_flag + ����ִ��
        //        TracePrint "����֮��ִ�п��أ�" & run_flag

        //����ս
        If ���뿪�� = 1 Then
            If ������ȴ = "���" Then
                ���뿪�� = 0
                ����ִ�� = 0
            Else
                res = Lib.YYS.��ȴ���(������ȴ)
                If res = "���" Then
                    ����ִ��=1
                Else
                    ����ִ�� = 0
                    Call log(account& "����֮���´�ִ��ʱ��Ϊ��" & ������ȴ)
                End If
            End If
            If ����ִ�� = 1 Then
                //                    call Lib.YYS_�쳣����.go_home(pics_path)
                ������ȴ=����(account,ͼƬĿ¼, ��������)
            End If
        End If
        run_flag = run_flag + ����ִ��
        //        TracePrint "����սִ�п��أ�" & run_flag

        //��翨
        If ��翨���� = 1 Then
            res = Lib.YYS.��ȴ���(��翨��ȴ)
            If res = "���" Then
                ��翨ִ��=1
            Else
                ��翨ִ��=0
                Call log(account & "��翨�´�ִ��ʱ��Ϊ��" & ��翨��ȴ)
            End If
            If ��翨ִ�� = 1 Then
                ��翨��ȴ=��翨(account,ͼƬĿ¼, ��翨����)
            End If
        End If
        run_flag = run_flag + ��翨ִ��
        //        TracePrint "��ǰִ�п��أ�" & run_flag

        //���Ѽ���
        If �������� = 1 Then
            res = Lib.YYS.��ȴ���(������ȴ)
            If res = "���" Then
                ����ִ�� = 1
            Else
                ����ִ�� = 0
                Call log(account& "���Ѽ����´�ִ��ʱ��Ϊ��" & ������ȴ)
            End If
            If ����ִ�� = 1 Then
                //                call Lib.YYS_�쳣����.go_home(pics_path)
                ������ȴ = ���Ѽ���(account, ͼƬĿ¼, ��������)
            End If
        End If
        run_flag = run_flag + ����ִ��
        //        TracePrint "����ִ�п��أ�" & ����ִ��

        //��ħ֮ʱ
        If ��ħ���� = 1 Then
            if ��ħ��ȴ = "���" or ��ħ��ȴ = "�ѹ�ʱ" then
                ��ħִ��=0
            else
                res = Lib.YYS.��ȴ���(��ħ��ȴ)
                If res = "���" Then
                    ��ħִ��=1
                Else
                    ��ħִ��=0
                    Call log(account& "��ħ֮ʱ�´�ִ��ʱ��Ϊ��" & ��ħ��ȴ)
                End If
            end if
            If ��ħִ�� = 1 Then
                //                call Lib.YYS_�쳣����.go_home(pics_path)
                ��ħ��ȴ = ��ħ����(account,ͼƬĿ¼, ��ħ����)
            End If
        End If
        run_flag = run_flag + ��ħִ��
        //        TracePrint "��ħִ�п��أ�" & ��ħִ��

        //��ħ����
        If ���쿪�� = 1 Then
            if ������ȴ = "���" then
                ����ִ��=0
            else
                res = Lib.YYS.��ȴ���(������ȴ)
                If res = "���" Then
                    ����ִ��=1
                Else
                    ����ִ��=0
                    Call log(account& "��ħ����֮ʱ�´�ִ��ʱ��Ϊ��" & ������ȴ)
                End If
            End If
            If ����ִ�� = 1 Then
                ������ȴ = ��ħ����(account,ͼƬĿ¼, ��������)
            End If
        End If
        run_flag = run_flag + ����ִ��
        //        TracePrint "����ִ�п��أ�" & ����ִ��

        //�������
        If ���򿪹� = 1 Then
            If ����ִ�� = 1 Then
                ������ȴ = �������(account, ͼƬĿ¼, ��������)
            end if
            select case ������ȴ
            case "���"
                ����ִ��=0
            case else
                res = Lib.YYS.��ȴ���(������ȴ)
                If res = "���" Then
                    ����ִ��=1
                Else
                    ����ִ��=0
                    Call log(account& "��������´�ִ��ʱ��Ϊ��" & ������ȴ)
                End If
            end select
        End If
        run_flag = run_flag + ����ִ��
        //        TracePrint "����ִ�п��أ�" & ����ִ��

        //�ͻ��
        If �ͻ���� = 1 Then
            res = Lib.YYS.��ȴ���(�ͻ��ȴ)
            If res = "���" Then
                �ͻִ�� = 1
            Else
                �ͻִ�� = 0
                Call log(account& "�ͻ�����´�ִ��ʱ��Ϊ��" & �ͻ��ȴ)
            End If

            If �ͻִ�� = 1 Then
                //call Lib.YYS_�쳣����.go_home(pics_path)
                �ͻ��ȴ = �ͻ��(account, ͼƬĿ¼, �ͻ����)
            End If
        End If
        run_flag = run_flag + �ͻִ��
        //        TracePrint "��ǰִ�п����ͻ�ƣ�" & run_flag

        //����
        If �������� = 1 Then
            res = Lib.YYS.��ȴ���(������ȴ)
            If res = "���" Then
                ����ִ�� = 1
            Else
                ����ִ�� = 0

            End If
            If ����ִ�� = 1 Then
                ������ȴ = ��������(account, ͼƬĿ¼, ��������)
            End If
            Call log(account& "���������´�ִ��ʱ��Ϊ��" & ������ȴ)
        End If
        run_flag = run_flag + ����ִ��

        //����
        If LBS���� = 1 Then
            res = Lib.YYS.��ȴ���(LBS��ȴ)
            If res = "���" Then
                LBSִ�� = 1
            Else
                LBSִ�� = 0

            End If
            If LBSִ�� = 1 Then
                LBS��ȴ = LBS����(account, ͼƬĿ¼, LBS����)
            End If
            Call log(account& "LBS�����´�ִ��ʱ��Ϊ��" & LBS��ȴ)
        End If
        run_flag = run_flag + LBSִ��

        //����
        If ���鿪�� = 1 Then
            res = Lib.YYS.��ȴ���(������ȴ)
            If res = "���" Then
                ����ִ�� = 1
            Else
                ����ִ�� = 0
                Call log(account& "���鸱���´�ִ��ʱ��Ϊ��" & ������ȴ)
            End If
            If ����ִ�� = 1 Then
                //                call Lib.YYS_�쳣����.go_home(pics_path)
                ������ȴ = ���鸱��(account, ͼƬĿ¼, ��������)
            End If
        End If
        run_flag = run_flag + ����ִ��
        //        TracePrint "��ǰִ�п��أ�" & run_flag

        //ʯ��
        If ʯ�࿪�� = 1 Then
            res = Lib.YYS.��ȴ���(ʯ����ȴ)
            If res = "���" Then
                ʯ��ִ�� = 1
            Else
                ʯ��ִ�� = 0
                Call log(account& "ʯ�ั���´�ִ��ʱ��Ϊ��" & ʯ����ȴ)
            End If
            If ʯ��ִ�� = 1 Then
                //                call Lib.YYS_�쳣����.go_home(pics_path)
                ʯ����ȴ = ʯ�ั��(account, ͼƬĿ¼, ʯ������)
            End If
        End If
        run_flag = run_flag + ʯ��ִ��
        //        TracePrint "��ǰִ�п��أ�" & run_flag


        //����
        If ���޿��� = 1 Then
            res = Lib.YYS.��ȴ���(������ȴ)
            If res = "���" Then
                ����ִ�� = 1
            Else
                ����ִ�� = 0
                Call log(account& "���޸����´�ִ��ʱ��Ϊ��" & ������ȴ)
            End If
            If ����ִ�� = 1 Then
                //                call Lib.YYS_�쳣����.go_home(pics_path)
                ������ȴ = ���޸���(account, ͼƬĿ¼, ��������)
            End If
        End If
        run_flag = run_flag + ����ִ��
        //        TracePrint "��ǰִ�п��أ�" & run_flag


        //@48�����
        If ����� = 1 Then
            If ���ȴ = "���" Then
                �ִ�� = 0
            Else
                res = Lib.YYS.��ȴ���(���ȴ)
                If res = "���" Then
                    �ִ�� = 1
                Else
                    �ִ�� = 0
                End If
            End If

            If �ִ�� = 1 Then
                ���ȴ = �����(account, ͼƬĿ¼, �����)
            End If
        End If
        run_flag = run_flag + �ִ��
        //        TracePrint "��ǰִ�п��أ�" & run_flag

        //����ͻ��
        If ��ͻ���� = 1 Then
            if ��ͻ��ȴ = "���" then
                ��ͻִ��=0
            else
                res = Lib.YYS.��ȴ���(��ͻ��ȴ)
                If res = "���" Then
                    ��ͻִ��=1
                Else
                    ��ͻִ��=0
                    Call log(account& "����ͻ���´�ִ��ʱ��Ϊ��" & ��ͻ��ȴ)
                End If
            end if
            If ��ͻִ�� = 1 Then
                ��ͻ��ȴ=����ͻ��(account,ͼƬĿ¼, ��ͻ����)
            End If
        End If
        TracePrint "��ͻ��ȴ��" & ��ͻ��ȴ
        run_flag = run_flag + ��ͻִ��
        //        TracePrint "��ǰִ�п��أ�" & ��ͻִ��


        //ҵԭ��
        If ҵԭ���� = 1 Then
            if ҵԭ��ȴ = "���" then
                ҵԭִ�� = 0
            else
                res = Lib.YYS.��ȴ���(ҵԭ��ȴ)
                If res = "���" Then
                    ҵԭִ��=1
                Else
                    ҵԭִ��=0

                End If
            end if
            If ҵԭִ�� = 1 Then
                ҵԭ��ȴ = ҵԭ��(account, ͼƬĿ¼, ҵԭ����)
            End If
            Call log(account& "����ͻ���´�ִ��ʱ��Ϊ��" & ҵԭ��ȴ)
        End If
        run_flag = run_flag + ҵԭִ��

        //���
        If ��ҿ��� = 1 Then
            res = Lib.YYS.��ȴ���(�����ȴ)
            If res = "���" Then
                ���ִ�� = 1
            Else
                ���ִ�� = 0
                Call log(�˺�& "��Ҹ����´�ִ��ʱ��Ϊ��" & �����ȴ)
            End If
            If ���ִ�� = 1 Then
                �����ȴ = ��Ҹ���(account, ͼƬĿ¼, �������)
            End If
        End If
        run_flag = run_flag + ���ִ��
        TracePrint "��ǰִ�п��أ�" & run_flag

        //��ͼ����
        If ���忪�� = 1 Then
            res = Lib.YYS.��ȴ���(������ȴ)
            If res = "���" Then
                ����ִ�� = 1
            Else
                ����ִ�� = 0
            End If
            If ����ִ�� = 1 Then
                ������ȴ = ��ͼ����(account, ͼƬĿ¼, ��������)
            End If
            Call log(�˺�& "���帱���´�ִ��ʱ��Ϊ��" & ������ȴ)
        End If
        run_flag = run_flag + ����ִ��

        //ˢЭս
        If Эս���� = 1 Then
            If Эսִ�� = 1 Then
                Эս��ȴ = ����Эս(account, ͼƬĿ¼, Эս����)
                If Эս��ȴ = "���" Then
                    Эսִ��=0
                Else
                    res = Lib.YYS.��ȴ���(Эս��ȴ)
                    If res = "���" Then
                        Эսִ��=1
                    Else
                        Эսִ��=0
                    End If
                End If
            End If
        End If
        run_flag = run_flag + Эսִ��

        //����
        If �������� = 1 Then
            If ����ִ�� = 1 Then
                ������ȴ = ������ӡ(account, ͼƬĿ¼, ��������)
            end if

            If ������ȴ = "���" Then
                //ִ�����
                ����ִ��=0
            elseif ������ȴ <> "" and ������ȴ <> "���" then
                res = Lib.YYS.��ȴ���(������ȴ)
                If res = "���" Then
                    ����ִ��=1
                Else
                    ����ִ��=0
                    //                    Call log(�˺�& "���������´�ִ��ʱ��Ϊ��" & ������ȴ)
                End If
            End If
        End If
        run_flag = run_flag + ����ִ��

        if run_flag > 0 Then
            //��˵�����и���Ҫִ��
            //����ģʽ�Ļ�����鵱ǰģʽ�Ƿ�ı�
            Delay 2500

        ElseIf run_flag = 0 Then
            //ִ���������������

            //���Ը���������ȴ�У�����Ƿ���Ҫִ������¼�
            //�������������¼�����ִ������¼�
            If tmp mod 60 = 0 or tmp=0 Then
                Call log("[" & account & "] " & time() & "==>����ģʽ������ȴִ�д�������ǰ�Ѵ�����" & tmp & "����")
                Call Lib.YYS_�쳣����.go_home(ͼƬĿ¼)
            End If
            Delay 10000
            tmp = tmp + 1//��¼��ǰ�ѵȴ���ʱ�䣬��λΪ����
        End If

        Call Lib.YYS_�쳣����.��������(ͼƬĿ¼, "")
        Call Lib.YYS_������.�����潱��(ͼƬĿ¼)

        if YS.process_mode.Value = 1 Then
            TracePrint "�������á���������������������"
            //���¶�ȡ��������
            ��������=YS.������ӡ.value
            �������� = YS.��������.value
            LBS����=YS.LBS����.value
            ���鿪��=YS.���鸱��.value
            ʯ�࿪��=YS.ʯ�ั��.value
            ���޿���=YS.���޸���.value
            ��ҿ���=YS.��Ҹ���.value
            ��ͻ����=YS.����ͻ��.value
            �ͻ����=YS.�ͻ��.value
            ��弿���=YS.�����ͻ.value
            ���򿪹�=YS.�������.value
            ��ħ����=YS.��ħ֮ʱ.value
            ���쿪��=YS.��ħ����.value
            ���翪��=YS.����֮��.value
            ��翨���� = YS.��翨.value
            �������� = YS.���Ѽ���.value
            ���뿪�� = YS.����.value
            ҵԭ���� = YS.ҵԭ��.Value
            ���忪�� = YS.��ͼ����.Value
            If currt_mode <> "�һ�ģʽ" Then
                exit function
            End If
        End If
    wend
End Function
//14
//================================!2���һ�ģʽ��================================


//================================!3��̽��ģʽ��================================
Function tansuo_settings()
    //��������
    Dim ̽������ : ̽������=YS.̽��ת�һ�.Value
    Dim ̽��ģʽ : ̽��ģʽ = ��ȡ����(YS.��ӵ���.list, YS.��ӵ���.listindex)
    Dim ��Ա���� : ��Ա���� = ��ȡ����(YS.��Ա�ӳ�.list, YS.��Ա�ӳ�.listindex)
    Dim ̽���Ѷ� : ̽���Ѷ� = ��ȡ����(YS.̽���Ѷ�.list, YS.̽���Ѷ�.listindex)
    Dim ̽���½� : ̽���½� = YS.̽���½�.listindex


    //�ر�����
    Dim ̽��˫�� : ̽��˫�� = YS.̽��˫��.value
    Dim ֻ����:ֻ���� = YS.ֻ����.value

    //��������
    Dim �������� : �������� = YS.��������.Value
    Dim �����ӳ� : �����ӳ� = ��ȡ����(YS.�����ӳ�.list, YS.�����ӳ�.listindex)
    Dim �������� : �������� = ��ȡ����(YS.��������.list, YS.��������.listindex)
    Dim �����Ǽ� : �����Ǽ� = YS.�����Ǽ�.listindex + 2
    Dim �϶����� : �϶����� = YS.�϶�����.Value
    Dim �������� : �������� = �����ӳ� & "|" & �������� & "|" & �����Ǽ� & "|" & �϶�����

    //��������
    Dim ̽������ : ̽������ = YS.̽������.Value
    Dim ��������:��������="���"
    If ̽������ Then
        If YS.̽�����.Value Then
            ��������=��������&"@����"
        End If
        If YS.̽������.Value Then
            ��������=��������&"@����"
        End If
    End If
    Dim ̽���������� : ̽���������� = ��ȡ����(YS.̽����������.list, YS.̽����������.listindex)
    Dim ̽���������:̽���������=YS.̽�����.Value
    Dim ��������:��������=̽������ & "|" & ̽���������� & "|" & ̽��������� & "|" & ��������
    TracePrint "�������ã�" & ��������

    //ͻ������
    Dim ����ͻ�� : ����ͻ�� = YS.����ͻ��.Value
    Dim ��ʱ�һ�
    If YS.��ʱ�һ�.Value Then
        ��ʱ�һ� = ��ȡ����(YS.��ʱ�һ�����.list, YS.��ʱ�һ�����.listindex)
        //        ��ʱ�һ� = YS.��ʱ�һ�����.listindex
    Else
        ��ʱ�һ� = "����ʱ"
    End If

    ͻ������ = ����ͻ�� & "|" & ��ʱ�һ�
    TracePrint "ͻ�����ã�" & ͻ������
    '0				1					2			3					4				5				6				7				8					9
    tansuo_settings = split(̽��ģʽ & "-" & ��Ա���� & "-" & ̽���½� & "-" & ̽���Ѷ� & "-" & ̽��˫�� & "-" &ֻ����& "-" & �������� & "-" & �������� & "-" & �������� & "-" & ͻ������, "-")
End Function

Event YS.��ӵ���.SelectChange
    Select Case YS.��ӵ���.ListIndex
    Case 0//����
        YS.��Ա�ӳ�.ListIndex = 1
        YS.��Ա�ӳ�.Enabled = 0

    Case 1//���
        YS.��Ա�ӳ�.Enabled = 1

    End Select
End Event

Event YS.̽��ת�һ�.Click
    YS.����ͻ��.Enabled = YS.̽��ת�һ�.Value
    YS.����ͻ��.Value = YS.̽��ת�һ�.Value
    YS.�һ�̽��.Value = YS.̽��ת�һ�.Value
End Event

Event YS.����ͻ��.Click
    YS.����ͻ��.Value = YS.����ͻ��.Value
    If YS.����ͻ��.Value Then
        YS.����ˢ��.Value = 0
    End If
End Event

Function ̽��ģʽ(account, path,����)
    Dim res,ret
    dim tansuo_count : tansuo_count = 0
    Dim ̽������ : ̽������=����
    If ̽������ = "" Then
        ̽������ = tansuo_settings()
    End If
    Dim exit_flag : exit_flag = 0
    Dim �һ�ʱ��, ͻ������
    Dim ����ʱ�� : ����ʱ�� = now()
    While 1
        TracePrint "*************************̽��ģʽ*************************"
        TracePrint "����ʱ�䣺" & ����ʱ��

        //����ģʽ�£���������
        if YS.process_mode.Value = 1 Then
            ̽������ = tansuo_settings()
        End If

        res = Lib.YYS_̽��ģʽ.tansuo(path, ̽������(0), ̽������(1), ̽������(2), ̽������(3), ̽������(4), ̽������(5), ̽������(6), ̽������(7), ̽������(8), ̽������(9))
        TracePrint time() & "---̽��ģʽ�����" & res
        Select Case res

        Case "��ʱ�ȴ�"
            ̽��ģʽ = Lib.YYS.������ȴ(Lib.CPS.��Χ���(3, 5))
            TracePrint "��ʱ�ȴ�,Ϊ�˼��ʱ��Ϊ��" & ̽��ģʽ
            exit_flag = 1

        Case "ս������"
            tansuo_count = tansuo_count + 1
            TracePrint "*******̽��ģʽ�ɹ����������+1��" & tansuo_count

        Case "ִ��ͻ��"
            ̽��ģʽ = Lib.YYS.������ȴ(Lib.CPS.��Χ���(2, 2))
            TracePrint "ִ��ͻ��,Ϊ�˼��ʱ��Ϊ��" & ̽��ģʽ
            ̽��ģʽ="ִ�йһ�"
            exit_flag = 1

        End Select

        //��ʱͻ��
        If instr(̽������(9), "����ʱ") = 0 Then
            //�����˶�ʱ�һ�
            TracePrint "̽��ͻ�����ã�" & ̽������(9)
            �һ�ʱ�� = DateAdd("n", Lib.CPS.��Χ���(split(̽������(9), "|")(1), 5), ����ʱ��)
            TracePrint "�´�ͻ��ʱ��Ϊ��" & �һ�ʱ��

            //�ж�ʱ��
            ret = Lib.YYS.��ȴ���(�һ�ʱ��)
            If ret = "���" Then
                TracePrint "�ѵ��һ�ʱ�䣬�˳�̽��ģʽ"
                ̽��ģʽ="ִ�йһ�"
                exit_flag = 1
            End If
        End If

        If exit_flag Then
            Call Lib.YYS_�쳣����.go_home(path)
            Exit function
        End If
        TracePrint "-------------------------̽��ģʽ-------------------------"
    Wend

End Function
//================================!3��̽��ģʽ��================================

/*=====================================@3 �ι��ܺ�����=======================================
@31������������� @32��Ҹ��� @33���鸱�� @34ʯ�ั�� @35���޸��� @36�������� @37����ͻ�� @38�����ͻ
@39�ͻ�� @40������ӡ @41��ħ֮ʱ @42��ħ���� @43������� @44������� @45����֮�� @46���Ѽ��� @47��翨
@48����� @49ҵԭ�� @50����Эս @51���� @52��ͼ���� @53 LBS���� */

//@31�������������
Function home_settings()
    Dim res
    res= ""
    If YS.���ｱ��.Value = 1 Then
        res = res & "|" & "���ｱ��"
    End If

    If YS.�̵�ڵ�.Value = 1 Then
        res = res & "|" & "�̵�ڵ�"
    End If

    If res = "" Then
        home_settings = ""
    Else
        res = Lib.CPS.strip(str, "|")
        home_settings = split(res, "|")
    End If

End Function

Function ÿ������(account, path, settings)
    Dim res,ret
    //����ģʽ�£���������
    if YS.process_mode.Value = 1 Then
        settings = home_settings()
    End If

    If vartype(settings) = 8204 Then
        For Each eMode In settings
            //��ȡ�����ļ�
            ret = Lib.YYS.��ȡ����(path, account, v)
            If ret <> "" Then
                If ret = "δִ��" Then
                    res = Lib.YYS_������.ÿ������(path, v)

                ElseIf Lib.YYS.��ȴ���(ret) = "���" Then
                    res = Lib.YYS_������.ÿ������(path, v)

                End If

                //��ʾִ�н��
                If res = "���" Then
                    TracePrint v & "����ִ�гɹ���"
                Else
                    TracePrint v & "����ִ��ʧ�ܡ�"
                End If
            End If
        Next
    End If

    Call Lib.YYS_������.�����潱��(path)
End Function

//@32��Ҹ���
//����|����2|��ȴʱ��|ƥ�䷽ʽ
function jinbi_settings()
    TracePrint "��Ҹ�������������"
    dim jinbi_flag:jinbi_flag = YS.��Ҹ���.Value
    dim jinbi_mode:jinbi_mode = jinbi_flag
    dim jinbi_zhenrong:jinbi_zhenrong = ��ȡ����(YS.�������.list, YS.�������.listindex)
    dim jinbi_time:jinbi_time = 0

    //��ҿ���|�������
    jinbi_settings = split(jinbi_flag & "-" & jinbi_zhenrong, "-")
End function

Event YS.��Ҹ���.Click
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 0
End Event

function ��Ҹ���(account, ��ͼ·��, ����)
    ��Ҹ��� = ""
    dim res
    //ִ������
    While 1
        res = Lib.YYS_��ʱ����.��Ӹ���(��ͼ·��,"���", "�Զ�","")
        If res = "���" Then
            //������ȴ
            ��Ҹ��� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(360, 10))
            Exit function
        End If
        Call log(account&"����ִ�У���Ҹ���")
    Wend
End Function

//@33���鸱��
function jingyan_settings()
    TracePrint "���鸱������������"
    dim jingyan_flag:jingyan_flag = YS.���鸱��.Value
    dim jingyan_mode:jingyan_mode = jingyan_flag
    dim jingyan_zhenrong:jingyan_zhenrong = ��ȡ����(YS.��������.List,YS.��������.ListIndex)
    dim jingyan_time:jingyan_time = 0

    //��ҿ���|�������
    jingyan_settings = split(jingyan_mode & "-" & jingyan_zhenrong, "-")
End function

Event YS.���鸱��.Click
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 0
End Event

//���鿪��|��������
function ���鸱��(account, ��ͼ·��, ����)
    ���鸱�� = ""
    dim res
    //ִ������
    While 1
        res = Lib.YYS_��ʱ����.��Ӹ���(��ͼ·��,"����", "�Զ�","")
        If res = "���" Then
            //������ȴ
            ���鸱�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(360, 10))
            Exit function
        End If
        Call log(account&"����ִ�У����鸱��")
    Wend
End Function

//@34ʯ�ั��
function shiju_settings()
    TracePrint "ʯ�ั������������"
    dim shiju_flag:shiju_flag = YS.ʯ�ั��.Value
    dim shiju_mode:shiju_mode = shiju_flag
    dim shiju_check:shiju_check = ��ȡ����(YS.ʯ��ˢ��.list, YS.ʯ��ˢ��.listindex)
    dim shiju_zhenrong:shiju_zhenrong = ��ȡ����(YS.ʯ������.list, YS.ʯ������.listindex)
    dim shiju_time:shiju_time = 0

    shiju_settings = split(shiju_mode & "-" & shiju_check & "-" & shiju_zhenrong, "-")
End function

Event YS.ʯ�ั��.Click
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 0
End Event

//ʯ�࿪��|ƥ��ģʽ|ʯ������
function ʯ�ั��(account, ��ͼ·��, ����)
    Call log(account & "����ִ�У�ʯ�ั��")
    dim res,exit_flag:exit_flag=0

    //ִ������
    For 600
        //����ģʽ�£���������
        if YS.process_mode.Value = 1 Then
            ���� = shiju_settings()
        End If

        res = Lib.YYS_��ʱ����.��Ӹ���(��ͼ·��,"ʯ��", ����(1),����(2))
        If res = "����" or res="ʤ��" or res="ս�����" Then
            //������ȴ
            ʯ�ั�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(60, 5))

            exit_flag = 1
            Else res="��ȴ��"
            ʯ�ั�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(15, 5))
            exit_flag = 1
        End If

        If exit_flag = 1 Then
            Call Lib.YYS_�쳣����.go_home(��ͼ·��)
            Exit Function
        End If
    Next
    Call Lib.YYS_�쳣����.go_home(��ͼ·��)
End Function

//@35���޸���
function nianshou_settings()
    TracePrint "���޸���������"
    dim nianshou_flag:nianshou_flag = YS.���޸���.Value
    dim nianshou_mode:nianshou_mode = nianshou_flag
    dim nianshou_check:nianshou_check = ��ȡ����(YS.����ˢ��.list, YS.����ˢ��.listindex)
    dim nianshou_zhenrong:nianshou_zhenrong = ��ȡ����(YS.��������.list, YS.��������.listindex)
    dim nianshou_time:nianshou_time = 0
    nianshou_settings = split(nianshou_mode & "-" & nianshou_check & "-" & nianshou_zhenrong, "-")
End function

Event YS.���޸���.Click
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 0
End Event

function ���޸���(account, ��ͼ·��, ����)
    dim res,exit_flag:exit_flag=0
    Call log(account & "����ִ�У����޸���")

    //ִ������
    For 600
        if YS.process_mode.Value = 1 Then
            ���� = nianshou_settings()
        End If

        res = Lib.YYS_��ʱ����.��Ӹ���(��ͼ·��, "����", ����(1), ����(2))
        If res = "����" or res="ʤ��" or res="ս�����" Then
            //������ȴ
            ���޸��� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(240, 30))
            exit_flag = 1

        ElseIf res = "��ȴ��" Then
            ���޸��� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(60, 30))
            exit_flag = 1

        End If

        If exit_flag = 1 Then
            Call Lib.YYS_�쳣����.go_home(��ͼ·��)
            Exit Function
        End If
    Next
    Call Lib.YYS_�쳣����.go_home(��ͼ·��)
End Function

//@36��������
function liandong_settings()
    dim liandong_flag:liandong_flag = YS.��������.Value//���� �һ���������
    dim liandong_check:liandong_check = ��ȡ����(YS.����ˢ��.list, YS.����ˢ��.listindex) // �ֶ�/�Զ�
    dim liandong_zhenrong:liandong_zhenrong = ��ȡ����(YS.��������.list, YS.��������.listindex) //����
    dim liandong_time:liandong_time = 0
    liandong_settings = split(liandong_flag &"-"& liandong_check &"-"& liandong_zhenrong,"-")
End function

function ��������(account, ��ͼ·��, ����)
    dim res,exit_flag:exit_flag=0
    //ִ������
    For 600
        if YS.process_mode.Value = 1 Then
            ���� = liandong_settings()
        End If
        res = Lib.YYS_��ʱ����.��Ӹ���(��ͼ·��, "����", ����(1),����(2))
        Select Case res
        Case "���"
            �������� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(5,5))
            exit_flag=1

        Case "ʧ��"
            �������� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(2, 2))
            exit_flag = 1

        Case Else
            If res = "ս�����" or res = "����" Then
                �������� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(10, 5))
                exit_flag = 1
            End If

        End Select

        If exit_flag = 1 Then
            Call Lib.YYS_�쳣����.go_home(��ͼ·��)
            Exit Function
        End If
    Next

    �������� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(10, 10))
    Call Lib.YYS_�쳣����.go_home(��ͼ·��)
End Function

//@37����ͻ��
//��һҳ����60����ʱ����ˣ���8��Ȼ��ˢ�£���ƥ�䵽59���ģ�һ�����Ĺ���59���л��кܶ�ѫ�¶�ģ����Һܺô�
Function person_tupo_settings()
    TracePrint "����ͻ�ƣ�����"
    dim person_tupo_flag:person_tupo_flag = YS.����ͻ��.Value
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

    dim person_tupo_check:person_tupo_check = YS.����ˢ��.Value
    dim person_tupo_zhenrong1:person_tupo_zhenrong1 = YS.person_zhenrong1.ListIndex
    dim person_tupo_retry:person_tupo_retry = YS.������ս.Value
    dim person_tupo_zhenrong2:person_tupo_zhenrong2=YS.person_zhenrong2.ListIndex
    dim person_change_zhenrong:person_change_zhenrong=YS.ʧ�ܺ�����.Value
    dim person_tupo_time:person_tupo_time = 0

    //(account,pics_path,��ͻ����(0),��ͻ����(1), ��ͻ����(2),��ͻ����(3),��ͻ����(4),��ͻ����(5))
    //                    ͻ�ƿ��أ�ͻ�Ƶȼ�������ˢ�£�ͻ������1��ս�����ԣ�ͻ������2
    person_tupo_settings = split(person_tupo_flag & "-" & person_tupo_level & "-" & person_tupo_check & "-" & person_tupo_zhenrong1 & "-" & person_tupo_retry & "-" & person_tupo_zhenrong2 & "-" & person_change_zhenrong,"-")
End Function

Event YS.����ͻ��.Click
    YS.����ҳ.tab=2
    YS.�һ���ϸ.Tab = 3
End Event

Event YS.�ͻ��.Click
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 3
End Event

Event YS.����ˢ��.Click
    Select Case YS.����ˢ��.Value
    Case 0
        YS.person_level.Enabled = 1
    Case 1
        YS.person_level.Enabled = 0
        YS.person_level.listindex = 0
    End Select
End Event

Function ����ͻ��(account, path, settings)
    //(account,pics_path,��ͻ����(0),��ͻ����(1), ��ͻ����(2),��ͻ����(3),��ͻ����(4),��ͻ����(5),��ͻ����(6))
    //                    ͻ�ƿ��أ� �Ǽ��ȼ���   ����ˢ�£�  ͻ������1�� ������ս��  ͻ������2,   ��������
    ����ͻ�� = ""
    Dim res, ret
    dim ��ͻ����:��ͻ����=settings
    Dim ���� : ���� = ��ͻ����(3)
    Dim ka_flag : ka_flag = 0
    Dim exit_flag : exit_flag = 0
    Call log(account & "����ִ�У�����ͻ��")
    While 1
        //����ģʽ�£���������
        if YS.process_mode.Value = 1 Then
            TracePrint "����ģʽ�£���������"
            ��ͻ���� = person_tupo_settings()
        End If
        //                     ����ͻ��(path,    �Ǽ�����,   ����ˢ��,    ����1,      ������ս,   ����2,      ������ս)
        ����ͻ�� = Lib.YYS_ͻ�����.����ͻ��(path, ��ͻ����(1), ��ͻ����(2), ����, ��ͻ����(4))
        TracePrint "����ͻ�ƽ����" & ����ͻ��
        If ����ͻ�� <> "" Then
            ka_flag = 0
        End If
        Select Case ����ͻ��
        Case ""
            //�������
            ka_flag = ka_flag + 1
            TracePrint "����������" & ka_flag
            If ka_flag > 50 Then
                ����ͻ��=Lib.YYS.������ȴ(Lib.CPS.��Χ���(3, 3))
                exit_flag = 1
            End If

        Case "ͻ�ƾ�Ϊ��"
            ����ͻ�� = "���"
            exit_flag = 1

        case "ˢ����ȴ��"
            ����ͻ�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(2, 2))
            exit_flag = 1

        case "��ȴ��"
            ����ͻ�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(2, 2))
            exit_flag = 1

        case "ʧ��"
            If ��ͻ����(6) = 1 Then
                //���û�п����������ݣ����2�����趨��1����
                ���� = ��ͻ����(5)
            End If

        Case Else
            ka_flag = 0
        End Select

        If exit_flag = 1 Then
            Call Lib.YYS_�쳣����.go_home(path)
            Exit Function
        End If
    Wend
End Function

//@38�����ͻ
Function liao_open_settings()
    Dim open_flag:open_flag=YS.�����ͻ.Value
    Dim stime : stime = Lib.CPS.create_datetime(YS.liao_stime_h.ListIndex, ��ȡ����(YS.liao_stime_n.List, YS.liao_stime_n.ListIndex))
    Dim liao_select : liao_select = YS.�ͻѡ��.ListIndex + 1
    liao_open_settings = split(open_flag & "-" & stime & "-" & liao_select, "-")
End Function

Function �����ͻ(account,path,settings)
    Dim res,ret
    Dim ����ʱ�� : ����ʱ�� = settings(1)
    Dim �ͻѡ�� : �ͻѡ�� = settings(2)

    //����Ƿ��ѵ�����ʱ��
    TracePrint "����ʱ��Ϊ��" & settings(1)
    ret = Lib.YYS.��ȴ���(settings(1))
    If ret = "���" Then
        Call log(account&"����ִ�У������ͻ")

        //�ѹ��趨�õ�ʱ�Σ�����ִ������
        �����ͻ = Lib.YYS_ͻ�����.open_liao(path, settings(2))
    Else
        �����ͻ=settings(1)
    End If
End Function

//@39�ͻ��
Function liao_tupo_settings()
    Dim liao_flag:liao_flag=YS.�ͻ��.Value
    Dim liao_star_level:liao_star_level=YS.�ͻ���Ǽ�.ListIndex
    Dim liao_level:liao_level=(YS.�ͻ�Ƶȼ�.ListIndex*10)
    Dim liao_dir : liao_dir = ��ȡ����(YS.�ͻ�Ʒ���.List,YS.�ͻ�Ʒ���.ListIndex)
    Dim liao_zhenrong:liao_zhenrong=YS.person_zhenrong1.ListIndex
    liao_tupo_settings = split(liao_flag & "-" & liao_star_level & "-" & liao_level & "-" & liao_dir & "-" &liao_zhenrong, "-")
End Function

Function �ͻ��(account, path, settings)
    Dim res, ret
    Dim �ͻ���� : �ͻ���� = settings
    Dim ���� : ���� = �ͻ����(3)
    Dim exit_flag:exit_flag = 0
    Dim ka_flag:ka_flag=0

    While 1
        Call log(account&"����ִ�У��ͻ��")

        //����ģʽ�£���������
        if YS.process_mode.Value = 1 Then
            TracePrint "����ģʽ�£���������"
            �ͻ���� = liao_tupo_settings()
        End If

        �ͻ�� = Lib.YYS_ͻ�����.�ͻ��(path, �ͻ����(1), �ͻ����(2), �ͻ����(3), ������ս)
        If �ͻ�� <> "" Then
            ka_flag=0
        End If
        TracePrint "�ͻ���ⲿ�����" & �ͻ��
        Select Case �ͻ��
        Case ""
            //�������
            ka_flag = ka_flag + 1
            TracePrint "�ͻ�ƿս��������" & ka_flag
            If ka_flag > 30 Then
                Call Lib.YYS_LW.���2(Lib.YYS_����.ս����("����"))
                exit_flag = 1
            End If

        Case "���"//����ᣬ��ȴ7Сʱ

            �ͻ�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(720, 6))
            exit_flag = 1

        Case "��ȴ��"//�������꣬��ȴ30����
            �ͻ�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(15, 6))
            exit_flag = 1

        Case "δ����"//δ��������ȴ1Сʱ
            �ͻ�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(60, 6))
            exit_flag = 1

        Case "����ʧ��"//�쳣���ȴ�һ������
            �ͻ�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(5, 2))
            exit_flag = 1
        End Select

        If exit_flag = 1 Then
            call Lib.YYS_�쳣����.go_home(path)
            Exit Function
        End If
    Wend
End Function

//@40������ӡ
Function yaoqi_settings()
    Dim tmp
    TracePrint "�������ã�����"
    dim yaoqi_flag:yaoqi_flag = YS.������ӡ.Value
    dim yaoqi_tar:yaoqi_tar = ��ȡ����(YS.����Ŀ��.list, YS.����Ŀ��.listindex)
    dim yaoqi_zhenrong:yaoqi_zhenrong = ��ȡ����(YS.��������.list, YS.��������.listindex)
    dim yaoqi_check:yaoqi_check= ��ȡ����(YS.yaoqi_check.list, YS.yaoqi_check.listindex)

    Dim yaoqi_count : yaoqi_count = 0
    If YS.yaoqi_count_flag.Value = 1 Then
        tmp = cint(YS.yaoqi_count.Text)
        If  tmp> 0 Then
            yaoqi_count = tmp
        End If
    End If

    Dim yaoqi_time : yaoqi_time = "�ر�"
    If YS.yaoqi_time.value = 1 Then
        stime = Lib.CPS.create_datetime(��ȡ����(YS.yaoqi_sh.list, YS.yaoqi_sh.listindex), ��ȡ����(YS.yaoqi_sn.list, YS.yaoqi_sn.listindex))
        tmp = cint(YS.yaoqi_sh.listindex)
        etime = DateAdd("n", tmp, stime)
        yaoqi_time = stime &"|"& etime
    end if

    //��������|����Ŀ��|ƥ��ģʽ|��������|��������|����ʱ��(��ʼʱ��|����ʱ��)
    yaoqi_settings = split(yaoqi_flag & "-" & yaoqi_tar & "-" & yaoqi_check & "-" & yaoqi_zhenrong & "-" & yaoqi_count & "-" &yaoqi_time & "-" & yaoqi_stime& "-" & yaoqi_etime, "-")
End function

Event YS.������ӡ.Click
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 4
End Event

//��������|����Ŀ��|ƥ��ģʽ|��������|��������|����ʱ��(��ʼʱ��|����ʱ��)
Function ������ӡ(account,path,settings)
    Dim res, ret
    dim ��������:�������� = settings
    dim ��ǰ����:��ǰ���� = 0
    Dim ����ִ��:����ִ�� = 1

    ������ӡ = ""
    While 1
        Call log(account&"����ִ�У���������")

        //����ģʽ�£���������
        if YS.process_mode.Value = 1 Then
            �������� = yaoqi_settings()
        End If

        //ʱ���ж�
        If ��������(5) <> "�ر�" and ��������(5) <> "" Then
            ret = split(��������(5), "|")
            TracePrint "������ӡ������ʱ�䣺" & ret(0)
            TracePrint "������ӡ������ʱ�䣺" & ret(1)

            //����Ƿ��ѵ�����ʱ��
            res = Lib.YYS.��ȴ���(ret(0))
            If res = "���" Then
                //�ѹ��趨�õ�ʱ�Σ�����ִ������
                ����ִ��=1
            End If

            //����Ƿ��ѹ��趨ʱ��
            res = Lib.YYS.��ȴ���(ret(1))
            If res = "���" Then
                //�ѹ��趨�õ�ʱ�Σ����������ű�
                ����ִ��="���"
                call Lib.YYS_�쳣����.go_home(pics_path)
                Exit function
            End If
        End If

        //�趨����
        ret=cint(��������(4))
        If ret <> 0 and ��������(4) <> "" Then
            TracePrint "��ǰ�趨�ˣ�" & ��������(4) & "������̽����"
            If ��ǰ���� > ret Then
                ����ִ��=0
                ������ӡ="���"
            End If
        End If

        //ִ���߼�
        If ����ִ�� = 1 Then
            res = Lib.YYS_��ʱ����.������ӡ(path, ��������(1), ��������(2), ��������(3))
            If res = "���" Then
                ��ǰ���� = ��ǰ���� + 1
                TracePrint account & "�����������¼������" & ��ǰ����
            End If
        End If
    Wend
End Function

//@41��ħ֮ʱ
Function fengmo_settings()
    Dim ��ħ����:��ħ���� = YS.��ħ֮ʱ.Value
    Dim ��ħ��ʱ : ��ħ��ʱ = "����ʱ"
    If YS.fengmo_time.Value = 1 Then
        Dim h:h = cint(��ȡ����(YS.fengmo_h.list,YS.fengmo_h.listindex))
        dim m:m = cint(��ȡ����(YS.fengmo_m.list,YS.fengmo_m.listindex))
        ��ħ��ʱ=Lib.CPS.create_datetime(h,m)
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
    //    Dim fengmo_zhenrong:fengmo_zhenrong=��ȡ����(res,ret)

    fengmo_settings = split(��ħ���� & "-" & ��ħ��ʱ, "-")
End Function
Event YS.��ħ֮ʱ.Click
    YS.��ħ����.Value = YS.��ħ֮ʱ.Value
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 1
End Event
Event YS.��ħ����.Click
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 1
End Event
Function ��ħ����(account,path,settings)
    Dim res
    ��ħ���� = ""
    TracePrint "��ħ����"
    //��ħʱ�����ж�
    Dim currt_h : currt_h = hour(now())
    Dim currt_n : currt_n = Minute(now())
    TracePrint "��ǰʱ��:  "&currt_h &":"&currt_n
    If currt_h < 22 and currt_h > 17 Then
        TracePrint "�Ϸ�ʱ��"

    elseif currt_h > 21 Then
        //�ѹ�ʱ��,
        ��ħ���� = "���"
        exit function
    Else
        //δ��ʱ�䡣��Сʱ���ڼ��
        TracePrint "δ��ʱ�䣬�˳�����2"
        ��ħ���� = Lib.YYS.������ȴ(20)
        exit function
    End If

    //��ʱ���
    If settings(1) <> "����ʱ" Then
        res = Lib.YYS.��ȴ���(settings(1))
        If res <> "���" Then
            ��ħ���� = Lib.YYS.������ȴ(20)
            exit function
        End If
    End If

    Call log(account&"����ִ�У���ħ����")

    ��ħ���� = Lib.YYS_ÿ������.��ħ����(path)
    If ��ħ���� = "���" Then
        ��ħ���� = "���"
        call Lib.YYS_�쳣����.go_home(pics_path)
        exit function
    End If
End Function

//@42��ħ����
Function fengmo_boss_settings()
    Dim ���쿪��:���쿪��=YS.��ħ����.Value
    Dim ��������:��������=YS.fengmo_zhenrong1.listindex
    Dim ��ѡ����:��ѡ����=YS.��ħ����.Value
    fengmo_boss_settings = split(���쿪�� & "-" & ��������& "-" &��ѡ����, "-")
End Function
//��ȡ����boss
//function get_boss()
//    Dim res:res=Weekday(now())
//    Select Case res
//    Case 1
//        get_boss="����"
//    Case 2
//        get_boss="����¥"
//    Case 3
//        get_boss="����¥"
//    Case 4
//        get_boss="��֩��"
//    Case 5
//        get_boss="������"
//    Case 6
//        get_boss="������"
//    Case 7
//        get_boss="����"
//    End Select
//End Function
Function ��ħ����(account, path, settings)
    Dim res
    ��ħ���� = ""
    //��ħʱ�����ж�
    Dim currt_h : currt_h = hour(now())
    Dim currt_n : currt_n = Minute(now())
    TracePrint "��ǰʱ��:  "&currt_h &":"&currt_n
    If currt_h < 22 and currt_h > 17 Then
        TracePrint "�Ϸ�ʱ��"

    elseif currt_h > 21 Then
        //�ѹ�ʱ��,
        ��ħ���� = "���"
        exit function
    Else
        //δ��ʱ�䡣��Сʱ���ڼ��
        TracePrint "δ��ʱ�䣬�˳�����2"
        ��ħ���� = Lib.YYS.������ȴ(30)
        exit function
    End If

    //��ʱ���
    If settings(1) <> "����ʱ" Then
        res = Lib.YYS.��ȴ���(settings(1))
        If res <> "���" Then
            ��ħ���� = Lib.YYS.������ȴ(20)
            exit function
        End If
    End If

    Call log(account&"����ִ�У���ħ����")

    ��ħ���� = Lib.YYS_ÿ������.��ħ����(path,settings)
    If ��ħ���� = "���" Then
        ��ħ���� = "���"
        call Lib.YYS_�쳣����.go_home(path)
    End If
End Function

//@43�������
Function diyu_settings()
    TracePrint "�������������"
    dim diyu_flag:diyu_flag = YS.�������.Value
    Dim diyu_mode : diyu_mode = diyu_flag

    Dim diyu_tar
    If YS.�������.listindex = 0 Then
        diyu_tar = "�Զ�"
    Else
        diyu_tar = ��ȡ����(YS.����ѡ��.List, YS.����ѡ��.Listindex)
    End If

    dim diyu_level:diyu_level = ��ȡ����(YS.�����ȼ�.List, YS.�����ȼ�.Listindex)
    dim diyu_time:diyu_time = 0

    //����|Ŀ�����|�����ȼ�
    diyu_settings = split(diyu_flag & "-" & diyu_tar & "-" & diyu_level, "-")
End Function

Event YS.�������.Click
    YS.����ҳ.tab = 1
    YS.�һ���ϸ.Tab = 4
End Event

Event YS.�������.SelectChange
    Select Case YS.�������.listindex
    Case 0
        YS.����ѡ��.List = "�Զ�"
        YS.����ѡ��.ListIndex = 0

    Case 1//����
        YS.����ѡ��.List="���ﳤ��|����"
    Case 2//����
        YS.����ѡ��.List="�����²ؾ���|����"
    Case 3//����
        YS.����ѡ��.List="��ϼɽ|����"
    Case 4//����
        YS.����ѡ��.List="���ﳤ��|����"
    Case 5//������
        YS.����ѡ��.List="���ﳤ��|����"
    Case 6//������
        YS.����ѡ��.List="���ﳤ��|����"
    Case 7//ŷ��
        YS.����ѡ��.List="���ﳤ��|����"
    Case 8//����
        YS.����ѡ��.List="���ﳤ��|����"
    Case 9//������
        YS.����ѡ��.List = "���ﳤ��|����"
    End Select

End Event

//@44�������
Function �������(account,path,settings)
    dim res
    dim ����:����=settings
    ������� = ""

    //����ģʽ�£���������
    if YS.process_mode.Value = 1 Then
        ���� = diyu_settings()
    End If

    Call log(account&"����ִ�У��������")

    //����ִ��
    If ����(1) = "�Զ�" Then
        ������� = Lib.YYS_������.�������(path, "��ϼɽ", "��ͼ�")
        Delay 1000
        ������� = Lib.YYS_������.�������(path, "�����²ؾ���", "��ͼ�")
    Else
        ������� = Lib.YYS_������.�������(path, ����(1), ����(2))
    End If

    //��ɺ�ִ����ȴ
    Select Case �������
    Case "δ��ʱ��"
        TracePrint "������սʱ�䣨6:00~23:59��"
        ������� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(120, 60))
    Case else
        TracePrint "��������쳣����������"
        ������� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(720, 60))
    End Select
End Function

//@45����֮��
Function yinjie_settings()
    //�ж����������ĩ�������Զ�����Ϊ0
    Dim ���翪�� : ���翪�� = YS.����֮��.Value
    Dim �������� : �������� = YS.��������.ListIndex
    //  dim �Ƿ���
    //  dim ��ʮ�˳�:��ʮ�˳�=
    //  yinjie_settings=split(���翪��& "-" &��ʮ�˳�,"-")
    yinjie_settings=split(���翪��&"-"&��������,"-")
End Function

Event YS.����֮��.Click
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 2
End Event

function ����֮��(account,path,settings)
    Dim ���� : ���� = settings
    Dim currt_day
    //����ģʽ�£���������
    if YS.process_mode.Value = 1 Then
        ���� = yinjie_settings()
    End If

    //�ж�����
    currt_day = Weekday(now())
    If currt_day > 1 and currt_day < 6 Then
        //��ǰ������ĩ����ִ��
        ����֮�� = "���"
        Exit function
    End If


    //ʱ�����ж�
    Dim currt_h:currt_h=hour(now())
    If currt_h < 19 Then
        //δ��ʱ�䡣��Сʱ���ڼ��
        ����֮�� = Lib.CPS.create_datetime(19,10)
        exit function
    elseif currt_h > 20 Then
        //�ѹ�ʱ��,
        ����֮�� = "���"
        exit function
    End If
    ����֮�� = Lib.YYS_ÿ������.����֮��(path, ����(1))

    Call Lib.YYS_�쳣����.go_home(pics_path)
End Function

//@46���Ѽ���
Function jiyang_settings(��ǰ�ʺ�)
    Dim �������� : �������� = YS.���Ѽ���.Value
    Dim ��翨ѡ��
    Select Case YS.��翨ѡ��.listindex
    Case 0//�Զ�
        ��翨ѡ�� = "����|̫��"
    Case 1
        ��翨ѡ�� = "̫��|����"
    Case Else
        ��翨ѡ�� = "̫��|����"
    End Select

    Dim ������ʽ:������ʽ=��ȡ����(YS.����Ŀ��.list,YS.����Ŀ��.listindex)
    jiyang_settings = split(�������� & "-" & ��翨ѡ�� & "-" & ������ʽ & "-" & ��ǰ�ʺ�, "-")
End Function

Function ���Ѽ���(account, path, settings)
    Dim res
    dim ����:���� = settings
    //����ģʽ�£���������
    if YS.process_mode.Value = 1 Then
        ���� = jiyang_settings(account)
    End If
    For Each v In ����
        TracePrint v
    Next
    res = Lib.YYS_������.��繦��(path, "���Ѽ���", ����)
    Select Case res
    Case "�Ѽ���"
        //�Ѽ���
        TracePrint "���ڼ����У���¼��ǰʱ��"
        ret = Lib.CPS.�ֲ���ͼ(path, "309,292,531,317", ��ǰ�˺� & "����״̬")
        If ret <> "" Then
            //��¼������Ϣ
            Call Lib.YYS.д������(path, ��ǰ�˺�, "����״̬", ret)
        End If

        For 2
            Call Lib.YYS_LW.���2(Lib.YYS_����.ս����("����"))
            Call Lib.YYS_LW.����ӳ�(55, 222)
        Next

        TracePrint "�Ѽ�������ȴ1Сʱ"
        ���Ѽ��� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(60, 5))

    Case "���"
        //��ȴ7Сʱ
        TracePrint "�����ý�翨����ȴ7Сʱ"
        ���Ѽ��� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(420, 20))

    Case "δ���"
        //��ȴ1Сʱ
        TracePrint "��翨�Ѵ��ڣ�30���Ӻ��ټ��"
        ���Ѽ��� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(30, 10))

    End Select

    call Lib.YYS_�쳣����.go_home(pics_path)
End Function

//@47��翨
Function jiejieka_settings()
    Dim ��翨����:��翨����=YS.��翨.Value
    Dim ��翨����:��翨����=��ȡ����(YS.��翨����.list,YS.��翨����.listindex)
    Dim ��翨�Ǽ�
    If YS.��翨�Ǽ�.listindex = 0 Then
        ��翨�Ǽ� = YS.��翨�Ǽ�.listindex
    Else
        ��翨�Ǽ� = YS.��翨�Ǽ�.listindex + 3
    End If
    Dim ��翨��˽:��翨��˽=��ȡ����(YS.��˽����.list,YS.��˽����.listindex)
    Dim ��翨���� : ��翨���� = YS.��翨����.listindex
    Dim �޿��Զ� : �޿��Զ� = YS.�޿��Զ�.Value

    jiejieka_settings = split(��翨���� & "-" & ��翨���� & "-" & ��翨�Ǽ� & "-" & ��翨��˽ & "-" & ��翨���� & "-" &�޿��Զ�, "-")
End Function
Event YS.��翨����.SelectChange
    Select Case YS.��翨����.listindex
    Case 0
        YS.�޿��Զ�.Enabled = 0
        YS.�޿��Զ�.Value = 0
    Case else
        YS.�޿��Զ�.Enabled = 1
    End Select
End Event
Event YS.�޿��Զ�.Click
    Select Case YS.�޿��Զ�.Value
    Case 1
        If YS.��翨����.listindex = 0 Then
            MsgBox "��翨����ָ��һ��������ܿ��������ܡ�"
            YS.�޿��Զ�.Value=0
        End If
    End Select
End Event
Function ��翨(account,path,settings)
    Dim res
    dim ����:���� = settings
    //����ģʽ�£���������
    if YS.process_mode.Value = 1 Then
        ���� = jiejieka_settings()
    End If


    For Each v In ����
        TracePrint v
    Next
    ��翨=""
    res = Lib.YYS_������.��繦��(path, "��翨", ����)
    Select Case res
    Case "���"
        //��ȴ7Сʱ
        TracePrint "�����ý�翨����ȴ7Сʱ"
        ��翨 = Lib.YYS.������ȴ(Lib.CPS.��Χ���(420, 20))

    Case "��ʹ��"
        //��ȴ1Сʱ
        TracePrint "��翨�Ѵ��ڣ�1Сʱ���ټ��"
        ��翨 = Lib.YYS.������ȴ(Lib.CPS.��Χ���(60, 10))
    End Select

    call Lib.YYS_�쳣����.go_home(path)
End Function

//@48�����
Function huodong_settings()
	Dim �����
    Dim ����� : ����� = ��ȡ����(YS.�����.list, YS.�����.ListIndex)

    Dim �����
    If YS.�����.Text = "������" or YS.�����.Text = "" Then
        �����=0
    elseIf cint(YS.�����.Text) > 0 Then
        ����� = YS.�����.Text
    Else
        �����=0
    End If

    Dim �ʱ��
    If YS.�ʱ��.Text = "������" or YS.�ʱ��.Text = "" Then
        �ʱ��=0
    elseIf cint(YS.�ʱ��.Text) > 0 Then
        �ʱ�� = YS.�ʱ��.Text
    Else
        �ʱ��=0
    End If

    Dim ����� : ����� = ��ȡ����(YS.�����.list, YS.�����.ListIndex)
    Dim �����Ѷ� : �����Ѷ� = ��ȡ����(YS.�����Ѷ�.list, YS.�����Ѷ�.ListIndex)
    Dim �Ƿ���� : �Ƿ���� = ��ȡ����(YS.�Ƿ����.list, YS.�Ƿ����.ListIndex)

    huodong_settings = split(����� & "-" & ����� & "-" & �ʱ�� & "-" & ����� & "-�����ȼ�" & �����Ѷ�& "-" & �Ƿ����, "-")
End Function

//settings(0) ս������
//settings(1) ����ƴ���
//settings(2) �ʱ��
//settings(3) �����
//settings(4) �����Ѷ�
//settings(5) �Ƿ����
Function �����(account, path, settings)
    Dim res
    Dim huodong_count : huodong_count = 0
    Dim ���� : ���� = settings
    Dim ���ȴ
    Dim exit_flag:exit_flag=0

	TracePrint "����ã�"
	For Each e In ����
		TracePrint e
	Next
    While 1
        //����ģʽ�£���������
        if YS.process_mode.Value = 1 Then
            ���� = huodong_settings()
        End If

		If cint(����(2)) > 0 Then
			���ȴ = cint(����(2))
		Else
			���ȴ = 40
		End If

        res = Lib.YYS_�.fuben_huodong(path,����)
        TracePrint "�����,�ⲿ�����" & res

        //�������������
        If res = "ս������" or res = "ʤ��" or res = "ʧ��" or res = "����" Then
            huodong_count = huodong_count + 1
            TracePrint "���趨��ս������:" & ����(4)
            TracePrint "ս����������ǰ����:" & huodong_count
            Call log(account & "�����:[" & huodong_count & "]")
            If cint(����(1)) > 0 Then
                If huodong_count >= cint(����(1)) Then
                    ����� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(���ȴ, 10))
                    exit_flag = 1
                End If
            End If

        ElseIf res = "����Ϊ��" Then
            ����� = "���"
            exit_flag = 1

        End If

        If exit_flag = 1 Then
            Delay 4000
            Call Lib.YYS_�쳣����.go_home(path)
            ����� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(���ȴ, 10))
            Exit function
        End If
    Wend

End Function

//@49ҵԭ��
Function chi_settings()
    Dim chi_flag : chi_flag = YS.ҵԭ��.Value
    Dim chi_type : chi_type = YS.chi_type.listindex + 1
    Dim chi_zhenrong : chi_zhenrong = YS.chi_zhenrong.listindex
    Dim ��ս���� : ��ս���� = YS.chi_count.listindex * 10
    Dim ��Ϣ��� : ��Ϣ��� = YS.chi_each_count.listindex * 10

    chi_settings = split(chi_flag & "-" & chi_type & "-" & chi_zherong & "-" & ��ս����& "-" &��Ϣ���, "-")
End Function
Function ҵԭ��(account, path, settings)
    Dim ����:����=chi_settings()
    Dim res, ret
    Dim currt_count:currt_count=0
    Dim exit_flag : exit_flag = 0
    Dim ��Ϣ���

    While 1
        //����ģʽ�£���������
        if YS.process_mode.Value = 1 Then
            ����=chi_settings()
        End If

        res = Lib.YYS_ҵԭ��.chi_mode(path, ����(1), ����(2), "")
        TracePrint "----++++�ⲿ���-ҵԭ��" & res
        If res <> "" Then
            If res = "ʤ��" or res = "ʧ��" or res = "����" Then
                currt_count=currt_count+1
                TracePrint "ս����������¼����" & currt_count
            ElseIf res = "ҵԭ��Ϊ��" Then
                ҵԭ�� = "���"
                exit_flag = 1
            End If
        End If

        If ����(4) <> 0 Then
            ��Ϣ��� = cint(Lib.CPS.��Χ���(����(4), 3))
            TracePrint "ҵԭ����Ϣ�����" & ��Ϣ���
            If currt_count >= ��Ϣ��� Then
                TracePrint "�ѳ����趨�Ĵ���������������"
                call log("ҵԭ���ѳ����趨�Ĵ���������������")
                ҵԭ�� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(3, 3))
                exit_flag=1
            End If
        End If

        If ����(3) <> 0 Then
            TracePrint "ҵԭ����ս������" & ����(3)
            If currt_count >= cint(����(3)) Then
                TracePrint "�ѳ����趨�Ĵ���������������"
                call log("ҵԭ���ѳ����趨�Ĵ���������������")
                ҵԭ�� = "���"
                exit_flag=1
            End If
        End If

        If exit_flag = 1 Then
            Call Lib.YYS_�쳣����.go_home(path)
            Exit function
        End If
    Wend

End Function

//@50����Эս
Function ����Эս(account, path, settings)
    Dim res, ret
    Dim count:count=0
    Dim exit_flag : exit_flag = 0

    Dim run_flag:run_flag=1
    //    While run_flag
    //        res = Lib.YYS_����ģʽ.����ģʽ(path, "����", "", "������", "", 1, "", "", "", "�����|�����|�����", "")
    //        TracePrint "+++++++++++���ѽ����" & res
    //        If res = "����" Then
    //        	jutxing
    //        End If
    //        Delay 1000
    //    Wend

    dim ����:����=3
    While 1

        res = Lib.YYS_ҵԭ��.chi_mode(path, ����, "", "ˢЭս")
        TracePrint "----++++�ⲿ���-ˢЭս��" & res
        If res <> "" Then
            If res = "����ƴ�" Then
                currt_count=currt_count+1
                TracePrint "+++++++++++++��¼����" & currt_count &"+++++++++++++"
                If currt_count >= 18 Then
                    exit_flag = 1
                    ����Эս = "���"
                End If
            ElseIf res = "ҵԭ��Ϊ��" Then
                ����Эս = "���"
                TracePrint "ҵԭ��Ϊ��"
                exit_flag = 1
            End If
        End If

        If exit_flag = 1 Then
            call Lib.YYS_�쳣����.go_home(path)
            Exit function
        End If
    Wend
End Function

//@51����
Function qilin_settings()
    Dim qilin_flag : qilin_flag = YS.����.Value
    //��ʱ����
    Dim qilin_time
    Select Case qilin_time
    Case 0
        qilin_time="����ʱ"
    Case 1
        qilin_time = Lib.CPS.create_datetime(��ȡ����(YS.qilin_h.List, YS.qilin_h.ListIndex), ��ȡ����(YS.qilin_m.List, YS.qilin_h.ListIndex))
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
Function ����(account, path, settings)
    //��ĩ�ж�
    Dim currt_day :currt_day=Weekday(now())
    If currt_day = 1 or currt_day >= 6 Then
        //��ĩ����ִ�к���
        ����ս = "���"
        Exit function
    End If

    //ʱ����ж�
    Dim currt_hour : currt_hour = hour(now())
    If currt_hour < 19 Then
        ����ս = Lib.CPS.create_datetime(19,01)
        Exit function
    elseif currt_hour >20 Then
        ����ս = "���"
        Exit function
    End If

    Dim res, exit_flag
    Dim ����:���� = qilin_settings()
    For 240
        //����ģʽ�£���������
        if YS.process_mode.Value = 1 Then
            ���� = qilin_settings()
        End If

        //��ʱ�ж�
        If ����(1) <> "����ʱ" Then
            res = Lib.YYS.��ȴ���(����(1))
            If res <> "���" Then
                TracePrint "ʱ��δ������ʣ" & res & "���ӡ�"
                ����ս=����(1)
                Exit function
            End If
        End If

        res = Lib.YYS_ÿ������.����ս(path)
        TracePrint "�����ⲿ�����" & res
        Select Case res
        Case "δ����"
            ���� = Lib.YYS.������ȴ(4)
            exit_flag = 1

        Case "���"
            ���� = "���"
            exit_flag = 1

        End Select

        If exit_flag = 1 Then
            call Lib.YYS_�쳣����.go_home(path)
            Exit function
        End If
    Next
    ���� = Lib.YYS.������ȴ(4)
    call Lib.YYS_�쳣����.go_home(path)
End Function

//@52��ͼ����
Function ��ͼ����(account, path, ��������)
    Dim res,exit_flag:exit_flag=0
    ��ͼ���� = Lib.YYS_��ʱ����.��ͼ����(path)
    Select Case ��ͼ����
    Case "δ��ȡ"
        ��ͼ���� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(25, 5))
        exit_flag = 1
    Case "��ȡ�ɹ�"
        ��ͼ���� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(120, 5))
        exit_flag = 1
    End Select

    If exit_flag = 1 Then
        Call Lib.YYS_�쳣����.go_home(path)
    End If
End Function

//@53LBS����
function LBS����(account, ��ͼ·��, ����)
    LBS���� = ""
    dim res

    if YS.process_mode.Value = 1 Then
        ���� = liandong_settings()
    End If

    res = Lib.YYS_��ʱ����.LBS����(��ͼ·��,"",settings)
    Select Case res
    Case "���"
        LBS���� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(120, 10))

    Case "ʧ��"
        LBS���� = Lib.YYS.������ȴ(Lib.CPS.��Χ���(30, 10))
    End Select

    Call Lib.YYS_�쳣����.go_home(��ͼ·��)
End Function
//=====================================@4 �����¼�==========================================
//���ѡ��
Event YS.menber_mode.SelectChange
    //    YS.mode_settings.tab = 2
    Select Case YS.menber_mode.ListIndex
    Case 0
        YS.��������.Enabled = 1
    Case 1
        YS.��������.Enabled = 1
        YS.��Ա�ӳ�.listindex = 0
    Case 2
        YS.��������.Enabled = 0
        YS.��������.Value = 0
        YS.��Ա�ӳ�.listindex = 1
    End Select
    TracePrint "���ѡ��"& ��ȡ����(YS.menber_mode.list, YS.menber_mode.ListIndex)
End Event

//����ģʽ
Event YS.����ģʽ.Click
    test_mode = YS.����ģʽ.Value
    YS.��ʾ����.Value=YS.����ģʽ.Value
End Event

//��ͼ�ļ���
Event YS.set_path.Click
    RunApp pics_path
End Event

//�ͻ���ģʽ-�Զ�ʶ��
Event YS.auto_check1.Click
    If YS.auto_check1.Value = 1 Then
        YS.game_type.Enabled = 0
    ElseIf YS.auto_check1.Value = 0 Then
        YS.game_type.Enabled = 1
    End If
End Event

//������ý���
Event YS.auto_path.Click
    If YS.auto_path.Value = 1 Then
        YS.����Ŀ¼.Enabled = 0
        default_path = Plugin.Sys.GetDir(3)
        setting_path = Plugin.Sys.GetDir(0) & "\ini"
        YS.����Ŀ¼.path = default_path
    Else
        YS.����Ŀ¼.Enabled = 1
        YS.����Ŀ¼.path = "ָ��������Ŀ¼"
    End If
End Event

//��ʱ�ػ�����
Event YS.shutdown_flag.Click
    Dim h : h = ��ȡ����(YS.shutdown_h.List, YS.shutdown_h.Listindex)
    Dim n : n = ��ȡ����(YS.shutdown_n.List, YS.shutdown_n.Listindex)
    Select Case YS.shutdown_flag.Value
    Case 0
        Call Lib.CPS.��ʱ�ػ�("ȡ��",h,n)
    Case 1
        Call Lib.CPS.��ʱ�ػ�("�ػ�",h,n)
    End Select
End Event

//ģʽѡ��
Event YS.select_mode.SelectChange
    currt_mode = ��ȡ����(YS.select_mode.list, YS.select_mode.listindex)
    YS.mode_settings.Tab = YS.select_mode.ListIndex
    TracePrint "ģʽѡ��" & currt_mode
    YS.�һ�����.tab=0
End Event

//������ť
Event YS.��������.Click
    TracePrint YS.��������.Value
    If YS.��������.Value = 1 Then
        liandong_mode = 1
        liandong_flag = 1
        liandong_check = ��ȡ����(YS.����ˢ��.list, YS.����ˢ��.listindex)
        TracePrint "��������������"
    Else
        liandong_mode = 0
        liandong_flag = 0
        TracePrint "�����������ر�"
    End If
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 0
End Event

//����ƥ��ģʽ
Event YS.����ˢ��.SelectChange
    liandong_check = ��ȡ����(YS.����ˢ��.list, YS.����ˢ��.listindex)
    TracePrint "����ƥ��ģʽ���ģ�"&liandong_check
End Event
Event YS.����ˢ��.SelectChange
    nianshou_check = ��ȡ����(YS.����ˢ��.list, YS.����ˢ��.listindex)
    TracePrint "����ƥ��ģʽ���ģ�"&nianshou_check
End Event
Event YS.ʯ��ˢ��.SelectChange
    shiju_check = ��ȡ����(YS.ʯ��ˢ��.list, YS.ʯ��ˢ��.listindex)
    TracePrint "ʯ��ƥ��ģʽ���ģ�"&shiju_check
End Event

//�ֶ���ѡ���Ե�����
Event YS.���Ѻ���.Click
    Call �Ե�������()
End Event
Event YS.��羭��.Click
    Call �Ե�������()
End Event
Event YS.������Ƭ.Click
    Call �Ե�������()
End Event
Event YS.�Ե�����.Click
    Call �Ե�������()
End Event
Event YS.�Ե�̽��.Click
    Call �Ե�������()
End Event
Event YS.�Ե�����.Click
    Call �Ե�������()
End Event
Event YS.�Ե�����.Click
    Call �Ե�������()
End Event
Event YS.�Ե�ͻ��.Click
    Call �Ե�������()
End Event
Event YS.������Ƭ��.SelectChange
    Call �Ե�������()
End Event
Event YS.�Ե�������.SelectChange
    Call �Ե�������()
End Event
Event YS.�Ե�̽����.SelectChange
    Call �Ե�������()
End Event
Event YS.�Ե�������.SelectChange
    Call �Ե�������()
End Event
Event YS.�Ե�������.SelectChange
    Call �Ե�������()
End Event
Event YS.�Ե�ͻ����.SelectChange
    Call �Ե�������()
End Event
//�Զ�ѡ���Ե�����
Event YS.����ѡ��.Click
    If YS.����ѡ��.Value = 1 Then
        YS.���Ѻ���.Value=1
        YS.��羭��.Value=0
        YS.������Ƭ.Value=0
        YS.�Ե�����.Value=0
        YS.�Ե�̽��.Value=0
        YS.�Ե�����.Value=1
        YS.�Ե�����.Value=1
        YS.�Ե�ͻ��.Value = 0
        YS.�Ե�������.ListIndex=16
        YS.�Ե�������.ListIndex = 12
    Else
        YS.���Ѻ���.Value=0
        YS.��羭��.Value=0
        YS.������Ƭ.Value=0
        YS.�Ե�����.Value=0
        YS.�Ե�̽��.Value=0
        YS.�Ե�����.Value=0
        YS.�Ե�����.Value=0
        YS.�Ե�ͻ��.Value = 0
        YS.������Ƭ��.ListIndex=0
        YS.�Ե�������.ListIndex=0
        YS.�Ե�̽����.ListIndex=0
        YS.�Ե�������.ListIndex=0
        YS.�Ե�������.ListIndex=0
        YS.�Ե�ͻ����.ListIndex=0
    End If
End Event
Event YS.�Ե����.Click
    If YS.�Ե����.Value = 1 Then
        YS.�һ�����.tab = 2
    End If
End Event

Event YS.����.Click
    YS.����ҳ.tab=1
    YS.�һ���ϸ.Tab = 2
End Event
//=====================================@5 �࿪���==========================================
Dimenv ������� //��������ʱ��Ľ�������
Dimenv all_hwnds//��¼��ǰ�Ѵ��ڵľ��
Dimenv all_state//��¼��Ӧ�����������߳�id num-xxx-id,num-xxx-id,num-xxx-id,num-xxx
Dimenv stop_id : stop_id = 0

//-+-+-+-+-+-+-+-+--+-+-+-�࿪��������-+-+-+-+-+-+-+-+--+-+-+-
//����int, 1�ɹ���0ʧ��
//��ʼ�� all_hwnds
//��ʼ�� all_state
Function init_hwnds(title)
    Dim i,tmp_arr
    all_hwnds = Lib.YYS.get_hwnds(title)
    If all_hwnds <> "" Then
        TracePrint "����get_hwnd��" & all_hwnds & title

        //���ݵ�ǰ���ڳ�ʼ������״̬
        tmp_arr=split(all_hwnds, ",")
        all_state = all_hwnds
        i = 1
        For Each w In tmp_arr
            TracePrint "��ʼ�����ڣ�"&w
            all_state = Replace(all_state, w, "�˺�"& i & "-" & w & "-δ����"& "-0")
            i = i + 1
        Next
        all_state = Replace(all_state, ",", "|")

        //��������
        YS.�˺��б�.list = "---�˺��б�---(" & UBound(tmp_arr)+1 &")|"& all_state
        init_hwnds = 1
    Else
        init_hwnds = 0
    End If
End Function

//��鵱ǰ����Ƿ��б䶯
//���µ�ǰ�Ĵ��ںͶ�Ӧ�Ĵ���״̬
Function check_hwnd(title)
    TracePrint "����check_hwnd"
    If title = "" Then
        title=game_type
    End If

    //��ȡ���´���
    new_hwnds = Lib.YYS.get_hwnds(title)
    If all_hwnds <> "" and new_hwnds = "" Then
        //�رն���Ĵ���
        TracePrint "�رն���Ĵ���"
    elseIf new_hwnds = "" and all_hwnds="" Then
        //��ǰ�޴���
        Exit Function
    ElseIf new_hwnds <> "" and all_hwnds = "" Then
        //��Ҫ���³�ʼ��
        Call init_hwnds(game_type)
    End If

    //�ж��Ƿ�������
    Dim tmp_arr : tmp_arr = split(new_hwnds, ",")
    currt_hwnds = all_hwnds
    If currt_hwnds <> "" Then
        For Each e_w In tmp_arr
            //            TracePrint e_w & "����� " & instr(currt_hwnds,e_w)
            //���������һ�����ڵ�ǰ�б���ʾ����������
            If instr(currt_hwnds,e_w) = 0 Then
                //�����´��ڣ����»�������
                Call add_hwnd(e_w)
            End If
        Next
    End If

    //�ж��Ƿ��м���
    currt_hwnds = all_hwnds
    If currt_hwnds <> "" Then
        tmp_arr = split(currt_hwnds, ",")
        For Each e_w In tmp_arr
            If instr(new_hwnds,e_w) = 0 Then
                //�����Ѷ�ʧ�Ĵ��ڣ�����ɾ��
                TracePrint "�����Ѷ�ʧ�Ĵ��ڣ�����ɾ��"
                Call del_hwnd(e_w)
            End If
        Next
    End If
    Call �����˺��б�()
    //����������ť
    TracePrint "����check_hwnd"
End Function


//���һ���´���
Sub add_hwnd(hwnd)
    TracePrint "��ʼִ�У�add_hwnd"

    //����¾��
    all_hwnds = all_hwnds & "," & hwnd

    //�����״̬
    Dim old_id,new_id,tam_arr
    old_id = split(all_state, "|")
    old_id = split(old_id(UBound(old_id)), "-")(0)
    old_id = cint(Replace(old_id, "�˺�", ""))
    new_id = old_id+1
    tam_arr = split(all_state, "|")
    all_state = all_state & "|" & "�˺�" & new_id & "-" & hwnd & "-δ����-0"
    all_state = Lib.CPS.strip(all_state, "|")
    TracePrint "����ִ�У�add_hwnd"
End Sub

//ɾ��һ������
Sub del_hwnd(hwnd)
    Dim res
    TracePrint "��ʼִ�У�del_hwnd��" & hwnd

    //��ֹͣ���߳�
    res = get_hwnd(hwnd, "����״̬")
    If res = "������" Then
        Call stop_sel(hwnd)
        TracePrint "����Ŀ�괰��" & hwnd
    End If

    //���´�����Ϣ
    all_hwnds = Replace(all_hwnds, hwnd, "")
    all_hwnds = Replace(all_hwnds, ",,", ",")
    all_hwnds = Lib.CPS.strip(all_hwnds, ",")

    //����״̬��Ϣ
    For Each tar_w In split(all_state, "|")
        If instr(tar_w, hwnd) > 0 Then
            all_state = Replace(all_state, tar_w, "")
            all_state = Replace(all_state, "||", "|")
            all_state = Lib.CPS.strip(all_state, "|")
            Exit for
        End If
    Next

    TracePrint "����ִ�У�del_hwnd"
End Sub

//���´��ھ��״̬���߳���Ϣ
//��ѯ��Ӧ����/�߳�/�˺ŵȵĶ�Ӧ״̬
Sub change_hwnd(hwnd, ����״̬, �߳�)
    TracePrint "--------------+++change_hwnd--------------+++"
    If hwnd = "" Then
        TracePrint "���鴰�ھ��"
        Exit Sub
    End If
    If ����״̬ = "δ����" Then
        �߳�=0
    End If

    Dim tmp_arr,ret,res
    If all_hwnds <> "" and all_state <> "" Then
        //����
        If instr(all_state, hwnd)>0 Then
            //������ڣ�����и���
            tmp_arr = split(all_state, "|")
            For Each e_state In tmp_arr
                //��λ��Ӧ����
                If instr(e_state, hwnd) > 0 Then
                    ret = split(e_state, "-")
                    TracePrint "ԭ����״̬��" & e_state
                    //���´���״̬
                    If ״̬ <> ����״̬ Then
                        new_st = ret(0) & "-" & ret(1) & "-" & ����״̬ & "-" & �߳�
                        TracePrint "���´���״̬��" & new_st
                        all_state = Replace(all_state, e_state, new_st)
                    End If
                End If
            Next
            //�����˺��б�
            Call �����˺��б�()

        End If
    End If
    TracePrint "--------------+++change_hwnd--------------+++"
End Sub

//��ѯһ������ĵ�ǰ״̬,�̣߳��˺���Ϣ��
//tar �����Ǿ�����̣߳��˺�id
Function get_hwnd(tar, state)
    TracePrint "-----------------����get_hwnd---------------"
    TracePrint "tar��" & tar
    TracePrint "state��" & state
    If vartype(tar) < 1 Then
        get_hwnd = ""
        TracePrint "tarĿ�겻�Ϸ����˳�����"
        Exit function
    End If

    If tar <> "" Then
        If instr(tar, "�˺�") > 0 Then
            tar = tar & "-"
        Else
            tar = "-" & tar
        End If
    Else
        TracePrint "tarΪ�գ����鴰�ڡ�"
        get_hwnd = ""
        Exit function
    End If

    Dim res, ret,e_w
    If all_hwnds <> "" and all_state <> "" Then
        Select Case state
        Case "����״̬"
            res=2
        Case "�߳�"
            res=3
        Case "�˺�"
            res=0
        Case ""
            //Ĭ�ϲ�ѯ����״̬
            res=2
        End Select

        For Each e_w In split(all_state, "|")
            //            TracePrint "���Ҷ���e_w��" & e_w
            //            TracePrint "����Ŀ��tar��" & tar
            If instr(e_w, tar) > 0 Then
                //��λ��ǰ���
                ret = split(e_w, "-")
                get_hwnd = ret(res)
                Exit function
            End If
        Next
        TracePrint "û�в�ѯ����[" & tar & "]��" & state & "��Ϣ��"
        get_hwnd=""
    Else
        get_hwnd=""
    End If
    TracePrint "-----------------����get_hwnd---------------"
End Function

//������ť��״̬����ɫ
Sub ������ť(flag)
    If flag = "" Then
        If YS.�˺��б�.ListIndex <= 0 Then
            //���ѡ����Ǳ��⣬����ʾ��ʾ
            flag="��ѡ���˺�"
        Else
            flag = ��ȡ����(YS.�˺��б�.list, YS.�˺��б�.ListIndex)
            flag = split(flag, "-")(2)
        End If
    End If

    Select case flag
    Case "������"
        YS.������ť.BackColor = "3B2FE5"
        YS.������ť.NormalColor ="4539EF"
        YS.������ť.OverColor ="4543F4"
        YS.������ť.DownColor="3125DB"
        YS.������ť.Caption = "ͣ  ֹ"

    Case "δ����"
        YS.������ť.BackColor = "5EAB25"
        YS.������ť.NormalColor ="68B62F"
        YS.������ť.OverColor ="68BF34"
        YS.������ť.DownColor="54A11B"
        YS.������ť.Caption = "��  ��"

    Case "�쳣"
        YS.������ť.Caption = "��  ��"
        YS.������ť.BackColor = "C0C0C0"

    Case "��ѡ���˺�"
        YS.������ť.Caption = "�� ѡ ��"
        YS.������ť.BackColor = "C0C0C0"

    Case "δ����"
        YS.������ť.Caption = "δ������Ϸ����"
        YS.������ť.BackColor = "C0C0C0"

    Case else
        YS.������ť.Caption = "��"
        YS.������ť.BackColor = "C0C0C0"
    End Select
End Sub

Function �����()
    Dim flag
    If YS.�˺��б�.ListIndex > 0 Then
        flag = ��ȡ����(YS.�˺��б�.list, YS.�˺��б�.ListIndex)
        flag = split(flag, "-")(1)
        ����� = Plugin.lw.SetWindowState(flag, 8)
        If ����� Then
            TracePrint "�ö��ɹ�" & flag
            Delay 500
            Call Plugin.lw.SetWindowState(flag, 9)
        Else
            TracePrint "�ö�ʧ��" & flag
        End If
    End If
End function

Sub ִ������()
    Dim res,ret
    TracePrint "********************��ʼִ������***************"
    If all_hwnds <> "" and all_state <> "" Then
        TracePrint "all_hwnds��"&all_hwnds
        TracePrint "all_state��"&all_state
        res = split(all_hwnds, ",")
        ret = split(all_state, "|")
        If UBound(res) = UBound(ret) Then
            //������֤û����
            For Each each_w In res
                ret = get_hwnd(each_w, "����״̬")
                If ret = "δ����" Then
                    TracePrint "��ǰִ�У�" & each_w
                    Call �����ű�(each_w)
                    Delay 500
                End If
            Next
        End If
    End If
    TracePrint "********************����ִ������***************"
End Sub

//��֤�б���º��ѡ��ͬһ��λ��
Sub �����˺��б�()
    Dim res
    res = YS.�˺��б�.ListIndex
    YS.�˺��б�.list = "---�˺��б�---(" & UBound(split(all_hwnds, ",")) + 1 & ")|" & all_state
    If YS.�˺��б�.ListCount > 1 Then
        YS.�˺��б�.ListIndex = res
    End If
End Sub

Sub ����ͷ��()
    Dim res,�����˺�,tmp
    If YS.�˺��б�.ListIndex > 0 Then
        //��ȡ��ǰ��ѡ��Ŀ��
        res = ��ȡ����(YS.�˺��б�.list, YS.�˺��б�.ListIndex)
        �����˺� = split(res,"_")(0)
        tmp = Lib.YYS.��ȡ����(path, �����˺�, "�˺�ͷ��")
        If tmp <> "" Then
            YS.ͷ��Ԥ��.Picture = t_path
        Else
            TracePrint "�����հ�ͷ��"
        End If
    End If
End Sub


//��⵱ǰ���ڣ�������ֵ�ǰ���ڶ�ʧ����ֹͣ��Ӧ�߳�
Function ʵʱ��ⴰ��()
    //	TracePrint "ʵʱ��ⴰ�ڿ�ʼ"
    Dim currt_text, currt_hwnd, tmp_arr
    currt_hwnds = Lib.YYS.get_hwnds(game_type)
    //    TracePrint "���´��ھ����" & currt_hwnds
    //    TracePrint "��ǰ���ھ����" & all_hwnds
    If all_hwnds <> "" Then
        tmp_arr = split(all_hwnds, ",")
        For Each e_w In tmp_arr
            If instr(currt_hwnds, e_w) = 0 Then
                TracePrint "���ֶ�ʧ�Ĵ��ڣ�" & e_w
                Call check_hwnd(game_type)
            End If
        Next
    End If
    //    TracePrint "ʵʱ��ⴰ�ڽ���"
End Function


//����ָ���ô����߳�
Sub stop_sel(tar)
    Dim res, ret
    Dim currt_state,currt_id
    //��ȡ��ǰ��ѡ�˺�
    ret = get_hwnd(tar,"����״̬")
    If ret = "������" Then
        res=get_hwnd(tar,"�߳�")
        TracePrint "׼��ֹͣ�̣߳�" & res
        Call StopThread(res)
        Call change_hwnd(tar,"δ����",0)
    End If
    TracePrint "���������ť"
    Call ui_switch(1)
    Call ������ť("")
End Sub

//-+-+-+-+-+-+-+-+--+-+-+-�࿪�����¼�-+-+-+-+-+-+-+-+--+-+-+-
Event YS.������ť.Click
    Select Case YS.��������.Value
    Case 1
        Call ִ������()
    Case 0
        //��ѡ����ѡ������ִ��
        If YS.�˺��б�.ListIndex > 0 Then
            Dim hwnd
            hwnd = ��ȡ����(YS.�˺��б�.list, YS.�˺��б�.ListIndex)
            hwnd = split(hwnd, "-")(1)
            TracePrint "��ѡĿ�괰��Ϊ��" & hwnd
            Call �����ű�(hwnd)
        End If
    End Select

End Event

Event YS.�˺��б�.Click
    //ÿ��ѡ�񣬶�ˢ��������ť
    Call ������ť("")

    Call �����()

    //����ͷ��
    Call ����ͷ��()
End Event

Event YS.�˺��б�.DblClick
    Call �����()
End Event

Event YS.ˢ�´���.Click
    YS.��������.Value = 0
    Call check_hwnd(game_type)
End Event

Sub ui_switch(flag)
    YS.��������.Enabled = flag
    YS.������ť.Enabled = flag
    YS.�˺��б�.Enabled = flag
    YS.��������.Enabled = flag
End Sub
//=====================================@6 ִ������==========================================
//�����ʼ��
Event YS.Load
    Call log("ҳ������")
End Event

//����������ɺ�
Event YS.LoadOver
    YS.mode.Tab=0
    YS.mode_settings.tab = YS.select_mode.ListIndex
    YS.�һ�����.tab = 0
    YS.����ҳ.tab = 0
    YS.currt_ver.Caption = "��ǰ����汾��" & Plugin.lw.ver()
    TracePrint "��ǰ����汾��" & Plugin.lw.ver()
    Call log("�����ʼ����ɡ�")
End Event

Sub main()
    TracePrint "��ʼִ��main----------"
    Dim res, ret

    //�ȴ����߳�ר�ݱ���
    dim ��ǰģʽ:��ǰģʽ = currt_mode
    dim ��ͼ·��:��ͼ·�� = pics_path
    dim ���ھ��:���ھ�� = �������
    Dim ��ǰ�ʺ�:��ǰ�ʺ� = get_hwnd(���ھ��,"�˺�")
    If ��ǰ�ʺ� = "" Then
        TracePrint "�������Ƿ�Ϸ���" & ���ھ��
        Exit Sub
    End If

    //�һ�ģʽ�е�̽��
    If ��ǰģʽ = "̽��ģʽ" and YS.̽��ת�һ�.Value=1 Then
        ��ǰģʽ="�һ�ģʽ"
    End If

    //��ⴰ�ڳߴ�
    res = Lib.CPS.get_windows_size(���ھ��, 854, 480)
    If res <> "����" Then
        TracePrint "Ŀ�괰�ڳߴ磺��" & res & "�����ǲ��ƥ��ĳߴ硾854x480�����������ʧЧ����������Ϸ�ͻ��ˡ�"
    End If

    //��ָ���Ĵ���
    res = Lib.CPS.����󶨴���(���ھ��, 1, 1, 1, 0, 0)
    If res = 1 Then
        //�ж��Ƿ�򿪴�����ʾ
        Call Plugin.lw.SetShowErrorMsg(YS.��ʾ����.Value)

        //����״̬��Ϣ
        Dim currt_id:currt_id = GetThreadID()
        If currt_id > 0 Then
            TracePrint ��ǰ�ʺ�&"�󶨳ɹ���" & ���ھ��
            TracePrint ��ǰ�ʺ�&"ִ��ģʽ��" & ��ǰģʽ
            TracePrint ��ǰ�ʺ� &"���߳�idΪ��" & currt_id
            Call change_hwnd(���ھ��, "������", currt_id)
            Call check_hwnd("")
        Else
            MsgBox "�����߳�ʧ��"
            Exit sub
        End If

        //��¼�����Ϣ
        Dim ��ǰ�����ļ�
        ��ǰ�����ļ� = Lib.YYS.��������(��ͼ·��, ��ǰ�ʺ�)
        If ��ǰ�����ļ�<>"" Then //���������ļ��������ɹ����¼
            Call Lib.YYS.д������(��ͼ·��, ��ǰ�˺�, "�˺�����ʱ��", now())
            Call Lib.YYS.д������(��ͼ·��, ��ǰ�˺�, "�˺�ģʽ", ��ǰģʽ)
            Call Lib.YYS.д������(��ͼ·��, ��ǰ�˺�, "�˺��߳�", currt_id)
            //���������ļ�����
        Else
            Call log(��ǰ�ʺ�&"�����ļ�����ʧ�ܡ���")
            Delay 1500
        End If

        //�ж��Ƿ�ɹ�������1/0
        //��¼��ǰ�˺�ͼ��-���������������
        If YS.��¼ͷ��.Value = 1 Then
            Call Lib.YYS_�쳣����.go_home(��ͼ·��)
            res = Lib.CPS.�ֲ���ͼ(��ͼ·��, "0,0,100,100", ��ǰ�ʺ� & "ͷ��")
            If res <> "" Then
                Call Lib.YYS.д������(��ͼ·��, ��ǰ�˺�, "�˺�ͷ��", res)
            End If
            Call ����ͷ��()

            //��¼ͷ��������

        End If

        //����״̬��ť
        Call ������ť("������")

        //�����ɹ���������ť
        If YS.��������.Value Then
            If ��ǰ�˺� = "�˺�" & (YS.�˺��б�.ListCount - 1) Then
                YS.��������.Value = 0
                Call ui_switch(1)
            End If
        Else
            Call ui_switch(1)
        End If

        //���߳�
        While 1
            //ʵʱ���¹���
            If YS.process_mode.Value Then
                ��ǰģʽ=currt_mode
            End If

            TracePrint ��ǰ�ʺ�&"��ǰģʽ��" & ��ǰģʽ
            Select Case ��ǰģʽ

            Case "�һ�ģʽ"
                Call �һ�ģʽ(��ǰ�ʺ�,��ͼ·��)

            Case "̽��ģʽ"
                Call ̽��ģʽ(��ǰ�ʺ�,��ͼ·��,"")

            Case "���ģʽ"
                Call ���ģʽ(��ǰ�ʺ�,��ͼ·��)

            Case "����ģʽ"
                TracePrint ��ǰģʽ

            Case "���Ĺ���"
                //��ȡ��ǰ��ѡ��
                If YS.���������.Value Then
                    Call Lib.YYS_���Ĺ���.���������(��ͼ·��,settings)
                ElseIf YS.�Զ�����.Value Then
                    Call Lib.YYS_���Ĺ���.��������(��ͼ·��, tar)
                End If

            Case "����ģʽ"
                Call �쳣����()
                Delay 60000

            End Select
        Wend
    End If
    TracePrint "����ִ��main----------"
End Sub

//��ť�������
Function �����ű�(hwnd)
    //���ж����������ǹر�
    TracePrint "***********�����ű�����************"
    TracePrint "����������ť"
    YS.������ť.Enabled = 0
    YS.�˺��б�.Enabled = 0
    Dim res,ret

    //�ȼ�齻������ĵ�ǰ״̬
    res = get_hwnd(hwnd, "")
    TracePrint "�����ű�res��" & res
    Select Case res
    Case "δ����"//�����߳�
        ������� = hwnd
        //�˴�����Ƿ�ִ�в���ģʽ
        If test_mode = 1 Then
            //ִ�в���ģʽ
            ret = BeginThread(test)
        Else
            ret = BeginThread(main)
        End If

        If ret Then
            TracePrint "�ⲿ������������̣߳�" & ret
        End If

    Case "������"//�ر��߳�
        TracePrint "��ǰ���������"
        //�ֶ������߳�
        Call stop_sel(hwnd)

    Case ""
        MsgBox "��Ϸ�����쳣1."
        TracePrint " ��ǰ���״̬��" & �������
        Call ui_switch(1)

    End Select
    TracePrint "***********�����ű�����************"
End Function


//init() �������
Sub init(title)
    TracePrint "��ʼִ��init----------"
    Dim res
    //1��ȡ���Ŀ¼
    //�ֶ�ѡ��
    If YS.auto_path.Value = 0 Then
        res = Lib.CPS.IsFolderExists(YS.����Ŀ¼.path)
        If res=1 Then
            TracePrint "·���Ϸ�"
            setting_path = YS.����Ŀ¼.path
        Else
            TracePrint "·�����Ϸ�,������ʱĿ¼"
            setting_path = Plugin.Sys.GetDir(0)
        End If
    End If

    Call log("�����ļ����Ŀ¼��" & setting_path)

    //2��ѹ��������ʱĿ¼
    If YS.��ʱĿ¼.value = 0 Then
        Call Lib.YYS.release_pics(pics_path, fujian)//�ͷŸ���ͼƬ����ʱĿ¼
        Call Lib.YYS.release_ini(setting_path, "default.ini")
    Else
        TracePrint "������ʱĿ¼"
        If YS.temp_path.path = "" Then
            If Lib.CPS.IsFolderExists("D:\CPS\YYS\YYS\Pictrues\2019\00����") Then
                pics_path = "D:\CPS\YYS\YYS\Pictrues\2019\00����"

            ElseIf Lib.CPS.IsFolderExists("E:\YYS\YYS\Pictrues\2019\00����") Then
                pics_path = "E:\YYS\YYS\Pictrues\2019\00����"

            ElseIf Lib.CPS.IsFolderExists("D:\CPS\MyProject\YYS\Pictrues\2019\00����") Then
                pics_path = "D:\CPS\MyProject\YYS\Pictrues\2019\00����"

            End If
        Else
            pics_path = YS.temp_path.path
        End If
    End If
    If pics_path = "" Then
        MsgBox "û������Ч��Ԫ��Ŀ¼��������"
        Exit Sub
    Else
        Call log("��ǰԪ��Ŀ¼��" & pics_path)
    End If

    //3��ȡini����ȡ�û�ini
    call get_settings()
    res = Lib.CPS.IsFileExists(setting_path & "default.ini")//�ȶ�ȡĬ�������ļ�
    res = Lib.CPS.IsFileExists(setting_path & "config.ini")//����У���ȡ�û������ļ�

    //4�״�ִ�У���⵱ǰ��Ч����
    ret = init_hwnds(title)
    If ret = 1 Then
        Dim run_time : run_time = 0
        TracePrint time() & "��ʼ���ɹ���" & all_state
        Call ui_switch(1)
        While 1
            If run_time mod 100 = 0 Then
                TracePrint time() & "--�ű�ִ����"
            End If

            //ʵʱ����Ӧ�Ĵ����Ƿ����
            Call ʵʱ��ⴰ��()

            If stop_id > 0 Then
                TracePrint "��⵽��Ҫֹͣ���߳�id��" & stop_id
                Call StopThread(stop_id)
                Delay 200
                Call check_hwnd("")
                stop_id =0
            End If

            run_time = run_time + 1
            Delay 100
        Wend
    Else
        TracePrint "��ȡ����ʧ��"
        Call ui_switch(0)
        Call ������ť("δ����")
    End If

    TracePrint "����ִ��init----------"
End Sub


//�����˳�ʱִ�еĺ���
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
            res = get_hwnd(e_w, "����״̬")
            If res = "������" Then
                Call StopThread(get_hwnd(e_w, "�߳�"))
                Call change_hwnd(e_w,"δ����","")
                Delay 200
                Call �����˺��б�()
            End If
        Next

        //�������id�����ȫ��δ������������
        all_hwnds = ""
        all_state = ""
        Call ������ť("")
        Call check_hwnd(game_type)
        Call ui_switch(0)
    End If
End Sub

//==================================================================�����й���======================================


Event YS.�һ�̽��.Click
    YS.̽��ת�һ�.Value = YS.�һ�̽��.Value
    YS.����ͻ��.Value = YS.�һ�̽��.Value
    YS.����ͻ��.Value = YS.�һ�̽��.Value
    YS.���޸���.Value = YS.�һ�̽��.Value
    YS.���Ѽ���.Value = YS.�һ�̽��.Value

End Event

Function liao_invaite_settings()
    Dim func_flag
    func_flag = YS.���������.Value
End Function


Function ������(account, path, settings)
    ������ = Lib.YYS_������.����������(path,tar,settings)
End Function


//���鸱��
Function yuling_settings()
    Dim yuling_zhenrong : yuling_zhenrong = YS.��������.ListIndex
    Dim yuling_type : yuling_type = ��ȡ����(YS.��������.List, YS.��������.ListIndex)
    Dim yuling_level:yuling_level = ��ȡ����(YS.�������.List, YS.�������.ListIndex)

    Dim yuling_count
    If YS.�������1.ListIndex = 0 Then
        yuling_count = 0
    Else
        Select Case YS.�������2.ListIndex
        Case 0//��
            yuling_count = YS.�������1.ListIndex
        Case 1//ʮ
            yuling_count = (YS.�������1.ListIndex + 1) * 10
        Case 2//��
            yuling_count = (YS.�������1.ListIndex + 1) * 100
        Case 3//ǧ
            yuling_count = (YS.�������1.ListIndex + 1) * 1000
        End Select
    End If
    yuling_settings = split(yuling_zhenrong & "-" & yuling_type & "-" & yuling_level & "-" & yuling_count, "-")
End Function

Function ����(account, path, settings)
    Dim res, ret
    Dim ������� : ������� = 0
    Dim exit_flag : exit_flag = 0
    Dim ���� : ���� = settings
    Dim �趨����

    While 1
        //ʵʱ��������
        if YS.process_mode.Value = 1 Then
            ���� = yuling_settings()
        End If
        �趨���� = cint(����(3))

        res = Lib.YYS_ҵԭ��.����(path, ����)
        TracePrint "�����ⲿ�����"&res
        Select Case res
        Case "����ƴ�"
            ������� = ������� + 1
            Call log(account & "��ǰ���������" & �������)
            If �趨���� > 0 and ������� >= �趨���� Then
                //����趨�������˳�
                exit_flag = 1
            End If

        Case "����Ϊ��"
            exit_flag = 1

        Case "���"
            exit_flag = 1

        End Select

        If exit_flag = 1 Then
            Call Lib.YYS_�쳣����.go_home(path)
            ���� = "���"
            Exit function
        End If
    Wend

End Function

//����ģʽ
Sub test()
    Call ui_switch(0)
    Dim path
    Dim hwnd
    hwnd = Lib.CPS.��ȡ���("Find|Win32Window0|����ʦ-������Ϸ")
    If hwnd > 0 Then
        //���Ҵ��ڳɹ������а�
        res = Lib.CPS.����󶨴���(hwnd, 1, 1, 1, 0, 0)
        If res = 0 Then
            //��ʧ��
            MsgBox "��ʧ��"
            Call ui_switch(1)
            Exit Sub
        End If
    End If
    TracePrint "��ʼ����ģʽ��������"
    Call Plugin.lw.SetShowErrorMsg(YS.��ʾ����.Value)
    //�����ɹ���������ť
    Call ui_switch(1)
    path = pics_path
    While 1
        //��������
        //        ret = Lib.YYS_��ʱ����.LBS����(path,settings)
        //        ����ֵ = ��ͼ����(account, path, ��������)
        //		����ֵ = Lib.YYS_̽��ģʽ.��������(path,"���","1|N��|4|1","��Ա")
        //        ����ֵ = Lib.YYS.check_page(Lib.YYS_����.̽��ģʽ(path))

        ret=liandong_settings()
        Call ��������("", path, ret)

        TracePrint "����ģʽ�ⲿ��" & ����ֵ

        Delay 3000
    Wend
End Sub

DimEnv show_log
show_log=0
//������
Call init(game_type)

Event YS.��������.Click
    If YS.��������.Value = 0 Then
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
