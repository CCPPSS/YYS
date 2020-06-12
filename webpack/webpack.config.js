'use strict'

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  target: 'node',
  mode: 'none',
  devtool: 'source-map',
  resolve: {
    alias: {
      '@src': path.resolve(__dirname, '../src'),
    }
  },
  entry: path.resolve(__dirname, '../src/index.js'),
  output: {
    filename: '[name].binder.js',
    path: path.resolve(__dirname, '../build')
  },
  module: {
    rules: [
      /*{
            test: /\.css$/,
            use: ['style-loader', 'css-loader'],
            exclude: [path.resolve(__dirname, '../node_modules')]
          },*/
      {
        test: /\.less$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'less-loader'],
        exclude: [path.resolve(__dirname, '../node_modules')]
      }, {
        test: /\.ejs$/,
        use: ['ejs-loader'],
        exclude: [path.resolve(__dirname, '../node_modules')]
      }
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'ejs 生成的模板页面',
      filename: 'index.html',
      template: path.resolve(__dirname, '../src/pages/home/render.js'),
      xhtml: true
    })
  ]
}
