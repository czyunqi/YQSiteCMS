<%
'#################################################################################
'## YQasp.aspjpeg.asp
'## ------------------------------------------------------------------------------
'## Feature  : YQAsp AspJpeg Class 
'## Version  : v0.2
'## Author      :   云奇(114066164@qq.com)
'## Update Date :   2021-7-15
'## Description : 基于AspJpeg 2 的YQasp插件
'#################################################################################
Class YQAsp_AspJpeg
 
 '===================================================
 '定义变量
 '===================================================
 Private s_author
 Private s_SourcePath, s_ToPath
 Private s_AspJpeg, s_Width, s_Height, s_Quality, s_Opacity, s_Force, s_BackGroundColor
 Private s_PenColor, s_PenWidth, s_BrushSolid, s_Font
 Private s_WaterMarkPath, s_Position
 Private s_Binary 
 Private t_PNGOutput 
 Private s_RegKey

 '===================================================
 '类初始化
 '===================================================
 Private Sub Class_Initialize()
  s_author = "xuhuan"
    
  YQasp.Use "Fso"
  
  Set s_AspJpeg =  [New]() '创建AspJpeg对象
  
  s_Quality = 100 '生成图片质量
  s_Opacity = 100 '生成图片透明度
  s_Width = 200 '默认图片宽度
  s_Height = 200 '默认图片高度
  s_Force = False '是否强制生成固定大小图片
  s_BackGroundColor = &HFFFFFF '背景色
  s_PenColor = &H000000 '画笔颜色
  s_PenWidth = 1 '画笔宽度   
  s_BrushSolid = False '是否加粗处理
  
  s_WaterMarkPath = ""
  
  s_Font = "" '文字水印使用的字体路径
  
  t_PNGOutput = False '是否PNG输出
  
  s_Binary = Null '图片的二进制数据
  
  s_RegKey = ""
  
  YQasp.Error(10001) = "服务器没有安装AspJpeg组件."
  YQasp.Error(10002) = "来源路径错误或文件不存在."
  YQasp.Error(10003) = "存储路径错误或路径不存在."
  YQasp.Error(10004) = "水印图片路径错误或水印图片不存在."
  YQasp.Error(10005) = "参数不能为空."
  YQasp.Error(10006) = "不是Gif格式的图片."
 End Sub
 
 '===================================================
 '清理工作
 '===================================================
 Private Sub Class_Terminate()
  s_AspJpeg.Close
  Set s_AspJpeg = Nothing
 End Sub
 
 '===================================================
 '属性设置
 '===================================================
 '---------------------------------------------------
 ' 返回作者，只读
 '---------------------------------------------------
 Public Property Get Author()
  Author = s_author
 End Property
 '---------------------------------------------------
 ' 返回AspJpeg版本，只读
 '---------------------------------------------------
 Public Property Get Version()
  Version = s_AspJpeg.Version
 End Property
 '---------------------------------------------------
 ' 返回当前操作的AspJpeg对象，只读
 '---------------------------------------------------
 Public Property Get AspJpeg()
  set AspJpeg = s_AspJpeg
 End Property
 '---------------------------------------------------
 ' 返回AspJpeg组件过期日期，只读
 '---------------------------------------------------
 Public Property Get [Expires]()
  [Expires] = s_AspJpeg.Expires
 End Property
 
 
 '---------------------------------------------------
 ' 设置AspJpeg组件的注册码，只写
 '---------------------------------------------------
 Public Property Let RegKey(ByVal k)
  s_AspJpeg.RegKey = k
  s_RegKey = k
 End Property
 
 '---------------------------------------------------
 ' 设置和返回图片生成质量全局参数，读写
 '---------------------------------------------------
 Public Property Let Quality(ByVal q)
  s_Quality = q
 End Property
 Public Property Get Quality()
  Quality = s_Quality
 End Property
 '---------------------------------------------------
 ' 设置和返回图片生成质量全局参数，读写
 '---------------------------------------------------
 Public Property Let Opacity(ByVal o)
  s_Opacity = o
 End Property
 Public Property Get Opacity()
  Opacity = s_Opacity
 End Property
 
 '---------------------------------------------------
 ' 设置和返回批量处理来源文件夹，读写
 '---------------------------------------------------
 Public Property Let SourcePath(ByVal s)
  s_SourcePath = YQasp.Fso.MapPath(s)
  if not YQasp.Fso.IsExists(s_SourcePath) then
   YQasp.Error.Raise 10002
  end if
 End Property
 Public Property Get SourcePath()
  SourcePath = s_SourcePath
 End Property
 '---------------------------------------------------
 ' 设置和返回批量处理保存文件夹，读写
 '---------------------------------------------------
 Public Property Let ToPath(ByVal s)
  s_ToPath = YQasp.Fso.MapPath(s)
  if not YQasp.Fso.IsExists(s_ToPath) then
   YQasp.Error.Raise 10002
  end if
 End Property
 Public Property Get ToPath()
  ToPath = s_ToPath
 End Property
 
 '---------------------------------------------------
 ' 设置和返回图片默认宽度，全局参数，读写
 '---------------------------------------------------
 Public Property Let Width(ByVal w)
  s_Width = w
 End Property
 Public Property Get Width()
  Width = s_Width
 End Property
 '---------------------------------------------------
 ' 设置和返回图片默认高度，全局参数，读写
 '---------------------------------------------------
 Public Property Let Height(ByVal h)
  s_Height = h
 End Property
 Public Property Get Height()
  Height = s_Height
 End Property
 '---------------------------------------------------
 ' 设置和返回默认强制生成指定尺寸图片，全局参数，读写
 '---------------------------------------------------
 Public Property Let Force(ByVal f)
  s_Force = f
 End Property
 Public Property Get Force()
  Force = s_Force
 End Property
 
 '---------------------------------------------------
 ' 设置和返回默认图片背景颜色，全局参数，读写
 '---------------------------------------------------
 Public Property Let BackGroundColor(ByVal bc)
  s_BackGroundColor = bc
 End Property
 Public Property Get BackGroundColor()
  BackGroundColor = s_BackGroundColor
 End Property
 '---------------------------------------------------
 ' 设置和返回默认画笔颜色，全局参数，读写
 '---------------------------------------------------
 Public Property Let PenColor(ByVal p)
  s_PenColor = p
 End Property
 Public Property Get PenColor()
  PenColor = s_PenColor
 End Property
 
 '---------------------------------------------------
 ' 设置和返回默认画笔宽度，全局参数，读写
 '---------------------------------------------------
 Public Property Let PenWidth(ByVal p)
  s_PenWidth = p
 End Property
 Public Property Get PenWidth()
  PenWidth = s_PenWidth
 End Property
 
 '---------------------------------------------------
 ' 设置和返回默认是否加粗，全局参数，读写
 '---------------------------------------------------
 Public Property Let BrushSolid(ByVal b)
  s_BrushSolid = b
 End Property
 Public Property Get BrushSolid()
  BrushSolid = s_BrushSolid
 End Property
 '---------------------------------------------------
 ' 设置和返回默认字体路径，全局参数，读写
 '---------------------------------------------------
 Public Property Let Font(ByVal f)
  s_Font = f
 End Property
 Public Property Get Font()
  Font = s_Font
 End Property
 '---------------------------------------------------
 ' 设置和返回默认水印图片路径，全局参数，读写
 '---------------------------------------------------
 Public Property Let WaterMarkPath(ByVal w)
  s_WaterMarkPath = w
 End Property
 Public Property Get WaterMarkPath()
  WaterMarkPath = s_WaterMarkPath
 End Property
 
 
 
 '===================================================
 ' 创建一个新的AspJpeg对象
 '===================================================
 Public Function [New]()
  if YQasp.IsInstall("Persits.Jpeg") then
   Set [New] =  Server.CreateObject("Persits.Jpeg")
   if YQasp.Has(s_RegKey) then
    [New].RegKey = s_RegKey
   end if
  else
   YQasp.Error.Raise 10001
  end if
 End Function
 
 '===================================================
 ' 根据参数自动调用相应方式打开图片，
 ' 可以是图片路径，二进制数据
 '===================================================
 Public Function [Open](ByVal s) 
  if not YQasp.Has(s) then   
   YQasp.Error.Raise 10005 
  end if
  
  set t_AspJpeg = [New]()
  
  select case typename(s)
   case "String"
    t_SourcePath = YQasp.Fso.MapPath(s)
    t_AspJpeg.Open t_SourcePath
   case "Byte()"
    t_AspJpeg.OpenBinary s
   case "IASPJpeg"
    set t_AspJpeg = s
   case else 
    YQasp.Error.Raise 10005 
  end select
  
  set [Open] = t_AspJpeg
 End Function
 
 '===================================================
 ' 判断是否输出PNG格式图片，如果保存文件扩展名为PNG
 ' 则按照PNG格式输出保存
 '===================================================
 Private Sub SetPNGOutput(ByVal s)
  if YQasp.Fso.ExtOf(s) = ".png" then
   t_PNGOutput = True
  else
   t_PNGOutput = False
  end if
 End Sub
 
 '===================================================
 ' 验证码函数，需要一个背景图片
 '===================================================
 Public Function RandCode(ByVal r, ByVal s, ByVal t)
  if YQasp.Has(r) then
   t_RandCode = r
  else
   t_RandCode = YQasp.RandStr("4:0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
  end if  
  Session("RandCode") = t_RandCode
  
  t_SourcePath = YQasp.Fso.MapPath(s)
  t_ToPath = YQasp.Fso.MapPath(t)
  
  if not YQasp.Fso.IsExists(t_SourcePath) then
   YQasp.Error.Raise 10002
  end if
  
  set s_AspJpeg = [Open](t_SourcePath)    
  
  Randomize
  for i = 1 to len(t_RandCode)  
   s_AspJpeg.Canvas.Font.Rotation = (Rnd*25-5)  '倾斜度
   s_AspJpeg.Canvas.Font.Color = (Rnd*255)*255*255+(Rnd*255)*255*255+(Rnd*255)*255*255 '颜色
   s_AspJpeg.Canvas.Font.Family = "Arial Black" '字体 宋体/黑体/楷体/隶书/
   s_AspJpeg.Canvas.Font.Bold = YQasp.ifHas(s_BrushSolid,False)     '是否加粗 true/false
   s_AspJpeg.Canvas.Font.Size = 30       '字体大小 
   s_AspJpeg.Canvas.Font.ShadowColor = &HFFFFFF
   s_AspJpeg.Canvas.Font.Quality = 100
   if YQasp.Has(s_Font) then
    s_AspJpeg.Canvas.PrintText 20 * (i-1)+5, 0, Mid(t_RandCode,i,1) , s_Font
   else
    s_AspJpeg.Canvas.PrintText 20 * (i-1)+5, 0, Mid(t_RandCode,i,1)
   end if
  next
  
   
  s_AspJpeg.Quality=YQasp.ifHas(s_Quality,100) '设置加水印后图片的质量
  
  s_Binary = s_AspJpeg.Binary  
  SetPNGOutput(t_ToPath)
  if t_PNGOutput then
   s_AspJpeg.PNGOutput = t_PNGOutput
  end if
  if YQasp.Has(t) then
   s_AspJpeg.save t_ToPath    '保存  
  end if
  
  RandCode =  YQasp.ifHas(t_ToPath,t_SourcePath)
 End Function
 
 '===================================================
 ' 输出图片
 '===================================================
 Public Sub [Flush]()
  Response.Expires = -9999
  Response.AddHeader "pragma", "no-cache"
  Response.AddHeader "cache-ctrol", "no-cache"
  Response.ContentType = "image/jpeg"
  Response.BinaryWrite s_Binary
 End Sub
 
 '==========================================================
 ' 生成缩略图
 '  Thumbnail(原图片路径, 生成图片路径, 高度, 宽度, 品质, 是否强制宽高)
 '==========================================================
 Public Function Thumbnail(ByVal s, ByVal t, ByVal w, ByVal h, ByVal q, ByVal f)
  t_SourcePath = YQasp.Fso.MapPath(s)
  t_ToPath = YQasp.Fso.MapPath(t)
  
  if not YQasp.Fso.IsExists(t_SourcePath) then
   YQasp.Error.Raise 10002
  end if
  
  t_Quality = YQasp.ifHas(q,s_Quality)
  t_Width = YQasp.ifHas(w,s_Width)
  t_Height = YQasp.ifHas(h,s_Height)
  t_Force = YQasp.ifHas(f,s_Force)
    
  Dim OriginalWidth, OriginalHeight '原图片宽度、高度 
     Dim CurrentWidth, CurrentHeight '缩略图宽度、高度 
  
  set s_AspJpeg = [Open](t_SourcePath)
  
  OriginalWidth = s_AspJpeg.Width
  OriginalHeight = s_AspJpeg.Height
  
  
  CurrentWidth = OriginalWidth
  CurrentHeight = OriginalHeight
  
  if OriginalWidth > t_Width or OriginalHeight > t_Height then
   if OriginalWidth >= t_Width then
    CurrentWidth = t_Width 
    CurrentHeight = (t_Width * OriginalHeight) / OriginalWidth
   end if
   if CurrentHeight >= t_Height then
    CurrentHeight = t_Height
    CurrentWidth = (t_Height * CurrentWidth) / CurrentHeight
   end if
  end if
     
  s_AspJpeg.Width = CurrentWidth
  s_AspJpeg.Height = CurrentHeight
  s_AspJpeg.Quality = YQasp.ifHas(t_Quality , YQasp.ifHas(s_Quality,100))
  s_AspJpeg.Sharpen 1,250
  
  if t_Force then  
   t_NewImage_Size = YQasp.IIF(CurrentWidth > CurrentHeight, CurrentWidth, CurrentHeight)
   set t_AspJpeg = [New]()
   t_AspJpeg.New t_NewImage_Size , t_NewImage_Size , s_BackGroundColor
   t_AspJpeg.Canvas.DrawImage (t_NewImage_Size - CurrentWidth)/2 ,(t_NewImage_Size - CurrentHeight)/2 ,s_AspJpeg 
   s_Binary = t_AspJpeg.Binary
   SetPNGOutput(t_ToPath)
   if t_PNGOutput then
    t_AspJpeg.PNGOutput = t_PNGOutput
   end if
   t_AspJpeg.Save t_ToPath 
   t_AspJpeg.Close
   set t_AspJpeg = Nothing
  else  
   s_Binary = s_AspJpeg.Binary
   SetPNGOutput(t_ToPath)
   if t_PNGOutput then
    s_AspJpeg.PNGOutput = t_PNGOutput
   end if
   s_AspJpeg.Save t_ToPath  
  end if 
        
  Thumbnail = t_ToPath
 End Function
 
 '===================================================
 ' 合并图片
 '===================================================
 Public Function Merge(ByVal s,ByVal t,ByVal r, ByVal x, ByVal y)
  t_SourcePath = YQasp.Fso.MapPath(s)
  t_ToPath = YQasp.Fso.MapPath(t)   
  
  if not YQasp.Fso.IsExists(t_SourcePath) then
   YQasp.Error.Raise 10002
  end if
  if not YQasp.Fso.IsExists(t_ToPath) then
   YQasp.Error.Raise 10003
  end if
  
  if not YQasp.Has(r) then
   t_ResultPath = YQasp.Fso.MapPath(r)
  else
   t_ResultPath = t_ToPath
  end if
  
  set t_Source_AspJpeg = [Open](t_SourcePath)
  set t_To_AspJpeg = [Open](t_ToPath)
  
  t_x = YQasp.ifHas(x,(t_To_AspJpeg.Width - t_Source_AspJpeg.Width) / 2)
  t_y = YQasp.ifHas(y,(t_To_AspJpeg.Height - t_Source_AspJpeg.Height) / 2)
  
  t_To_AspJpeg.Canvas.DrawImage t_x,t_y,t_Source_AspJpeg
  
  SetPNGOutput(t_ResultPath)
  if t_PNGOutput then
   t_To_AspJpeg.PNGOutput = t_PNGOutput
  end if
  t_To_AspJpeg.Save t_ResultPath
  
  s_Binary = t_To_AspJpeg.Binary
  
  t_Source_AspJpeg.Close
  t_To_AspJpeg.Close
  set t_Source_AspJpeg = Nothing
  set t_To_AspJpeg = Nothing
  
  Merge = t_ResultPath
  
 End Function
 
 '===================================================
 ' 根据参数返回水印坐标位置的数组
 '===================================================
 Public Function WaterMarkPosition(ByVal source_w,ByVal source_h,ByVal width,ByVal height,ByVal pos)
  Dim t_Position(2)
  
  select case pos '水印位置  
   case 1 '顶部居左
    t_Position(0) = 0
    t_Position(1) = 0 
   case 2 '顶部居中   
    t_Position(0) = (source_w - width) / 2
    t_Position(1) = 0
   case 3    '顶部居右   
    t_Position(0) = source_w - width
    t_Position(1) = 0
   case 4    '中心位置   
    t_Position(0) = (source_w - width) / 2  
    t_Position(1) = (source_h - height) / 2  
   case 5    '底部居左   
    t_Position(0) = 0
    t_Position(1) = source_h - height  - 10
   case 6    '底部居中   
    t_Position(0) = (source_w - width) / 2  
    t_Position(1) = source_h - height  - 10
   case 7    '底部居右   
    t_Position(0) = source_w - width
    t_Position(1) = source_h - height - 10
   case else   '随机位置   
    Randomize
    t_Position(0) = YQasp.Rand(0,(source_w - width)) 
    Randomize
    t_Position(1) = Int(source_h - height + 1) * Rnd 
  end select
  WaterMarkPosition = t_Position
  
 End Function
 
 '===================================================
 ' 添加文字水印
 ' WaterMarkFont(文字,背景图片路径,水印位置,水印质量,
 ' 水印透明度,水印文字角度,文字颜色,文字字体,是否加粗,文字尺寸) 
 '===================================================
 Public Function WaterMarkFont(ByVal Str,ByVal BackgroundImage,ByVal Pos,ByVal Quality,ByVal Opacity,ByVal Rotation,ByVal Color,ByVal Family,ByVal Bold,ByVal FontSize)  
  t_SourcePath = YQasp.Fso.MapPath(BackgroundImage)
  
  if not YQasp.Fso.IsExists(t_SourcePath) then
   YQasp.Error.Raise 10002
  end if
  
  set t_AspJpeg = [Open](t_SourcePath)
  
  set b_AspJpeg = [New]()
  b_AspJpeg.New  t_AspJpeg.Width , t_AspJpeg.Height , s_BackGroundColor  
  
  if YQasp.Has(Rotation) then
   b_AspJpeg.Canvas.Font.Rotation = Rotation  '倾斜度
  end if  

  b_AspJpeg.Canvas.Font.Color = YQasp.ifHas(Color,s_PenColor) '颜色 
  
  b_AspJpeg.Canvas.Font.Family = YQasp.ifHas(Family,"Arial") '字体 宋体/黑体/楷体/隶书/
  
  b_AspJpeg.Canvas.Font.Bold = YQasp.ifHas(Bold,YQasp.ifHas(s_BrushSolid,False))     '是否加骈 true/  

  b_AspJpeg.Canvas.Font.Size = YQasp.ifHas(FontSize,30)
  
  b_AspJpeg.Canvas.Font.Opacity = 1
  
  b_AspJpeg.Canvas.Font.Quality = YQasp.ifHas(Quality,s_Quality)
  
  
  FontHeight = Round( ( YQasp.ifHas(FontSize,30) / 2 ))
  FontWidth = Round( FontHeight * Len(Str))
'  FontHeight = YQasp.ifHas(FontSize,30)
'  FontWidth = FontHeight * Len(Str)

  t_WaterMarkPosition = WaterMarkPosition(t_AspJpeg.Width , t_AspJpeg.Height , FontWidth , FontHeight , Pos)
   
  if YQasp.Has(s_Font) and not YQasp.Has(Family) then
   b_AspJpeg.Canvas.PrintText t_WaterMarkPosition(0), t_WaterMarkPosition(1), Str , s_Font
  else
   b_AspJpeg.Canvas.PrintText t_WaterMarkPosition(0), t_WaterMarkPosition(1), Str
  end if
      
  t_AspJpeg.Canvas.DrawImage 0, 0, b_AspJpeg , YQasp.ifHas(Opacity ,YQasp.ifHas(s_Opacity,100) ) / 100 , s_BackGroundColor 
  
  s_Binary = t_AspJpeg.Binary
  
  SetPNGOutput(t_SourcePath)
  if t_PNGOutput then
   t_AspJpeg.PNGOutput = t_PNGOutput
  end if
  t_AspJpeg.Save t_SourcePath
  
  b_AspJpeg.Close
  set b_AspJpeg = Nothing
  t_AspJpeg.Close
  set t_AspJpeg = Nothing
  WaterMarkFont = t_SourcePath
 End Function
 
 '===================================================
 ' 添加图片水印
 ' WaterMarkJpeg(水印图片路径,背景图片路径,水印位置,水印质量,水印透明度) 
 '===================================================
 Public Function WaterMarkJpeg(ByVal s,ByVal t,ByVal Pos,ByVal Quality,ByVal Opacity)
  t_SourcePath = YQasp.Fso.MapPath(s)
  t_ToPath = YQasp.Fso.MapPath(t)
  
  if not YQasp.Fso.IsExists(t_SourcePath) then
   if not YQasp.Fso.IsExists(s_WaterMarkPath) then
    YQasp.Error.Raise 10004
   else
    t_SourcePath = s_WaterMarkPath
   end if
  end if
  if not YQasp.Fso.IsExists(t_ToPath) then
   YQasp.Error.Raise 10003
  end if
  
  set t_Source_AspJpeg = [Open](t_SourcePath)
  
  set t_To_AspJpeg = [Open](t_ToPath)
  
  t_WaterMarkPosition = WaterMarkPosition(t_To_AspJpeg.Width , t_To_AspJpeg.Height , t_Source_AspJpeg.Width , t_Source_AspJpeg.Height , Pos)
  
  t_To_AspJpeg.Quality  = YQasp.ifHas(Quality , s_Quality) 
  
  
  if t_PNGOutput then
   t_To_AspJpeg.Canvas.DrawPNG t_WaterMarkPosition(0), t_WaterMarkPosition(1) , t_Source_AspJpeg , YQasp.ifHas(Opacity ,YQasp.ifHas(s_Opacity,100)) / 100,s_BackGroundColor
  else
   t_To_AspJpeg.Canvas.DrawImage t_WaterMarkPosition(0), t_WaterMarkPosition(1) , t_Source_AspJpeg , YQasp.ifHas(Opacity ,YQasp.ifHas(s_Opacity,100)) / 100,s_BackGroundColor
  end if
  
  s_Binary = t_To_AspJpeg.Binary
  
  SetPNGOutput(t_ToPath)
  if t_PNGOutput then
   t_To_AspJpeg.PNGOutput = t_PNGOutput
  end if
  
  t_To_AspJpeg.Save t_ToPath
  
  
  t_Source_AspJpeg.Close
  t_To_AspJpeg.Close
  set t_Source_AspJpeg = Nothing
  set t_To_AspJpeg = Nothing
  WaterMarkJpeg = t_ToPath
 End Function
 
 '===================================================
 ' 简化的添加水印函数，根据参数自动判断是文字水印还是图片水印
 ' WaterMark(水印图片路径或文字,背景图片路径,水印位置,水印质量,水印透明度) 
 '===================================================
 Public Function WaterMark(ByVal s,ByVal t,ByVal Pos,ByVal Quality,ByVal Opacity)  
  t_SourcePath = YQasp.Fso.MapPath(s)
  t_ToPath = YQasp.Fso.MapPath(t)
  
  if not YQasp.Fso.IsExists(t_ToPath) then
   YQasp.Error.Raise 10003
  end if
  if YQasp.Fso.IsFile(t_SourcePath) then
   WaterMark = WaterMarkJpeg( s, t, Pos, Quality, Opacity)
  else
   WaterMark = WaterMarkFont( s, t, Pos, Quality, Opacity, "", "", "", "", "")
  end if  
 End Function
 
 Public Function W(ByVal s,ByVal t,ByVal Pos,ByVal Quality,ByVal Opacity)
  W = WaterMark( s, t, Pos, Quality, Opacity)
 End Function
 
 '===================================================
 ' 图片切割，按照提供的左上角和右下角坐标切割图片 
 ' Crop(原图片路径,图片存储路径[可以为空],左上角X坐标,左上角y坐标,右下角x坐标,右下角y坐标)
 '===================================================
 Public Function Crop(ByVal s,ByVal t,ByVal tx,ByVal ty,ByVal bx,ByVal by)
  t_SourcePath = YQasp.Fso.MapPath(s)
  t_ToPath = YQasp.Fso.MapPath(YQasp.ifHas(t,s))
  if not YQasp.Fso.IsExists(t_SourcePath) then
   YQasp.Error.Raise 10002
  end if
  
  set t_Source_AspJpeg = [Open](t_SourcePath)
  
  t_Source_AspJpeg.Crop tx,ty,bx,by
  s_Binary = t_Source_AspJpeg.Binary
  SetPNGOutput(t_ToPath)
  if t_PNGOutput then
   t_Source_AspJpeg.PNGOutput = t_PNGOutput
  end if
  t_Source_AspJpeg.Save t_ToPath
  t_Source_AspJpeg.Close
  set t_Source_AspJpeg = Nothing
  Crop = t_ToPath
 End Function
 
 '===================================================
 ' Gif动画图片缩放，保留原动画属性 
 ' GifResize(原Gif图片路径,图片存储路径[可以为空],图片宽度,图片高度[可以为空],图片算法)
 '===================================================
 Public Function GifResize(ByVal s,ByVal t,ByVal w,ByVal h,ByVal a)
  t_SourcePath = YQasp.Fso.MapPath(s)
  t_ToPath = YQasp.Fso.MapPath(YQasp.ifHas(t,s))
  if not YQasp.Fso.IsExists(t_SourcePath) then
   YQasp.Error.Raise 10002
  end if  
  if  Lcase(YQasp.Fso.Extof(t_SourcePath)) <> ".gif" then
   YQasp.Error.Raise 10006
  end if  
  set t_AspJpeg = [New]()
  set t_Gif = t_AspJpeg.Gif
  t_Gif.Open t_SourcePath
  if not YQasp.Has(h) then
   t_Gif.Resize w 
  else
   t_Gif.Resize w , h , YQasp.ifHas(a,0)
  end if
  
  t_Gif.Save t_ToPath
  s_Binary = t_Gif.Binary
  t_AspJpeg.Close
  set t_Gif = Nothing
  set t_AspJpeg = Nothing
  GifResize = t_ToPath
 End Function
 
 '===================================================
 ' Gif动画图片缩放函数简化函数，保留原动画属性 
 ' G(原Gif图片路径,图片存储路径[可以为空],图片宽度)
 '===================================================
 Public Function G(ByVal s,ByVal t,ByVal w)
  G = GifResize(s,t,w,"","")
 End Function

 '===================================================
 ' 默认函数，感觉缩略图用的会比较多，就把生成缩略图作为了默认函数
 ' 缩略图函数简化函数
 '===================================================
 Public Default Function T(ByVal s, ByVal tp, ByVal w, ByVal h, ByVal q, ByVal f)
  T = Thumbnail(s,tp,w,h,q,f)
 End Function

End Class
%>
