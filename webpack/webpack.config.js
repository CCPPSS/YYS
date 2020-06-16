'use strict'
const template = 'ejs' //ejs或者jade

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  target: 'node',
  mode: 'none',
  watch: true,
  watchOptions: {
    ignored: /node_modules/i, //不监听的目录
    aggregateTimeout: 2000, //监听间隔
    poll: 1000 //单位毫秒 监听的间隔 ? 或者是每秒的检测次数 不知道？
  },
  devtool: 'source-map',
  resolve: {
    alias: {
      '@src': path.resolve(__dirname, '../src'),
      'layout': path.resolve(__dirname, `../src/layout/${template}/render.js`),
    }
  },
  entry: path.resolve(__dirname, '../src/index.js'),
  output: {
    filename: '[name].binder.js',
    path: path.resolve(__dirname, '../build')
  },
  module: {
    rules: [{
      test: /\.css$/i,
      use: ['style-loader', 'css-loader'],
      exclude: [path.resolve(__dirname, '../node_modules')]
    }, {
      test: /\.less$/i,
      use: [MiniCssExtractPlugin.loader, 'css-loader', 'less-loader'],
      exclude: [path.resolve(__dirname, '../node_modules')]
    }, {
      test: /\.ejs$/i,
      use: ['ejs-loader'],
      exclude: [path.resolve(__dirname, '../node_modules')]
    }, {
      test: /\.jade$/i,
      use: ['jade-loader'],
      exclude: [path.resolve(__dirname, '../node_modules')]
    }, {
      test: /\.pug$/i,
      use: ['pug-loader'],
      exclude: [path.resolve(__dirname, '../node_modules')]
    }],
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: `生成${template}模板页面`,
      filename: 'index.html',
      template: path.resolve(__dirname, `../src/pages/home/${template}/render.js`),
      xhtml: true
    })
  ]
}
