<%
'######################################################################
'## YQasp.ipinfo.asp
'## -------------------------------------------------------------------
'## Feature     :   YQAsp IpInfo Class
'## Version     :   v1.1 Alpha
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description :   YQAsp IP信息查询类（插件）
'##					本类修改自互联网流传代码
'##					利用QQWry.DAT文件，查询指定IP所在位置 
'##					本类在ASP环境中使用纯真版QQWry.dat通过完美测试
'##					如果您的服务器环境不支持ADodb.Stream，将无法使用此程序
'##					推荐使用纯真数据库，更新也方便
'##					您可以根据 QQWry(IP) 返回值来判断该IP地址在数据库中是否存在，
'##					如果不存在可以执行其他的一些操作，比如您自建一个数据库作为追捕等
'##	
'##					.SetQQWryFile	：设置QQWry.DAT文件的路径
'##					.GetIpInfo(ip,type)方法的参数说明：	
'##						ip：ip地址字符串
'##						type：显示方式
'##							"1"或"ip"	：返回IP地址
'##							"2"或"c"		：返回所在城市，如：广西桂林市
'##							"3"或"l"		：返回所在区域，如：某某网吧
'##							"4"或"cl"	：返回所在城市及区域，如：广西桂林市 某某网吧
'##							"5"或"all"	：返回更详细的信息，如：您来自：124.226.126.121 所在区域：广西桂林市 某某网吧
'##					.GetWryInfo()方法返回一个QQWry.DAT文件信息数组
'##						.GetWryInfo()(0):返回数据库版本信息
'##						.GetWryInfo()(1):返回数据库IP地址数目
'##	
'## Examples	:	YQasp.W YQasp.Ext("ipinfo").GetIpInfo("192.168.1.1","cl")	'直接使用
'##					With YQasp.Ext("ipinfo")
'##						.SetQQWryFile = "/Data/QQWry.Dat"		'设置QQWry.Dat文件路径
'##						YQasp.WN .GetWryInfo()(1)				'输出数据库IP地址数目
'##						YQasp.WN .GetIpInfo(YQasp.GetIp(),5)		'输出当前访问者IP信息
'##					End With
'######################################################################

Class YQAsp_IpInfo
	' ============================================
	' 变量声明
	' ============================================
	Private QQWryFile, Country, LocalStr
	Private StartIP, EndIP, CountryFlag, Buf, OffSet
	Private FirstStartIP, LastStartIP, RecordCount
	Private Stream, EndIPOff,s_charset
	' ============================================
	' 类模块初始化
	' ============================================
	Private Sub Class_Initialize
		s_charset		= YQasp.CharSet
		Country 		= ""
		LocalStr 		= ""
		StartIP 		= 0
		EndIP 			= 0
		CountryFlag 	= 0 
		FirstStartIP 	= 0 
		LastStartIP 	= 0 
		EndIPOff 		= 0 
		QQWryFile 		= Server.MapPath("/db/QQWry.Dat") 'QQ IP库路径，要转换成物理路径
		YQasp.Error(20001) = "您的服务器不支持 Adodb.Stream 组件."
	End Sub
	' ============================================
	' 类终结
	' ============================================
	Private Sub Class_Terminate
		On ErrOr Resume Next
		Stream.Close
		If Err Then Err.Clear
		Set Stream = Nothing
	End Sub
	' ============================================
	' 设置QQWry.Dat文件路径
	' ============================================
	Public Property Let SetQQWryFile(ByVal p)
		If Instr(p,":") = 0 Then
			p = Server.MapPath(p)
		End If
		If Right(p,1) = "\" Then p = Left(p,Len(p)-1)
		QQWryFile = p
	End Property
	' ============================================
	' 返回QQWry信息(公共函数，QQWry.Dat版本以及记录条数)
	' ============================================
	Public Function GetWryInfo()
		Dim arrQQWry(1)
		Call QQWry("255.255.255.255")
		' 读取数据库版本信息
		arrQQWry(0) = Country & " " & LocalStr
		' 读取数据库IP地址数目
		arrQQWry(1) = RecordCount + 1
		GetWryInfo = arrQQWry
	End Function
	' ============================================
	' 返回IP信息（公共函数）
	' ============================================
	Public Function GetIpInfo(ByVal IP, ByVal sType)
		Call QQWry(IP)
		Select Case LCase(sType)
			Case "1","ip"	GetIpInfo = IP
			Case "2","c"	GetIpInfo = Country
			Case "3","l"	GetIpInfo = LocalStr
			Case "4","cl"	GetIpInfo = Country & " " & LocalStr
			Case "5","all"	GetIpInfo = "您来自：" & IP & " 所在区域：" & Country & " " & LocalStr & ""
		End Select
	End Function
	' ============================================
	' IP地址转换成整数
	' ============================================
	Private Function IPToInt(ByVal IP)
		Dim IPArray, i
		IPArray = Split(IP, ".", -1)
		FOr i = 0 to 3
			If Not IsNumeric(IPArray(i)) Then IPArray(i) = 0
			If CInt(IPArray(i)) < 0 Then IPArray(i) = Abs(CInt(IPArray(i)))
			If CInt(IPArray(i)) > 255 Then IPArray(i) = 255
		Next
		IPToInt = (CInt(IPArray(0))*256*256*256) + (CInt(IPArray(1))*256*256) + (CInt(IPArray(2))*256) + CInt(IPArray(3))
	End Function
	' ============================================
	' 整数逆转IP地址
	' ============================================
	Private Function IntToIP(ByVal IntValue)
		p4 = IntValue - Fix(IntValue/256)*256
		IntValue = (IntValue-p4)/256
		p3 = IntValue - Fix(IntValue/256)*256
		IntValue = (IntValue-p3)/256
		p2 = IntValue - Fix(IntValue/256)*256
		IntValue = (IntValue - p2)/256
		p1 = IntValue
		IntToIP = Cstr(p1) & "." & Cstr(p2) & "." & Cstr(p3) & "." & Cstr(p4)
	End Function
	' ============================================
	' 获取开始IP位置
	' ============================================
	Private Function GetStartIP(ByVal RecNo)
		OffSet = FirstStartIP + RecNo * 7
		Stream.Position = OffSet
		Buf = Stream.Read(7)
		
		EndIPOff = AscB(MidB(Buf, 5, 1)) + (AscB(MidB(Buf, 6, 1))*256) + (AscB(MidB(Buf, 7, 1))*256*256) 
		StartIP  = AscB(MidB(Buf, 1, 1)) + (AscB(MidB(Buf, 2, 1))*256) + (AscB(MidB(Buf, 3, 1))*256*256) + (AscB(MidB(Buf, 4, 1))*256*256*256)
		GetStartIP = StartIP
	End Function
	' ============================================
	' 获取结束IP位置
	' ============================================
	Private Function GetEndIP()
		Stream.Position = EndIPOff
		Buf = Stream.Read(5)
		EndIP = AscB(MidB(Buf, 1, 1)) + (AscB(MidB(Buf, 2, 1))*256) + (AscB(MidB(Buf, 3, 1))*256*256) + (AscB(MidB(Buf, 4, 1))*256*256*256) 
		CountryFlag = AscB(MidB(Buf, 5, 1))
		GetEndIP = EndIP
	End Function
	' ============================================
	' 获取地域信息，包含国家和和省市
	' ============================================
	Private Sub GetCountry(ByVal IP)
		If (CountryFlag = 1 Or CountryFlag = 2) Then
			Country = GetFlagStr(EndIPOff + 4)
			If CountryFlag = 1 Then
				LocalStr = GetFlagStr(Stream.Position)
				' 以下用来获取数据库版本信息
				If IP >= IPToInt("255.255.255.0") And IP <= IPToInt("255.255.255.255") Then
					LocalStr = GetFlagStr(EndIPOff + 21)
					Country = GetFlagStr(EndIPOff + 12)
				End If
			Else
				LocalStr = GetFlagStr(EndIPOff + 8)
			End If
		Else
			Country = GetFlagStr(EndIPOff + 4)
			LocalStr = GetFlagStr(Stream.Position)
		End If
		' 过滤数据库中的无用信息
		Country = Trim(Country)
		LocalStr = Trim(LocalStr)
		If InStr(Country, "CZ88.NET") Then Country = ""
		If InStr(LocalStr, "CZ88.NET") Then LocalStr = ""
	End Sub
	' ============================================
	' 获取IP地址标识符
	' ============================================
	Private Function GetFlagStr(ByVal OffSet)
		Dim Flag
		Flag = 0
		Do While (True)
			Stream.Position = OffSet
			Flag = AscB(Stream.Read(1))
			If(Flag = 1 Or Flag = 2 ) Then
				Buf = Stream.Read(3) 
				If (Flag = 2 ) Then
					CountryFlag = 2
					EndIPOff = OffSet - 4
				End If
				OffSet = AscB(MidB(Buf, 1, 1)) + (AscB(MidB(Buf, 2, 1))*256) + (AscB(MidB(Buf, 3, 1))*256*256)
			Else
				Exit Do
			End If
		Loop
		
		If (OffSet < 12 ) Then
			GetFlagStr = ""
		Else
			Stream.Position = OffSet
			GetFlagStr = GetStr() 
		End If
	End Function
	' ============================================
	' 获取字串信息
	' ============================================
	Private Function GetStr() 
		Dim c
		GetStr = ""
		If LCase(s_charset) = "utf-8" Then
			Dim objstream 
			Set objstream = Server.CreateObject("Adodb.Stream")
			objstream.Type = 1 
			objstream.Mode =3 
			objstream.Open
			c = Stream.Read(1)
			Do While (AscB(c)<>0 And Not Stream.EOS)
				objstream.write c
				c = Stream.Read(1)
			Loop
			objstream.Position = 0
			objstream.Type = 2
			objstream.Charset = "GB2312"
			GetStr = objstream.ReadText
			objstream.Close
			Set objstream = Nothing
		Else
			Do While (True)
				c = AscB(Stream.Read(1))
				If (c = 0) Then Exit Do 
				
				'如果是双字节，就进行高字节在结合低字节合成一个字符
				If c > 127 Then
					If Stream.EOS Then Exit Do
					GetStr = GetStr & Chr(AscW(ChrB(AscB(Stream.Read(1))) & ChrB(C)))
				Else
					GetStr = GetStr & Chr(c)
				End If
			Loop 
		End If
	End Function

	' ============================================
	' 核心函数，执行IP搜索
	' ============================================
	Public Function QQWry(ByVal DotIP)
		If Not YQasp.IsInstall("Adodb.Stream") Then YQasp.Error.Raise 20001
		Dim IP, nRet
		Dim RangB, RangE, RecNo
		
		IP = IPToInt (DotIP)
		
		Set Stream = CreateObject("Adodb.Stream")
		Stream.Mode = 3
		Stream.Type = 1
		Stream.Open
		Stream.LoadFromFile QQWryFile
		Stream.Position = 0
		Buf = Stream.Read(8)
		
		FirstStartIP = AscB(MidB(Buf, 1, 1)) + (AscB(MidB(Buf, 2, 1))*256) + (AscB(MidB(Buf, 3, 1))*256*256) + (AscB(MidB(Buf, 4, 1))*256*256*256)
		LastStartIP  = AscB(MidB(Buf, 5, 1)) + (AscB(MidB(Buf, 6, 1))*256) + (AscB(MidB(Buf, 7, 1))*256*256) + (AscB(MidB(Buf, 8, 1))*256*256*256)
		RecordCount = Int((LastStartIP - FirstStartIP)/7)
		' 在数据库中找不到任何IP地址
		If (RecordCount <= 1) Then
			Country = "未知"
			QQWry = 2
			Exit Function
		End If
		
		RangB = 0
		RangE = RecordCount
		
		Do While (RangB < (RangE - 1)) 
			RecNo = Int((RangB + RangE)/2) 
			Call GetStartIP (RecNo)
			If (IP = StartIP) Then
				RangB = RecNo
				Exit Do
			End If
			If (IP > StartIP) Then
				RangB = RecNo
			Else 
				RangE = RecNo
			End If
		Loop
		
		Call GetStartIP(RangB)
		Call GetEndIP()

		If (StartIP <= IP) And ( EndIP >= IP) Then
			' 没有找到
			nRet = 0
		Else
			' 正常
			nRet = 3
		End If
		Call GetCountry(IP)

		QQWry = nRet
	End Function
End Class 
%>