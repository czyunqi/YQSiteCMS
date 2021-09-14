/**
 * 获取URL的参数
 * @param {string} url url
 * @param {string} key 参数名
 * @returns 
 */
function getQueryString(url, key) {
  if (url.indexOf("?") != -1) {
    var str = url.split("?");
    var p = str[1];
    if (p.indexOf("&") != -1) {
      var p1 = p.split("&");
      var v = "";
      for (var i = 0; i < p1.length; i++) {
        var vv = p1[i].split("=");
        if (vv[0] == key) {
          return vv[1];
        }
      }
      return v;
    } else {
      var v = p.split("=");
      if (v[0] == key) {
        return v[1];
      } else {
        return "";
      }
    }
  } else {
    return "";
  }
}