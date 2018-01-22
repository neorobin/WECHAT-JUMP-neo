' 作者：523066680 / vicyang
'  https://github.com/vicyang/WeChat-JumpGame-Auto
'  2018-01-02
'  v1.21 添加随机因素

Dim PI = 3.1415926, two_PI = 2 * PI

Dim DO_PRESS = true ' 调试用, 是否 TOUCH 屏幕的开头



' 视图中心	562.5	979
DIM VIEW_CENT_X = 562.5
DIM VIEW_CENT_Y = 979

dim target_x, target_y

Delay 1000
Dim x1, y1, x2, y2

Dim screenX, screenY
screenX = GetScreenX()
screenY = GetScreenY()

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
Dim  Jumper_header_rad = 30, Jumper_Height = 159			' Jumper_Height = 1110-951 = 159

' Jumper header center color H 分量范围: 0.58--0.75 以 0.66 为中心, 半径为 0.09


' v_RGB: The name of the variable in which to store the color ID in hexadecimal blue-green-red (BGR) format.
' For example, the color purple is defined 0x800080 because it has an intensity of 80 for its blue
' and red components but an intensity of 00 for its green component.

Dim HSV = {"H":0,"S":0,"V":0}, v_RGB = &H7A4B52
' 亮点色 B48D96   暗点色 383534   754457   664C3D

v_RGB = &H7A4B52
Call RGB2HSV(HSV, v_RGB)
say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

v_RGB = &HB48D96
Call RGB2HSV(HSV, v_RGB)
say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

v_RGB = &H383534
Call RGB2HSV(HSV, v_RGB)
say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

v_RGB = &H754457
Call RGB2HSV(HSV, v_RGB)
say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

v_RGB = &H664C3D
Call RGB2HSV(HSV, v_RGB)
say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]

v_RGB = &H61EEFF  ' 黄色
Call RGB2HSV(HSV, v_RGB)
say UCase(HEX(v_RGB)) & ", H: " &  HSV["H"] & ", S: " &  HSV["S"] & ", V: " &  HSV["V"]


Dim jumper_head_outline_x(1000), jumper_head_outline_y(1000)




Dim Jumper_header = {"x":-1, "y":-1}
' CALL locate_Jumper_header(Jumper_header)
' SAY "locate_Jumper_header Jumper_header 坐标在" & Jumper_header["x"] & "," & Jumper_header["y"]
' SAY "Jumper foot 坐标在" & Jumper_header["x"] & "," & (Jumper_header["y"] + Jumper_Height)

Dim Jumper = {"x":-1, "y":-1}
' CALL locate_Jumper(Jumper)
' SAY "locate_Jumper Jumper foot 坐标在" & Jumper["x"] & "," & Jumper["y"]

dim hold, foot_x, foot_y

While (true)
	' CALL locate_Jumper(Jumper)
	' SAY "locate_Jumper Jumper foot 坐标在" & Jumper["x"] & "," & Jumper["y"]
    ' Touch Jumper["x"], Jumper["y"], 1


    call locate_Jumper_header_by_cross_chord(Jumper_header)
	SAY "Jumper_header 坐标在" & Jumper_header["x"] & "," & Jumper_header["y"]


    foot_x = Jumper_header["x"]
    foot_y = (Jumper_header["y"] + Jumper_Height)
	SAY "Jumper foot 坐标在" & foot_x & "," & foot_y


    target_x = (VIEW_CENT_X * 2 - Jumper_header["x"])
    target_y = (VIEW_CENT_Y * 2 -  (Jumper_header["y"] + Jumper_Height) )
	SAY "目标 坐标在" & target_x & "," & target_y



    dist = distance(foot_x, foot_y, target_x, target_y)
    hold = Int(dist * (timerate ))
    say "Distance: " & Int(dist) & ", Delay: " & hold

    if DO_PRESS then
        Touch target_x, target_y, hold
    end if

    ' Touch jumper_head_outline_x(1), jumper_head_outline_y(1), 1
    exit While
Wend
EndScript

Dim  x, y, rColor

x = 336
y = 952

rColor = GetPixelColor(x, y, 0)

TracePrint "这个点的颜色为：" & rColor
rColor = GetPixelColor(x, y, 1)
TracePrint "这个点的颜色为：" & rColor

While (False)
//点击屏幕坐标(100,100)的点，并持续按住100毫秒（0.1秒）
Touch x, y, 1

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


Function locate_Jumper(Jumper)
    call locate_Jumper_header(Jumper)
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




' 轮廓算法
' 1. 从内部点搜索到边缘
' 从内部一点一直向右直至搜索到一个外部点, 上一个内部点就是一个轮廓点
' 以此轮郭点为中心, 那个外部点为起始, 顺时针搜索邻点直至搜索到第一个内部点
' 这个内部点作为第2个轮廓点, 以搜索的上一个外部点为起始, 以第2个轮廓点为中心
' 搜索第3个轮廓点
' ...
' 直到再次搜索到第1个轮廓点, 轮廓闭合, 结束





' 正交十字弦定位法找出 i 头中心
Function locate_Jumper_header_by_cross_chord(Jumper_header)

    ' Jumper header 半径
    ' Dim  Jumper_header_rad = 30
    ' Jumper header center color &H7A4B52 = 8014674
    Dim  Jumper_header_center_color = &H7A4B52, Jumper_header_center_color_H_cent = 0.65, Jumper_header_center_color_H_rad = 0.09

    Dim start_x, start_y, ret_val

    KeepCapture()

    ret_val = FindColor(0, 0, 0, 0, UCase(Hex(Jumper_header_center_color)) & "-080808", 0, 1, start_x, start_y)
    '当需要函数返回值时需要加括号
    If ret_val > -1 Then
        TracePrint "找到的颜色:" & UCase(Hex(Jumper_header_center_color)) & ", 找到的颜色序号为" & ret_val & ",坐标在" & start_x & "," & start_y
    Else
        TracePrint "DBP 20180120_002351 全部没找到"
    End If

    dim x_dir = {"left":-1,"right":1,"up":0,"down":0}
    dim y_dir = {"left":0,"right":0,"up":-1,"down":1}
    Dim dir = Array("left","right","up","down")
    dim pos_x = {"left":-1,"right":-1,"up":-1,"down":-1}
    dim pos_y = {"left":-1,"right":-1,"up":-1,"down":-1}

    for j = 0 to UBound(dir)
        x = start_x
        y = start_y
        do
            x = x + x_dir[dir(j)]
            y = y + y_dir[dir(j)]
            rColor = GetPixelColor(x, y, 1)
            Call RGB2HSV(HSV, rColor)
            if Abs(HSV["H"] - Jumper_header_center_color_H_cent) > Jumper_header_center_color_H_rad then
                pos_x[dir(j)] = x
                pos_y[dir(j)] = y

                SAY "search 坐标在" & x & "," & y
                exit do
            End If
        loop while true
    next
    ReleaseCapture()

    Jumper_header["x"] = (pos_x["left"] + pos_x["right"]) / 2
    Jumper_header["y"] = (pos_y["up"] + pos_y["down"]) / 2
end function








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

    if DO_PRESS then
        Touch centx, centy, hold
        Touch 10, 10, 10
    end if
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


