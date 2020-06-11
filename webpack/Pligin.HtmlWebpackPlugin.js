'use strict'

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = [
  new HtmlWebpackPlugin({
    title: 'ejs 生成的模板页面',
    filename: 'index.html',
    template: path.resolve(__dirname, '../src/pages/home/render.js'),
    xhtml: true
  })
]
