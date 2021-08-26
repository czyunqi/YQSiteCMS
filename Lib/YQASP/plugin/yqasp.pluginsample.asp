<%
'#################################################################################
'##  YQasp.pluginsample.asp
'##  ------------------------------------------------------------------------------
'##  Feature      :  YQAsp Plugin Class Sample
'##  Version      :  1.0
'##  For YQAsp  :  3.0+
'##  Author      :   云奇(114066164@qq.com)
'##  Update Date :   2021-7-15
'##  Description  :  YQAsp's plugin should be like this file as follow:
'##                  1.  File name should be like this: 'YQasp.***.asp'.  The '***'
'##                      is your plugin's name, with lower-case letters as better.
'##                  2.  Class's name should be like this: 'YQAsp_***'. The '***'
'##                      is your plugin's name, lower-case letters after the '_'
'##                      are not required.
'##                  3.  You must put your file(s) in 'plugin' folder or any other
'##                      folder you setted with the property 'YQasp.PluginPath'.
'#################################################################################
Class YQAsp_PluginSample

  Private s_author, s_version

  Private Sub Class_Initialize()
    s_author  = "coldstone"
    s_version  = "0.1"
    'Set exception info, please custom your ErrorCode such as 10001 or "test001".
    'Please try to keep your ErrorCode is not the same with other people.
    'Attention! You can use any character, not just numbers!
    'The exception info string should be like this : 
    '  "[error info]|[error detail description]|[suggestion]"
    '   the [detail description] and [suggestion] part is NOT required.  
    YQasp.Error("error-test-numberonly") = "Error! Accept number only."_
                                        & "|Your inputed {0} is not a number"_
                                        & "|Please check the number you inputed."
  End Sub
  Private Sub Class_Terminate()
    
  End Sub

  'Set Property
  Public Property Get Author()
    Author = s_author
  End Property
  Public Property Get Version()
    Version = s_version
  End Property

  'Define a 'Sub'
  Public Sub helloWorld()
    YQasp.Print "Hello YQAsp!"
  End Sub

  'Define a 'Function'
  Public Function Return(ByVal s)
    Return = s
  End Function

  'Define default Function
  Public Default Function Fun(ByVal num)
    If Not isNumeric(num) Then
      'Raise a exception info when 'YQasp.Debug' is 'True'
      If YQasp.Debug Then
        YQasp.Error.FunctionName = "YQasp(""PluginSample"").Fun"
        YQasp.Error.Detail = num
        YQasp.Error.Raise "error-test-numberonly"
      End If
      Exit Function
    End If
    Fun = num
  End Function

End Class
%>