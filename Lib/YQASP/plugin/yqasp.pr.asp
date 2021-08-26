<%
'Option Explicit
'######################################################################
'## YQasp.pr.asp
'## -------------------------------------------------------------------
'## Feature     :   YQAsp Google PageRank Class
'## Version     :   v1.0
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description :   YQAsp 谷歌PR值查询类（插件）
'######################################################################

Private Const OFFSET_4 = 4294967296
Private Const MAXINT_4 = 2147483647
Class YQAsp_Pr
	Private s_iplist
	Private b_ranip

	Public Property Let IpList(ByVal s)
		s_iplist = s
	End Property

	Public Property Let RanIp(ByVal b)
		b_ranip = b
	End Property
	
	Private Sub Class_Initialize
		s_iplist = "64.233.169.84,64.233.179.93,209.85.135.184,209.85.135.102,64.233.169.115,64.233.169.19,209.85.135.19,64.233.169.184,216.239.59.147,209.85.135.44,209.85.135.100,64.233.189.162,216.239.59.103,64.233.189.19,66.102.9.147,64.233.189.104,66.102.9.184,64.233.169.81,216.239.59.19,66.102.9.99,209.85.135.115,64.233.189.18,66.249.89.83,216.239.59.44"
		b_ranip = True
	End Sub
	Private Sub Class_Terminate
	End Sub

	Private Function getIp()
		Dim arrIp
		arrIp = Split(s_iplist,",")
		If b_ranip And UBound(arrIp) > 0 Then
			Randomize()
			getIp = arrIp(Round(Rnd()*UBound(arrIp)))
		Else
			getIp = arrIp(0)
		End If
	End Function
	
	Private Function zeroFill(ByVal a, ByVal b)
		Dim z
		z = &H80000000
		If ((z And a) <> 0) Then
			a = BitRShift(a, 1)
			a = a And Not z
			a = a Or &H40000000
			a = BitRShift(a, b - 1)
		Else
			a = BitRShift(a, b)
		End If
		zeroFill = a
	End Function
	
	Private Function uw_WordAdd(ByVal wordA, ByVal wordB)
	' Adds words A and B avoiding overflow
		Dim myUnsigned
		
		myUnsigned = LongToUnsigned(wordA) + LongToUnsigned(wordB)
		' Cope with overflow
		If myUnsigned > OFFSET_4 Then
			myUnsigned = myUnsigned - OFFSET_4
		End If
		uw_WordAdd = UnsignedToLong(myUnsigned)
	End Function
	
	Private Function uw_WordSub(ByVal wordA, ByVal wordB)
	' Subtract words A and B avoiding underflow
		Dim myUnsigned
		
		myUnsigned = LongToUnsigned(wordA) - LongToUnsigned(wordB)
		' Cope with underflow
		If myUnsigned < 0 Then
			myUnsigned = myUnsigned + OFFSET_4
		End If
		uw_WordSub = UnsignedToLong(myUnsigned)
	End Function
	
	Private Function UnsignedToLong(value)
		If value < 0 Or value >= OFFSET_4 Then Error 6 ' Overflow
		If value <= MAXINT_4 Then
			UnsignedToLong = value
		Else
			UnsignedToLong = value - OFFSET_4
		End If
	End Function
	
	Private Function LongToUnsigned(value)
		If value < 0 Then
			LongToUnsigned = value + OFFSET_4
		Else
			LongToUnsigned = value
		End If
	End Function
	
	Private Function BitLShift(ByVal x, n)
		If n = 0 Then
			BitLShift = x
		Else
			Dim k
			k = 2 ^ (32 - n - 1)
			Dim d
			d = x And (k - 1)
			Dim c
			c = d * 2 ^ n
			If x And k Then
				c = c Or &H80000000
			End If
			BitLShift = c
		End If
	End Function
	
	Private Function BitRShift(ByVal x, n)
		If n = 0 Then
			BitRShift = x
		Else
			Dim y
			y = x And &H7FFFFFFF
			Dim z
			If n = 32 - 1 Then
				z = 0
			Else
				z = y \ 2 ^ n
			End If
			If y <> x Then
				z = z Or 2 ^ (32 - n - 1)
			End If
			BitRShift = z
		End If
	End Function
	
	Private Function mix(ByVal a, ByVal b, ByVal c)
		a = uw_WordSub(a, b): a = uw_WordSub(a, c): a = a Xor (zeroFill(c, 13))
		b = uw_WordSub(b, c): b = uw_WordSub(b, a): b = b Xor BitLShift(a, 8)
		c = uw_WordSub(c, a): c = uw_WordSub(c, b): c = c Xor zeroFill(b, 13)
		a = uw_WordSub(a, b): a = uw_WordSub(a, c): a = a Xor zeroFill(c, 12)
		b = uw_WordSub(b, c): b = uw_WordSub(b, a): b = b Xor BitLShift(a, 16)
		c = uw_WordSub(c, a): c = uw_WordSub(c, b): c = c Xor zeroFill(b, 5)
		a = uw_WordSub(a, b): a = uw_WordSub(a, c): a = a Xor zeroFill(c, 3)
		b = uw_WordSub(b, c): b = uw_WordSub(b, a): b = b Xor BitLShift(a, 10)
		c = uw_WordSub(c, a): c = uw_WordSub(c, b): c = c Xor zeroFill(b, 15)
		
		Dim m(2)
		m(0) = a
		m(1) = b
		m(2) = c
		mix = m
	End Function
	
	Private Function GoogleCH(url(), length)
		Dim init, a, b, c
		init = &HE6359A60
		a = &H9E3779B9
		b = &H9E3779B9
		c = &HE6359A60
		
		Dim k, l
		k = 0
		l = length
		
		Dim mixo
		While (l >= 12)
			a = uw_WordAdd(a, url(k + 0))
			a = uw_WordAdd(a, BitLShift(url(k + 1), 8))
			a = uw_WordAdd(a, BitLShift(url(k + 2), 16))
			a = uw_WordAdd(a, BitLShift(url(k + 3), 24))
			b = uw_WordAdd(b, url(k + 4))
			b = uw_WordAdd(b, BitLShift(url(k + 5), 8))
			b = uw_WordAdd(b, BitLShift(url(k + 6), 16))
			b = uw_WordAdd(b, BitLShift(url(k + 7), 24))
			c = uw_WordAdd(c, url(k + 8))
			c = uw_WordAdd(c, BitLShift(url(k + 9), 8))
			c = uw_WordAdd(c, BitLShift(url(k + 10), 16))
			c = uw_WordAdd(c, BitLShift(url(k + 11), 24))
			mixo = mix(a, b, c)
			a = mixo(0): b = mixo(1): c = mixo(2)
			k = k + 12
			l = l - 12
		Wend
		c = c + length
		If l >= 11 Then c = uw_WordAdd(c, BitLShift(url(k + 10), 24))
		If l >= 10 Then c = uw_WordAdd(c, BitLShift(url(k + 9), 16))
		If l >= 9 Then c = uw_WordAdd(c, BitLShift(url(k + 8), 8))
		If l >= 8 Then b = uw_WordAdd(b, BitLShift(url(k + 7), 24))
		If l >= 7 Then b = uw_WordAdd(b, BitLShift(url(k + 6), 16))
		If l >= 6 Then b = uw_WordAdd(b, BitLShift(url(k + 5), 8))
		If l >= 5 Then b = uw_WordAdd(b, url(k + 4))
		If l >= 4 Then a = uw_WordAdd(a, BitLShift(url(k + 3), 24))
		If l >= 3 Then a = uw_WordAdd(a, BitLShift(url(k + 2), 16))
		If l >= 2 Then a = uw_WordAdd(a, BitLShift(url(k + 1), 8))
		If l >= 1 Then a = uw_WordAdd(a, url(k + 0))
		
		mixo = mix(a, b, c)
		If (mixo(2) < 0) Then
			GoogleCH = mixo(2) + 2 ^ 32
		Else
			GoogleCH = mixo(2)
		End If
	End Function
	
	Private Function StrConv(ByVal s)
		Dim tmpArr(),i
		ReDim tmpArr(Len(s))
		For i = 0 To Len(s) - 1
			tmpArr(i) = Asc(Mid(s,i+1,1))
		Next
		StrConv = tmpArr
	End Function
	
	Private Function c32to8bit(arr32())
		Dim arr8()
		ReDim arr8(4 * (UBound(arr32) + 1) - 1)
		Dim i, bitOrder
		For i = 0 To UBound(arr32)
			For bitOrder = i * 4 To i * 4 + 3
				arr8(bitOrder) = arr32(i) And 255
				arr32(i) = zeroFill(arr32(i), 8)
			Next
		Next
		c32to8bit = arr8
	End Function
	
	Private Function GoogleNewCh(ByVal ch)
		Dim prbuf(19), i
		prbuf(0) = (BitLShift(Fix(ch / 7), 2) Or ((ch - 13 * Fix(ch / 13)) And 7))
		'prbuf(0) = (BitLShift((ch / 7), 2) Or ((ch Mod 13) And 7))
		For i = 1 To 19
			prbuf(i) = prbuf(i - 1) - 9
		Next
		
		GoogleNewCh = GoogleCH(c32to8bit(prbuf), 80)
	End Function
	
	Private Function UrlEncode(ByVal urlText)
		Dim i
		Dim ansi
		Dim ascii
		Dim encText
		
		ansi = StrConv(urlText)
		
		encText = ""
			For i = 0 To UBound(ansi)
			ascii = ansi(i)
		
			Select Case ascii
			Case 48,49,50,51,52,53,54,55,56,57, 65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90, 97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122
				encText = encText & Chr(ascii)
		
			Case 32
				encText = encText & "+"
		
			Case Else
				If ascii < 16 Then
					encText = encText & "%0" & Hex(ascii)
				Else
					encText = encText & "%" & Hex(ascii)
				End If
		
			End Select
		Next
		
		UrlEncode = encText
	End Function
	
	Public Default Function GetPageRank(url)
		Dim reqgr, reqgre
		reqgr = "info:" & url
		reqgre = "info:" & UrlEncode(url)
		
		Dim bUrl
		bUrl = StrConv(reqgr)
		
		Dim gch
		gch = GoogleCH(bUrl, Len(reqgr))
		gch = GoogleNewCh(gch)
		Dim querystring
		querystring = "http://" & getIp() & "/search?client=navclient-auto&ch=6" & gch & "&ie=UTF-8&oe=UTF-8&features=Rank:FVN&q=" & reqgre
		
		Dim xml
		Set xml = Server.CreateObject("Microsoft.XMLHTTP")
		xml.Open "GET", querystring, False
		xml.setRequestHeader "User-Agent", "Mozilla/4.0 (compatible; GoogleToolbar 2.0.114-big; Windows XP 5.1)"
		xml.send
		
		GetPageRank = ""
		Dim res
		res = xml.responseText
		Set xml = Nothing
		If Len(res) > 2 Then
			Dim pos, pos1
			pos = InStr(res, "Rank_")
			pos1 = InStr(pos, res, Chr(10))
			If pos > 0 And pos1 > 0 Then
				res = Mid(res, pos, pos1 - pos)
				Dim x
				x = Split(res, ":", 3)
				GetPageRank = x(2)
			End If
		End If
	End Function
End Class 
%>