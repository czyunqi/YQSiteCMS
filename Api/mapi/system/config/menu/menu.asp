<%
'***********************************************************
'* 添加系统菜单
'* Author      :   云奇(114066164@qq.com)
'* Update Date :   2021-8-13
'***********************************************************
Sub add()

  If checkDomain() = False Then Exit Sub          '验证请求域名
  If checkMethod("POST") = False Then Exit Sub    '校验请求方式

  '菜单名称
  Dim boardName : boardName = YQAsp.Str.Validate(YQAsp.Post("boardName")).Name("菜单名称").Required.PrintEndJson '校验不能为空
  '父级栏目Id
  Dim parentID : parentID = YQAsp.Str.Validate(YQAsp.Post("parentID")).Name("父级栏目Id").Required.IsNumber.PrintEndJson '校验不能为空且必须是数字
  '父级栏目路径, 栏目级别, 栏目子级数量, 排序依据
  Dim parentStr, depth, child, orders

  if parentID = 0 then
    '如果父级栏目ID为0,即为一级栏目
    parentStr = "0"
    depth = 0
    child = 0
    '查询所有一级栏目的排序一最大的值
    set rs = YQAsp.db.sel("select top 1 orders from board where depth=0 order by orders desc")
    if YQAsp.isn(rs) then
      orders = 1  '排序号
    else
      orders = rs(0) + 1    '排序号
    end if
  YQAsp.Db.Close(rs)
  else
    '如果父级栏目ID不为0，则为二级以下栏目
    '查询父级栏目相关信息
    YQAsp.Var("parentID") = parentID
    set rs = YQAsp.db.Query("select top 1 * from board where id={parentID}")
    if rs("depth") = 0 then
      parentStr = parentID&","  '如父级栏目为一级栏目则栏目路径为父级栏目的ID
    else
      parentStr = rs("parentStr")&","&parentID&","  '父级栏目的路径加父级栏目的ID组成新栏目的父级路径
    end if
    depth = rs("depth") + 1 '栏目级别为父级栏目的级别加1
    child = 0 '子栏目数
    orders = cstr(rs("orders")&","&rs("child")+1) '排序号
    YQAsp.Db.Close(rs)
    '更新父级的子栏目数
    YQAsp.Db.Exec("update board set child = child + 1 where id = {parentID}")
  end if
  
  '插入新栏目记录
  YQAsp.Var("boardName") = boardName
  YQAsp.Var("parentStr") = parentStr
  YQAsp.Var("depth") = depth
  YQAsp.Var("child") = child
  YQAsp.Var("orders") = orders
  dim r : r = YQAsp.Db.Ins("board", "boardName:{boardName},parentID:{parentID},parentStr:{parentStr},depth:{depth},child:{child},orders:{orders}")
  if r = 1 then
    msg = "添加成功!"
  else
    code = 300
    msg = "添加失败!"
  end if

End Sub
%>

<%
'***********************************************************
'* 修改系统菜单
'* Author      :   云奇(114066164@qq.com)
'* Update Date :   2021-8-13
'***********************************************************
Sub update()

  If checkDomain() = False Then Exit Sub          '验证请求域名
  If checkMethod("POST") = False Then Exit Sub    '校验请求方式

  '菜单Id
  Dim id : id = YQAsp.Str.Validate(YQAsp.Post("id")).Name("id").Required.PrintEndJson '校验不能为空
  '菜单名称
  Dim boardName : boardName = YQAsp.Str.Validate(YQAsp.Post("boardName")).Name("菜单名称").Required.PrintEndJson '校验不能为空
  
  YQAsp.Var("id") = id
  YQAsp.Var("boardName") = boardName
  
  set rs = YQAsp.db.sel("select top 1 id from board where id={id}")
  if YQAsp.isn(rs) Then
    YQAsp.Db.Close(rs)
    code = 300
    msg = "找不到相关记录!"
  else
    YQAsp.Db.Close(rs)
    dim r : r = YQAsp.Db.Exec("update board set boardName={boardName} where id = {id}")
    if r = 1 then
      msg = "修改成功!"
    else
      code = 300
      msg = "修改失败!"
    end if
  end if


End Sub
%>

<%
'***********************************************************
'* 获取系统菜单列表（无分页、无限级）
'* Author      :   云奇(114066164@qq.com)
'* Update Date :   2021-8-13
'***********************************************************
Sub getList()

  If checkDomain() = False Then Exit Sub          '验证请求域名
  If checkMethod("GET") = False Then Exit Sub    '校验请求方式

  Dim list : Set list = YQAsp.Json.NewArray
  Dim item : Set item = YQAsp.Json.NewObject
  Dim items

  sql = "select * from board where depth=0 order by orders asc"
  set rs = YQAsp.db.Sel(sql)
  do while not rs.eof
    item.Put "id", rs("id")
    item.Put "boardName", YQAsp.Str.ToString(rs("boardName"))
    item.Put "parentID", rs("parentID")
    item.Put "parentStr", YQAsp.Str.ToString(rs("parentStr"))
    item.Put "depth", rs("depth")
    item.Put "child", rs("child")
    item.Put "orders", YQAsp.Str.ToString(rs("orders"))
    
    If rs("child") > 0 Then
      item.Put "items", YQAsp.Json.Parse(getMenu(rs("id")))
    End If

    list.Add YQAsp.Json.Parse(YQAsp.Encode(item))
    item.Clear
  rs.movenext
  loop
 YQAsp.Db.Close(rs)
  
  data.Put "total", list.length
  data.Put "list", list

 Set item = Nothing
 Set list = Nothing

End Sub

' 递归函数获取无限级菜单
Function getMenu(parentId)

  Dim rs_Menu
  Dim list_Menu : Set list_Menu = YQAsp.Json.NewArray
  Dim item_Menu : Set item_Menu = YQAsp.Json.NewObject

  sql = "select * from board where parentID="&parentId&" order by orders asc"
  set rs_Menu = YQAsp.db.Sel(sql)
  do while not rs_Menu.eof
    item_Menu.Put "id", rs_Menu("id")
    item_Menu.Put "boardName", YQAsp.Str.ToString(rs_Menu("boardName"))
    item_Menu.Put "parentID", rs_Menu("parentID")
    item_Menu.Put "parentStr", YQAsp.Str.ToString(rs_Menu("parentStr"))
    item_Menu.Put "depth", rs_Menu("depth")
    item_Menu.Put "child", rs_Menu("child")
    item_Menu.Put "orders", YQAsp.Str.ToString(rs_Menu("orders"))
    
    If rs_Menu("child") > 0 Then
      item_Menu.Put "items", YQAsp.Json.Parse(getMenu(rs_Menu("id")))
    End If

    list_Menu.Add YQAsp.Json.Parse(YQAsp.Encode(item_Menu))
    item_Menu.Clear
  rs_Menu.movenext
  loop
  YQAsp.Db.Close(rs_Menu)

  getMenu = YQAsp.Encode(list_Menu)

 Set item_Menu = Nothing
 Set list_Menu = Nothing

End Function
%>

<%
'***********************************************************
'* 删除系统菜单
'* Author      :   云奇(114066164@qq.com)
'* Update Date :   2021-8-13
'***********************************************************
Sub del()

  If checkDomain() = False Then Exit Sub          '验证请求域名
  If checkMethod("POST") = False Then Exit Sub    '校验请求方式

  '菜单Id
  Dim id : id = YQAsp.Str.Validate(YQAsp.Post("id")).Name("id").Required.PrintEndJson '校验不能为空
  
  YQAsp.Var("id") = id
  
  set rs = YQAsp.db.sel("select top 1 id,child from board where id={id}")
  if YQAsp.isn(rs) Then
    YQAsp.Db.Close(rs)
    code = 300
    msg = "找不到相关记录!"
  else
    if cint(rs("child"))<>0 then
      code = 300
      msg = "删除失败：存在子菜单!"
      YQAsp.Db.Close(rs)
      Exit Sub
    End If
    YQAsp.Db.Close(rs)
    dim r : r = YQAsp.Db.Exec("delete from board where id = {id}")
    if r = 1 then
      msg = "删除成功!"
    else
      code = 300
      msg = "删除失败!"
    end if
  end if

End Sub
%>

<%
'***********************************************************
'* 排序：向下移动
'* Author      :   云奇(114066164@qq.com)
'* Update Date :   2021-8-14
'***********************************************************
Sub down()

  If checkDomain() = False Then Exit Sub          '验证请求域名
  If checkMethod("POST") = False Then Exit Sub    '校验请求方式
  
  Dim moveID, mParentID, mParentStr, mOrders, mChildStr

  '菜单Id
  YQAsp.Var("id")  = YQAsp.Str.Validate(YQAsp.Post("id")).Name("id").Required.PrintEndJson '校验不能为空

  set rs = YQAsp.db.sel("select top 1 * from board where id={id}")
  if YQAsp.isn(rs) Then
    YQAsp.Db.Close(rs)
    code = 300
    msg = "找不到相关记录!"
    Exit Sub
  end if

  YQAsp.Var("parentID") = rs("parentID")     '向下栏目父级ID
  YQAsp.Var("parentStr") = rs("parentStr")    '向下栏目父级路径
  YQAsp.Var("orders") = rs("orders")      '向下栏目排序号

  if YQAsp.Var("parentID") = 0 then '一级栏目
    YQAsp.Var("childStr") = YQAsp.Var("id") &","      '向下栏目子栏目父级路径前缀，更新子栏目排序号时用
  else
    YQAsp.Var("childStr") = YQAsp.Var("parentStr") & YQAsp.Var("id") & ","   '向下栏目子栏目父级路径前缀，更新子栏目排序号时用
  end if
  YQAsp.Db.Close(rs)
  '====查询是否为同级别里最下面的栏目,是则不需要调整位置,否则取需调整的上下二个栏目的各种参数====
  sql = "select top 1 * from board where orders>{orders} and parentID={parentID} order by orders asc"
  set rs = YQAsp.db.Sel(sql) '查询在同一级中是否有排序号比较所选栏目更大的，如果有则调整，如果没有则显示到底了
  if YQAsp.has(rs) then
    moveID = rs("id")      '向上栏目ID
    mParentID = rs("parentID")   '向上栏目父级ID
    mParentStr = rs("parentStr")   '向上栏目父级路径
    mOrders = rs("orders")    '向上栏目排序号
    if mParentID = 0 then
      mChildStr = moveID &","   '向上栏目子栏目父级路径前缀，更新子栏目排序号时用
    else
      mChildStr = mParentStr & moveID & "," '向上栏目子栏目父级路径前缀，更新子栏目排序号时用
    end if
    YQAsp.Db.Close(rs)
    '更新向下栏目及所有子栏目
    YQAsp.Var("moveID") = moveID
    YQAsp.Var("mChildStr") = mChildStr
    YQAsp.Var("likeKey") = "%{=childStr}%"
    set rs = YQAsp.db.Sel("select * from board where parentStr like {likeKey} or id={id} order by orders asc")
    do while not rs.eof
      if rs("id") = cint(YQAsp.Var("id")) then
        YQAsp.Var("mOrders") = mOrders
      else
        YQAsp.Var("mOrders") = mOrders &","& right(rs("orders"),len(rs("orders"))-(len(mOrders)+1))
      end if
      YQAsp.Var("mID") = rs("id")
      YQAsp.Db.Exec("update board set orders={mOrders} where id = {mID}")
    rs.movenext
    loop
    YQAsp.Db.Close(rs)
    '更新向上栏目及所有子栏目
    YQAsp.Var("likeKey") = "%{=mChildStr}%"
    set rs = YQAsp.db.sel("select * from board where parentStr like {likeKey} or id={moveID} order by orders asc")
    do while not rs.eof
      if rs("id") = moveID then
        YQAsp.Var("mOrders") = YQAsp.Var("orders")
      else
        YQAsp.Var("mOrders") = YQAsp.Var("orders") &","& right(rs("orders"),len(rs("orders"))-(len(YQAsp.Var("orders"))+1))
      end if
      YQAsp.Var("mID") = rs("id")
      YQAsp.Db.Exec("update board set orders={mOrders} where id = {mID}")
    rs.movenext
    loop
    YQAsp.Db.Close(rs)
    msg = "更新成功!"
  else
    YQAsp.Db.Close(rs)
    code = 300
    msg = "已经到底了!"
  end if

End Sub
%>

<%
'***********************************************************
'* 排序：向上移动
'* Author      :   云奇(114066164@qq.com)
'* Update Date :   2021-8-14
'***********************************************************
Sub up()

  If checkDomain() = False Then Exit Sub          '验证请求域名
  If checkMethod("POST") = False Then Exit Sub    '校验请求方式
  
  Dim moveID, mParentID, mParentStr, mOrders, mChildStr
  Dim parentID, parentStr, orders

  '菜单Id
  YQAsp.Var("id") = YQAsp.Str.Validate(YQAsp.Post("id")).Name("id").Required.PrintEndJson '校验不能为空

  set rs = YQAsp.db.sel("select top 1 * from board where id={id}")
  if YQAsp.isn(rs) Then
    YQAsp.Db.Close(rs)
    code = 300
    msg = "找不到相关记录!"
    Exit Sub
  end if

  parentID = rs("parentID")     '向上栏目父级ID
  parentStr = rs("parentStr")    '向上栏目父级路径
  orders = rs("orders")      '向上栏目排序号
  if parentID = 0 then '一级栏目
    childStr = YQAsp.Var("id") &","      '向上栏目子栏目父级路径前缀，更新子栏目排序号时用
  else
    childStr = parentStr & YQAsp.Var("id") &","   '向上栏目子栏目父级路径前缀，更新子栏目排序号时用
  end if
  YQAsp.Db.Close(rs)

  '====查询是否为同级别里最上面的栏目,是则不需要调整位置,否则取需调整的上下二个栏目的各种参数====
  YQAsp.Var("orders") = orders
  YQAsp.Var("parentID") = parentID
  set rs = YQAsp.db.sel("select top 1 * from board where orders<{orders} and parentID={parentID} order by orders desc") '查询在同一级中是否有排序号比较所选栏目更小的，如果有则调整，如果没有则显示到顶了
  if YQAsp.has(rs) then
    moveID = rs("id")      '向下栏目ID
    mParentID = rs("parentID")   '向下栏目父级ID
    mParentStr = rs("parentStr")   '向下栏目父级路径
    mOrders = rs("orders")    '向下栏目排序号
    if mParentID = 0 then
      mChildStr = moveID & ","   '向下栏目子栏目父级路径前缀，更新子栏目排序号时用
    else
      mChildStr = mParentStr & moveID & "," '向下栏目子栏目父级路径前缀，更新子栏目排序号时用
    end if
    YQAsp.Db.Close(rs)
    YQAsp.Var("moveID") = moveID
    YQAsp.Var("childStr") = childStr
    YQAsp.Var("mChildStr") = mChildStr
    '更新向上栏目及所有子栏目
    YQAsp.Var("likeKey") = "%{=childStr}%"
    set rs = YQAsp.db.sel("select * from board where parentStr like {likeKey} or id={id} order by orders asc")
    do while not rs.eof
      if rs("id") = cint(YQAsp.Var("id")) then
        YQAsp.Var("mOrders") = mOrders
      else
        YQAsp.Var("mOrders") = mOrders &","& right(rs("orders"),len(rs("orders"))-(len(mOrders)+1))
      end if
      YQAsp.Db.Exec("update board set orders={mOrders} where id = {id}")
    rs.movenext
    loop
    YQAsp.Db.Close(rs)
    '更新向下栏目及所有子栏目
    YQAsp.Var("likeKey") = "%{=mChildStr}%"
    set rs = YQAsp.db.sel("select * from board where parentStr like {likeKey} or id={moveID} order by orders asc")
    do while not rs.eof
      if rs("id") = moveID then
        YQAsp.Var("mOrders") = orders
      else
        YQAsp.Var("mOrders") = orders&","&right(rs("orders"),len(rs("orders"))-(len(orders)+1))
      end if
      YQAsp.Var("mID") = rs("id")
      YQAsp.Db.Exec("update board set orders={mOrders} where id = {mID}")
    rs.movenext
    loop
    YQAsp.Db.Close(rs)
  else
    YQAsp.Db.Close(rs)
    code = 300
    msg = "已经到顶了!"
  end if

End Sub
%>