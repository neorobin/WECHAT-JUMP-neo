' Author neorobin
' https://github.com/neorobin/WECHAT-JUMP-neo/tree/WECHAT-JUMP-neo-%E5%8D%95%E8%BD%AE%E5%BB%93%E7%8E%AF%E7%AE%80%E6%98%93

' 作者：523066680 / vicyang
'  https://github.com/vicyang/WeChat-JumpGame-Auto
'  2018-01-02
'  v1.21 添加随机因素

Dim PI = 3.1415926, two_PI = 2 * PI

Dim DEBUG_SW = FALSE

Dim DO_PRESS = False ' 调试用, 是否 TOUCH 屏幕的开头




' 视图中心  562.5   979
Dim VIEW_CENT_X = 562.5
Dim VIEW_CENT_Y = 979

Dim target_x, target_y, Target = {"x":0, "y":0}

Delay 1000
Dim x1, y1, x2, y2

Dim screenX, screenY
screenX = GetScreenX()
screenY = GetScreenY()


' 轮廓环坐标极值
dim contour_ring_min = {"x": screenX * 2, "y": screenY * 2}
dim contour_ring_max = {"x": -screenX * 2, "y": -screenY * 2}

Dim bgcolor, iter
Dim top, bottom, centx, centy, dist
Randomize (Time())

'  上一次的 body 坐标, 触屏时间, 初始时间率
Dim prevx, prevy, lastpress, timerate
Dim body
Dim changed

' init timerate
timerate = 1.32

Dim BALL_DIAMETER, BALL_DIAMETER_SQUARE, BALL_RADIUS_SQUARE

' 球直径
BALL_DIAMETER = 80
' 开局红球堆在上下平分线上的 横坐标分布: 604,640,677
' 所以球径 = (677 - 604) / (Sin[60 Degree] * 4) = 73/(2*Sqrt(3))
' BALL_DIAMETER = (677 - 604) / (Sin(PI / 3)* 4)
' BALL_DIAMETER = 73/(2*Sqrt(3))
BALL_DIAMETER_SQUARE = BALL_DIAMETER * BALL_DIAMETER
' 球半径平方
BALL_RADIUS_SQUARE = BALL_DIAMETER * BALL_DIAMETER / 4

' 用于 球圆中心对称色差算法
Dim RADIUS_FULL, RADIUS_45DEG, BALL_SCH_WIDTH, BALL_SCH_LOOP_IND_CENTER

' 用于 球圆中心对称色差算法
RADIUS_FULL = BALL_DIAMETER / 2                                               ' 横向或纵向半径分量
RADIUS_45DEG = RADIUS_FULL / Sqr(2)                                               ' 45 度斜向半径分量
BALL_SCH_WIDTH = BALL_DIAMETER * 3 / 4                                            ' 定位搜索区域宽度
BALL_SCH_LOOP_IND_CENTER = Round((1 + BALL_SCH_WIDTH) / 2)     ' 定位搜索 LOOP 索引值中心值

say "screenX: " & screenX & ", screenY: " & screenY



' Jumper header 半径, Jumper_Height 从头中心到脚的距离
Dim  Jumper_header_rad = 30, Jumper_Height = 159            ' Jumper_Height = 1110-951 = 159

' Jumper header center color H 分量范围: 0.58--0.75 以 0.66 为中心, 半径为 0.09


' v_RGB: The name of the variable in which to store the color ID in hexadecimal blue-green-red (BGR) format.
' For example, the color purple is defined 0x800080 because it has an intensity of 80 for its blue
' and red components but an intensity of 00 for its green component.

Dim HSV = {"H":0,"S":0,"V":0}, v_RGB = &H7A4B52
' 亮点色 B48D96   暗点色 383534   754457   664C3D

' v_RGB = &H7A4B52
' Call RGB2HSV(HSV, v_RGB)
' say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

' v_RGB = &HB48D96
' Call RGB2HSV(HSV, v_RGB)
' say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

' v_RGB = &H383534
' Call RGB2HSV(HSV, v_RGB)
' say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

' v_RGB = &H754457
' Call RGB2HSV(HSV, v_RGB)
' say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

' v_RGB = &H664C3D
' Call RGB2HSV(HSV, v_RGB)
' say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

' v_RGB = &H61EEFF  ' 黄色
' Call RGB2HSV(HSV, v_RGB)
' say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]


Dim jumper_head_outline_x(1000), jumper_head_outline_y(1000)




Dim Jumper_header = {"x":-1, "y":-1}, Jumper_foot = {"x":-1, "y":-1}
' CALL locate_Jumper_header(Jumper_header)
' say "locate_Jumper_header Jumper_header 坐标在" & Jumper_header["x"] & "," & Jumper_header["y"]
' say "Jumper foot 坐标在" & Jumper_header["x"] & "," & (Jumper_header["y"] + Jumper_Height)

Dim Jumper = {"x":-1, "y":-1}
' CALL locate_Jumper(Jumper)
' say "locate_Jumper Jumper foot 坐标在" & Jumper["x"] & "," & Jumper["y"]

Dim hold, foot_x, foot_y

if DEBUG_SW then
    Log.Open
end if

    ' Call locate_Jumper_header_by_cross_chord(Jumper_header)
    ' say "Jumper_header 坐标在" & Jumper_header["x"] & "," & Jumper_header["y"]


    ' foot_x = Jumper_header["x"]
    ' foot_y = (Jumper_header["y"] + Jumper_Height)
    ' say "Jumper foot 坐标在" & foot_x & "," & foot_y


' Dim 返回值
' 返回值=GetTempDir()
' TracePrint "当前设备的临时目录为：" & 返回值


' Log.Open
' TracePrint "日志被开启，这句话会被记录到日志文件中"
' Log.Close
' TracePrint "日志被关闭，这句话不会被记录到日志文件中"


' EndScript



While (False)
    ' CALL locate_Jumper(Jumper)
    ' say "locate_Jumper Jumper foot 坐标在" & Jumper["x"] & "," & Jumper["y"]
    ' Touch Jumper["x"], Jumper["y"], 1


    Call locate_Jumper_header_by_cross_chord(Jumper_header)
    say "Jumper_header 坐标在" & Jumper_header["x"] & "," & Jumper_header["y"]


    foot_x = Jumper_header["x"]
    foot_y = (Jumper_header["y"] + Jumper_Height)
    say "Jumper foot 坐标在" & foot_x & "," & foot_y


    target_x = (VIEW_CENT_X * 2 - Jumper_header["x"])
    target_y = (VIEW_CENT_Y * 2 -  (Jumper_header["y"] + Jumper_Height) )
    say "目标 坐标在" & target_x & "," & target_y



    dist = distance(foot_x, foot_y, target_x, target_y)
    hold = Int(dist * (timerate))
    say "Distance: " & Int(dist) & ", Delay: " & hold

    If DO_PRESS Then
        Touch target_x, target_y, hold
    End If

    ' Touch jumper_head_outline_x(1), jumper_head_outline_y(1), 1
    exit While
Wend


Dim x, y, rColor


' 0..GetScreenX() - 1, 0..GetScreenY() - 1 是屏幕有效范围, 超出范围取色都返回 &H000000
' x = screenX - 1
' y = screenY - 1



' 轮廓算法
' 1. 从内部点搜索到边缘
' 从内部一点一直向右直至搜索到一个外部点, 上一个内部点就是一个轮廓点
' 以此轮郭点为中心, 那个外部点为起始, 顺时针搜索邻点直至搜索到第一个内部点
' 这个内部点作为第2个轮廓点, 以搜索的上一个外部点为起始, 以第2个轮廓点为中心
' 搜索第3个轮廓点
' ...
' 直到再次搜索到第1个轮廓点, 轮廓闭合, 结束


' 找出若干轮廓环, 在每个轮廓环内部做排序, 把环内 y 坐标最小行上 x 坐标最小的点作为环首
' 在两次轮廓截图中匹配轮廓环对比, 将能得到最大匹配度的位移作为结果偏移


' 轮廓环扫描
' 在纵坐标 300--1700 之间 以 50 的间隔水平扫描线自左到右(x 增加)扫描屏幕 (0 -- GetScreenX() - 1)
' 当扫到一个色阶跃时, 在右边的点作为轮廓点



Dim contour_rings_x(10000), contour_rings_y(10000)
Dim contour_rings_pnt = 0   ' 轮廓环操作指针

Dim SCAN_LINE_GAP = 50, SCAN_LINE_MIN_Y = 300, SCAN_LINE_MAX_Y = 1700


Dim ret_val
' Call contour()

call locate_Jumper_foot_by_cross_chord(Jumper_foot)

ret_val = Locate_1st_contour_ring()

if NOT ret_val then
    say "Locate_1st_contour_ring() 失败"
else
    say "Locate_1st_contour_ring() 成功"
    ' call draw_contour_ring(10)                ' 显示轮廓环路径
end if

if Locate_Target(Target) then
    say "Locate_Target(Target) 成功"
    say "Target: " & Target["x"] & "," & Target["y"]
else
    say "Locate_Target(Target) 失败"
end if

while(False)

    ' 搜索 Jumper 的位置

    ' 搜索目标物体的位置

    ' 计算并跳跃

    ' 等待画面稳定
    ' Delay 1000 + Int(Rnd() * 1500)
wend




EndScript


function Locate_Target(Target)
    Dim ret_val
    Locate_Target = False

    ret_val = Locate_1st_contour_ring()
    if ret_val then
        Locate_Target = True

        Target["x"] = (contour_ring_min["x"] + contour_ring_max["x"]) / 2
        Target["y"] = (contour_ring_min["y"] + contour_ring_max["y"]) / 2
    else
        Target["x"] = -99
        Target["y"] = -99
    end if
end function



function locate_Jumper_foot_by_cross_chord(Jumper_foot)
    Call locate_Jumper_header_by_cross_chord(Jumper_foot)
    Jumper_foot["y"] = Jumper_foot["y"] + Jumper_Height
    say "Jumper_foot 坐标在" & Jumper_foot["x"] & "," & Jumper_foot["y"]
end function



' 以此轮郭点为中心, 那个外部点为起始, 顺时针搜索邻点直至搜索到第一个内部点
' 这个内部点作为第2个轮廓点, 以搜索的上一个外部点为起始, 以第2个轮廓点为中心
' 搜索第3个轮廓点
' ...
' 直到再次搜索到第1个轮廓点, 轮廓闭合, 结束
' 第一个轮廓点由 contour_rings_x(contour_rings_pnt), contour_rings_y(contour_rings_pnt) 指出
' contour_rings_x(contour_rings_pnt) - 1, contour_rings_y(contour_rings_pnt) 为第一个外部点
Function search_a_contour_ring()
    Dim cnt_round = 0   ' 轮郭点为中心 顺时针搜索计数, 如果搜索 8 个点后仍无每二个轮廓点出现, 则是一个单轮廓点环
    Dim pos = {"x":-1, "y":-1}, center = {"x":-1, "y":-1}, test_pos = {"x":-1, "y":-1}, last_test_pos = {"x":-1, "y":-1}
    Dim HSV = {"H":0,"S":0,"V":0}, last_HSV = {"H":0,"S":0,"V":0}, path_HSV = {"H":0,"S":0,"V":0}
    Dim is_new_contour_pointer

    search_a_contour_ring = False

    ' 初始化轮廓环极值
    contour_ring_min = {"x": screenX * 2, "y": screenY * 2}
    contour_ring_max = {"x": -screenX * 2, "y": -screenY * 2}

    Call GetPixelHSV(path_HSV, contour_rings_x(contour_rings_pnt), contour_rings_y(contour_rings_pnt))

    test_pos ["x"] = contour_rings_x(contour_rings_pnt) - 1
    test_pos ["y"] = contour_rings_y(contour_rings_pnt)

    While cnt_round <= 8

        ' debug_msg "contour_rings_x(contour_rings_pnt), contour_rings_y(contour_rings_pnt): " & contour_rings_x(contour_rings_pnt) & "," & contour_rings_y(contour_rings_pnt)
        ' debug_msg "test_pos: " & test_pos["x"] & "," & test_pos["y"]
        last_test_pos["x"] = test_pos["x"] :  last_test_pos["y"] = test_pos["y"]
        Call next_pos_clock_wise(test_pos, contour_rings_x(contour_rings_pnt), contour_rings_y(contour_rings_pnt))

        Call GetPixelHSV(HSV, test_pos["x"], test_pos["y"])
        If Not is_HSV_DIFF(HSV, path_HSV) Then
            ' 找到一个新的轮廓点, 检测新的轮廓点是否已在轮廓环中出现
            ' debug_msg "找到轮廓点: " & test_pos["x"] & "," & test_pos["y"]
            ' ShowMessage "找到轮廓点: " & test_pos["x"] & "," & test_pos["y"]

            ' 更新轮廓环极值
            if test_pos["x"] < contour_ring_min["x"] then
                contour_ring_min["x"] = test_pos["x"]
            end if
            if test_pos["y"] < contour_ring_min["y"] then
                contour_ring_min["y"] = test_pos["y"]
            end if
            if test_pos["x"] > contour_ring_max["x"] then
                contour_ring_max["x"] = test_pos["x"]
            end if
            if test_pos["y"] > contour_ring_max["y"] then
                contour_ring_max["y"] = test_pos["y"]
            end if

            is_new_contour_pointer = True
            For j = 0 To contour_rings_pnt - 1
                if contour_rings_x(j) = test_pos["x"] and contour_rings_y(j) = test_pos["y"] then
                    is_new_contour_pointer = False
                    Exit For
                End If
            Next
            If Not is_new_contour_pointer Then
                ' 轮廓环闭环
                debug_msg "轮廓环闭环: " & test_pos["x"] & "," & test_pos["y"]
                ' call draw_contour_ring(10)                ' 显示轮廓环路径
                search_a_contour_ring = True
                Exit Function
            End If

            ' 轮廓环闭环未闭环
            ' 以新轮廓点的色作为新的比对色
            Call copyHSV(HSV, path_HSV)

            ' 保存新的轮廓点到轮廓环上
            contour_rings_pnt = contour_rings_pnt + 1
            contour_rings_x(contour_rings_pnt) = test_pos["x"]
            contour_rings_y(contour_rings_pnt) = test_pos["y"]

            test_pos["x"] = last_test_pos["x"] :  test_pos["y"] = last_test_pos["y"]
            ' 复位顺时针搜索计数
            cnt_round = 0
        Else
            ' 继续搜索, 顺时针搜索计数 + 1
            cnt_round = cnt_round + 1
        End If
    Wend
    If cnt_round > 8 Then
        debug_msg "轮郭点为中心 顺时针搜索计数, 如果搜索 8 个点后仍无每二个轮廓点出现, 则是一个单轮廓点环: " & contour_rings_x(contour_rings_pnt) & "," & contour_rings_y(contour_rings_pnt)
        search_a_contour_ring = True
        Exit Function
    End If
End Function


' 显示轮廓环路径
function draw_contour_ring(gap)
    dim j
    TouchDown contour_rings_x(0), contour_rings_y(0), 1  ' 按住屏幕上的坐标不放，并设置此触点ID=1
    For j = 0 To contour_rings_pnt step gap
        TouchMove contour_rings_x(j), contour_rings_y(j), 1, 0 ' 将ID=1的触点花0毫秒移动至 contour_rings_x(j), contour_rings_y(j)坐标
    Next
    TouchUp 1 ' 松开弹起ID=1的触点
end function


' 顺时针方向 以 center 为中心, pos 为起点的下一个点
Function next_pos_clock_wise(pos, center_x, center_y)
    Dim dx = pos["x"] - center_x, dy = pos["y"] - center_y
    Select Case dy
        Case -1
            Select Case dx
                Case -1         ' 上左 -> 上
                    pos ["x"] = center_x
                    pos ["y"] = center_y - 1
                Case 0         ' 上 -> 上右
                    pos ["x"] = center_x + 1
                    pos ["y"] = center_y - 1
                Case 1         ' 上右 -> 右
                    pos ["x"] = center_x + 1
                    pos ["y"] = center_y
                Case Else
                    say "error @ next_pos_clock_wise 20180122_215614: dx, dy: " & dx & "," & dy
                    pos ["x"] = -99
                    pos ["y"] = -99
                    EndScript
            End Select
        Case 0
            Select Case dx
                Case -1         ' 左 -> 上左
                    pos ["x"] = center_x - 1
                    pos ["y"] = center_y - 1
                Case 1         ' 右 -> 下右
                    pos ["x"] = center_x + 1
                    pos ["y"] = center_y + 1
                Case Else
                    say "error @ next_pos_clock_wise 20180122_215621: dx, dy: " & dx & "," & dy
                    say "error @ next_pos_clock_wise 20180122_215621: center_x, center_x: " & center_x & "," & center_y
                    say "error @ next_pos_clock_wise 20180122_215621: pos: " & pos["x"] & "," & pos["y"]
                    pos ["x"] = -99
                    pos ["y"] = -99
                    EndScript
            End Select
        Case 1
            Select Case dx
                Case -1         ' 下左 -> 左
                    pos ["x"] = center_x - 1
                    pos ["y"] = center_y
                Case 0         ' 下 -> 下左
                    pos ["x"] = center_x - 1
                    pos ["y"] = center_y + 1
                Case 1         ' 下右 -> 下
                    pos ["x"] = center_x
                    pos ["y"] = center_y + 1
                Case Else
                    say "error @ next_pos_clock_wise 20180122_215441: dx, dy: " & dx & "," & dy
                    pos ["x"] = -99
                    pos ["y"] = -99
                    EndScript
            End Select
        Case Else
            say "error @ next_pos_clock_wise 20180122_215149: dx, dy: " & dx & "," & dy
            pos ["x"] = -99
            pos ["y"] = -99
            EndScript
    End Select
End Function

Function contour()
    KeepCapture()
    Dim HSV = {"H":0,"S":0,"V":0}, last_HSV = {"H":0,"S":0,"V":0}
    For y = SCAN_LINE_MIN_Y To SCAN_LINE_MAX_Y Step SCAN_LINE_GAP
        x = 0
        Call GetPixelHSV(last_HSV, x, y)

        For x = 1 To screenX - 1
            Call GetPixelHSV(HSV, x, y)
            If is_HSV_DIFF(HSV, last_HSV) Then
                debug_msg "找到轮廓点 坐标在" & x & "," & y
                contour_rings_x(contour_rings_pnt) = x
                contour_rings_y(contour_rings_pnt) = y
                ' Touch x, y, 1

                Call search_a_contour_ring()

                ReleaseCapture()
                Exit Function
            Else
                copyHSV(HSV, last_HSV)
            End If
        Next
    Next
    ReleaseCapture()
End Function


Function Locate_1st_contour_ring()

    Locate_1st_contour_ring = False
    contour_rings_pnt = 0

    KeepCapture()
    Dim HSV = {"H":0,"S":0,"V":0}, last_HSV = {"H":0,"S":0,"V":0}
    For y = SCAN_LINE_MIN_Y To SCAN_LINE_MAX_Y Step SCAN_LINE_GAP
        x = 0
        Call GetPixelHSV(last_HSV, x, y)

        For x = 1 To screenX - 1
            Call GetPixelHSV(HSV, x, y)
            If is_HSV_DIFF(HSV, last_HSV) Then
                debug_msg "找到轮廓点 坐标在" & x & "," & y
                contour_rings_x(contour_rings_pnt) = x
                contour_rings_y(contour_rings_pnt) = y
                ' Touch x, y, 1

                ' Call search_a_contour_ring()
                Locate_1st_contour_ring = search_a_contour_ring()
                ReleaseCapture()
                Exit Function
            Else
                copyHSV(HSV, last_HSV)
            End If
        Next
    Next
    ReleaseCapture()
End Function







While (False)
    ' 点击屏幕坐标(100,100)的点，并持续按住100毫秒（0.1秒）
    ' Touch x, y, 1

Wend

While (True)
    ' Exit While


    bgcolor = GetPixelColor(100, 360)
    KeepCapture()
    body = findbody()

    If body = 1 Then
        iter = iter + 1
        say "From: " & x1 & "," & y1

        If check_bgcolor_change(bgcolor) = 1 Then
            bgcolor = GetPixelColor(100, 360)
        End If

        KeepCapture()
        top = get_topline(x1)
        If top < 0
            Exit While
        End If
        say "top = " & top

        centx = get_centx(top, x1)
        If centx < 0 Then
            Exit While
        End If
        say "centx = " & centx

        bottom = get_bottomline(centx, top)
        centy = (top + bottom) / 2
        say "bottom = " & bottom

        ' 魔改，如果遇到干扰导致目标点过于接近边界，则y+20
        If (centy - top) < 20 Then
            say "Too close, y + 50"
            centy = top + 50
        End If

        dist = distance(x1, y1, centx, centy)
        say "from: " & x1 & ", " & y1 & " to: " & centx & ", " & centy

        ReleaseCapture()
        SnapShot ("/sdcard/Pictures/autojump_" & iter Mod 5 & ".png")

        lastpress = press(dist)
    Else
        Exit While
    End If

    Delay 1000 + Int(Rnd() * 1500)
    If Int(Rnd() * 5) = 1 Then
        press (2)
        Delay 200
    End If

    If Int(Rnd() * 6) = 0 Then
        say "have a rest"
        Delay 3000 + Int(Rnd() * 3) * 1000
    End If

    TracePrint "Step: " & iter
    TracePrint ""
    prevx = x1
    prevy = y1
Wend




' 把 HSV_src 的值复制给 HSV_dest
' 表变量直接赋值是得到同样的引用, 即两个表引用一同一个数据空间
Function copyHSV(HSV_src, HSV_dest)
    HSV_dest["H"] = HSV_src["H"]
    HSV_dest["S"] = HSV_src["S"]
    HSV_dest["V"] = HSV_src["V"]
End Function


' 获取一点的 HSV 颜色值, 外部引用参数初始化: HSV = {"H":0,"S":0,"V":0}
' GetPixelColor(x, y, 1) 获取一点的 十进制颜色值
Function GetPixelHSV(HSV, x, y)
    Call RGB2HSV(HSV, GetPixelColor(x, y, 1))
End Function

Function is_HSV_DIFF(HSV1, HSV2)
    ' HSV 色差半径阀值
    Dim H_rad = 0.09, V_rad = 5, S_rad = 0.7
    IF ABS(HSV1["H"] - HSV2["H"]) > H_rad OR ABS(HSV1["V"] - HSV2["V"]) > V_rad OR ABS(HSV1["S"] - HSV2["S"]) > V_rad THEN
        is_HSV_DIFF = True
    Else
        is_HSV_DIFF = False
    End If
End Function


Function is_HSV_DIFF_2(HSV1, HSV2)
    ' HSV 色差半径阀值
    Dim H_rad = 0.09, V_rad = 10, S_rad = 0.7
    IF ABS(HSV1["H"] - HSV2["H"]) > H_rad OR ABS(HSV1["V"] - HSV2["V"]) > V_rad OR ABS(HSV1["S"] - HSV2["S"]) > V_rad THEN
        is_HSV_DIFF_2 = True
    Else
        is_HSV_DIFF_2 = False
    End If
End Function





Function locate_Jumper(Jumper)
    Call locate_Jumper_header(Jumper)
    Jumper["y"] = Jumper["y"] + Jumper_Height
End Function








Function locate_Jumper_header(Jumper_header)

    ' Dim H_record = ""

    Dim Jumper_header_cent_X, Jumper_header_cent_Y, x, y, ret_val, sch_x, sch_y, new_Jumper_header_cent_X, new_Jumper_header_cent_Y
    ' Jumper header 半径

    ' Jumper header center color &H7A4B52 = 8014674


    ' Jumper header center color &H7A4B52 = 8014674
    Dim  Jumper_header_center_color = &H7A4B52, Jumper_header_center_color_H_cent = 0.65, Jumper_header_center_color_H_rad = 0.09




    ' i 头圆周分割份数用于取色采样点的个数 直径*4 - 角点总数 == 60*4-18(90度的角点数)*4 = 168
    Dim cnt_part = Round(Jumper_header_rad * two_PI * 1.2)
    ' cnt_part = 168
    ' 找出 i 头的中心位置
    Dim rColor, j, cnt_in_head, cnt_in_head_MAX = 0
    Dim sch_moved

    KeepCapture()

    ret_val = FindColor(0, 0, 0, 0, UCase(Hex(Jumper_header_center_color)), 0, 1, Jumper_header_cent_X, Jumper_header_cent_Y)
    '当需要函数返回值时需要加括号
    If ret_val > -1 Then
        TracePrint "找到的颜色:" & UCase(Hex(Jumper_header_center_color)) & ", 找到的颜色序号为" & ret_val & ",坐标在" & Jumper_header_cent_X & "," & Jumper_header_cent_Y
    Else
        TracePrint "DBP 20180117_031721 全部没找到"
    End If

    Do
        sch_moved = False
        ' 中心向8个方向搜索
        For x = -1 To 1
            For y = -1 To 1
                If Not (x = 0 And y = 0) Then
                    sch_x = Jumper_header_cent_X + x
                    sch_y = Jumper_header_cent_Y + y

                    ' 测试圆周点在 i 头区域计数, 以色调 H 值为判断依据
                    cnt_in_head = 0
                    For j = 0 To cnt_part - 1
                        x = Round(sch_x + Jumper_header_rad * Cos(j * two_PI / cnt_part))
                        y = Round(sch_y + Jumper_header_rad * Sin(j * two_PI / cnt_part))

                        rColor = GetPixelColor(x, y, 1)

                        Call RGB2HSV(HSV, rColor)
                        ' H_record = H_record & ucase(hex(rColor)) & ":" & Round(HSV["H"],2) & ", "

                        ' Jumper header center color H 分量范围: 0.58--0.75 以 0.66 为中心, 半径为 0.09
                        if Abs(HSV["H"] - Jumper_header_center_color_H_cent) <= Jumper_header_center_color_H_rad then
                            cnt_in_head = cnt_in_head + 1
                        End If
                    Next
                    If cnt_in_head > cnt_in_head_MAX Then
                        sch_moved = True
                        cnt_in_head_MAX = cnt_in_head
                        new_Jumper_header_cent_X = sch_x
                        new_Jumper_header_cent_Y = sch_y
                    End If
                End If
            Next
        Next
        If sch_moved Then
           Jumper_header_cent_X = new_Jumper_header_cent_X
           Jumper_header_cent_Y = new_Jumper_header_cent_Y
        Else
           Exit Do
        End If
    Loop While True

    ReleaseCapture()

    ' 因 Jumper_header_rad 是偶数, 而 FindColor 采用的左上到右下, 所以最终结果 x,y 做微调
    Jumper_header ["x"] = Jumper_header_cent_X + 1
    Jumper_header ["y"] = Jumper_header_cent_Y + 9

    ' say H_record

End Function








' 正交十字弦定位法找出 i 头中心
Function locate_Jumper_header_by_cross_chord(Jumper_header)

    ' Jumper header 半径
    ' Dim  Jumper_header_rad = 30
    ' Jumper header center color &H7A4B52 = 8014674
    Dim  Jumper_header_center_color = &H7A4B52, Jumper_header_center_color_H_cent = 0.65, Jumper_header_center_color_H_rad = 0.09

    Dim start_x, start_y, ret_val

    Dim HSV = {"H":0,"S":0,"V":0}, last_HSV = {"H":0,"S":0,"V":0}, path_HSV = {"H":0,"S":0,"V":0}

    KeepCapture()

    ret_val = FindColor(0, 0, 0, 0, UCase(Hex(Jumper_header_center_color)) & "-080808", 0, 1, start_x, start_y)
    '当需要函数返回值时需要加括号
    If ret_val > -1 Then
        TracePrint "找到的颜色:" & UCase(Hex(Jumper_header_center_color)) & ", 找到的颜色序号为" & ret_val & ",坐标在" & start_x & "," & start_y
    Else
        TracePrint "DBP 20180120_002351 全部没找到"
    End If

    Dim x_dir = {"left":-1,"right":1,"up":0,"down":0}
    Dim y_dir = {"left":0,"right":0,"up":-1,"down":1}
    Dim dir = Array("left","right","up","down")
    Dim pos_x = {"left":-1,"right":-1,"up":-1,"down":-1}
    Dim pos_y = {"left":-1,"right":-1,"up":-1,"down":-1}

    For j = 0 To UBound(Dir)
        x = start_x
        y = start_y

        Call GetPixelHSV(last_HSV, x, y)

        Do
            x = x + x_dir[dir(j)]
            y = y + y_dir[dir(j)]
            ' rColor = GetPixelColor(x, y, 1)
            ' Call RGB2HSV(HSV, rColor)

            Call GetPixelHSV(HSV, x, y)
            debug_msg "@ coor: " & x & "," & y & ", H:" & HSV["H"] & ", S:" & HSV["S"] & ", V:" & HSV["V"]

            if Abs(HSV["H"] - Jumper_header_center_color_H_cent) > Jumper_header_center_color_H_rad or is_HSV_DIFF_2(HSV, last_HSV) then
                pos_x [dir(j)] = x
                pos_y [dir(j)] = y

                debug_msg "search 坐标在" & x & "," & y
                Exit Do
            End If

            call copyHSV(HSV, last_HSV)
        Loop While True
    Next
    ReleaseCapture()

    Jumper_header["x"] = (pos_x["left"] + pos_x["right"]) / 2
    Jumper_header["y"] = (pos_y["up"] + pos_y["down"]) / 2
End Function








' Jumper header center color 0x7A4B52 = 8014674

' v_RGB: The name of the variable in which to store the color ID in hexadecimal blue-green-red (BGR) format.
' For example, the color purple is defined 0x800080 because it has an intensity of 80 for its blue
' and red components but an intensity of 00 for its green component.
Function RGB2HSV(HSV, v_RGB)

    Dim var_B, var_G, var_R, var_Min, var_Max, del_Max, del_R, del_G, del_B
    ' var_B = v_RGB >> 16 & 0xFF
    var_B = v_RGB \ (2 ^ 16) Mod 256
    ' var_G = v_RGB >> 8 & 0xFF
    var_G = v_RGB \ (2 ^ 8) Mod 256
    ' var_R = v_RGB & 0xFF
    var_R = v_RGB Mod 256

    ' var_Min = min( var_R, var_G, var_B )    //Min. value of v_RGB
    ' var_Min = var_R < var_G ? var_R : var_G
    If var_R < var_G Then
        var_Min = var_R
    Else
        var_Min = var_G
    End If
    ' var_Min = var_Min < var_B ? var_Min : var_B
    If var_B < var_Min Then
        var_Min = var_B
    End If

    ' var_Max = max( var_R, var_G, var_B )    //Max. value of v_RGB
    ' var_Max = var_R > var_G ? var_R : var_G
    If var_R > var_G Then
        var_Max = var_R
    Else
        var_Max = var_G
    End If
    ' var_Max = var_Max > var_B ? var_Max : var_B
    If var_B > var_Max Then
        var_Max = var_B
    End If

    del_Max = var_Max - var_Min             ' Delta v_RGB value

    HSV ["V"] = var_Max

    If del_Max = 0 Then                     ' This is a gray, no chroma...
       HSV ["H"] = 0
       HSV ["S"] = 0
    Else                                    ' Chromatic data...
        HSV ["S"] = del_Max / var_Max

        del_R = (((var_Max - var_R) / 6) + (del_Max / 2)) / del_Max
        del_G = (((var_Max - var_G) / 6) + (del_Max / 2)) / del_Max
        del_B = (((var_Max - var_B) / 6) + (del_Max / 2)) / del_Max

        If var_R = var_Max Then
            HSV ["H"] = del_B - del_G
        ElseIf var_G = var_Max Then
            HSV ["H"] = (1 / 3) + del_R - del_B
        ElseIf var_B = var_Max Then
            HSV ["H"] = (2 / 3) + del_G - del_R
        End If

        if  HSV["H"] < 0 then
            HSV["H"] = HSV["H"] + 1
        End If
        if HSV["H"] > 1 THEN
            HSV["H"] = HSV["H"] - 1
        End If
    End If
End Function



Function get_topline(body_x)
    Dim execute
    Dim cmp
    Dim color, num
    Dim xleft, xright, halfx, offset, range
    halfx = screenX / 2
    ' 考虑body和block非常接近的情况
    offset = 30

    If body_x > halfx Then
        xleft = 1
        xright = halfx - offset
        ' TracePrint "get_topline: from left side"
    Else
        xleft = halfx + offset
        xright = screenX
        ' TracePrint "get_topline: from right side"
    End If

    range = xright - xleft

    For y = 600 To 1000 Step 10
        color = GetPixelColor(xleft, y)
        ' say "bgcolor: "& color

        num = GetColorNum(xleft, y, xright, y, color, 0.95)

        ' 如果相同颜色的数量比预计像素少 6
        If num < (range - 6) Then
            get_topline = y

            ' 精确扫描
            For yy = (y - 10) To y Step 2
                num = GetColorNum(xleft, yy, xright, yy, color, 0.95)
                If num < (range - 2) Then
                    get_topline = yy
                    Exit For
                End If
            Next
            Exit For
        End If

        ' say "Y: " & y & ", Result: " & cmp
        ' Touch 800, y, 100
        ' Delay 100
    Next

    If cmp = 1 Then
        get_topline = -1
    End If
End Function

Function get_centx(topline, body_x)
    Dim color, cmp, num
    bgcolor = GetPixelColor(5, topline)

    Dim xleft, xright, halfx, xa, xb
    halfx = screenX / 2

    If body_x > halfx Then
        xleft = 1
        xright = halfx
        ' TracePrint "get_cenx: from left side"
    Else
        xleft = halfx + 1
        xright = screenX
        ' TracePrint "get_cenx: from right side"
    End If

    ' 大致区域
    For x = xleft To xright Step 10
        num = GetColorNum(x, topline, x + 9, topline, bgcolor, 0.95)
        If num < 9 Then
            xleft = x - 5
            xright = x + 30
            Exit For
        End If
    Next

    If xleft < 1 Then
        xleft = 1
    End If

    If xright > screenX Then
        xright = screenX
    End If

'   say "top " & topline
'   say "test xleft " & xleft & ", xright:" & xright

    ' 精细搜索
    get_centx = -1
    For x = xleft To xright Step 1
        cmp = CmpColor(x, topline, bgcolor, 0.95)
        ' 不匹配时返回 -1
        If cmp = -1 Then
            xa = x
            Exit For
        End If
    Next

    num = GetColorNum(xleft, topline, xright, topline, bgcolor, 0.95)
    get_centx = xa + Int((xright - xleft + 1 - num) / 2)

End Function

Function get_bottomline(centx, top)
    Dim color, cmp, white, leftcmp, leftw, bgwhite
    color = GetPixelColor(centx, top + 20)
    bgwhite = CmpColor(centx, top + 20, "FFFFFF", 0.95)

    get_bottomline = -1

    For y = top + 20 To top + 500 Step 10
        cmp = CmpColor(centx, y, color, 0.95)
        leftcmp = CmpColor(centx - 20, y, color, 0.95)

        If cmp = -1 Or leftcmp = -1 Then
            white = CmpColor(centx, y, "FFFFFF", 0.9)
            leftw = CmpColor(centx - 20, y, "FFFFFF", 0.9)

            ' 如果不是白色(非圆点)，精确范围
            If white = -1 Then
                get_bottomline = y
                ' 精确搜索
                For yy = (y - 10) To y Step 2
                    cmp = CmpColor(centx, yy, color, 0.95)
                    If cmp = -1 Then
                        get_bottomline = yy
                        Exit For
                    End If
                Next
                ' 结束外部 for
                Exit For
            Else
                ' 如果 block 主要为白色，且偏左的轮廓非白色，直接判定bottom
                If bgwhite > -1 And leftw = -1 Then
                    get_bottomline = y
                    Exit For
                End If
            End If

        End If

    Next

End Function

Function check_bgcolor_change(bgcolor)
    check_bgcolor_change = 0
    While (CmpColor(100, 360, bgcolor, 0.98) = -1)
        say "Color changed"
        Delay 3000
        check_bgcolor_change = 1
        Exit While
    Wend
End Function

Function findbody()
    Dim times = 0
    Dim result = -1

    While (result = -1)
        FindPic 0, 0, 0, 0, "Attachment:body.png", "000000", 3, 0.95, x1, y1
        If x1 > -1 And y1 > -1 Then
            x1 = x1 + 30
            y1 = y1 + 30
            result = 1
        End If

        If times >= 30 Then
            result = 0
        End If

        times = times + 1
        Delay 300
        say "find pic again, times: " & times
    Wend
    findbody = result

End Function

Function press(delta)
    Dim hold, r

    r = 0
    If bottom - top > 50 Then
        r = Rnd() * 0.1 - 0.05
    End If

    hold = Int(delta * (timerate + r))
    say "Distance: " & Int(delta) & ", Delay: " & hold & " rand: " & Left(r, 5)

    If DO_PRESS Then
        Touch centx, centy, hold
        Touch 10, 10, 10
    End If
    press = hold
End Function

Function distance(x1, y1, x2, y2)
    distance = Sqr((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
End Function

Function OnScriptExit()
    Delay 2000
End Function

Sub say(something)
    ShowMessage something
    TracePrint something
End Sub


Sub debug_msg(something)
    if DEBUG_SW then
        ShowMessage something
        TracePrint something
    end if
End Sub



