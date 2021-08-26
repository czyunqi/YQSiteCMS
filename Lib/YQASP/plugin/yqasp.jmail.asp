<%
'######################################################################
'## YQasp.jmail.asp
'## -------------------------------------------------------------------
'## Feature     :   YQAsp Chinese character processing tools
'## Version     :   1.0
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description :   This plugin provides Jmail.
'##
'######################################################################

Class YQAsp_Jmail

  Private s_SMTPServer, s_FromMail, s_FromName, s_MailServerUserName, s_MailServerPassword, s_Charset

  Private Sub Class_Initialize()
		s_SMTPServer = "smtp.qq.com"
		s_FromMail = "301093752@qq.com"
		s_FromName = "杰西工作室"
		s_MailServerUserName = "301093752"
		s_MailServerPassword = "123456"
		s_Charset = "GB2312"
  End Sub
  
  
  Private Sub Class_Terminate()
    
  End Sub
  
  Public Property Let EmailSMTPServer(ByVal value)
    s_SMTPServer = value
  End Property
        
  Public Property Let EmailFromMail(ByVal value)
    s_FromMail = value
  End Property
        
  Public Property Let EmailFromName(ByVal value)
    s_FromName = value
  End Property
        
  Public Property Let EmailUserName(ByVal value)
    s_MailServerUserName = value
  End Property
        
  Public Property Let EmailPassword(ByVal value)
    s_MailServerPassword = value
  End Property
        
  Public Property Let EmailCharset(ByVal value)
    s_Charset = value
  End Property
        
  Public Property Get EmailSMTPServer()
    EmailSMTPServer = s_SMTPServer
  End Property
        
  Public Property Get EmailFromMail()
    EmailFromMail = s_FromMail
  End Property
        
  Public Property Get EmailFromName()
    EmailFromName = s_FromName
  End Property
        
  Public Property Get EmailUserName()
    EmailUserName = s_MailServerUserName
  End Property
        
  Public Property Get EmailPassword()
    EmailPassword = s_MailServerPassword
  End Property
        
  Public Property Get EmailCharset()
    EmailCharset = s_Charset
  End Property

  '发送邮件，返回状态1 ， 2 ， 3   状态1为检测不到JMAIL组件  状态2为发送失败  状态3为发送成功！
  '发送带三个参数 ToEmail：收件人地址 Subject：邮件主题 Body：邮件内容，第一版本暂不支持带附件内容
  Public Function SendMail(ByVal ToEmail,ByVal Subject,ByVal Body)
          On Error Resume Next
    Set jmail = Server.CreateObject("JMAIL.Message")   '建立发送邮件的对象
    If Err.Number <> 0 Then
        SendMail = 1
        Exit Function
    End If
    jmail.silent = True    '屏蔽例外错误，返回FALSE跟TRUE两值
    jmail.logging = False   '启用邮件日志
    jmail.Charset = s_Charset     '邮件的文字编码GB2312为中文 UTF-8为英文
    jmail.ISOEncodeHeaders = False '防止邮件标题乱码
    jmail.ContentType = "text/html"    '邮件的格式为HTML格式
    jmail.AddRecipient ToEmail    '邮件收件人的地址
    jmail.From = s_FromMail  '发件人的E-MAIL地址
    jmail.FromName = s_FromName   '发件人姓名
    jmail.MailServerUserName = s_MailServerUserName    '登录邮件服务器所需的用户名
    jmail.MailServerPassword = s_MailServerPassword     '登录邮件服务器所需的密码
    jmail.Subject = Subject    '邮件的标题 
    jmail.Body = Body      '邮件的内容
    jmail.Priority = 1      '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
    jmail.Send(s_SMTPServer)     '执行邮件发送（通过邮件服务器地址）
    jmail.Close()   '关闭对象    
    If jmail.ErrorCode <> 0 Then
        SendMail = 2
    Else
        SendMail = 3
    End If
  End Function
  
End Class
%>