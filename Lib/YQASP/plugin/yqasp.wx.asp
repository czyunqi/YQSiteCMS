<% 
'###################################################################### 
'## YQasp.weixin.asp 
'## ------------------------------------------------------------------- 
'## Feature     :   YQAsp weixin Class 
'## Version     :   v1.0
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description :   微信API接口
'###################################################################### 
Class YQAsp_WX
    '变量声明
    Private s_AppID,s_AppSecret,s_Token,s_AdmOpenID,s_redirect_uri
    ' ============================================ 
    ' 类模块初始化 
    ' ============================================ 
    Private Sub Class_Initialize 
        s_AppID = ""
        s_AppSecret = ""
        s_Token = ""
        s_AdmOpenID = ""
        s_redirect_uri = ""
    End Sub
    ' ============================================ 
    ' 类终结 
    ' ============================================ 
    Private Sub Class_Terminate 
        On ErrOr Resume Next
        If Err Then Err.Clear
    End Sub
     
    Public Property Let AppID(ByVal p)
        s_AppID=p 
    End Property

    Public Property Get AppID()
        AppID=s_AppID
    End Property
     
    Public Property Let AppSecret(ByVal p)
        s_AppSecret=p
    End Property

    Public Property Get AppSecret()
        AppSecret=s_AppSecret
    End Property
     
    Public Property Let Token(ByVal p)
        s_Token=p
    End Property

    Public Property Get Token()
        Token=s_Token
    End Property
     
    Public Property Let AdmOpenID(ByVal p)
        s_AdmOpenID=p
    End Property

    Public Property Get AdmOpenID()
        AdmOpenID=s_AdmOpenID
    End Property
     
    Public Property Let Redirect_uri(ByVal p)
        s_redirect_uri=p
    End Property

    Public Property Get Redirect_uri()
        Redirect_uri=s_redirect_uri
    End Property
     
    '微信设置类
     
    '获取微信的Access_Token
    Public Function Get_Access_Token()
        Get_Access_Token="a"
        '将Access_Token进行缓存
        Dim CacheName,s_url,s_result
        CacheName="APPID_"&s_AppID
        YQasp.Cache(CacheName).Expires = 120
        If Not YQasp.Cache(CacheName).Ready or YQasp.IsN(Get_Access_Token) Then
            s_url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="&s_AppID&"&secret="&s_AppSecret
            s_result=HttpSend(s_url,"get","")
            '{"access_token":"I8UUyLt5P82Ytfc7PV5OxoqUhPDvfZrvu4UQ1DqyFhP5QWlT0Cow","expires_in":7200}
            '{"errcode":40013,"errmsg":"invalid appid"}
            IF instr(s_result,"access_token")>0 Then
                Get_Access_Token = YQasp.Str.GetName(YQasp.Str.GetValue(s_result,":"""),""",")
                YQasp.Cache(CacheName) = Get_Access_Token                
                YQasp.Cache(CacheName).SaveAPP
            Else
                Get_Access_Token = ""
            End IF
        Else
            Get_Access_Token = YQasp.Cache(CacheName)
        End IF
        IF YQasp.IsN(Get_Access_Token) Then YQasp.WE "Access_Token Error"
    End Function
     
    '获取jsAPI
    Public Function Get_jsapi_ticket()
        '缓存时间7200秒，即120分钟
        CacheName = "JsAPI_Ticket_"&s_AppID
        YQasp.Cache(CacheName).Expires = 120
        If Not YQasp.Cache(CacheName).Ready or YQasp.IsN(Get_jsapi_ticket) Then
            '获取Access_Token
            Access_Token = Get_Access_Token
            s_url="https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="&Access_Token&"&type=jsapi"
            '发送请求，返回正确值为：
            '{
            '    "errcode":0,
            '    "errmsg":"ok",
            '    "ticket":"bxLdikRXVbTPdHSM05e5u5sUoXNKd8-41ZO3MhKoyN5OfkWITDGgnr2fwJ0m9E8NYzWKVZvdVtaUgWvsdshFKA",
            '    "expires_in":7200
            '}
            s_result = HttpSend(s_url,"get","")
            IF instr(s_result,"ticket")>0 Then
                Get_jsapi_ticket = YQasp.Str.GetName(YQasp.Str.GetValue(s_result,"ticket"":"""),""",")
                YQasp.Cache(CacheName) = Get_jsapi_ticket                
                YQasp.Cache(CacheName).SaveAPP
            Else
                Get_jsapi_ticket = ""
            End IF
            'Set Json = YQasp.Ext("vbsjson")
            'Set JsonObj = Json.Decode(result)
            'Get_jsapi_ticket = JsonObj("ticket")
            'Set JsonObj = Nothing
            'Set Json = Nothing
        Else
            Get_jsapi_ticket = YQasp.Cache(CacheName)
        End IF
    End Function
     
    '获取微信的用户信息
    Public Function GetUserInfo(UserOpenID)
        '获取Access_Token
        Access_Token = Get_Access_Token
        s_url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token="&Access_Token&"&openid="&UserOpenID&"&lang=zh_CN"
        '发送请求，返回正确值为：{"errcode":0,"errmsg":"ok"}
        GetUserInfo = HttpSend(s_url,"get","")
    End Function
     
    '微信网页授权及相关方法

    '获取网页授权CODE
    Public Function OAuth_Get_Code()
        s_url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid="&s_AppID&"&redirect_uri="&Server.URLEncode(s_redirect_uri)&"&response_type=code&scope=snsapi_userinfo&state=Sky#wechat_redirect"
        OAuth_Get_Code = s_url
        'YQasp.RR s_url
    End Function
     
    '得到Code后再继续获取网页授权Access_Token，与微信的Access_Token不同
    Public Function OAuth_Get_Access_Token(code)
        s_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="&s_AppID&"&secret="&s_AppSecret&"&code="&code&"&grant_type=authorization_code"
        '发送请求        ，错误将返回{"errcode":40029,"errmsg":"invalid code"}
        '成功后返回
        '{
        '   "access_token":"ACCESS_TOKEN",
        '   "expires_in":7200,
        '   "refresh_token":"REFRESH_TOKEN",
        '   "openid":"OPENID",
        '   "scope":"SCOPE"
        '}
        OAuth_Get_Access_Token = HttpSend(s_url,"get","")
        'IF instr(OAuth_Get_Access_Token,"errcode")>0 Then YQasp.WE "读取信息失败！"
    End Function
     
    '获取网页授权方式的用户信息
    Public Function OAuth_GetUserInfo(OAuth_access_token,UserOpenID)
        s_url = "https://api.weixin.qq.com/sns/userinfo?access_token="&OAuth_access_token&"&openid="&UserOpenID&"&lang=zh_CN"
        '发送请求
        OAuth_GetUserInfo = HttpSend(s_url,"get","")
        '错误时返回{"errcode":40003,"errmsg":" invalid openid "}
        'IF instr(OAuth_Get_Access_Token,"errcode")>0 Then YQasp.WE "读取信息失败！"
    End Function
     
    '回复被动响应消息
     
    '文本回复，换行：在content中能够换行，微信客户端就支持换行显示
    Public Function Re_Text(s_ToUser,s_FromUser,s_Content)
        s_xml = "<xml>"
        s_xml = s_xml&"<ToUserName><![CDATA["&s_ToUser&"]]></ToUserName>"
        s_xml = s_xml&"<FromUserName><![CDATA["&s_FromUser&"]]></FromUserName>"
        s_xml = s_xml&"<CreateTime>"&now()&"</CreateTime>"
        s_xml = s_xml&"<MsgType><![CDATA[text]]></MsgType>"
        s_xml = s_xml&"<Content><![CDATA["&s_Content&"]]></Content>"
        s_xml = s_xml&"</xml>"
        Re_Text = s_xml
    End Function
     
    '图片回复，MediaId通过上传多媒体文件，得到的id。 
    Public Function Re_Image(s_ToUser,s_FromUser,s_MediaId)
        s_xml = "<xml>"
        s_xml = s_xml&"<ToUserName><![CDATA["&s_ToUser&"]]></ToUserName>"
        s_xml = s_xml&"<FromUserName><![CDATA["&s_FromUser&"]]></FromUserName>"
        s_xml = s_xml&"<CreateTime>"&now()&"</CreateTime>"
        s_xml = s_xml&"<MsgType><![CDATA[image]]></MsgType>"
        s_xml = s_xml&"<Image>"
        s_xml = s_xml&"<MediaId><![CDATA["&s_MediaId&"]]></MediaId>"
        s_xml = s_xml&"</Image>"
        s_xml = s_xml&"</xml>"
        Re_Image = s_xml
    End Function
     
    '语音回复，通过上传多媒体文件，得到的id。 
    Public Function Re_Voice(s_ToUser,s_FromUser,s_MediaId)
        s_xml = "<xml>"
        s_xml = s_xml&"<ToUserName><![CDATA["&s_ToUser&"]]></ToUserName>"
        s_xml = s_xml&"<FromUserName><![CDATA["&s_FromUser&"]]></FromUserName>"
        s_xml = s_xml&"<CreateTime>"&now()&"</CreateTime>"
        s_xml = s_xml&"<MsgType><![CDATA[voice]]></MsgType>"
        s_xml = s_xml&"<Voice>"
        s_xml = s_xml&"<MediaId><![CDATA["&s_MediaId&"]]></MediaId>"
        s_xml = s_xml&"</Voice>"
        s_xml = s_xml&"</xml>"
        Re_Voice = s_xml
    End Function
     
    '视频回复，通过上传多媒体文件，得到的id。 
    Public Function Re_Video(s_ToUser,s_FromUser,s_MediaId,s_Title,s_Description)
        s_xml = "<xml>"
        s_xml = s_xml&"<ToUserName><![CDATA["&s_ToUser&"]]></ToUserName>"
        s_xml = s_xml&"<FromUserName><![CDATA["&s_FromUser&"]]></FromUserName>"
        s_xml = s_xml&"<CreateTime>"&now()&"</CreateTime>"
        s_xml = s_xml&"<MsgType><![CDATA[video]]></MsgType>"
        s_xml = s_xml&"<Video>"
        s_xml = s_xml&"<MediaId><![CDATA["&s_MediaId&"]]></MediaId>"
        s_xml = s_xml&"<Title><![CDATA["&s_Title&"]]></Title>"
        s_xml = s_xml&"<Description><![CDATA["&s_Description&"]]></Description>"
        s_xml = s_xml&"</Video>"
        s_xml = s_xml&"</xml>"
        Re_Video = s_xml
    End Function

    '音乐回复
    'Title               否         音乐标题
    'Description         否         音乐描述
    'MusicURL            否         音乐链接
    'HQMusicUrl          否         高质量音乐链接，WIFI环境优先使用该链接播放音乐
    'ThumbMediaId        是         缩略图的媒体id，通过上传多媒体文件，得到的id  
    Public Function Re_Music(s_ToUser,s_FromUser,s_Title,s_Description,s_MusicUrl,s_HQMusicUrl,s_ThumbMediaId)
        s_xml = "<xml>"
        s_xml = s_xml&"<ToUserName><![CDATA["&s_ToUser&"]]></ToUserName>"
        s_xml = s_xml&"<FromUserName><![CDATA["&s_FromUser&"]]></FromUserName>"
        s_xml = s_xml&"<CreateTime>"&now()&"</CreateTime>"
        s_xml = s_xml&"<MsgType><![CDATA[music]]></MsgType>"
        s_xml = s_xml&"<Music>"
        s_xml = s_xml&"<Title><![CDATA["&s_Title&"]]></Title>"
        s_xml = s_xml&"<Description><![CDATA["&s_Description&"]]></Description>"
        s_xml = s_xml&"<MusicUrl><![CDATA["&s_MusicUrl&"]]></MusicUrl>"
        s_xml = s_xml&"<HQMusicUrl><![CDATA["&s_HQMusicUrl&"]]></HQMusicUrl>"
        s_xml = s_xml&"<ThumbMediaId><![CDATA["&s_ThumbMediaId&"]]></ThumbMediaId>"               
        s_xml = s_xml&"</Music>"
        s_xml = s_xml&"</xml>"
        Re_Music = s_xml
    End Function
     
    '图文回复
    'ArticleCount         是         图文消息个数，限制为10条以内
    'Articles             是         多条图文消息信息，默认第一个item为大图,注意，如果图文数超过10，则将会无响应
    'Title                否         图文消息标题
    'Description          否         图文消息描述
    'PicUrl               否         图片链接，支持JPG、PNG格式，较好的效果为大图360*200，小图200*200
    'Url                  否         点击图文消息跳转链接
    's_Array格式： array(array(s_Title,s_Description,s_PicUrl,s_Url),array(s_Title,s_Description,s_PicUrl,s_Url))
    Public Function Re_News(s_ToUser,s_FromUser,s_Array)
        IF isArray(s_Array) Then
            s_ArticleCount = Ubound(s_Array)
            IF s_ArticleCount > 10 Then s_ArticleCount = 10
            s_xml = "<xml>"
            s_xml = s_xml&"<ToUserName><![CDATA["&s_ToUser&"]]></ToUserName>"
            s_xml = s_xml&"<FromUserName><![CDATA["&s_FromUser&"]]></FromUserName>"
            s_xml = s_xml&"<CreateTime>"&now()&"</CreateTime>"
            s_xml = s_xml&"<MsgType><![CDATA[news]]></MsgType>"
            s_xml = s_xml&"<ArticleCount>"&s_ArticleCount&"</ArticleCount>"
            s_xml = s_xml&"<Articles>"
            for s_i = 0 to s_ArticleCount - 1
                s_Title = s_Array(s_i,0)
                s_Description = s_Array(s_i,1)
                s_PicUrl = s_Array(s_i,2)
                s_Url = s_Array(s_i,3)
                s_xml = s_xml&"<item>"
                s_xml = s_xml&"<Title><![CDATA["&s_Title&"]]></Title>"
                s_xml = s_xml&"<Description><![CDATA["&s_Description&"]]></Description>"
                s_xml = s_xml&"<PicUrl><![CDATA["&s_PicUrl&"]]></PicUrl>"
                s_xml = s_xml&"<Url><![CDATA["&s_Url&"]]></Url>"
                s_xml = s_xml&"</item>"
            next
            s_xml = s_xml&"</Articles>"
            s_xml = s_xml&"</xml>"
        Else
            s_xml = ""
        End IF
        Re_News = s_xml
    End Function
    
    '主动发送客服消息
     
    '发送文本消息
    Public Function Send_Text(UserOpenID,Text)
        '获取Access_Token
        Access_Token = Get_Access_Token
        s_url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="&Access_Token
        '消息内容
        '{"touser":"OPENID","msgtype":"text","text":{"content":"Hello World"}}
        s_Data = "{""touser"":"""&UserOpenID&""",""msgtype"":""text"",""text"":{""content"":"""&Text&"""}}"
        '发送请求        ，返回正确值为：{"errcode":0,"errmsg":"ok"}
        Send_Text = HttpSend(s_url,"post",s_Data)
    End Function
     
    '发送图片消息
    Public Function Send_Image(UserOpenID,s_media_id)
        '获取Access_Token
        Access_Token = Get_Access_Token
        s_url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="&Access_Token
        '消息内容
        '{"touser":"OPENID","msgtype":"image","image":{"media_id":"MEDIA_ID"}}
        s_Data = "{""touser"":"""&UserOpenID&""",""msgtype"":""image"",""image"":{""media_id"":"""&s_media_id&"""}}"
        '发送请求        ，返回正确值为：{"errcode":0,"errmsg":"ok"}
        Send_Image = HttpSend(s_url,"post",s_Data)
    End Function
     
    '发送语音消息
    Public Function Send_Voice(UserOpenID,s_media_id)
        '获取Access_Token
        Access_Token = Get_Access_Token
        s_url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="&Access_Token
        '消息内容
        '{"touser":"OPENID","msgtype":"voice","voice":{"media_id":"MEDIA_ID"}}
        s_Data = "{""touser"":"""&UserOpenID&""",""msgtype"":""voice"",""voice"":{""media_id"":"""&s_media_id&"""}}"
        '发送请求        ，返回正确值为：{"errcode":0,"errmsg":"ok"}
        Send_Voice = HttpSend(s_url,"post",s_Data)
    End Function
     
    '发送视频消息
    Public Function Send_Video(UserOpenID,s_media_id,s_title,s_description)
        '获取Access_Token
        Access_Token = Get_Access_Token
        s_url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="&Access_Token
        '消息内容
        '{"touser":"OPENID","msgtype":"video","video":{"media_id":"MEDIA_ID","title":"TITLE","description":"DESCRIPTION"}}
        s_Data = "{""touser"":"""&UserOpenID&""",""msgtype"":""video"",""video"":{""media_id"":"""&s_media_id&""",""title"":"""&s_title&""",""description"":"""&s_description&"""}}"
        '发送请求        ，返回正确值为：{"errcode":0,"errmsg":"ok"}
        Send_Video = HttpSend(s_url,"post",s_Data)
    End Function
     
    '发送音乐消息
    Public Function Send_Music(UserOpenID,s_title,s_description,s_musicurl,s_hqmusicurl,s_thumb_media_id)
        '获取Access_Token
        Access_Token = Get_Access_Token
        s_url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="&Access_Token
        '消息内容
        '{"touser":"OPENID","msgtype":"music","music":{"title":"MUSIC_TITLE","description":"MUSIC_DESCRIPTION","musicurl":"MUSIC_URL","hqmusicurl":"HQ_MUSIC_URL","thumb_media_id":"THUMB_MEDIA_ID" }}
        s_Data = "{""touser"":"""&UserOpenID&""",""msgtype"":""music"",""music"":{""title"":"""&s_title&""",""description"":"""&s_description&""",""musicurl"":"""&s_musicurl&""",""hqmusicurl"":"""&s_hqmusicurl&""",""thumb_media_id"":"""&s_thumb_media_id&"""}}"
        '发送请求        ，返回正确值为：{"errcode":0,"errmsg":"ok"}
        Send_Music = HttpSend(s_url,"post",s_Data)
    End Function
     
    '发送图文消息
    Public Function Send_News(UserOpenID,s_Array)
        IF isArray(s_Array) Then
            s_ArticleCount = Ubound(s_Array)
            IF s_ArticleCount > 10 Then s_ArticleCount = 10
            '获取Access_Token
            Access_Token = Get_Access_Token
            s_url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="&Access_Token
            '消息内容
            s_Data = "{""touser"":"""&UserOpenID&""",""msgtype"":""news"",""news"":{""articles"":["
            for s_i = 0 to s_ArticleCount - 1
                s_title = s_Array(s_i,0)
                s_description = s_Array(s_i,1)
                s_picurl = s_Array(s_i,2)
                s_url = s_Array(s_i,3)
                s_Data = s_Data&"{""title"":"""&s_title&""",""description"":"""&s_description&""",""url"":"""&s_url&""",""picurl"":"""&s_picurl&"""}"
                if s_i < s_ArticleCount - 1 Then s_Data = s_Data&","
            next
            s_Data = s_Data&"]}}"
            '发送请求，返回正确值为：{"errcode":0,"errmsg":"ok"}
            Send_News = HttpSend(s_url,"post",s_Data)
        Else
            Send_News = ""
        End IF
    End Function
     
    '微信菜单管理
     
    '设置菜单，对于已关注的用户24小时才生效
    Public Function SetMenu(MenuData)
        '获取Access_Token
        Access_Token = Get_Access_Token
        s_url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token="&Access_Token
        '菜单Json
        '{"button":[{"type":"click","name":"服务介绍","key":"V101","sub_button":[{"type":"view","name":"搜索","url":"http://www.soso.com/"},……]},……]}
        '发送请求，返回正确值为：{"errcode":0,"errmsg":"ok"}
        SetMenu = HttpSend(s_url,"post",MenuData)
    End Function
     
    '查寻菜单
    Public Function GetMenu()
        '获取Access_Token
        Access_Token = Get_Access_Token
        s_url = "https://api.weixin.qq.com/cgi-bin/menu/get?access_token="&Access_Token
        '发送请求，返回正确值为：{"errcode":0,"errmsg":"ok"}
        GetMenu = HttpSend(s_url,"get","")
    End Function
     
    '删除菜单
    Public Function DelMenu()
        '获取Access_Token
        Access_Token = Get_Access_Token
        s_url = "https://api.weixin.qq.com/cgi-bin/menu/delete?access_token="&Access_Token
        '发送请求，返回正确值为：{"errcode":0,"errmsg":"ok"}
        GetMenu = HttpSend(s_url,"get","")
    End Function
     
    '用户分组管理
    '=========================================================================================================================
    '创建分组
    Public Function AddGroup(s_name)
        '获取Access_Token
        Access_Token=Get_Access_Token
        s_url="https://api.weixin.qq.com/cgi-bin/groups/create?access_token="&Access_Token
        '{"group":{"name":"test"}}
        s_post="{""group"":{""name"":"""&s_name&"""}}"
        '发送请求，返回正确值为：{"group": {"id": 107, "name": "test"}}，错误{"errcode":40013,"errmsg":"invalid appid"}
        AddGroup=HttpSend(s_url,"post",s_post)
    End Function
     
    '查询所有分组
    Public Function GetGroup()
        '获取Access_Token
        Access_Token=Get_Access_Token
        s_url="https://api.weixin.qq.com/cgi-bin/groups/get?access_token="&Access_Token
        '发送请求，错误{"errcode":40013,"errmsg":"invalid appid"}
        GetGroup=HttpSend(s_url,"get","")
    End Function
     
    '修改分组名
    Public Function EditGroup(s_id,s_name)
        '获取Access_Token
        Access_Token=Get_Access_Token
        s_url="https://api.weixin.qq.com/cgi-bin/groups/update?access_token="&Access_Token
        '{"group":{"id":108,"name":"test2_modify2"}}
        s_post="{""group"":{""id"":"&s_id&",""name"":"""&s_name&"""}}"
        '发送请求，返回正确值为：{"errcode": 0, "errmsg": "ok"}，错误{"errcode":40013,"errmsg":"invalid appid"}
        EditGroup=HttpSend(s_url,"post",s_post)
    End Function
     
    '查询用户所在分组
    Public Function GetUserGroup(UserOpenID)
        '获取Access_Token
        Access_Token=Get_Access_Token
        s_url="https://api.weixin.qq.com/cgi-bin/groups/getid?access_token="&Access_Token
        '{"openid":"od8XIjsmk6QdVTETa9jLtGWA6KBc"}
        s_post="{""openid"":"""&UserOpenID&"""}"
        '发送请求，返回正确值为：{"groupid": 102}，错误{"errcode":40003,"errmsg":"invalid openid"}
        GetUserGroup=HttpSend(s_url,"post",s_post)
    End Function
     
    '修改用户分组
    Public Function EditUserGroup(UserOpenID,s_to_groupid)
        '获取Access_Token
        Access_Token=Get_Access_Token
        s_url="https://api.weixin.qq.com/cgi-bin/groups/members/update?access_token="&Access_Token
        '{"openid":"oDF3iYx0ro3_7jD4HFRDfrjdCM58","to_groupid":108}
        s_post="{""openid"":"""&UserOpenID&""",""to_groupid"":"&s_to_groupid&"}"
        '发送请求，返回正确值为：{"errcode": 0, "errmsg": "ok"}，错误{"errcode":40013,"errmsg":"invalid appid"}
        EditUserGroup=HttpSend(s_url,"post",s_post)
    End Function
     
    '二维码
    '=========================================================================================================================
    '获取带参数的二维码的过程包括两步，首先创建二维码ticket，然后凭借ticket到指定URL换取二维码。
    '目前有2种类型的二维码，分别是临时二维码和永久二维码，前者有过期时间，最大为1800秒，但能够生成较多数量，后者无过期时间，数量较少（目前参数只支持1--100000）
    '两种二维码分别适用于帐号绑定、用户来源统计等场景。 
     
    '创建临时二维码ticket
    Public Function AddTempTicket(s_scene_id)
        '获取Access_Token
        Access_Token=Get_Access_Token
        s_url="https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token="&Access_Token
         
        '{"expire_seconds": 1800, "action_name": "QR_SCENE", "action_info": {"scene": {"scene_id": 123}}}
        'expire_seconds         该二维码有效时间，以秒为单位。 最大不超过1800。
        'action_name                 二维码类型，QR_SCENE为临时,QR_LIMIT_SCENE为永久
        'action_info                 二维码详细信息
        'scene_id                         场景值ID，临时二维码时为32位非0整型，永久二维码时最大值为100000（目前参数只支持1--100000） 
        s_post="{""expire_seconds"": 1800, ""action_name"": ""QR_SCENE"", ""action_info"": {""scene"": {""scene_id"": "&s_scene_id&"}}}"
         
        '发送请求        
        AddTempTicket=HttpSend(s_url,"post",s_post)
        '正确返回：
        '{"ticket":"gQG28DoAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xL0FNMRnNRAAIEesLvUQMECAcAAA==","expire_seconds":1800}
        '错误返回
        '{"errcode":40013,"errmsg":"invalid appid"}
    End Function
     
    '创建永久二维码ticket
    Public Function AddLongTicket(s_scene_id)
        '获取Access_Token
        Access_Token=Get_Access_Token
        s_url="https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token="&Access_Token
         
        '{"action_name": "QR_LIMIT_SCENE", "action_info": {"scene": {"scene_id": 123}}}
        s_post="{""action_name"": ""QR_LIMIT_SCENE"", ""action_info"": {""scene"": {""scene_id"": "&s_scene_id&"}}}"
         
        '发送请求        
        AddLongTicket=HttpSend(s_url,"post",s_post)
    End Function
     
    '通过ticket换取二维码
    Public Function GetQrCode(s_ticket)
        '获取二维码ticket后，开发者可用ticket换取二维码图片。
        '请注意，本接口无须登录态即可调用。 
        '提醒： TICKET记得进行UrlEncode
        s_url="https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket="&Server.URLEncode(s_ticket)
         
        '发送请求        
        GetQrCode=HttpSend(s_url,"get","")
        'ticket正确情况下，http 返回码是200，是一张图片，可以直接展示或者下载。
        'HTTP头（示例）如下：
        'Accept-Ranges:bytes
        'Cache-control:max-age=604800
        'Connection:keep-alive
        'Content-Length:28026
        'Content-Type:image/jpg
        'Date:Wed, 16 Oct 2013 06:37:10 GMT
        'Expires:Wed, 23 Oct 2013 14:37:10 +0800
        'Server:nginx/1.4.1 
        '错误情况下（如ticket非法）返回HTTP错误码404。 
    End Function
     
     
    '公共方法
    '=========================================================================================================================
     
    '提交Http的GET或POST请求，并得到返回的结果
    Private Function HttpSend(url,stype,s_data)
        'YQasp.Use "Http"
        Dim http
        Set Http = YQasp.Http.New
        IF YQasp.Has(s_data) Then Http.Data=s_data
        IF lcase(stype)="post" Then
                HttpSend = Http.Post(url)
        Else
                HttpSend = Http.Get(url)
        End IF
        Set http = Nothing
    End Function
             
End Class
%>