$(function () {

  //添加
  $(document).on('click', '[data-toggle="add"]', function (e) {
    var _options = {
      element: "#table",
      id: "",
      type: "navtab",
      title: "添加",
      url: "",
      param: "",
      width: 500,
      height: 500,
    }
    var $this = $(this),
      data = $this.data(),
      options = $.extend(_options, data.options);
    if (options.param) {
      var row = $.CurrentNavtab.find(options.element).data("selectedDatas");
      if (typeof (row) != 'undefined') {
        if (row.length >= 1) {
          var p = ""
          pv = options.param;
          if (pv.indexOf(",") != -1) {
            //多个参数
            pv = pv.split(",");
            for (var i = 0; i < pv.length; i++) {
              p == "" ? p += "?" + pv[i] + "=" + row[0][pv[i]] : p += "&" + pv[i] + "=" + row[0][pv[i]];
            }
            options.url = options.url + p;
          } else {
            //单个参数
            options.url = options.url + "?" + pv + "=" + row[0][pv];
          }
        }
      }
    }
    console.log(options.url)
    var params = {
      id: options.id,
      title: options.title,
      url: options.url
    };
    if (options.type == "navtab") {
      params.fresh = true;
      BJUI.navtab(params);
    } else if (options.type == "dialog") {
      params.width = options.width;
      params.height = options.height;
      BJUI.dialog(params);
    }
  });

  //修改
  $(document).on('click', '[data-toggle="edit"]', function (e) {
    console.log("edit")
    var _options = {
      element: "#table",
      id: "",
      type: "navtab",
      title: "修改",
      url: "",
      param: "",
      width: 500,
      height: 500,
    }
    var $this = $(this),
      data = $this.data(),
      options = $.extend(_options, data.options);
    var row = $.CurrentNavtab.find(options.element).data("selectedDatas");

    if (typeof (row) == 'undefined') {
      BJUI.alertmsg('info', '请选择操作记录！');
      return false;
    }

    if (row.length > 1) {
      BJUI.alertmsg('info', '仅支持单行编辑！');
      return false;
    }

    options.url = options.url + "?" + options.param + "=" + row[0][options.param];
    var params = {
      id: options.id,
      title: options.title,
      url: options.url
    };
    if (options.type == "navtab") {
      params.fresh = true;
      BJUI.navtab(params);
    } else if (options.type == "dialog") {
      params.width = options.width;
      params.height = options.height;
      BJUI.dialog(params);
    }
  });

  //删除
  $(document).on('click', '[data-toggle="del"]', function (e) {
    var _options = {
      element: "#table",
      type: "navtab",
      param: "id",
      url: ""
    }
    var $this = $(this),
      data = $this.data(),
      options = $.extend(_options, data.options);

    var row = $.CurrentNavtab.find(options.element).data("selectedDatas");
    if (typeof (row) == 'undefined') {
      BJUI.alertmsg('info', '请选择操作记录！');
      return false;
    }
    var id = '';
    $.each(row, function (key, val) {
      id += (id == '') ? row[key][options.param] : " " + row[key][options.param];
    });
    BJUI.ajax('doajax', {
      url: BJUI.appInfo.requestUrl + options.url,
      type: "POST",
      data: {
        [options.param]: id
      },
      confirmMsg: '确认要删除选中的记录吗?<br>本操作不可恢复，请谨慎操作!',
      loadingmask: true,
      okCallback: function (res, options) {
        if (options.type == "navtab") {
          $.CurrentNavtab.find(options.element).datagrid('refresh', false);
        } else if (options.type == "dialog") {
          $.CurrentDialog.find(options.element).datagrid('refresh', false);
        }
      }
    });
  });

  //刷新
  $(document).on('click', '[data-toggle="refresh"]', function (e) {
    console.log("刷新")
    var _options = {
      element: "#table",
      type: "navtab"
    }
    var $this = $(this),
      data = $this.data(),
      options = $.extend(_options, data.options);
    if (options.type == "navtab") {
      $.CurrentNavtab.find(options.element).datagrid('refresh', false);
    } else if (options.type == "dialog") {
      $.CurrentDialog.find(options.element).datagrid('refresh', false);
    }
  });

});