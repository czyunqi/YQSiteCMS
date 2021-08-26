<%
Class YQAsp_Fun
	Private s_version
	Private Sub Class_Initialize()
		s_version = "0.1"
	End Sub
	Private Sub Class_Terminate()
		
	End Sub
	
	Public Property Get Version()
		Version = s_version
	End Property
	Public Function [New]()
		Set [New] = New YQAsp_Fun
	End Function
	'身份证15位转18位，只支持2000年之前的，成功返回18位身份证号，失败返回原字符串
	Public Function IdCard(ByVal a)
		If Len(a) = 15 Then 
			'加19就行了，2000年以后应该就没15位了
			a = Left(a,6) & "19" & Right(a,9)
			Dim m : m = 0
			Dim b : Set b = YQasp.List.NewArray("7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2")
			For i = 0 To 16
				m = m + (CLng(Right(Left(a,i+1),1)) * CLng(b(i)))
			Next 
			Dim x : Set x = YQasp.List.NewArray("1 0 X 9 8 7 6 5 4 3 2")
			IdCard = a & x(m Mod 11)
		Else 
			IdCard = a
		End If 
	End Function
	'远程接口加域名限制，感谢 @绝世名伶
	'注意：此方法必须在接口文件最前面运行，否则会报设置头信息错误
	'null为本地运行的HTML远程访问时的值
	'必须在远程访问接口时有效，当前页测试无效
	'例子：If fun.Header("http://www.jam1.cn,http://YQasp.cn,null") Then 输出接口内容
	Public Function Header(ByVal arr)
		Response.AddHeader "Access-Control-Allow-Origin","*"
		Header = False
		Dim a : Set a = YQasp.List.New
		a.Separator = ","
		a.Data = Replace(arr," ","")
		If a.Has(Request.ServerVariables("HTTP_ORIGIN")) Then Header = True
	End Function

	'Public Default Function Fun(ByVal num)
	'	Fun = num
	'End Function
End Class
%>