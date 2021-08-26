<% 
'###################################################################### 
'## YQasp.mail.asp 
'## ------------------------------------------------------------------- 
'## Feature     :   YQAsp Mail Class 
'## Version     :   v0.2 Alpha 
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description :   YQAsp Jmail邮件发送（插件） 
'##     建议Body 和HTMLBody只设置其中一个，否则邮件将是多部分MIME格式的消息 
'##     本类是基于Jmail组件的类，在Jmail 4.5 版本下测试通过，有兴趣的可以测试下其他版本。 
'##     如果您的服务器环境不支持Jmail，将无法使用此程序。  
'## Examples :  
'##     '1.快速发送邮件方式，前面需要配置了各项基本参数，适用于邮件参数基本固定，只需要添加收件人和附件的情况  
'##     YQasp.Ext("mail").Init()  '初始化jmail对象，因为下面的设置都需要涉及到jmail对象，为了让下面的参数设置顺序可以随意排列必须先初始化 
'##     YQasp.Ext("mail").AddRecipient "********@126.com"  '增加联系人 
'##     YQasp.Ext("mail").AddRecipient "********@126.com;********@126.com"  '增加多个联系人 
'##     YQasp.Ext("mail").AddRecipient Array("********@126.com")  '数组方式增加联系人，数组也可以不这样设置，只要是数组就可以 
'##     YQasp.Ext("mail").AddRecipientBCC "********@126.com"  '增加密件收件人,非必须 
'##     YQasp.Ext("mail").AddRecipientCC "********@126.com"  '增加邮件抄送者,非必须 
'##     YQasp.Ext("mail").Smtp="smtp.126.com" '设置SMTP 
'##     YQasp.Ext("mail").From="********@126.com" '发送人的邮箱 
'##     YQasp.Ext("mail").FromName="虚幻" '发送人姓名 
'##     YQasp.Ext("mail").MailServerUserName="********@126.com" '发送人邮箱用户名 
'##     YQasp.Ext("mail").MailServerPassword="********" '发送人邮箱密码 
'##     YQasp.Ext("mail").Subject="Subjectsmtp.126.com" '邮件主题 
'##     YQasp.Ext("mail").Body="<font color='red'>Bodysmtp.126.com</font>" '邮件body内容 
'##     YQasp.Ext("mail").AppendText "<font color='red'>AppendText.126.com</font>" '增加文本内容 
'##     YQasp.Ext("mail").AddAttachmentIn("t.rar;t.asp") '增加多个嵌入式附件 
'##     t_file=YQasp.Ext("mail").File("") '返回附件数组，非必须 
'##     YQasp.WN t_file(0) '输出第一个附件ID 
'##     YQasp.WN YQasp.Ext("mail").File(1) '输出第二个附件ID，如果 
'##     YQasp.Ext("mail").HTMLBody="<font color='red'>HTMLBodysmtp.126.com</font>" '邮件HTMLBODY内容 
'##     YQasp.Ext("mail").AppendHTML YQasp.Ext("mail").File(0) '往邮件内容中添加附件，有附件的邮件将以html格式发送 
'##     YQasp.Ext("mail").AddAttachment("t.rar") '增加一个普通附件 
'##     YQasp.WN YQasp.Ext("mail").QuickSend() '快速发送，输出发送邮件数 
'##     YQasp.WN YQasp.Ext("mail").RecipientsCount() '输出收件人数量 
'##     '2.一般发送邮件方式，不需要上面的设置，只需要一个函数就可以了，邮件和附件参数不符都可以采用字符串或数组形式，字符串形式的话多个数据之间用 ; 进行分隔。 
'##     YQasp.WN YQasp.Ext("mail").Send("smtp.126.com","********@126.com","虚幻","********@126.com","********@126.com","********","Subjectsmtp.126.com","","<font color='red'>HTMLBodysmtp.126.com</font>",1,"","","") '发送邮件，输出发送邮件数 

'##     '该函数的参数如下，每个参数的具体含义可以详见该函数头部的注释YQasp.Ext("mail").Send(Smtp,From,FromName,Email,MailServerUserName,MailServerPassword,Subject,Body,HTMLBody,Priority,Silent,tCharset,tContentType) 
'##     基本的使用主要就是上面的了，其他一些应用可以详见代码，每个函数和方法都有注释了。 
'##        2010/06/11 晚修正了一个问题，更新了下注释 
'###################################################################### 

Class YQAsp_Mail 
 ' ============================================ 
 ' 变量声明 
 ' ============================================ 
 Private s_jmail,s_ISOEncodeHeaders,s_Silent,s_Charset,s_ContentType,s_From,s_FromName,s_MailServerUserName,s_MailServerPassword,s_Priority,s_Logging,s_Smtp 
 Private t_Subject,t_Body,t_HTMLBody,t_File 
 ' ============================================ 
 ' 类模块初始化 
 ' ============================================ 
 Private Sub Class_Initialize 
  s_ISOEncodeHeaders   = True   '是否将信头编码成iso-8859-1字符集. 缺省是True  
  s_Silent     = True   '设置为true,ErrorCode包含的是错误代码  
  s_Charset         = "Gb2312"  '设置标题和内容编码，如果标题有中文，必须设定编码为gb2312  
  s_ContentType     = "text/html"  '如果发内嵌附件设置为空值  
  s_From         = ""  ' 发送者地址  
  s_FromName        = ""  ' 发送者姓名  
  s_MailServerUserName = ""  ' 身份验证的用户名  
  s_MailServerPassword = ""  ' 身份验证的密码  
  s_Priority        = 1   '设置优先级，范围从1到5，越大的优先级越高，3为普通   
  s_Logging     = True   '是否使用日志 
  s_Smtp         = "" 
  t_Subject         = "" 
  t_Body         = "" 
  t_HTMLBody        = "" 
  t_File         = "" 
  YQasp.Error(10001)   = "您的服务器不支持 Jmail 组件." 
  YQasp.Error(10002)   = "发送者地址不能为空." 
  YQasp.Error(10003)   = "发送者姓名不能为空." 
  YQasp.Error(10004)   = "优先级必须为1-5之间的数字." 
  YQasp.Error(10005)   = "Jmail 对象未创建." 
  YQasp.Error(10006)   = "邮件地址不正确." 
  YQasp.Error(10007)   = "SMTP地址为空或不正确." 
  YQasp.Error(10008)   = "没有任何收件人." 
  YQasp.Error(20001)   = "身份验证的用户名不能为空." 
  YQasp.Error(20002)   = "身份验证的密码不能为空." 
  YQasp.Error(30001)   = "邮件发送失败." 
 End Sub 
 ' ============================================ 
 ' 类终结 
 ' ============================================ 
 Private Sub Class_Terminate 
  On ErrOr Resume Next 
  s_jmail.Close() 
  If Err Then Err.Clear 
  Set s_jmail = Nothing 
 End Sub 

 ' ============================================ 
 ' 设置ISOEncodeHeaders 
 ' ============================================ 
 Public Property Let ISOEncodeHeaders(ByVal p) 
  s_ISOEncodeHeaders=YQasp.IIF(p,p,False) 
 End Property 

 ' ============================================ 
 ' 返回ISOEncodeHeaders 
 ' ============================================ 
 Public Property Get ISOEncodeHeaders() 
  ISOEncodeHeaders=s_ISOEncodeHeaders 
 End Property 

 ' ============================================ 
 ' 设置Silent 
 ' ============================================ 
 Public Property Let Silent(ByVal p) 
  s_Silent=YQasp.IIF(p,p,False) 
 End Property 

 ' ============================================ 
 ' 返回Silent 
 ' ============================================ 
 Public Property Get Silent() 
  Silent=s_Silent 
 End Property 

 ' ============================================ 
 ' 设置Logging 
 ' ============================================ 
 Public Property Let Logging(ByVal p) 
  s_Logging=YQasp.IIF(p,p,False) 
 End Property 

 ' ============================================ 
 ' 返回Logging 
 ' ============================================ 
 Public Property Get Logging() 
  Logging=s_Logging 
 End Property 

 ' ============================================ 
 ' 设置Charset 
 ' ============================================ 
 Public Property Let [Charset](ByVal p) 
  s_Charset=YQasp.Ifhas(p,"GB2312") 
 End Property 

 ' ============================================ 
 ' 设置ContentType 
 ' ============================================ 
 Public Property Let [ContentType](ByVal p) 
  s_ContentType=YQasp.Ifhas(p,"text/html") 
 End Property 

 ' ============================================ 
 ' 设置From 
 ' ============================================ 
 Public Property Let From(ByVal p) 
  s_From=p 
 End Property 

 ' ============================================ 
 ' 设置FromName 
 ' ============================================ 
 Public Property Let FromName(ByVal p) 
  s_FromName=p 
 End Property 

 ' ============================================ 
 ' 设置MailServerUserName 
 ' ============================================ 
 Public Property Let MailServerUserName(ByVal p) 
  s_MailServerUserName=p 
 End Property 

 ' ============================================ 
 ' 设置MailServerPassword 
 ' ============================================ 
 Public Property Let MailServerPassword(ByVal p) 
  s_MailServerPassword=p 
 End Property 

 ' ============================================ 
 ' 设置Priority 
 ' ============================================ 
 Public Property Let Priority(ByVal p) 
  If Not YQasp.Test(p,"int") or int(p)<1 or int(p)>5 Then 
   YQasp.Error.Raise 10004 
  End If 
  s_Priority=p 
 End Property 

 ' ============================================ 
 ' 设置Smtp 
 ' ============================================ 
 Public Property Let Smtp(ByVal p) 
  s_Smtp=p 
 End Property 

 ' ============================================ 
 ' 设置Subject 
 ' ============================================ 
 Public Property Let Subject(ByVal p) 
  t_Subject=p 
 End Property 

 ' ============================================ 
 ' 设置Body 
 ' ============================================ 
 Public Property Let Body(ByVal p) 
  t_Body=p 
 End Property 

 ' ============================================ 
 ' 设置HTMLBody 
 ' ============================================ 
 Public Property Let HTMLBody(ByVal p) 
  t_HTMLBody=p 
 End Property 

 ' ============================================ 
 ' 返回日志 
 ' ============================================ 
 Public Property Get [Log]() 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  [Log]=s_jmail.Log 
 End Property 

 ' ============================================ 
 ' 返回嵌入式附件列表,如果参数为空或者小于0则返回附件列表数组，否则则返回指定索引值的附件值，如果指定索引值大于最大数组下标则返回最大下标的附件值 
 ' ============================================ 
 Public Property Get [File](ByVal p) 
  If Not YQasp.Has(p) Then 
   P=-1 
  End If 
  If Not IsNumeric(p) Then 
   p=Int(p) 
  End If 
  If p < 0 Then 
   [File]=t_File 
  Else 
   [File]=t_File(YQasp.IIF(p > Ubound(t_File),Ubound(t_File),p)) 
  End If 
 End Property 

 ' ============================================ 
 ' 返回所有收件人数量 
 ' ============================================ 
 Public Property Get RecipientsCount() 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  RecipientsCount=s_jmail.Recipients.count 
 End Property  

 ' ============================================ 
 ' 清除所有收件人 
 ' ============================================ 
 Public Sub RecipientsClear() 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  s_jmail.Recipients.clear() 
 End Sub 

 ' ============================================ 
 ' 字符串转数组，字符串各值以;分隔，如果参数为数组则直接返回数组 
 ' ============================================ 
 Public Function ToArray(ByVal p) 
  If Not IsArray(p) then  
   If InStr(p,";")>0 Then 
    If InStrRev(p,";")=Len(p) Then 
     p=Left(p,len(p)-1) 
    End If 
    ToArray = Split(p,";") 
   Else 
    ToArray = Array(p) 
   End If 
  Else 
   ToArray=p 
  End If  
 End Function 
 ' ============================================ 
 ' 添加收件人,参数可以为字符串，多个地址之间用;分隔，也可以为数组 
 ' ============================================ 
 Public Sub AddRecipient(ByVal p) 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  t_p=ToArray(p) 
  For i=0 to UBound(t_p) 
   If Not YQasp.Test(t_p(i),"email") Then 
    YQasp.Error.Raise 10006 
   End If 
   s_jmail.AddRecipient(t_p(i)) 
  Next 
 End Sub 

 ' ============================================ 
 ' 添加密件收件人的地址 
 ' ============================================ 
 Public Function AddRecipientBCC(ByVal p) 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  t_p=ToArray(p) 
  For i=0 to UBound(t_p) 
   If Not YQasp.Test(t_p(i),"email") Then 
    YQasp.Error.Raise 10006 
   End If 
   s_jmail.AddRecipientBCC(t_p(i)) 
  Next 
 End Function 

 ' ============================================ 
 ' 添加邮件抄送者的地址 
 ' ============================================ 
 Public Function AddRecipientCC(ByVal p) 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  t_p=ToArray(p) 
  For i=0 to UBound(t_p) 
   If Not YQasp.Test(t_p(i),"email") Then 
    YQasp.Error.Raise 10006 
   End If 
   s_jmail.AddRecipientCC(t_p(i)) 
  Next 
 End Function 

 ' ============================================ 
 ' 增加普通附件,参数可以为相对和绝对地址，可以为字符串，也可以为数组 
 ' ============================================ 
 Public Sub AddAttachment(ByVal p) 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  t_p=ToArray(p) 
  For i=0 to UBound(t_p) 
   s_jmail.AddAttachment(Server.MapPath(t_p(i))) 
  Next 
 End Sub 

 ' ============================================ 
 ' 返回附件数量 
 ' ============================================ 
 Public Function AttachmentsCount() 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  AttachmentsCount=s_jmail.Attachments.Count 
 End Function 

 ' ============================================ 
 ' 清除所有附件 
 ' ============================================ 
 Public Sub AttachmentsClear() 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  s_jmail.Attachments.Clear 
 End Sub 

 ' ============================================ 
 ' 增加嵌入式附件,参数可以为相对和绝对地址，可以为字符串，也可以为数组，返回文件列表数组 
 ' ============================================ 
 Public Function AddAttachmentIn(ByVal p) 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  t_p=ToArray(p) 
  Redim t_File(Ubound(t_p)) 
  For i=0 to UBound(t_p) 
   t_File(i)=s_jmail.AddAttachment(Server.MapPath(t_p(i))) 
  Next   
  AddAttachmentIn=t_File 
 End Function 

 ' ============================================ 
 ' 追加HTML  
 ' ============================================ 
 Public Sub AppendHTML(ByVal p) 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  s_jmail.appendHTML p 
 End Sub 

 ' ============================================ 
 ' 追加文本  
 ' ============================================ 
 Public Sub AppendText(ByVal p) 
  If Not isobject(s_jmail) Then 
   YQasp.Error.Raise 10005 
  End If 
  s_jmail.appendText p 
 End Sub 

 ' ============================================ 
 ' 创建Jmail对象,返回一个新的jmail对象,提供需要直接使用jmail对象的情况下使用 
 ' ============================================ 
 Public Function Jmail() 
  If Not YQasp.IsInstall("JMAIL.Message") then 
   YQasp.Error.Raise 10001 
  End If 
  Set Jmail   = Server.CreateObject("JMail.Message") 
 End Function  

 ' ============================================ 
 ' 初始化Jmail对象 
 ' ============================================ 
 Public Sub Init() 
  If Not YQasp.IsInstall("JMAIL.Message") then 
   YQasp.Error.Raise 10001 
  End If 
  If Not IsObject(s_jmail) Then 
   Set s_jmail = Server.CreateObject("JMail.Message") 
  End If 
 End Sub 

 ' ============================================ 
 ' 关闭释放Jmail对象 
 ' ============================================ 
 Public Sub Terminate() 
  If IsObject(s_jmail) then 
   s_jmail.close() 
   Set s_jmail   =  Nothing 
  End If 
 End Sub 

 ' ============================================ 
 ' 快速发送邮件，返回发送邮件数量，配置了各项参数的情况下才能使用，适用于邮件参数基本固定，只需要添加收件人和附件 
 ' ============================================ 
 Public Function QuickSend()   
  If Not YQasp.IsInstall("JMAIL.Message") then 
   YQasp.Error.Raise 10001 
  End If 
  If Not YQasp.Has(s_Smtp) then 
   YQasp.Error.Raise 10007 
  End If 
  If Not YQasp.Has(s_From) then 
   YQasp.Error.Raise 10002 
  End If 
  If Not YQasp.Has(s_FromName) then 
   YQasp.Error.Raise 10003 
  End If 
  If Not YQasp.Has(s_MailServerUserName) then 
   YQasp.Error.Raise 20001 
  End If 
  If Not YQasp.Has(s_MailServerPassword) then 
   YQasp.Error.Raise 20002 
  End If 
  If Not YQasp.Has(t_Subject) Then 
   t_Subject="无主题." 
  End If 
  If RecipientsCount()=0 then    
   YQasp.Error.Raise 10008 
  End If 
  If Not isobject(s_jmail) Then 
   Set s_jmail = Server.CreateObject("JMail.Message")   
  End If   
  s_jmail.silent = s_Silent  
  s_jmail.Charset = s_Charset   
  If AttachmentsCount()=0 Then 
   s_jmail.ContentType = s_ContentType 
  End If 
  s_jmail.From = s_From 
  s_jmail.FromName = s_FromName 
  s_jmail.MailServerUserName = s_MailServerUserName 
  s_jmail.MailServerPassword = s_MailServerPassword 
  s_jmail.Subject = t_Subject 
  s_jmail.Body =t_Body 
  s_jmail.HTMLBody =t_HTMLBody 
  s_jmail.Priority = s_Priority 
  s_jmail.Send s_Smtp 
  If Err.Number<>0 then 
   YQasp.Error.Raise 30001 
  End If 
  QuickSend = RecipientsCount() 
  Terminate() 
 End Function  

 ' ============================================ 
 ' 根据参数发送邮件，成功返回发送数量,收件人参数可以为字符串，数组 
 ' Smtp 'smtp地址 
 ' From '发件人邮箱 
 ' FromName '发件人姓名 
 ' Email '收件人邮箱 
 ' MailServerUserName '身份验证的用户名 
 ' MailServerPassword '身份验证的密码 
 ' Subject '主题 
 ' Body '内容 
 ' HTMLBody 'HTML格式内容 
 ' Priority '优先级 
 ' Silent '设置为true,ErrorCode包含的是错误代码 
 ' tCharset '设置标题和内容编码 
 ' tContentType '如果发内嵌附件设置为空值 
 ' ============================================ 
 Public Function Send(ByVal Smtp,ByVal From,ByVal FromName,ByVal Email,ByVal MailServerUserName,ByVal MailServerPassword,ByVal Subject,ByVal Body,ByVal HTMLBody,ByVal Priority,ByVal Silent,ByVal tCharset,ByVal tContentType) 
  If Not YQasp.IsInstall("JMAIL.Message") then 
   YQasp.Error.Raise 10001 
  End If 
  Set t_jmail = Server.CreateObject("JMail.Message")   
  If Not YQasp.Has(Smtp) then 
   YQasp.Error.Raise 10007 
  End If 
  If Not YQasp.Has(From) then 
   YQasp.Error.Raise 10002 
  End If 
  If Not YQasp.Has(FromName) then 
   YQasp.Error.Raise 10003 
  End If 
  If Not YQasp.Has(Email) then 
   YQasp.Error.Raise 10008 
  End If   
  t_Email=ToArray(Email)  
  For i=0 to UBound(t_Email) 
   If Not YQasp.Test(t_Email(i),"email") Then 
    YQasp.Error.Raise 10006 
   End If 
   t_jmail.AddRecipient(t_Email(i)) 
  Next   
  If t_jmail.Recipients.count=0 then    
   YQasp.Error.Raise 10008 
  End If 
  If Not YQasp.Has(MailServerUserName) then 
   YQasp.Error.Raise 20001 
  End If 
  If Not YQasp.Has(MailServerPassword) then 
   YQasp.Error.Raise 20002 
  End If 
  If Not YQasp.Has(Subject) Then 
   Subject="无主题." 
  End If 
  If Not YQasp.Has(Priority) Then 
   Priority = 1 
  End If 
  If Not YQasp.Has(Silent) Then 
   Silent = True 
  End If 
  If Not YQasp.Has(tCharset) Then 
   tCharset = "UTF-8" 
  End If 
  If Not YQasp.Has(tContentType) Then 
   tContentType = "text/html" 
  End If 
  t_jmail.silent = Silent  
  t_jmail.Charset = tCharset 
  t_jmail.ContentType = tContentType 
  t_jmail.From = From 
  t_jmail.FromName = FromName  
  t_jmail.MailServerUserName = MailServerUserName 
  t_jmail.MailServerPassword = MailServerPassword 
  t_jmail.Subject = Subject 
  t_jmail.Body =Body 
  t_jmail.HTMLBody =HTMLBody 
  t_jmail.Priority = Priority 
  t_jmail.Send Smtp 
  If Err.Number<>0 then 
   YQasp.Error.Raise 30001 
  End If 
  Send = t_jmail.Recipients.count 
  t_jmail.close() 
  Set t_jmail = Nothing 
 End Function  

End Class  
%>
