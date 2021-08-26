const path = require('path')
const glob = require('glob')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const {
  CleanWebpackPlugin
} = require('clean-webpack-plugin')
const TransferWebpackPlugin = require('transfer-webpack-plugin')
const PurifyCssWebpack = require('purifycss-webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');

//动态添加入口
var entry = {}
glob.sync('./src/html/**/*.js').forEach(function (name) {
  var start = name.indexOf('src/html/') + 9,
    end = name.length - 3,
    n = name.slice(start, end).split('/')
  var arr_key = '',
    arr_val = []
  n.map(function (value, index) {
    arr_key == '' ? (arr_key = value) : (arr_key = arr_key + '/' + value)
  })
  arr_val.push(name)
  entry[arr_key] = arr_val
})

module.exports = {
  entry: entry,
  module: {
    rules: [{
        test: /\.css$/,
        use: [{
            loader: MiniCssExtractPlugin.loader,
            options: {
              publicPath: '/Admin/'
            }
          },
          'css-loader',
          'postcss-loader'
        ]
      },
      // 处理字体
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        use: ['url-loader']
      },
      {
        test: /\.ejs$/,
        loader: 'ejs-loader'
      }
    ]
  },
  resolve: {
    // 省略文件后缀
    extensions: ['.js'],
    alias: {}
  },
  plugins: [
    //清除之前生成的文件夹
    new CleanWebpackPlugin(),
    //将css分离出去
    new MiniCssExtractPlugin({
      filename: 'assets/css/[name].[hash:10].css'
    }),
    //复制静态资源
    new CopyWebpackPlugin([{
      from: './src/static',
      to: './static'
    }, {
      from: './src/api',
      to: './api'
    }])
  ],
  // 配置webpack执行相关
  performance: {
    maxEntrypointSize: 1000000, // 最大入口文件大小1M
    maxAssetSize: 1000000 // 最大资源文件大小1M
  }
}