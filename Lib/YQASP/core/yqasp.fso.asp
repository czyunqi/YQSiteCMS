<%
'######################################################################
'## YQasp.fso.asp
'## -------------------------------------------------------------------
'## Feature     :   YQAsp FileSystemObject Class
'## Version     :   1.0
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description :   YQAsp Files System Operator
'##
'######################################################################
Class YQAsp_Fso
  Public oFso, IsVirtualHost
  Private Fso
  Private b_force,b_overwrite
  Private s_fsoName,s_sizeformat,s_charset, s_bom

  Private Sub Class_Initialize
    s_fsoName     = "Scripting.FileSystemObject"
    s_charset     = "UTF-8"
    On Error Resume Next
    Set Fso       = Server.CreateObject(s_fsoName)
    Set oFso      = Fso
    On Error Goto 0
    IsVirtualHost = True
    b_force       = True
    b_overwrite   = True
    s_sizeformat  = "K"
    YQasp.Error("error-fso-filenotfound") = YQasp.Lang("error-fso-filenotfound")
    YQasp.Error("error-fso-write") = YQasp.Lang("error-fso-write")
    YQasp.Error("error-fso-md") = YQasp.Lang("error-fso-md")
    YQasp.Error("error-fso-list") = YQasp.Lang("error-fso-list")
    YQasp.Error("error-fso-attrfile") = YQasp.Lang("error-fso-attrfile")
    YQasp.Error("error-fso-attr") = YQasp.Lang("error-fso-attr")
    YQasp.Error("error-fso-copy") = YQasp.Lang("error-fso-copy")
    YQasp.Error("error-fso-move") = YQasp.Lang("error-fso-move")
    YQasp.Error("error-fso-del") = YQasp.Lang("error-fso-del")
    YQasp.Error("error-fso-renamefile") = YQasp.Lang("error-fso-renamefile")
    YQasp.Error("error-fso-rename") = YQasp.Lang("error-fso-rename")
    YQasp.Error("error-fso-control") = YQasp.Lang("error-fso-control")
    YQasp.Error("error-fso-ctrlnotfound") = YQasp.Lang("error-fso-ctrlnotfound")
  End Sub

  Private Sub Class_Terminate
    Set Fso   = Nothing
    Set oFso   = Nothing
  End Sub
  '设置和读取FSO组件名称
  Public Property Let fsoName(Byval str)
    s_fsoName = str
    Set Fso = Server.CreateObject(s_fsoName)
    Set oFso = Fso
  End Property
  Public Property Get fsoName()
    fsoName = s_fsoName
  End Property
  '设置待操作文件编码
  Public Property Let CharSet(Byval str)
    s_charset = Ucase(str)
  End Property
  '设置是否删除只读文件
  Public Property Let Force(Byval bool)
    b_force = bool
  End Property
  '设置是否覆盖原有文件
  Public Property Let OverWrite(Byval bool)
    b_overwrite = bool
  End Property
  '设置文件大小显示格式(G,M,K,b,auto)
  Public Property Let SizeFormat(Byval str)
    s_sizeformat = str
  End Property
  '设置UTF-8文件的BOM信息如何处理
  '注：此属性已废除，YQAsp 读取和写入utf-8编码文件一律去掉BOM。
  Public Property Let FileBom(Byval string)
    s_bom = string
  End Property

  '检测文件或文件夹是否存在
  Public Function isExists(ByVal path)
    isExists = False
    If isFile(path) or isFolder(path) Then isExists = True
  End Function
  '检测文件是否存在
  Public Function isFile(ByVal filePath)
    filePath = absPath(filePath) : isFile = False
    If Fso.FileExists(filePath) Then isFile = True
  End Function
  '读取文件文本内容
  Public Function Read(ByVal filePath)
    Dim p, f, ch, o_strm, tmpStr, s_char
    s_char = s_charset
    If Instr(filePath,">")>0 Then
      ch = YQasp.Str.GetNameValue(FilePath, ">")
      filePath = Trim(ch(0))
      s_char = UCase(Trim(ch(1)))
    End If
    p = absPath(filePath)
    If isFile(p) Then
      Set o_strm = Server.CreateObject("ADODB.Stream")
      With o_strm
        .Type = 2
        .Mode = 3
        .Open
        .LoadFromFile p
        .CharSet = "x-ansi"
        .Position = 2
        If .Size > 4 Then
          '一律去掉BOM
          If AscB(.ReadText(1)) = 239 And AscB(.ReadText(1)) = 187 And AscB(.ReadText(1)) = 191 Then
            .Position = 0
            .Charset = "utf-8"
            .Position = 5
          Else
            .Position = 0
            .Charset = s_char
            .Position = 2
          End If
        End If
        tmpStr = .ReadText
        .Close
      End With
      Set o_strm = Nothing
    Else
      tmpStr = ""
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.Read"
        YQasp.Error.Detail = filePath
        YQasp.Error.Raise "error-fso-filenotfound"
      End If
    End If
    tmpStr = Replace(tmpStr, vbLf, vbCrLf)
    tmpStr = Replace(tmpStr, vbCr & vbCrLf, vbCrLf)
    Read = tmpStr
  End Function
  '将二进制数据保存为文件
  Public Function SaveAs(ByVal filePath, ByVal fileContent)
    On Error Resume Next
    Dim p, s_char, o_strm, o_utf8
    p = absPath(filePath)
    SaveAs = MD(Left(p,InstrRev(p,"\")-1))
    If SaveAs Then
      Set o_strm = Server.CreateObject("ADODB.Stream")
      With o_strm
        .Type = 1
        .Open
        .Write fileContent
        If .Size > 2 Then
          .Position = 0
          If  AscB(.Read(1)) = 239 And AscB(.Read(1)) = 187 And AscB(.Read(1)) = 191 Then
            Set o_utf8 = Server.CreateObject("ADODB.Stream")
            o_utf8.Type = 1
            o_utf8.Open
            .Position = 3
            .Copyto o_utf8
            o_utf8.SaveToFile p, YQasp.IIF(b_overwrite, 2, 1)
            o_utf8.Close
            Set o_utf8 = Nothing
          Else
            .SaveToFile p, YQasp.IIF(b_overwrite, 2, 1)
          End If
        Else
          .SaveToFile p, YQasp.IIF(b_overwrite, 2, 1)
        End If
        .Close
      End With
      Set o_strm = Nothing
    End If
    If Err.Number<>0 Then
      SaveAs = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.SaveAs"
        YQasp.Error.Detail = filePath
        YQasp.Error.Raise "error-fso-write"
      End If
    End If
    Err.Clear()
  End Function
  '创建文件并写入内容
  Public Function CreateFile(ByVal filePath, ByVal fileContent)
    On Error Resume Next
    Dim p, ch, s_char, o_strm, o_utf8
    s_char = s_charset
    If Instr(filePath,">")>0 Then
      ch = YQasp.Str.GetNameValue(filePath,">")
      filePath = Trim(ch(0))
      s_char = UCase(Trim(ch(1)))
    End If
    p = absPath(filePath)
    CreateFile = MD(Left(p,InstrRev(p,"\")-1))
    If CreateFile Then
      Set o_strm = Server.CreateObject("ADODB.Stream")
      With o_strm
        .Charset = s_char
        .Open
        .WriteText = fileContent
        If s_char = "UTF-8" Then
          Set o_utf8 = Server.CreateObject("ADODB.Stream")
          o_utf8.type=1
          o_utf8.Open
          .Position = 3
          .Copyto o_utf8
          o_utf8.SaveToFile p, YQasp.IIF(b_overwrite, 2, 1)
          o_utf8.Close
          Set o_utf8 = Nothing
        Else
          .SaveToFile p, YQasp.IIF(b_overwrite, 2, 1)
        End If
        .Close
      End With
      Set o_strm = Nothing
    End If
    If Err.Number<>0 Then
      CreateFile = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.CreateFile"
        YQasp.Error.Detail = filePath
        YQasp.Error.Raise "error-fso-write"
      End If
    End If
    Err.Clear()
  End Function
  '按正则表达式更新文件内容
  Public Function UpdateFile(ByVal filePath, ByVal rule, ByVal result)
    Dim tmpStr : filePath = absPath(filePath)
    tmpStr = YQasp.Str.Replace(Read(filePath),rule,result)
    UpdateFile = CreateFile(filePath,tmpStr)
  End Function
  '向文本文件追加内容
  Public Function AppendFile(ByVal filePath, ByVal fileContent)
    Dim tmpStr : filePath = absPath(filePath)
    tmpStr = Read(filePath) & fileContent
    AppendFile = CreateFile(filePath,tmpStr)
  End Function
  '检测文件夹是否存在
  Public Function isFolder(ByVal folderPath)
    folderPath = absPath(folderPath) : isFolder = False
    If Fso.FolderExists(folderPath) Then isFolder = True
  End Function
  '创建文件夹
  Public Function CreateFolder(ByVal folderPath)
    On Error Resume Next
    Dim p,arrP,i : CreateFolder = True
    p = absPath(folderPath)
    arrP = Split(p,"\") : p = ""
    For i = 0 To Ubound(arrP)
      p = p & arrP(i) & "\"
      If IsVirtualHost Then
        If Instr(p, absPath("/") & "\")>0 Then
          If Not isFolder(p) And i>0 Then Fso.CreateFolder(p)
        End If
      Else
        If Not isFolder(p) And i>0 Then Fso.CreateFolder(p)
      End If
    Next
    If Err.Number<>0 Then
      CreateFolder = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.CreateFolder"
        YQasp.Error.Detail = folderPath
        YQasp.Error.Raise "error-fso-md"
      End If
    End If
    Err.Clear()
  End Function
  '创建文件夹
  Public Function MD(ByVal folderPath)
    MD = CreateFolder(folderPath)
  End Function
  '列出文件夹下的所有文件夹、文件
  Public Function Dir(ByVal folderPath)
    Dir = List(folderPath,0)
  End Function
  '列出文件夹下的所有文件夹或文件
  Public Function List(ByVal folderPath, ByVal fileType)
    On Error Resume Next 'Do not delete or comment
    Dim f,fs,k,arr(),i,l
    folderPath = absPath(folderPath) : i = 0
    Select Case LCase(fileType)
      Case "0","" l = 0
      Case "1","file" l = 1
      Case "2","folder" l = 2
      Case Else l = 0
    End Select
    Set f = Fso.GetFolder(folderPath)
    If l = 0 Or l = 2 Then
      Set fs = f.SubFolders
      ReDim Preserve arr(4,fs.Count-1)
      For Each k In fs
        arr(0,i) = k.Name & "/"
        arr(1,i) = formatSize(k.Size,s_sizeformat)
        arr(2,i) = k.DateLastModified
        arr(3,i) = Attr2Str(k.Attributes)
        arr(4,i) = k.Type
        i = i + 1
      Next
    End If
    If l = 0 Or l = 1 Then
      Set fs = f.Files
      ReDim Preserve arr(4,fs.Count+i-1)
      For Each k In fs
        arr(0,i) = k.Name
        arr(1,i) = formatSize(k.Size,s_sizeformat)
        arr(2,i) = k.DateLastModified
        arr(3,i) = Attr2Str(k.Attributes)
        arr(4,i) = k.Type
        i = i + 1
      Next
    End If
    Set fs = Nothing
    Set f = Nothing
    List = arr
    If Err.Number<>0 Then
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.list"
        YQasp.Error.Detail = folderPath
        YQasp.Error.Raise "error-fso-list"
      End If
    End If
    Err.Clear()
  End Function
  '取文件名
  Public Function NameOf(ByVal f)
    NameOf = GetNameOf(f, 0)
  End Function
  '取文件扩展名
  Public Function ExtOf(ByVal f)
    ExtOf = GetNameOf(f, 1)
  End Function
  Private Function GetNameOf(ByVal f, ByVal t)
    Dim re,na,ex
    If YQasp.isN(f) Then GetNameOf = "" : Exit Function
    f = Replace(f,"\","/")
    If Right(f,1) = "/" Then
      re = Split(f,"/")
      GetNameOf = YQasp.IIF(t=0,re(Ubound(re)-1),"")
      Exit Function
    ElseIf Instr(f,"/")>0 Then
      re = Split(f,"/")(Ubound(Split(f,"/")))
    Else
      re = f
    End If
    If Instr(re,".")>0 Then
      na = Left(re,InstrRev(re,".")-1)
      ex = Mid(re,InstrRev(re,"."))
    Else
      na = re
      ex = ""
    End If
    If t = 0 Then
      GetNameOf = na
    ElseIf t = 1 Then
      GetNameOf = ex
    End If
  End Function
  '设置文件或文件夹属性
  Public Function Attr(ByVal path, ByVal attrType)
    On Error Resume Next
    Dim p,a,i,n,f,at : p = absPath(path) : n = 0 : Attr = True
    If not isExists(p) Then
      Attr = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.Attr"
        YQasp.Error.Detail = path
        YQasp.Error.Raise "error-fso-attrfile"
      End If
      Exit Function
    End If
    If isFile(p) Then
      Set f = Fso.GetFile(p)
    ElseIf isFolder(p) Then
      Set f = Fso.GetFolder(p)
    End If
    at = f.Attributes : a = UCase(attrType)
    If Instr(a,"+")>0 Or Instr(a,"-")>0 Then
      a = YQasp.IIF(Instr(a," ")>0,Split(a," "),Split(a,","))
      For i = 0 To Ubound(a)
        Select Case a(i)
          Case "+R" at = YQasp.IIF(at And 1,at,at+1)
          Case "-R" at = YQasp.IIF(at And 1,at-1,at)
          Case "+H" at = YQasp.IIF(at And 2,at,at+2)
          Case "-H" at = YQasp.IIF(at And 2,at-2,at)
          Case "+S" at = YQasp.IIF(at And 4,at,at+4)
          Case "-S" at = YQasp.IIF(at And 4,at-4,at)
          Case "+A" at = YQasp.IIF(at And 32,at,at+32)
          Case "-A" at = YQasp.IIF(at And 32,at-32,at)
        End Select
      Next
      f.Attributes = at
    Else
      For i = 1 To Len(a)
        Select Case Mid(a,i,1)
          Case "R" n = n + 1
          Case "H" n = n + 2
          Case "S" n = n + 4
        End Select
      Next
      f.Attributes = YQasp.IIF(at And 32,n+32,n)
    End If
    Set f = Nothing
    If Err.Number<>0 Then
      Attr = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.Attr"
        YQasp.Error.Detail = path
        YQasp.Error.Raise "error-fso-attr"
      End If
    End If
    Err.Clear()
  End Function
  '获取文件或文件夹信息
  Public Function getAttr(ByVal path, ByVal attrType)
    Dim f,s,p : p = absPath(path)
    If isFile(p) Then
      Set f = Fso.GetFile(p)
    ElseIf isFolder(p) Then
      Set f = Fso.GetFolder(p)
    Else
      getAttr = ""
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.getAttr"
        YQasp.Error.Detail = path
        YQasp.Error.Raise "error-fso-attrfile"
      End If
      Exit Function
    End If
    Select Case LCase(attrType)
      Case "0","name" : s = f.Name
      Case "1","date", "datemodified" : s = f.DateLastModified
      Case "2","datecreated" : s = f.DateCreated
      Case "3","dateaccessed" : s = f.DateLastAccessed
      Case "4","size" : s = formatSize(f.Size,s_sizeformat)
      Case "5","attr" : s = Attr2Str(f.Attributes)
      Case "6","type" : s = f.Type
      Case Else s = ""
    End Select
    Set f = Nothing
    getAttr = s
  End Function
  '复制文件（支持通配符*和?）
  Public Function CopyFile(ByVal fromPath, ByVal toPath)
    CopyFile = FOFO(fromPath,toPath,0,0)
  End Function
  '复制文件夹（支持通配符*和?）
  Public Function CopyFolder(ByVal fromPath, ByVal toPath)
    CopyFolder = FOFO(fromPath,toPath,1,0)
  End Function
  '复制文件或文件夹
  Public Function Copy(ByVal fromPath, ByVal toPath)
    Dim ff,tf : ff = absPath(fromPath) : tf = absPath(toPath)
    If isFile(ff) Then
      Copy = CopyFile(fromPath,toPath)
    ElseIf isFolder(ff) Then
      Copy = CopyFolder(fromPath,toPath)
    Else
      Copy = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.Copy"
        YQasp.Error.Detail = fromPath
        YQasp.Error.Raise "error-fso-copy"
      End If
    End If
  End Function
  '移动文件（支持通配符*和?）
  Public Function MoveFile(ByVal fromPath, ByVal toPath)
    MoveFile = FOFO(fromPath,toPath,0,1)
  End Function
  '移动文件夹（支持通配符*和?）
  Public Function MoveFolder(ByVal fromPath, ByVal toPath)
    MoveFolder = FOFO(fromPath,toPath,1,1)
  End Function
  '移动文件或文件夹
  Public Function Move(ByVal fromPath, ByVal toPath)
    Dim ff,tf : ff = absPath(fromPath) : tf = absPath(toPath)
    If isFile(ff) Then
      Move = MoveFile(fromPath,toPath)
    ElseIf isFolder(ff) Then
      Move = MoveFolder(fromPath,toPath)
    Else
      Move = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.Move"
        YQasp.Error.Detail = fromPath
        YQasp.Error.Raise "error-fso-move"
      End If
    End If
  End Function
  '删除文件（支持通配符*和?）
  Public Function DelFile(ByVal path)
    DelFile = FOFO(path,"",0,2)
  End Function
  '删除文件夹（支持通配符*和?）
  Public Function DelFolder(ByVal path)
    DelFolder = FOFO(path,"",1,2)
  End Function
  '删除文件夹（支持通配符*和?）
  Public Function RD(ByVal path)
    RD = DelFolder(path)
  End Function
  '删除文件或文件夹
  Public Function Del(ByVal path)
    Dim p : p = absPath(path)
    If isFile(p) Then
      Del = DelFile(path)
    ElseIf isFolder(p) Then
      Del = DelFolder(path)
    Else
      Del = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.Del"
        YQasp.Error.Detail = path
        YQasp.Error.Raise "error-fso-del"
      End If
    End If
    Err.Clear()
  End Function
  '重命名文件或文件夹
  Public Function Rename(ByVal path, ByVal newname)
    Dim p,n : p = absPath(path) : Rename = True
    n = Left(p,InstrRev(p,"\")) & newname
    If Not isExists(p) Then
      Rename = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.Rename"
        YQasp.Error.Detail = newname
        YQasp.Error.Raise "error-fso-renamefile"
      End If
      Exit Function
    End If
    If isExists(n) Then
      Rename = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.Rename"
        YQasp.Error.Detail = newname
        YQasp.Error.Raise "error-fso-rename"
      End If
      Exit Function
    End If
    If isFolder(p) Then
      Fso.MoveFolder p,n
    ElseIf isFile(p) Then
      Copy p, n
      Del p
    End If
  End Function
  '重命名文件或文件夹
  Public Function Ren(ByVal path, ByVal newname)
    Ren = Rename(path,newname)
  End Function

  '取文件夹绝对路径
  Private Function absPath(ByVal p)
    Dim pt
    If YQasp.IsN(p) Then absPath = "" : Exit Function
    If Mid(p,2,1)<>":" Then
      If isWildcards(p) Then
        p = Replace(p,"*","[.$.[e.a.s.p.s.t.a.r].#.]")
        p = Replace(p,"?","[.$.[e.a.s.p.q.u.e.s].#.]")
        p = Server.MapPath(p)
        p = Replace(p,"[.$.[e.a.s.p.q.u.e.s].#.]","?")
        p = Replace(p,"[.$.[e.a.s.p.s.t.a.r].#.]","*")
      Else
        p = Server.MapPath(p)
      End If
    End If
    If Right(p,1) = "\" Then p = Left(p,Len(p)-1)
    absPath = p
  End Function
  '显示文件或文件夹在服务器上的存放位置（支持通配符*和?）
  Public Function MapPath(p)
    MapPath = absPath(p)
  End Function
  '格式化文件大小
  Public Function formatSize(Byval fileSize, ByVal level)
    Dim s : s = Int(fileSize) : level = UCase(level)
    formatSize = YQasp.IIF(s/(1073741824)>0.01,FormatNumber(s/(1073741824),2,-1,0,-1),"0.01") & " GB"
    If s = 0 Then formatSize = "0 GB"
    If level = "G" Or (level="AUTO" And s>1073741824) Then Exit Function
    formatSize = YQasp.IIF(s/(1048576)>0.1,FormatNumber(s/(1048576),1,-1,0,-1),"0.1") & " MB"
    If s = 0 Then formatSize = "0 MB"
    If level = "M" Or (level="AUTO" And s>1048576) Then Exit Function
    formatSize = YQasp.IIF((s/1024)>1,Int(s/1024),1) & " KB"
    If s = 0 Then formatSize = "0 KB"
    If Level = "K" Or (level="AUTO" And s>1024) Then Exit Function
    If level = "B" or level = "AUTO" Then
      formatSize = s & " bytes"
    Else
      formatSize = s
    End If
  End Function
  '路径是否包含通配符
  Private Function isWildcards(ByVal path)
    isWildcards = False
    If Instr(path,"*")>0 Or Instr(path,"?")>0 Then isWildcards = True
  End Function
  '文件或文件夹操作原型
  Private Function FOFO(ByVal fromPath, ByVal toPath, ByVal FOF, ByVal MOC)
    On Error Resume Next
    FOFO = True
    Dim ff,tf,oc,of,oi,ot,os
    'ff 来源路径         'tf 目标路径
    ff = absPath(fromPath) : tf = absPath(toPath)
    If FOF = 0 Then
    '如果是文件
      oc = isFile(ff) : of = "File" : oi = YQasp.Lang("fso-file")
    ElseIf FOF = 1 Then
    '如果是文件夹
      oc = isFolder(ff) : of = "Folder" : oi = YQasp.Lang("fso-folder")
    End If
    If MOC = 0 Then
      ot = "Copy" : os = YQasp.Lang("fso-copy")
    ElseIf MOC = 1 Then
      ot = "Move" : os = YQasp.Lang("fso-move")
    ElseIf MOC = 2 Then
      ot = "Delete" : os = YQasp.Lang("fso-delete")
    End If
    If oc Then
    '如果文件或文件夹存在
      If MOC<>2 Then
      '如果复制和移动
        If FOF = 0 Then
        '如果是文件
          If Right(toPath,1)="/" or Right(toPath,1)="\" Then
          '如果目标路径是文件夹，直接建立
            FOFO = MD(tf) : tf = tf & "\"
          Else
          '如果目标路径是文件，建立文件夹
            FOFO = MD(Left(tf,InstrRev(tf,"\")-1))
          End If
        ElseIf FOF = 1 Then
        '如果是文件夹则先建立目标文件夹
          tf = tf & "\"
          FOFO = MD(tf)
        End If
        '执行复制或者移动，如果是复制要考虑是否覆盖
        Execute("Fso."&ot&of&" ff,tf"&YQasp.IfThen(MOC=0,",b_overwrite"))
        'YQasp.wn("Fso."&ot&of&" "&ff&","&tf&","&b_overwrite&"")
      Else
        '删除，考虑是否删除只读
        Execute("Fso."&ot&of&" ff,b_force")
      End If
      If Err.Number<>0 Then
        FOFO = False
        If YQasp.Debug Then
          YQasp.Error.FunctionName = "YQasp.Fso.FOFO"
          YQasp.Error.Detail = Array(os, oi, frompath, YQasp.IIF(MOC =2 , "", os & YQasp.Lang("fso-to") & toPath))
          YQasp.Error.Raise "error-fso-control"
        End If
      End If
    ElseIf isWildcards(ff) Then
    '如果有通配符
'      If Not isFolder(Left(ff,InstrRev(ff,"\")-1)) Then
'        FOFO = False
'        YQasp.Error.Msg = "<br />" & os & oi & "失败！" & YQasp.IIF(MOC=2,"","源") & oi & "不存在( "&frompath&" )"
'        YQasp.Error.Raise 63
'      End If
      If MOC<>2 Then
      '复制和移动
        FOFO = MD(tf)
        Execute("Fso."&ot&of&" ff,tf"&YQasp.IIF(MOC=0,",b_overwrite",""))
      Else
      '删除
        Execute("Fso."&ot&of&" ff,b_force")
      End If
      If Err.Number<>0 Then
        FOFO = False
        If YQasp.Debug Then
          YQasp.Error.FunctionName = "YQasp.Fso.FOFO"
          YQasp.Error.Detail = Array(os, oi, frompath, YQasp.IIF(MOC = 2, "", os & YQasp.Lang("fso-to") & toPath))
          YQasp.Error.Raise "error-fso-control"
        End If
      End If
    Else
      FOFO = False
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp.Fso.FOFO"
        YQasp.Error.Detail = Array(os, oi, YQasp.IIF(MOC = 2, "", YQasp.Lang("fso-source")), frompath)
        YQasp.Error.Raise "error-fso-ctrlnotfound"
      End If
    End If
    Err.Clear()
  End Function
  '格式化文件属性
  Private Function Attr2Str(ByVal attrib)
    Dim a,s : a = Int(attrib)
    If a>=2048 Then a = a - 2048
    If a>=1024 Then a = a - 1024
    If a>=32 Then : s = "A" : a = a- 32 : End If
    If a>=16 Then a = a- 16
    If a>=8 Then a = a - 8
    If a>=4 Then : s = "S" & s : a = a- 4 : End If
    If a>=2 Then : s = "H" & s : a = a- 2 : End If
    If a>=1 Then : s = "R" & s : a = a- 1 : End If
    Attr2Str = s
  End Function
End Class
%>