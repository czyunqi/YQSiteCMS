<%
'######################################################################
'## YQasp.error.asp
'## -------------------------------------------------------------------
'## Feature     :   YQAsp Exception Class
'## Version     :   1.0
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description :   Deal with the YQAsp Exception
'##
'######################################################################
Class YQAsp_Error
  Private b_redirect, b_continue, b_console
  Private i_errNum, i_delay, i_errLine, i_codeCache
  Private s_title, s_url, s_css, s_msg, s_funName
  Private o_err, a_detail, o_codeList
  Private e_err, e_conn, e_dom
  Private Sub Class_Initialize()
    i_errNum    = ""
    i_delay     = 5
    i_errLine   = 0
    i_codeCache = 5
    s_title     = YQasp.Lang("error-title")
    b_redirect  = False
    b_console   = True
    b_continue  = False
    s_url       = "javascript:history.go(-1)"
    Set o_err   = Server.CreateObject("Scripting.Dictionary")
    o_err.CompareMode = 1
  End Sub
  Private Sub Class_Terminate()
    If IsObject(o_codeList) Then Set o_codeList = Nothing
    Set o_err = Nothing
    If IsObject(e_err) Then Set e_err = Nothing
    If IsObject(e_conn) Then Set e_conn = Nothing
    If IsObject(e_dom) Then Set e_dom = Nothing
  End Sub
  '设置或读取自定义的错误代码和错误信息
  Public Default Property Get E(ByVal n)
    If IsNumeric(n) Then n = "E" & n
    If o_err.Exists(n) Then
      E = Join(o_err(n), "|")
    Else
      E = YQasp.Lang("error-unkown")
    End If
  End Property
  Public Property Let E(ByVal n, ByVal s)
    Dim a_info, i_tmp
    If YQasp.Has(n) And YQasp.Has(s) Then
      If IsNumeric(n) Then n =  "E" & n
      a_info = Split(s, "|")
      i_tmp = UBound(a_info)
      If i_tmp < 2 Then
        a_info = Split(s & String(2 - i_tmp, "|"), "|")
      End If
      o_err(n) = a_info
    End If
  End Property
  '取最后一次发生错误的代码
  Public Property Get LastError
    LastError = i_errNum
  End Property
  '设置和读取错误信息标题
  Public Property Get Title
    Title = s_title
  End Property
  Public Property Let Title(ByVal s)
    s_title = s
  End Property
  '设置显示错误信息时的详细信息替换参数
  Public Property Let Detail(ByVal arr)
    a_detail = arr
  End Property
  '设置和读取出错函数名
  Public Property Get FunctionName
    FunctionName = s_funName
  End Property
  Public Property Let FunctionName(ByVal string)
    s_funName = string
  End Property
  '设置和读取页面是否自动转向
  Public Property Get [Redirect]
    [Redirect] = b_redirect
  End Property
  Public Property Let [Redirect](ByVal b)
    b_redirect = b
  End Property
  '设置和读取Debug模式下出错后是否继续运行后面的代码
  '说明：普通模式下总是继续运行
  Public Property Get OnErrorContinue
    OnErrorContinue = b_continue
  End Property
  Public Property Let OnErrorContinue(ByVal bool)
    b_continue = bool
  End Property
  '设置和读取是否在控制台内显示详细错误信息
  Public Property Get ConsoleDetail
    ConsoleDetail = b_console
  End Property
  Public Property Let ConsoleDetail(ByVal bool)
    b_console = bool
  End Property
  '设置和读取发生错误后的跳转页地址
  '说明：如不设置此属性，则默认为返回前一页
  Public Property Get Url
    Url = s_url
  End Property
  Public Property Let Url(ByVal s)
    s_url = s
  End Property
  '设置和读取自动跳转页面等待时间（秒）
  Public Property Get Delay
    Delay = i_delay
  End Property
  Public Property Let Delay(ByVal i)
    i_delay = i
  End Property
  '设置和读取显示错误信息DIV的CSS样式名称
  Public Property Get ClassName
    ClassName = s_css
  End Property
  Public Property Let ClassName(ByVal s)
    s_css = s
  End Property
  '设置错误行号
  Public Property Let LineNumber(ByVal i)
    i_errLine = i
  End Property
  '设置要保存最后执行的语句的数量
  Public Property Let LastCodeCache(ByVal i)
    i_codeCache = i
  End Property

  'Dom和Connection错误
  Public Sub SetErrors(ByRef e, ByRef ec, ByRef ed)
    If isObject(e) Then Set e_err = e
    If IsObject(ec) Then Set e_conn = ec
    If isObject(ed) Then Set e_dom = ed
  End Sub
  
  '生成一个错误(常用于开发者错误模式)
  Public Sub Raise(ByVal n)
    If YQasp.isN(n) Then Exit Sub
    If IsNumeric(n) Then n = "E" & n
    If Not IsObject(e_err) Then Set e_err = Err
    Dim b_consoleDetail, b_isEnd
    Dim msg
    '得到已定义错误信息
    msg = o_err(n)
    '如果是Debug模式，出错后是否继续运行
    b_isEnd = YQasp.IIF(YQasp.Debug , Not b_continue, False)
    '在控制台内输出错误信息
    InConsole msg, b_console
    If b_isEnd Then
      YQasp.PrintEnd ShowErrorMsg(msg)
    Else
      YQasp.Print ShowErrorMsg(msg)
    End If
    i_errNum = n
    s_msg = ""
  End Sub
  
  '立即抛出一个错误信息(常用于用户错误模式)
  Public Sub Throw(ByVal msg)
    Dim a_info, i_tmp
    If YQasp.Has(msg) Then
      a_info = Split(msg, "|")
      i_tmp = UBound(a_info)
      If i_tmp < 2 Then
        a_info = Split(msg & String(2 - i_tmp, "|"), "|")
      End If
      YQasp.Print ShowErrorMsg(a_info)
    End If
  End Sub

  Public Sub Inject(ByRef object_err, ByVal string_filePath, ByVal int_lineNumber, ByVal string_sourceCode)
    If YQasp.Debug Then
      If Not IsObject(o_codeList) Then Set o_codeList = YQasp.Json.NewArray
      YQasp.Error.SetErrors object_err, Null, Null
      YQasp.Error.LineNumber = int_lineNumber
      o_codeList.Add Array(string_sourceCode, string_filePath, int_lineNumber)
      If object_err.Number<>0 Then
        YQasp.Error.Throw "Microsoft VBScript 运行时错误"
        object_err.Clear
        i_errLine = 0
        If Not b_continue Then YQasp.Exit
      End If
    End If
  End Sub
  
  '在控制台中抛出错误信息
  Public Sub Console(ByVal n)
    If YQasp.isN(n) Then Exit Sub
    If IsNumeric(n) Then n = "E" & n
    Dim msg
    msg = o_err(n)
    InConsole msg, YQasp.Debug
  End Sub
  
  '控制台输出错误：
  Private Sub InConsole(ByVal msg, ByVal hasDetail)
    If YQasp.Console.Enable Then
      Dim SB : Set SB = YQasp.Str.StringBuilder()
      SB.Append "[Error] "
      SB.Append msg(0)
      If hasDetail Then
        SB.Append " ("
        If YQasp.Has(msg(1)) Then
          If Left(msg(1), 1) = ":" Then msg(1) = Mid(msg(1), 2)
          SB.Append "详细信息：" & YQasp.Str.Format(msg(1), a_detail) & "; "
        End If
        If YQasp.Has(s_funName) Then SB.Append "来源函数：" & s_funName & "; "
        SB.Append "请求URL：" & YQasp.GetUrl("") & "; "
        SB.Append "请求方式：" & Request.ServerVariables("REQUEST_METHOD") & "; "
        Dim s_ref : s_ref = Request.ServerVariables("HTTP_REFERER")
        If YQasp.Has(s_ref) Then
          SB.Append "来源URL：" & s_ref
        End If
        If Err.Number <> 0 Then
          SB.Append "; 错误代码：" & Err.Number
          SB.Append "; 错误描述：" & Err.Description
          SB.Append "; 错误来源：" & Err.Source
        End If
        If YQasp.Has(msg(2)) Then SB.Append"; 处理建议：" & msg(2)
        SB.Append ")"
      End If
      YQasp.Console SB.ToString()
      Set SB = Nothing
    End If
  End Sub
  
  '显示错误信息框
  Private Function ShowErrorMsg(ByVal msg)
    Dim SB, key, s_ref, i, lines
    s_ref = Request.ServerVariables("HTTP_REFERER")
    Set SB = YQasp.Str.StringBuilder()
    If YQasp.IsN(s_css) Then
      s_css = "YQasp-error"
      SB.Append "<style>.YQasp-error{width:70%;font-size:12px;font-family:""Microsoft Yahei"";margin:10px auto;padding:10px 20px;}.YQasp-error legend{margin:0 0 5px 0;padding:0 10px;font-size:14px;font-weight:bolder;}.YQasp-error p{margin:0 0 10px 0;padding:0;}.YQasp-error p.msg{font-size:14px;}.YQasp-error p a:link{color:#09F;}.YQasp-error p a:hover{color:#090;}.YQasp-error h3{font-size:12px;margin:0 0 10px 0;padding:0;font-weight:normal;}.YQasp-error h3 .title{font-weight:bolder;}.YQasp-error h3 a{color:#090;text-decoration:none;font-family:consolas;}.YQasp-error .info{margin-bottom:10px;margin-top:-6px;}.YQasp-error ul.list{margin:0;padding:0;}.YQasp-error ul.list li{list-style:none;margin:0 24px;color:#666;line-height:1.6em;word-break:break-all;}.YQasp-error ul.list li strong{color:#555;}.YQasp-error table{font-size:12px;width:95%;margin:0 10px;font-family:consolas;line-height:14px;}.YQasp-error table td{padding:0;margin:0;color:#666}.YQasp-error .code{background-color:#F7F7F7;padding:0 3px;}</style>"
    End If
    SB.Append "<fieldset id=""YQaspError"" class="""
    SB.Append s_css
    SB.Append """>"
    SB.Append "<legend>"
    SB.Append s_title
    SB.Append "</legend>"
    SB.Append "<p class=""msg"">"
    SB.Append msg(0)
    SB.Append "</p>"
    If YQasp.Debug Then
      '显示详细错误信息
      SB.Append "<h3><a href=""javascript:toggle('YQasp_err_detail')"" id=""YQasp_err_detail_m"">[-]</a> <span class=""title"">详细错误信息</span></h3>"
      SB.Append "<div class=""info"" id=""YQasp_err_detail"">"
      SB.Append "<ul class=""list"">"
      If YQasp.Has(msg(1)) Then
        If Left(msg(1), 1) = ":" Then msg(1) = Mid(msg(1), 2)
        SB.Append "<li><strong>错误信息 : </strong>"
        SB.Append YQasp.Str.Format(msg(1), a_detail)
        SB.Append "</li>"
      End If
      If YQasp.Has(s_funName) Then
        SB.Append "<li><strong>来源函数 : </strong>"
        SB.Append s_funName
        SB.Append "</li>"
      End If
      SB.Append "<li><strong>请求URL : </strong>"
      SB.Append YQasp.GetUrl("")
      SB.Append "</li>"
      SB.Append "<li><strong>请求方式 : </strong>"
      SB.Append Request.ServerVariables("REQUEST_METHOD")
      SB.Append "</li>"
      IF YQasp.Has(s_ref) Then
        SB.Append "<li><strong>来源URL : </strong>"
        SB.Append s_ref
        SB.Append "</li>"
      End If
      If IsObject(e_conn) Then
        If e_conn.Errors.Count > 0 Then
          If e_conn.Errors(0).Number <> 0 Then
            With e_conn.Errors(0)
              SB.Append "<li><strong>数据库类型 : </strong>"
              SB.Append YQasp.Db.GetTypeVersion(e_conn)
              SB.Append "</li>"
              SB.Append "<li><strong>错误代码 : </strong>"
              SB.Append .Number
              SB.Append "</li>"
              SB.Append "<li><strong>错误描述 : </strong>"
              SB.Append .Description
              SB.Append "</li>"
              SB.Append "<li><strong>源错代码 : </strong>"
              SB.Append .NativeError
              SB.Append "</li>"
              SB.Append "<li><strong>错误来源 : </strong>"
              SB.Append .Source
              SB.Append "</li>"
              SB.Append "<li><strong>SQL 错误码 : </strong>"
              SB.Append .SQLState
              SB.Append "</li>"
              If YQasp.Log.Enable Then
                YQasp.Log.Error msg(0) & YQasp.IfThen(YQasp.Has(msg(1)), ", " & YQasp.Str.Format(msg(1), a_detail)) & _
                               " [数据库]" & YQasp.Db.GetTypeVersion(e_conn) & ", " & _
                               "[错误描述]" & .Description & ", " & _
                               "[源错代码]" & .NativeError & ", " & _
                               "[错误来源]" & .Source _
                               , YQasp.IIF(YQasp.Has(s_funName), "function : " & s_funName, "db error")
              End If
            End With
          End If
        End If
      End If
      If IsObject(e_dom) Then
        If e_dom.errorCode <> 0 Then
          With e_dom
            SB.Append "<li><strong>DOM错误代码 : </strong>"
            SB.Append .errorCode
            SB.Append "</li>"
            SB.Append "<li><strong>DOM错误原因 : </strong>"
            SB.Append .reason
            SB.Append "</li>"
            SB.Append "<li><strong>DOM错误来源 : </strong>"
            SB.Append .url
            SB.Append "</li>"
            SB.Append "<li><strong>DOM错误行号 : </strong>"
            SB.Append .line
            SB.Append "</li>"
            SB.Append "<li><strong>DOM错误位置 : </strong>"
            SB.Append .linepos
            SB.Append "</li>"
            SB.Append "<li><strong>DOM源文本 : </strong>"
            SB.Append .srcText
            SB.Append "</li>"
          End With
        End If
      End If
      If Not IsObject(e_conn) And Not IsObject(e_dom) And IsObject(e_err) Then
        If e_err.Number <> 0 Then
          SB.Append "<li><strong>错误代码 : </strong>"
          SB.Append e_err.Number
          SB.Append "</li>"
          SB.Append "<li><strong>错误描述 : </strong>"
          SB.Append e_err.Description
          SB.Append "</li>"
          SB.Append "<li><strong>错误来源 : </strong>"
          SB.Append e_err.Source
          SB.Append "</li>"
        End If
        If i_errLine > 0 Then
          If o_codeList.Length > 0 Then
            SB.Append "<li><strong>错误行代码栈 : </strong>"
            SB.Append "<table>"
            lines = o_codeList.Length - i_codeCache
            If lines < 0 Then lines = 0
            For i = lines To o_codeList.Length - 1
              If IsArray(o_codeList(i)) Then
                SB.Append "<tr>"
                SB.Append "<td>"
                SB.Append o_codeList(i)(1)
                SB.Append ", line "
                SB.Append o_codeList(i)(2)
                If i = (o_codeList.Length - 1) Then
                  SB.Append " (错误行)"
                  If YQasp.Log.Enable Then
                    YQasp.Log.Error "VBScript 运行时错误。错误代码 : " & e_err.Number & _
                                   ", 错误描述 : " & e_err.Description & _
                                   ", 错误来源 : " & e_err.Source, _
                                   o_codeList(i)(1) & ":" & o_codeList(i)(2)
                  End If
                End If
                SB.Append ": <span class=""code"">"
                SB.Append YQasp.Str.HtmlEncode(o_codeList(i)(0))
                SB.Append "</span></td>"
                SB.Append "<tr>"
              End If
            Next
            SB.Append "</table>"
            SB.Append "</li>"
          End If
        End If
      End If

      If YQasp.Has(msg(2)) Then
        If Left(msg(2), 1) = ":" Then msg(2) = Mid(msg(2), 2)
        SB.Append "<li><strong>处理建议 : </strong>"
        SB.Append msg(2)
        SB.Append "</li>"
      End If
      SB.Append "</ul>"
      SB.Append "</div>"
      '显示QueryString
      If Request.QueryString.Count > 0 Then
        SB.Append "<h3><a href=""javascript:toggle('YQasp_err_querystring')"" id=""YQasp_err_querystring_m"">[-]</a> <span class=""title"">Query String 参数</span></h3>"
        SB.Append "<div class=""info"" id=""YQasp_err_querystring"">"
        SB.Append "<ul class=""list"">"
        For Each key In Request.QueryString
          SB.Append "<li><strong>"
          SB.Append key
          SB.Append " : </strong>"
          SB.Append Request.QueryString(key)
          SB.Append "</li>"
        Next
        SB.Append "</ul>"
        SB.Append "</div>"
      End If
      '显示Form
      If Request.Form.Count > 0 Then
        SB.Append "<h3><a href=""javascript:toggle('YQasp_err_form')"" id=""YQasp_err_form_m"">[-]</a> <span class=""title"">表单数据</span></h3>"
        SB.Append "<div class=""info"" id=""YQasp_err_form"">"
        SB.Append "<ul class=""list"">"
        For Each key In Request.Form
          SB.Append "<li><strong>"
          SB.Append key
          SB.Append " : </strong>"
          SB.Append Request.Form(key)
          SB.Append "</li>"
        Next
        SB.Append "</ul>"
        SB.Append "</div>"
      End If
      '显示HTTP报头
      Dim keyName
      SB.Append "<h3><a href=""javascript:toggle('YQasp_err_http')"" id=""YQasp_err_http_m"">[+]</a> <span class=""title"">HTTP 报头</span></h3>"
      SB.Append "<div class=""info"" id=""YQasp_err_http"" style=""display:none;"">"
      SB.Append "<ul class=""list"">"
      key = Split(Request.ServerVariables("ALL_HTTP"), vbLf)
      For i = 0 To UBound(key)-1
        keyName = LCase(YQasp.Str.Replace(YQasp.Str.GetColonName(key(i)), "^http_", ""))
        SB.Append "<li><strong>"
        SB.Append UCase(Left(keyName,1)) & Mid(keyName,2)
        SB.Append " : </strong>"
        SB.Append YQasp.Str.GetColonValue(key(i))
        SB.Append "</li>"
      Next
      SB.Append "</ul>"
      SB.Append "</div>"
    Else
      '显示普通模式详细错误信息
      If (YQasp.Has(msg(1)) And Left(msg(1), 1) <> ":") Or YQasp.Has(msg(2)) Then
        SB.Append "<h3><a href=""javascript:toggle('YQasp_err_detail')"" id=""YQasp_err_detail_m"">[-]</a> <span class=""title"">详细错误信息</span></h3>"
        SB.Append "<div class=""info"" id=""YQasp_err_detail"">"
        SB.Append "<ul class=""list"">"
        If YQasp.Has(msg(1)) And Left(msg(1), 1) <> ":" Then
          SB.Append "<li><strong>错误信息 : </strong>"
          SB.Append YQasp.Str.Format(msg(1), a_detail)
          SB.Append "</li>"
        End If
        If YQasp.Has(msg(2)) And Left(msg(2), 1) <> ":" Then
          SB.Append "<li><strong>处理建议 : </strong>"
          SB.Append msg(2)
          SB.Append "</li>"
        End If
        SB.Append "</ul>"
        SB.Append "</div>"
      End If
    End If
    SB.Append "<p class=""redirect"">"
    If YQasp.Str.IsSame(s_ref, YQasp.GetUrl("")) Or YQasp.IsN(s_ref) Then
      b_redirect = False
      s_url = "javascript:location.reload(true)"
    End If
    If b_redirect Then
      SB.Append "页面将在<span id=""YQasp_timeoff"">"
      SB.Append i_delay
      SB.Append "</span>秒钟后跳转，如果浏览器没有正常跳转，"
    End If
    SB.Append "<a href="""
    SB.Append s_url
    SB.Append """>请点击此处"
    If YQasp.Str.IsSame(s_url, "javascript:history.go(-1)") Then
      SB.Append "返回"
    ElseIf YQasp.Str.IsSame(s_url, "javascript:location.reload(true)") Then
      SB.Append "刷新"
    Else
      SB.Append "继续"
    End If
    SB.Append "</a></p>"
    SB.Append "<script type=""text/javascript"">function toggle(id){var el = document.getElementById(id);var a = document.getElementById(id+""_m"");if(a.innerHTML==""[-]""){el.style.display = ""none"";a.innerHTML = ""[+]"";}else if(a.innerHTML==""[+]""){el.style.display = """";a.innerHTML = ""[-]"";}}"
    If b_redirect Then
      SB.Append "function timeMinus(){var el = document.getElementById(""YQasp_timeoff"");var timeLeft = parseInt(el.innerHTML);el.innerHTML = timeLeft - 1;} setInterval(timeMinus, 1000);"
      SB.Append "setTimeout(function(){"
      If YQasp.Str.IsSame(Left(s_url,11), "javascript:") Then
        SB.Append Mid(s_url, 12)
      Else
        SB.Append "location.href='"
        SB.Append s_url
        SB.Append "'"
      End If
      SB.Append "},"
      SB.Append i_delay * 1000
      SB.Append ");"
    End If
    SB.Append "</script></fieldset>"
    ShowErrorMsg = SB.ToString()
    Set SB = Nothing
  End Function
  
  '显示已定义的所有错误代码及信息，返回Json格式
  Public Function Defined()
    Defined = YQasp.Str.ToString(o_err)
  End Function
End Class
%>