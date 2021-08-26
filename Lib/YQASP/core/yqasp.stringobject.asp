<%
'######################################################################
'## YQasp.stringobject.asp
'## -------------------------------------------------------------------
'## Feature     :   YQAsp String Object Class
'## Version     :   1.0
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description :   Format a string with chaining operations.
'##
'######################################################################
'链式操作Str方法
Class YQAsp_StringObject
  Private s_source
  '设置源
  Public Property Let Value(ByRef string)
    If IsObject(string) Then
      Set s_source = string
    Else
      s_source = string
    End If
  End Property
  '读取处理后的源
  Public Default Property Get Value()
    If IsObject(s_source) Then
      Set Value = s_source
    Else
      Value = s_source
    End If
  End Property
  Private Function S(ByRef string)
    Set S = New YQAsp_StringObject
    S.Value = string
  End Function

  Public Function Format(ByVal value)
    Set Format = S(YQasp.Str.Format(s_source, value))
  End Function
  Public Function IsSame(ByVal string)
    IsSame = YQasp.Str.IsSame(s_source, string)
  End Function
  Public Function IsEqual(ByVal string)
    IsEqual = YQasp.Str.IsEqual(s_source, string)
  End Function
  Public Function Compare(ByVal t, ByVal b)
    Compare = YQasp.Str.Compare(s_source, t, b)
  End Function
  Public Function IsIn(string)
    IsIn = YQasp.Str.IsIn(s_source, string)
  End Function
  Public Function IsInList(ByVal string)
    IsInList = YQasp.Str.IsInList(s_source, string)
  End Function
  Public Function StartsWith(ByVal string)
    StartsWith = YQasp.Str.StartsWith(s_source, string)
  End Function
  Public Function EndsWith(ByVal string)
    EndsWith = YQasp.Str.EndsWith(s_source, string)
  End Function
  Public Function GetColonName()
    Set GetColonName = S(YQasp.Str.GetColonName(s_source))
  End Function
  Public Function GetColonValue()
    Set GetColonValue = S(YQasp.Str.GetColonValue(s_source))
  End Function
  Public Function GetName(ByVal separator)
    Set GetName = S(YQasp.Str.GetName(s_source, separator))
  End Function
  Public Function GetValue(ByVal separator)
    Set GetValue = S(YQasp.Str.GetValue(s_source, separator))
  End Function
  Public Function GetNameValue(ByVal separator)
    Set GetNameValue = S(YQasp.Str.GetNameValue(s_source, separator))
  End Function
  Public Function Cut(ByVal strlen)
    Set Cut = S(YQasp.Str.Cut(s_source, strlen))
  End Function
  Public Function Replace(ByVal rule, ByVal replaceWith)
    Set Replace = S(YQasp.Str.Replace(s_source, rule, replaceWith))
  End Function
  Public Function ReplaceLine(ByVal rule, ByVal replaceWith)
    Set ReplaceLine = S(YQasp.Str.ReplaceLine(s_source, rule, replaceWith))
  End Function
  Public Function ReplacePart(ByVal rule, ByVal group, ByVal replaceWith)
    Set ReplacePart = S(YQasp.Str.ReplacePart(s_source, rule, group, replaceWith))
  End Function
  Public Function Match(ByRef rule)
    Set Match = YQasp.Str.Match(s_source, rule)
  End Function
  Public Function [Test](ByRef rule)
    [Test] = YQasp.Str.Test(s_source, rule)
  End Function
  Public Function RegexpEncode()
    Set RegexpEncode = S(YQasp.Str.RegexpEncode(s_source))
  End Function
  Public Function TrimChar(ByVal char)
    Set TrimChar = S(YQasp.Str.TrimChar(s_source, char))
  End Function
  Public Function HtmlEncode()
    Set HtmlEncode = S(YQasp.Str.HtmlEncode(s_source))
  End Function
  Public Function HtmlDecode()
    Set HtmlDecode = S(YQasp.Str.HtmlDecode(s_source))
  End Function
  Public Function HtmlFilter()
    Set HtmlFilter = S(YQasp.Str.HtmlFilter(s_source))
  End Function
  Public Function HtmlFormat()
    Set HtmlFormat = S(YQasp.Str.HtmlFormat(s_source))
  End Function
  Public Function HtmlSafe()
    Set HtmlSafe = S(YQasp.Str.HtmlSafe(s_source))
  End Function
  Public Function ToString()
    Set ToString = S(YQasp.Str.ToString(s_source))
  End Function
  Public Function JsEncode()
    Set JsEncode = S(YQasp.Str.JsEncode(s_source))
  End Function
  Public Function JsEncode_(ByVal cn)
    Set JsEncode_ = S(YQasp.Str.JsEncode_(s_source, cn))
  End Function
  Public Function JavaScript()
    Set JavaScript = S(YQasp.Str.JavaScript(s_source))
  End Function
  Public Sub JsAlert()
    Call YQasp.Str.JsAlert(s_source)
  End Sub
  Public Sub JsAlertUrl(ByVal url)
    Call YQasp.Str.JsAlertUrl(s_source, url)
  End Sub
  Public Sub JsConfirmUrl(ByVal yesUrl, ByVal cancelUrl)
    Call YQasp.Str.JsConfirmUrl(s_source, yesUrl, cancelUrl)
  End Sub
  Public Function RandomStr()
    Set RandomStr = S(YQasp.Str.RandomStr(s_source))
  End Function
  Public Function RandomString(ByVal allowStr)
    Set RandomString = S(YQasp.Str.RandomString(s_source, allowStr))
  End Function
  Public Function RandomNumber(ByVal max)
    Set RandomNumber = S(YQasp.Str.RandomNumber(s_source, max))
  End Function
  Public Function ToNumber(ByVal decimalType)
    Set ToNumber = S(YQasp.Str.ToNumber(s_source, decimalType))
  End Function
  Public Function ToPrice()
    Set ToPrice = S(YQasp.Str.ToPrice(s_source))
  End Function
  Public Function ToPercent()
    Set ToPercent = S(YQasp.Str.ToPercent(s_source))
  End Function
  Public Function Half2Full()
    Set Half2Full = S(YQasp.Str.Half2Full(s_source))
  End Function
  Public Function Full2Half()
    Set Full2Half = S(YQasp.Str.Full2Half(s_source))
  End Function
  Public Function Validate()
    Set Validate = S(YQasp.Str.Validate(s_source))
  End Function

  '将ASP函数重写为链式操作
  'Replace
  Public Function Rep(ByVal find, ByVal replacewith)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set Rep = S(o_re.Re(s_source, find, replaceWith))
    Set o_re = Nothing
  End Function
  'Replace 忽略大小写
  Public Function iReplace(ByVal find, ByVal replaceWith)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set iReplace = S(o_re.ReCase(s_source, find, replaceWith))
    Set o_re = Nothing
  End Function
  'Replace 完整参数
  Public Function RepAll(ByVal find, ByVal replaceWith, ByVal start, ByVal count, ByVal compare)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set RepAll = S(o_re.ReFull(s_source, find, replaceWith, start, count, compare))
    Set o_re = Nothing
  End Function
  Public Function Instr(ByVal string)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Instr = o_re.Instr_(s_source, string)
    Set o_re = Nothing
  End Function
  Public Function InstrAll(ByVal string, ByVal start, ByVal compare)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    InstrAll = o_re.Instr__(s_source, string, start, compare)
    Set o_re = Nothing
  End Function
  Public Function InStrRev(ByVal string)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    InStrRev = o_re.InStrRev_(s_source, string)
    Set o_re = Nothing
  End Function
  Public Function InStrRevAll(ByVal string, ByVal start, ByVal compare)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    InStrRevAll = o_re.InStrRev__(s_source, string, start, compare)
    Set o_re = Nothing
  End Function
  Public Function LCase()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set LCase = S(o_re.LCase_(s_source))
    Set o_re = Nothing
  End Function
  Public Function Left(ByVal length)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set Left = S(o_re.Left_(s_source, length))
    Set o_re = Nothing
  End Function
  Public Function Len()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Len = o_re.Len_(s_source)
    Set o_re = Nothing
  End Function
  Public Function LTrim()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set LTrim = S(o_re.LTrim_(s_source))
    Set o_re = Nothing
  End Function
  Public Function RTrim()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set RTrim = S(o_re.RTrim_(s_source))
    Set o_re = Nothing
  End Function
  Public Function Trim()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set Trim = S(o_re.Trim_(s_source))
    Set o_re = Nothing
  End Function
  Public Function Mid(ByVal start)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set Mid = S(o_re.Mid_(s_source, start))
    Set o_re = Nothing
  End Function
  Public Function MidAll(ByVal start, ByVal length)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set MidAll = S(o_re.Mid__(s_source, start, length))
    Set o_re = Nothing
  End Function
  Public Function Right(ByVal length)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set Right = S(o_re.Right_(s_source, length))
    Set o_re = Nothing
  End Function
  Public Function StrComp(ByVal string)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    StrComp = o_re.StrComp_(s_source, string)
    Set o_re = Nothing
  End Function
  Public Function StrCompAll(ByVal string, ByVal compare)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    StrCompAll = o_re.StrComp__(s_source, string, compare)
    Set o_re = Nothing
  End Function
  Public Function StrReverse()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set StrReverse = S(o_re.StrReverse_(s_source))
    Set o_re = Nothing
  End Function
  Public Function Split(ByVal separator)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Split = o_re.Split_(s_source, separator)
    Set o_re = Nothing
  End Function
  Public Function UCase()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Set UCase = S(o_re.UCase_(s_source))
    Set o_re = Nothing
  End Function

  Public Function CDate()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    CDate = o_re.CDate_(s_source)
    Set o_re = Nothing
  End Function
  Public Function IsDate()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    IsDate = o_re.IsDate_(s_source)
    Set o_re = Nothing
  End Function
  Public Function Asc()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Asc = o_re.Asc_(s_source)
    Set o_re = Nothing
  End Function
  Public Function CBool()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    CBool = o_re.CBool_(s_source)
    Set o_re = Nothing
  End Function
  Public Function CByte()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    CByte = o_re.CByte_(s_source)
    Set o_re = Nothing
  End Function
  Public Function CCur()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    CCur = o_re.CCur_(s_source)
    Set o_re = Nothing
  End Function
  Public Function CDbl()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    CDbl = o_re.CDbl_(s_source)
    Set o_re = Nothing
  End Function
  Public Function Chr()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Chr = o_re.Chr_(s_source)
    Set o_re = Nothing
  End Function
  Public Function CInt()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    CInt = o_re.CInt_(s_source)
    Set o_re = Nothing
  End Function
  Public Function CLng()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    CLng = o_re.CLng_(s_source)
    Set o_re = Nothing
  End Function
  Public Function CSng()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    CSng = o_re.CSng_(s_source)
    Set o_re = Nothing
  End Function
  Public Function CStr()
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    CStr = o_re.CStr_(s_source)
    Set o_re = Nothing
  End Function
    
  Public Function Round(ByVal numdecimalplaces)
    Dim o_re : Set o_re = New YQAsp_StringOriginal
    Round = o_re.Round_(s_source, numdecimalplaces)
    Set o_re = Nothing
  End Function
End Class
%>