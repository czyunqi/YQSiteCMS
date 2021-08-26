<%
'######################################################################
'## YQasp.config.asp
'## -------------------------------------------------------------------
'## YQAsp 配置文件
'######################################################################

'加载语言包文件
%>
<!--#include file="lang/zh.asp" -->
<%
YQasp.Init() 'YQAsp初始化
''====================================
''  YQAsp 基础配置
''====================================

''设置'YQasp.asp'文件在网站中的路径，以"/"开头:
YQasp.BasePath = "/code/lib/YQAsp/"
''设置YQAsp存放插件文件的路径，以"/"开头:
YQasp.PluginPath = "/code/lib/YQAsp/plugin"
''打开开发者调试模式：
YQasp.Debug = True
''配置默认首页的文件名，用于伪Rewrite时的首页地址省略
'YQasp.DefaultPageName = "index.asp"

''====================================
''  Db 数据库配置
''====================================

''配置数据库默认连接：
'YQasp.Db.SetConn "ACCESS", "/sampledata/YQaspSampleData.mdb", ""
YQasp.Db.SetConn "MSSQL", "YQSiteCMS", "sa:123456@(local)"
''配置第二个数据库连接
'YQasp.Db.SetConnection "connname", "MSSQL", "data", "sa:pass@(local)"
'YQasp.Db.SetConnection "connname", 1, "data", "root:pass@server:port"
''设置分页标识URL参数
'YQasp.Db.PageParam          = "page"
''设置分页每页数量
'YQasp.Db.PageSize           = 25

''====================================
''  Encrypt 加密解密配置
''====================================

''配置加密解密的密钥：
'YQasp.Encrypt.Key           = ""

''====================================
''  Console 控制台配置
''====================================

''在这里设置token的值，区分大小写，如果设置了Token值，
''仅前端输入的token和这里设置一致时，才会输出控制台信息
'YQasp.Console.Token         = ""
''是否开启控制台
YQasp.Console.Enable        = True
''是否在控制台中自动显示执行的SQL语句
'YQasp.Console.ShowSql       = True
''是否在控制台中自动显示执行的SQL语句的执行时间
'YQasp.Console.ShowSqlTime   = True
''控制台中缓存的内容最大字节数
'YQasp.Console.MaxCacheSize  = 8000
''单条控制台输出的内容最大字节数
'YQasp.Console.MaxLogSize    = 3000

''====================================
''  Error 异常信息配置
''====================================

''抛出异常信息时的标题
'YQasp.Error.Title           = "发生错误啦"
''是否自动跳转页面
'YQasp.Error.Redirect        = True
''跳转等待时间（秒）
'YQasp.Error.Delay           = 5
''错误信息框的css样式
'YQasp.Error.ClassName       = ""

''====================================
''  Cache 配置
''====================================

''是否开启缓存数量计数
'YQasp.Cache.CountEnabled     = True
''文件缓存默认保存路径
'YQasp.Cache.SavePath         = "/_cache"
''文件缓存默认保存文件类型
'YQasp.Cache.FileType         = ".YQaspcache"
''缓存默认过期时间(分钟或指定时间，如果为0则表示一直不过期)
'YQasp.Cache.Expires          = 5

''====================================
''  Fso 配置
''====================================

''设置FSO组件名称（如果服务器上修改过）
'YQasp.Fso.fsoName           = "Scripting.FileSystemObject"
''设置是否删除只读文件
'YQasp.Fso.Force             = True
''设置是否覆盖原有文件
'YQasp.Fso.OverWrite         = True
''设置文件大小显示格式(G,M,K,b,auto)
'YQasp.Fso.SizeFormat        = "K"

''====================================
''  Http 配置
''====================================

''异步模式
'YQasp.Http.Async            = False
''服务器解析超时（毫秒）
'YQasp.Http.ResolveTimeout   = 20000
''服务器连接超时（毫秒）
'YQasp.Http.ConnectTimeout   = 20000
''发送数据超时（毫秒）
'YQasp.Http.SendTimeout      = 300000
''接受数据超时（毫秒）
'YQasp.Http.ReceiveTimeout   = 60000

''====================================
''  Json 配置
''====================================

''设置生成Json字符串是是否编码 Unicode 字符
'YQasp.Json.EncodeUnicode    = True
''设置是否启用快速取值模式
'YQasp.Json.QuickMode        = True

''====================================
''  List 配置
''====================================

''List的键值是否区分大小写
'YQasp.List.IgnoreCase      = False

''====================================
''  Str 配置
''====================================

''是否编码ToString时的Unicode字符
'YQasp.Str.EncodeJsonUnicode = False

''====================================
''  Tpl 配置
''====================================

''设置静态模板文件存放的目录路径
'YQasp.Tpl.FilePath          = "/view/"
''设置和读取标签的标识符
'YQasp.Tpl.TagMask           = "{*}"
''设置模板中是否可以执行ASP代码
'YQasp.Tpl.AspEnable         = False
''设置如何处理未定义的标签(keep/remove/comment)
'YQasp.Tpl.TagUnknown        = "keep"

''====================================
''  Upload 配置
''====================================

''配置文本编码
'YQasp.Upload.CharSet          = "utf-8"
''设置允许上传的最大字节数
'YQasp.Upload.AllowMaxSize     = -1
''设置允许上传的单文件的最大字节数
'YQasp.Upload.AllowMaxFileSize = -1
''设置允许上传的文件的扩展名
'YQasp.Upload.AllowFileTypes   = "jpg|png|gif|.rar|.zip|doc|docx|xls|xlsx|ppt|pptx|pdf"
''设置文件保存目录
'YQasp.Upload.SavePath         = "/UploadFiles"

''====================================
''  Log 日志配置
''====================================

''是否启用日志记录，默认关闭
'YQasp.Log.Enable              = False
''文件日志保存路径
'YQasp.Log.SavePath            = "/../"
''文件日志保存频率
'' d, day - 每天保存为一个日志
'' h, hour - 每小时保存为一个日志
'' m, minute - 每分钟保存为一个日志
'YQasp.Log.FileRolling         = "day"
''日志ID，不同的ID会生成不同的日志文件
'YQasp.Log.ID                  = "s1"
''文件日志信息模版，标签含义
'' date - 日期时间，可用 :D格式 格式化样式
'' method - 请求方法
'' url - 请求Url
'' ua - 用户UserAgent
'' ip - 用户IP
'' run - 程序执行到此处所花的毫秒数
'' msg - 日志信息
'' fn - 错误日志中附加的代码定位信息，仅Error日志中有
'' 注意，可以新增任何标签，用{}包含就好，用 YQasp.Log.Set / SetOne 方法添加内容
''信息类日志
'YQasp.Log.Style("info")  = "[{date:Dy-mm-dd hh:ii:ss}, {ip}] ({method} {url}, {run}ms) {msg}"
''警告类日志
'YQasp.Log.Style("warn")  = "[{date:Dy-mm-dd hh:ii:ss}, {ip}] ({method} {url}, {run}ms):\n  {ua}\n  {msg}"
''错误类日志
'YQasp.Log.Style("error") = "[{date:Dy-mm-dd hh:ii:ss}] ({method} {url}, {run}ms)\n  {fn}\n  {msg}"
%>