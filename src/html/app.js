import '../assets/css/style.css';
import '../assets/js/public';

var module = {
  data: {},
  init: function () {
    this.appInit();
    this.getMenu();
    /*BJUI.ajax('doajax', {
      type: "POST",
      url: '/api/manager/menu-form.json',
      loadingmask: true,
      okCallback: function (json, options) {}
    })*/
  },
  //框架初始化
  appInit: function () {
    var that = this;
    BJUI.init({
      JSPATH: 'staic/bjui/', //[可选]框架路径
      PLUGINPATH: 'staic/bjui/plugins/', //[可选]插件路径
      loginInfo: {
        url: 'login_timeout.html',
        title: '登录',
        width: 440,
        height: 240
      }, // 会话超时后弹出登录对话框
      appInfo: {
        requestUrl: "/Api/mapi"
        //https://evcs.sdzh.top/wapi/manager/test
      },
      statusCode: {
        ok: 200,
        error: 300,
        timeout: 301
      }, //[可选]
      ajaxTimeout: 300000, //[可选]全局Ajax请求超时时间(毫秒)
      alertTimeout: 3000, //[可选]信息提示[info/correct]自动关闭延时(毫秒)
      pageInfo: {
        total: 'totalRow',
        pageCurrent: 'pageCurrent',
        pageSize: 'pageSize',
        orderField: 'orderField',
        orderDirection: 'orderDirection'
      }, //[可选]分页参数
      keys: {
        statusCode: 'code',
        message: 'msg'
      }, //[可选]
      ui: {
        sidenavWidth: 220,
        showSlidebar: true, //[可选]左侧导航栏锁定/隐藏
        overwriteHomeTab: false //[可选]当打开一个未定义id的navtab时，是否可以覆盖主navtab(控制台)
      },
      debug: false, // [可选]调试模式 [true|false，默认false]
      theme: 'default' // 若有Cookie['bjui_theme'],优先选择Cookie['bjui_theme']。皮肤[五种皮肤:default, orange, purple, blue, red, green]
    });

    //时钟
    var today = new Date(),
      time = today.getTime()
    $('#bjui-date').html(today.formatDate('yyyy/MM/dd'))
    setInterval(function () {
      today = new Date(today.setSeconds(today.getSeconds() + 1))
      $('#bjui-clock').html(today.formatDate('HH:mm:ss'))
    }, 1000)
  },
  //获取导航菜单
  getMenu: function () {
    var that = this;
    console.log(BJUI.appInfo.requestUrl)


    $("#bjui-hnav-navbar").append('<li class="active"><a href="' + BJUI.appInfo.requestUrl + '/system/config/menu/getMenu.json" data-toggle="sidenav" data-id-key="targetid">站点</a></li>');
    $("#bjui-hnav-navbar").append('<li><a href="' + BJUI.appInfo.requestUrl + '/system/config/menu/getMenu.json" data-toggle="sidenav" data-id-key="targetid">系统</a></li>');

    /*BJUI.ajax('doajax', {
      type: "POST",
      url: '/api/manager/system/getMenu.json',
      loadingmask: true,
      okCallback: function (json, options) {}
    })*/
  }
};

$(function () {
  module.init();
});