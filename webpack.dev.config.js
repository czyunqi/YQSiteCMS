const path = require('path')
const webpack = require('webpack')
const merge = require('webpack-merge')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const webpackConfigBase = require('./webpack.base.config')

const webpackConfigDev = {
  mode: 'development',
  output: {
    path: path.resolve(__dirname, './Admin/'),
    publicPath: "/Admin/",
    filename: 'assets/scripts/[name].[hash:10].js'
  },
  module: {
    rules: [{
      test: /\.(png|jpe?g|gif|svg)$/,
      use: [{
        loader: 'url-loader',
        options: {
          esModule: false,
          limit: 500, // 设置图像大小超过多少转存为单独图片,
          publicPath: '/Admin/',
          //outputPath: '/',
          name: 'assets/img/[name].[hash:10].[ext]' // 转存的图片目录
        }
      }]
    }]
  },
  devtool: '#eval-source-map',
  devServer: {
    publicPath: "/Admin/",
    //contentBase: path.join(__dirname, 'local'),
    compress: true,
    port: 3005,
    inline: true,
    hot: true, // 模块热更新
    liveReload: true, // 检测到文件更改时重新加载
    open: true, // 自动打开浏览器
    openPage: "Admin/index.html",
    proxy: {
      '/admin/api/': {
        target: 'http://localhost:8512',
        pathRewrite: {
          '^/admin/api/': '/src/api/'
        },
        changeOrigin: true, // target是域名的话，需要这个参数，
        secure: false, // 设置支持https协议的代理
      }
    }
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin() ////热更新模块，这样js改变就不会全部重载，而是只是重载你改过的那一部分
  ]
}

module.exports = merge(webpackConfigBase, webpackConfigDev)
//动态生成html
//获取html-webpack-plugin参数的方法
var getHtmlConfig = function (name, chunks) {
  var template = '',
    filename
  if (name.indexOf('-') != -1) {
    var n = name.split('/')
    n.map(function (value, index) {
      template == '' ?
        (template = 'html/' + value) :
        (template = template + '/' + value)
    })
  } else {
    template = 'html/' + name
  }
  filename = template.replace('html/', '')
  return {
    template: `./src/${template}.html`,
    filename: `${filename}.html`,
    inject: true,
    hash: false,
    chunks: [name],
    //favicon: './src/assets/img/favicon.ico',
    minify: {
      removeComments: false, //移除HTML中的注释
      collapseWhitespace: false, //折叠空白区域 也就是压缩代码
      removeAttributeQuotes: false //去除属性引用
    }
  }
}
//配置页面
var htmlArray = []
Object.keys(module.exports.entry).forEach(function (element) {
  htmlArray.push({
    _html: element,
    title: '',
    chunks: [element]
  })
})
//自动生成html模板
htmlArray.forEach(function (element) {
  module.exports.plugins.push(
    new HtmlWebpackPlugin(getHtmlConfig(element._html, element.chunks))
  )
})