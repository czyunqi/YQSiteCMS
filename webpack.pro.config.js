const path = require('path')
const webpack = require('webpack')
const merge = require('webpack-merge')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const webpackConfigBase = require('./webpack.base.config')
const OptimizeCss = require('optimize-css-assets-webpack-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');

const webpackConfigPro = {
    mode: 'production',
    optimization: {
        minimizer: [
            //压缩CSS代码
            new OptimizeCss(),
            //压缩js代码
            new UglifyJsPlugin({
                //启用文件缓存
                cache: true,
                //使用多线程并行运行提高构建速度
                parallel: true,
                //使用 SourceMaps 将错误信息的位置映射到模块
                sourceMap: true
            })
        ]
    },
    output: {
        publicPath: "/Admin/",
        path: path.resolve(__dirname, './Admin/'),
        filename: 'assets/scripts/[name].[hash:10].js'
    },
    module: {
        rules: [{
            test: /\.(png|jpe?g|gif|svg)$/,
            use: [{
                loader: 'url-loader',
                options: {
                    esModule: false,
                    limit: 10000, // 设置图像大小超过多少转存为单独图片,
                    publicPath: '/Admin/',
                    name: 'assets/img/[name].[hash:10].[ext]' // 转存的图片目录
                }
            }]
        }]
    },
    plugins: [
        new webpack.HotModuleReplacementPlugin() ////热更新模块，这样js改变就不会全部重载，而是只是重载你改过的那一部分
    ]
}

module.exports = merge(webpackConfigBase, webpackConfigPro)
//动态生成html
//获取html-webpack-plugin参数的方法
var getHtmlConfig = function (name, chunks) {
    var template = '',
        filename;
    if (name.indexOf('-') != -1) {
        var n = name.split('/')
        n.map(function (value, index) {
            template == '' ? (template = 'html/' + value) : (template = template + '/' + value)
        })
    } else {
        template = 'html/' + name
    }
    filename = template.replace('html/', '');
    return {
        template: `./src/${template}.html`,
        filename: `${filename}.html`,
        inject: true,
        hash: false,
        chunks: [name],
        //favicon: './src/assets/img/favicon.ico',
        minify: {
            removeComments: true, //移除HTML中的注释
            collapseWhitespace: true, //折叠空白区域 也就是压缩代码
            removeAttributeQuotes: true //去除属性引用
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