<%
'#################################################################################
'##  YQasp.bs.asp
'##  ------------------------------------------------------------------------------
'##  Feature      :  YQAsp Bootstrap 代码片段生成插件
'##  Version      :  1.0
'##  For YQAsp  :  3.0+
'##  Author      :   云奇(114066164@qq.com)
'##  Update Date :   2021-7-15
'#################################################################################
Class YQAsp_Bs
	'定义内部变量
	Private s_ver, s_source, s_val
	'构造方法
	Private Sub Class_Initialize()
		s_ver = 3
	End Sub
	'设置或获取BS版本，可选值为：3或4，默认为3
	Public Property Get Ver()
		Ver = s_ver
	End Property
	Public Property Let Ver(ByVal String)
		s_ver = String
	End Property
	Public Function [New]()
		Set [New] = New YQAsp_Bs
	End Function
	'设置代码片段源文本
	Public Default Function Str(ByVal String)
		Set Str = New YQAsp_BsCode
		If YQasp.Str.IsInList("btn,btna,dropdown,btnGroup,FormInline,Form",YQasp.Str.GetName(String,":")) Then 
			Str.Code = Str.Tag(String,YQasp.Str.GetValue(String, ":"))
		Else 
			Str.Code = String
		End If 
	End Function
End Class


Class YQAsp_BsCode
	Private s_source
	'设置源
	Public Property Let Code(ByRef String)
		s_source = String
	End Property
	'读取处理后的源
	Public Default Property Get Code()
		s_source = YQasp.Str.iReplace(s_source,"{col-l}","col-sm-3")
		s_source = YQasp.Str.iReplace(s_source,"{col-r}","col-sm-9")
		Dim Match,Matches
		Set Matches = YQasp.Str.Match(s_source, "{(.+?)}")
		For Each Match In Matches
			s_source = Replace(s_source, Match.Value, "")
		Next
		Code = s_source
	End Property
	'根据参数取得对应代码片段
	Public Function Tag(ByVal t, ByVal l)
		listType = l
		Dim q : Set q = New YQAsp_Str_StringBuilder
		Select Case YQasp.Str.GetName(t, ":")
			Case "btn"
				q.Append "<button type=""{type}"" class=""btn btn-default {css}"" id=""{id}"" onClick=""{url}"" {disabled}>{str}</button>"
			Case "btna"
				q.Append "<a href=""{url}"" class=""btn btn-default {css}"" id=""{id}"" role=""button"" {disabled}>{str}</a>"
			Case "dropdown"
				q.Append "<div class=""drop{type}"">"
				q.Append "<button class=""btn dropdown-toggle btn-default {css}"" type=""button"" id=""{id}"" data-toggle=""dropdown"" aria-haspopup=""true"" aria-expanded=""true"" {disabled}>{str} <span class=""caret""></span></button>"
				q.Append "<ul class=""dropdown-menu"" aria-labelledby=""{id}"">{loop}</ul></div>"
			Case "btnGroup"
				q.Append "<div class=""btn-group drop{type}"" id=""{id}"">"
				q.Append "<button type=""button"" class=""btn btn-default {css}"" {disabled}>{str}</button>"
				q.Append "<button type=""button"" class=""btn btn-default {css} dropdown-toggle"" data-toggle=""dropdown"" aria-haspopup=""true"" aria-expanded=""false""><span class=""caret""></span></button>"
				q.Append "<ul class=""dropdown-menu"">{loop}</ul></div>"
			Case "FormInline"
				Select Case YQasp.Str.GetValue(t, ":")
					Case "text"
						q.Append "<div class=""form-group"">"
						q.Append "<label {labelhide} for=""{id}"">{str}</label> "
						q.Append "<input type=""{type}"" class=""form-control {css}"" id=""{id}"" name=""{name}"" placeholder=""{ph}"" value=""{val}"" {disabled}>"
						q.Append "</div>"
					Case "textarea"
						q.Append "<div class=""form-group"">"
						q.Append "<label {labelhide} for=""{id}"">{str}</label> "
						q.Append "<textarea class=""form-control {css}"" rows=""{row}"" id=""{id}"" name=""{name}"" placeholder=""{ph}"" {disabled}>{val}</textarea>"
						q.Append "</div>"
					Case "checkbox"
						q.Append "<div class=""form-group"">{loop}</div>"
					Case "radio"
						q.Append "<div class=""form-group"">{loop}</div>"
					Case "select"
						q.Append "<div class=""form-group"">"
						q.Append "<label {labelhide} for=""{id}"">{str}</label> "
						q.Append "<select {multiple} size=""{size}"" class=""form-control"">"
						q.Append "{loop}"
						q.Append "</select>"
						q.Append "</div>"
					Case "static"
						q.Append "<div class=""form-group"">"
						q.Append "<label {labelhide} for=""{id}"">{str}</label> "
						q.Append "<p class=""form-control-static {css}"">{val}</p>"
						q.Append "</div>"
				End Select
			Case "Form"
				Select Case YQasp.Str.GetValue(t, ":")
					Case "text"
						q.Append "<div class=""form-group"">"
						q.Append "<label class=""{col-l} control-label"" for=""{id}"">{label}</label>"
						q.Append "<div class=""{col-r}"">"
						q.Append "<input type=""{type}"" class=""form-control {css}"" id=""{id}"" name=""{name}"" placeholder=""{ph}"" value=""{val}"" {disabled}>"
						q.Append "</div></div>"
					Case "textarea"
						q.Append "<div class=""form-group"">"
						q.Append "<label class=""{col-l} control-label"" for=""{id}"">{label}</label>"
						q.Append "<div class=""{col-r}"">"
						q.Append "<textarea class=""form-control {css}"" rows=""{row}"" id=""{id}"" name=""{name}"" placeholder=""{ph}"" {disabled}>{val}</textarea>"
						q.Append "</div></div>"
					Case "checkbox"
						q.Append "<div class=""form-group"">"
						q.Append "<label class=""{col-l} control-label"" for=""{id}"">{label}</label>"
						q.Append "<div class=""{col-r}"">"
						q.Append "{loop}"
						q.Append "</div></div>"
					Case "radio"
						q.Append "<div class=""form-group"">"
						q.Append "<label class=""{col-l} control-label"" for=""{id}"">{label}</label>"
						q.Append "<div class=""{col-r}"">"
						q.Append "{loop}"
						q.Append "</div></div>"
					Case "select"
						q.Append "<div class=""form-group"">"
						q.Append "<label class=""{col-l} control-label"" for=""{id}"">{label}</label>"
						q.Append "<div class=""{col-r}"">"
						q.Append "<select {multiple} size=""{size}"" class=""form-control"">"
						q.Append "{loop}"
						q.Append "</select>"
						q.Append "</div></div>"
					Case "static"
						q.Append "<div class=""form-group"">"
						q.Append "<label class=""{col-l} control-label"" for=""{id}"">{label}</label>"
						q.Append "<div class=""{col-r}"">"
						q.Append "<p class=""form-control-static {css}"">{val}</p>"
						q.Append "</div></div>"
				End Select
		End Select
		Tag = q.ToString
	End Function
	Private Function S(ByRef String)
		Set S = New YQAsp_BsCode
		S.Code = String
	End Function
	'替换Str字符串
	Public Function Str(ByVal value)
		Set Str = S(YQasp.Str.iReplace(s_source,"{str}",value))
	End Function
	'替换ID
	Public Function Id(ByVal value)
		Set Id = S(YQasp.Str.iReplace(s_source,"{id}",value))
	End Function
	'替换Name
	Public Function Name(ByVal value)
		Set Name = S(YQasp.Str.iReplace(s_source,"{name}",value))
	End Function
	'替换CSS
	Public Function Css(ByVal value)
		Set Css = S(YQasp.Str.iReplace(s_source,"{css}",value))
	End Function
	'替换Type
	Public Function [Type](ByVal value)
		Set [Type] = S(YQasp.Str.iReplace(s_source,"{type}",value))
	End Function
	'替换Label
	Public Function Label(ByVal value)
		Set Label = S(YQasp.Str.iReplace(s_source,"{label}",value))
	End Function
	'替换Url
	Public Function Url(ByVal value)
		'If InStr(Value,"http") = 0 Then Value = "http://" & Value
		Set Url = S(YQasp.Str.iReplace(s_source,"{url}",value))
	End Function
	'替换Val
	Public Function Val(ByVal value)
		Set Val = S(YQasp.Str.iReplace(s_source,"{val}",value))
	End Function
	'替换Disabled
	Public Function Disabled()
		Set Disabled = S(YQasp.Str.iReplace(s_source,"{disabled}","disabled"))
	End Function
	'替换HideLabel
	Public Function HideLabel()
		Set HideLabel = S(YQasp.Str.iReplace(s_source,"{labelhide}","class=""sr-only"""))
	End Function
	'替换PlaceHolder
	Public Function PlaceHolder(ByVal value)
		Set PlaceHolder = S(YQasp.Str.iReplace(s_source,"{ph}",value))
	End Function
	'替换Row
	Public Function Row(ByVal value)
		Set Row = S(YQasp.Str.iReplace(s_source,"{row}",value))
	End Function
	'替换Size
	Public Function Size(ByVal value)
		Set Size = S(YQasp.Str.iReplace(s_source,"{size}",value))
	End Function
	'替换Multiple
	Public Function Multiple()
		Set Multiple = S(YQasp.Str.iReplace(s_source,"{multiple}","multiple"))
	End Function
	'替换其他
	Public Function F(ByVal value)
		Set F = S(YQasp.Str.iReplace(s_source,"{"&YQasp.Str.GetName(value,":")&"}",YQasp.Str.GetValue(value,":")))
	End Function
	'替换List
	Public Function [Loop](ByVal Data,ByVal t)
		Dim d,i,li,b,C,rname : d = ""
		If YQasp.isN(data) Then data = "[{}]"
		If TypeName(data) = "String" Then Set d = YQasp.Json.Parse(data)
		If TypeName(data) = "YQAsp_Json_Array" Then Set d = Data
		Set li = YQasp.Str.StringBuilder
		Select Case t
			Case "li"
				For i = 0 To d.Length-1
					Select Case d(i)("type")
						Case "li" li.Append "<li><a href="""&d(i)("url")&""">"&d(i)("name")&"</a></li>"
						Case "header" li.Append "<li class=""dropdown-header"">"&d(i)("name")&"</li>"
						Case "separator" li.Append "<li role=""separator"" class=""divider""></li>"
						Case "disabled" li.Append "<li class=""disabled""><a href="""&d(i)("url")&""">"&d(i)("name")&"</a></li>"
						Case Else li.Append "<li><a href="""&d(i)("url")&""">"&d(i)("name")&"</a></li>"
					End Select
				Next
			Case "checkbox"
				For i = 0 To d.Length-1
					b="":If YQasp.Has(d(i)("disabled")) And d(i)("disabled") Then b="disabled"
					c="":If YQasp.Has(d(i)("type")) And d(i)("type")="inline" Then c=" checkbox-inline"
					li.Append "<div class=""checkbox "&c&""">"
					li.Append "<label {labelhide}> <input type=""checkbox"" id="""&d(i)("id")&""" name="""&d(i)("name")&""" value="""&d(i)("val")&""" "&b&">"&d(i)("str")&"</label>"
					li.Append "</div>"
				Next
			Case "radio"
				rname = d(0)("name")
				For i = 0 To d.Length-1
					b="":If YQasp.Has(d(i)("disabled")) And d(i)("disabled") Then b="disabled"
					c="":If YQasp.Has(d(i)("type")) And d(i)("type")="inline" Then c=" radio-inline"
					li.Append "<div class=""radio "&c&""">"
					li.Append "<label {labelhide}> <input type=""radio"" id="""&d(i)("id")&""" name="""&rname&""" value="""&d(i)("val")&""" "&b&">"&d(i)("str")&"</label>"
					li.Append "</div>"
				Next
			Case "select"
				For i = 0 To d.Length-1
					li.Append "<option value="""&d(i)("val")&""">"&d(i)("str")&"</option>"
				Next
		End Select
		Set d = Nothing
		d = li.ToString
		Set li = Nothing
		Set [Loop] = S(YQasp.Str.iReplace(s_source,"{loop}",d))
	End Function
End Class
%>