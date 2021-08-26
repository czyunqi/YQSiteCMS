<%
'######################################################################
'## run.asp
'## -------------------------------------------------------------------
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-8-9
'## Description :   api全局入口
'##
'######################################################################
%>
<%
  Dim result : Set result = YQAsp.Json.NewObject
  Dim code : code = 200
  Dim msg : msg = "获取成功!"
  Dim data : Set data = YQAsp.Json.NewObject
  Dim rs, sql
  YQAsp.Json.EncodeUnicode = False '不用\uxxxx形式编码生成JSON中的中文字符

  YQAsp.Include Module
  
  Execute(View&"()")

  result.Put "code", code
  result.Put "msg", msg
  result.Put "data", data
  result.Put "time", YQAsp.GetScriptTime()

  YQAsp.Echo result.toString()
  Set data = Nothing
  Set result = Nothing
%>

<%
'## -------------------------------------------------------------------
'## 校验请求方式
'## method string 请求方式
'## -------------------------------------------------------------------
Function checkMethod(method)
  If YQAsp.IsN(method) Then 
    checkMethod = true
    Exit Function
  End If
  If YQAsp.Str.IsSame(YQAsp.GetMethod(), method) = false then
    checkMethod = false
    code = 300
    msg = "仅支持" & method & "请求!"
    Exit Function
  Else
    checkMethod = true
    Exit Function
  End If
End Function

'## -------------------------------------------------------------------
'## 验证请求域名
'## -------------------------------------------------------------------
Function checkDomain()
  Dim r : r = True

  If YQAsp.GetHeaderVal("Host")<>"www.czyunqi.com" and YQAsp.GetHeaderVal("Host")<>"localhost:8512"  Then
    r = False
    code = 300
    msg = "非法请求来源!"
  End If

  checkDomain = r
End Function

'## -------------------------------------------------------------------
'## 验证请求Ip
'## -------------------------------------------------------------------
Function checkIp()
  Dim clientIp : clientIp = YQAsp.GetIP()
  YQAsp.Print clientIp
End Function
%>