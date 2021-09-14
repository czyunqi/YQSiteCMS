import '../assets/css/style.css';
import './index.css';

var COOKIE_NAME = 'sys_account';

var module = {
  data: {},
  init: function () {
    var that = this;
    console.log("init")
    if ($.cookie(COOKIE_NAME)) {
      $("input[name=account]").val($.cookie(COOKIE_NAME));
      $("input[name=password]").focus();
      $("#remember").attr('checked', true);
    } else {
      $("input[name=account]").focus();
    }

    that.clickCode();


    $("form[name=formLogin]").submit(function (e) {
      e.preventDefault();
      var issubmit = true;
      var i_index = -1;
      $(this).find('.form-control').each(function (i) {
        if ($.trim($(this).val()).length == 0) {
          $(this).css('border', '1px #ff0000 solid');
          issubmit = false;
          if (i_index < 0) {
            i_index = i;
          }
        }
      });
      if (!issubmit) {
        $(this).find('.form-control').eq(i_index).focus();
        return false;
      }
      var $remember = $("#remember");
      if ($remember.attr('checked')) {
        $.cookie(COOKIE_NAME, $("input[name=account]").val(), {
          path: '/',
          expires: 15
        });
      } else {
        $.cookie(COOKIE_NAME, null, {
          path: '/'
        }); //删除cookie
      }

      $("button[name=submit-form]").attr("disabled", true).val('登陆中..');

      location.href = 'app.html'

    });

  },
  // 绑定验证码点击事件
  clickCode: function () {
    var that = this;
    $("#captcha_img").click(function () {
      that.changeCode();
    });
  },
  // 更新验证码图片
  changeCode: function () {
    //$("#captcha_img").attr("src", "sys/login/getCaptcha?t=" + (new Date().getTime()));
  }
};

$(function () {
  module.init();
});