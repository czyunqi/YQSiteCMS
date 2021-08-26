<%
'######################################################################
'## YQasp.cache.asp
'## -------------------------------------------------------------------
'## Feature     :   YQAsp Cache Class
'## Version     :   1.0
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description :   Save and Get Cache With YQAsp
'##
'######################################################################
Class YQAsp_Cache
  Public Items, CountEnabled, Expires, FileType
  Private s_path, b_fsoOn
  '构造函数
  Private Sub Class_Initialize
    Set Items = Server.CreateObject("Scripting.Dictionary")
    Items.CompareMode = 1
    s_path = Server.MapPath("/_cache") & "\"
    CountEnabled = True
    Expires = 5
    FileType = ".YQaspcache"
    YQasp.Error("error-cache-notfound") = YQasp.Lang("error-cache-notfound")
    YQasp.Error("error-cache-invalid-object") = YQasp.Lang("error-cache-invalid-object")
    YQasp.Error("error-cache-invalid-file") = YQasp.Lang("error-cache-invalid-file")
  End Sub
  '析构函数
  Private Sub Class_Terminate
    Set Items = Nothing
  End Sub
  '建新YQasp缓存类实例
  Public Function [New]()
    Set [New] = New YQAsp_Cache
  End Function
  '取当前所有缓存数量
  Public Property Get Count
    Count = YQasp.IIF(CountEnabled,YQasp_Cache_Count,-1)
  End Property
  '添加缓存值
  Public Property Let Item(ByVal p, ByVal v)
    If IsNull(p) Then p = ""
    If Not IsObject(Items(p)) Then
      Set Items(p) = New YQasp_Cache_Info
      Items(p).CountEnabled = CountEnabled
      Items(p).Expires = Expires
      Items(p).FileType = FileType
    End If
    Items(p).Name = p
    Items(p).Value = v
    Items(p).SavePath = s_path
  End Property
  '获取缓存值
  Public Default Property Get Item(ByVal p)
    If Not IsObject(Items(p)) Then
      Set Items(p) = New YQasp_Cache_Info
      Items(p).Name = p
      Items(p).SavePath = s_path
      Items(p).CountEnabled = CountEnabled
      Items(p).Expires = Expires
      Items(p).FileType = FileType
    End If
    set Item = Items(p)
  End Property
  '设置文件缓存保存目录路径
  Public Property Let SavePath(ByVal s)
    If Not Instr(s,":") = 2 Then s = Server.MapPath(s)
    If Right(s,1) <> "\" Then s = s & "\"
    s_path = s
  End Property
  Public Property Get SavePath()
    SavePath = s_path
  End Property
  '保存所有文件缓存
  Public Sub SaveAll
    Dim f
    For Each f In Items
      Items(f).Save
    Next
  End Sub
  '保存所有内存缓存
  Public Sub SaveAppAll  
    Dim f 
    For Each f In Items
      Items(f).SaveApp
    Next
  End Sub
  '清除所有文件缓存
  Public Sub RemoveAll
    Dim f
    For Each f In Items
      Items(f).Remove
    Next
  End Sub
  '清除所有内存缓存
  Public Sub RemoveAppAll  
    Dim f 
    For Each f In Items
      Items(f).RemoveApp
    Next
  End Sub
  '清空缓存
  Public Sub [Clear]
    RemoveAll
    RemoveAppAll
    YQasp.RemoveApplication "YQasp_Cache_Count"
  End Sub
End Class
'统计缓存数量
Private Function YQasp_Cache_Count()
  YQasp_Cache_Count = 0
  Dim n : n = YQasp.GetApplication("YQasp_Cache_Count")
  If IsArray(n) Then
    If Ubound(n) = 1 Then YQasp_Cache_Count = n(0)
  End If
End Function
'缓存计数更改
Private Function YQasp_CacheCount_Change(ByVal a, ByVal t)
  Dim n : n = YQasp.GetApplication("YQasp_Cache_Count")
  If isArray(n) Then
    If Ubound(n) = 1 Then
      If TypeName(n(1)) = "Dictionary" Then
        If t = 1 Then n(1)(a) = a
        If t = -1 Then
          If n(1).Exists(a) Then n(1).Remove(a)
        End If
        YQasp.SetApplication "YQasp_Cache_Count", Array(n(1).Count,n(1))
      End If
    End If
  Else
    Dim dic : Set dic = Server.CreateObject("Scripting.Dictionary")
    If t = 1 Then dic(a) = a
    YQasp.SetApplication "YQasp_Cache_Count", Array(YQasp.IIF(t=1,1,0),dic)
  End If
End Function
'缓存项处理方法
class YQasp_Cache_Info
  Public SavePath, [Name], CountEnabled, FileType
  Private i_exp, d_exp, o_value
  Private Sub Class_Initialize
    i_exp = 5
    d_exp = ""
  End Sub
  Private Sub Class_Terminate
    If IsObject(o_value) Then Set o_value = Nothing
  End Sub
  '设置和读取缓存过期时间
  Public Property Let Expires(ByVal i)
    If isDate(i) Then
      '具体日期时间
      d_exp = CDate(i)
    ElseIf isNumeric(i) Then
      '数值（分钟）
      If i>0 Then
        i_exp = i
      ElseIf i=0 Then
        i_exp = 60*24*365*99
      End If
    End If
  End Property
  Public Property Get Expires()
    Expires = YQasp.IfHas(d_exp, i_exp)
  End Property
  '设置和读取缓存的值
  Public Property Let [Value](ByVal s)
    If IsObject(s) Then
      Select Case TypeName(s)
        Case "Recordset"
        '如果是记录集
          Set o_value = s.Clone
        Case Else
        '如果是其它对象
          Set o_value = s
      End Select
    Else
      '其它直接赋值
      o_value = s
    End If
  End Property
  Public Default Property Get [Value]()
    '在内存缓存中取值
    Dim app : app = YQasp.GetApplication(Me.Name)
    If IsArray(app) Then
      If UBound(app) = 1 Then
        If IsDate(app(0)) Then
          If IsObject(app(1)) Then
            Set [Value] = app(1)
            Exit Property
          Else
            [Value] = app(1)
            If YQasp.Has([Value]) Then Exit Property
          End If
        End If
      End If
    End If
    '如果内存缓存中没有该值则在文件缓存中取
    If YQasp.Fso.IsFile(FilePath) Then
      On Error Resume Next
      Dim rs
      set rs = Server.CreateObject("Adodb.Recordset")
      rs.Open FilePath
      If Err.Number <> 0 Then
        Err.Clear
        [Value] = YQasp.Fso.Read(FilePath)
      Else
        Set [Value] = rs
      End If
    Else
      YQasp.Error.FunctionName = "Cache:Item.Get"
      YQasp.Error.Detail = YQasp.Str.HtmlEncode(Me.Name)
      YQasp.Error.Raise "error-cache-notfound"
    End If
  End Property
  '保存到内存缓存
  Public Sub SaveApp
    Dim appArr(1) : appArr(0) = Now()
    If IsObject(o_value) Then
      '保存字典对象和记录对象（记录集对象将自动转为二维数组）
      Select Case TypeName(o_value)
        Case "Dictionary"
          Set appArr(1) = o_value
        Case "Recordset"
          appArr(1) = o_value.GetRows(-1)
        Case Else
          YQasp.Error.FunctionName = "Cache:Item.SaveApp"
          YQasp.Error.Detail = YQasp.Str.HtmlEncode(Me.Name)&" &gt; "&TypeName(o_value)
          YQasp.Error.Raise "error-cache-invalid-object"
      End Select
    Else
      appArr(1) = o_value
    End If
    YQasp.SetApplication Me.Name, appArr
    If CountEnabled Then YQasp_CacheCount_Change Me.Name, 1
  End Sub
  '保存到文件缓存
  Public Sub Save
    Select Case TypeName(o_value)
      Case "Recordset"
        YQasp.Fso.CreateFile FilePath, "rs"
        YQasp.Fso.DelFile FilePath
        o_value.Save FilePath, 1
        If CountEnabled Then YQasp_CacheCount_Change Me.Name, 1
      Case "String"
        YQasp.Fso.CreateFile FilePath, o_value
        If CountEnabled Then YQasp_CacheCount_Change Me.Name, 1
      Case Else
        YQasp.Error.FunctionName = "Cache:Item.Save"
        YQasp.Error.Detail = YQasp.Str.HtmlEncode(Me.Name)
        YQasp.Error.Raise "error-cache-invalid-file"
    End Select
  End Sub
  '删除文件缓存
  Public Sub Remove
    '删除文件缓存
    If Not YQasp.Str.Test(DelPath,"[*?]") Then
      If YQasp.Fso.IsExists(DelPath) Then YQasp.Fso.Del DelPath
      If CountEnabled Then YQasp_CacheCount_Change Me.Name, -1
    Else
      '如果有通配符
      YQasp.Fso.DelFile left(DelPath,len(DelPath)-Len(FileType))
      YQasp.Fso.DelFolder left(DelPath,len(DelPath)-Len(FileType))
      If CountEnabled Then YQasp_CacheCount_Change Me.Name, -1
    End If
  End Sub
  '删除内存缓存
  Public Sub RemoveApp
    If YQasp.Has(Me.Name) Then YQasp.RemoveApplication Me.Name
    If CountEnabled Then YQasp_CacheCount_Change Me.Name, -1
  End Sub
  '取文件缓存的缓存路径
  Public Property Get FilePath()
    FilePath = TransPath("[\\:""*?<>|\f\n\r\t\v\s]")
  End Property
  '取文件缓存的缓存地址，可带通配符
  Private Function DelPath()
    DelPath = TransPath("[\\:""<>|\f\n\r\t\v\s]")
  End Function
  '将名称转换为文件缓存地址
  Private Function TransPath(ByVal fe)
    Dim s_p : s_p = ""
    Dim parr : parr = split(Me.Name,"/")
    Dim i
    for i = 0 to UBound(parr)
      If YQasp.Str.Test(parr(i),fe) Then parr(i)=Server.URLEncode(parr(i))
      s_p = s_p & "_" & parr(i)
      If i < UBound(parr) Then
        s_p = s_p & "\"
      End If
    next
    If s_p="" Then s_p="_"
    TransPath = SavePath & s_p & FileType
  End Function  
  '缓存是否可用（未过期）
  Public Function Ready()
    Dim app : app = YQasp.GetApplication(Me.Name)
    Ready = False
    '如果是内存缓存
    If IsArray(app) Then
      If UBound(app) = 1 Then
        If IsDate(app(0)) Then
          Ready = isValid(app(0))
          If Ready Then Exit Function
        End If
      End If
    '如果是文件缓存
    ElseIf YQasp.Fso.IsFile(FilePath) Then
      Ready = isValid(YQasp.Fso.GetAttr(FilePath,1))
    End If
  End Function
  '验证时间是否过期
  Private Function isValid(ByVal t)
    If IsDate(t) Then
      If YQasp.Has(d_exp) Then
        isValid = (DateDiff("s",Now,d_exp) > 0)
      Else
        isValid = (DateDiff("s",t,Now) < i_exp*60)
      End If
    End If
  End Function
End Class
%>