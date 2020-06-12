'use strict'

const path = requrie('path')

module.exports = {
  target: 'node',
  mode: 'none',
  resolve: {
    alias: {
      '@srr': path.resolve(__dirname, '../src/'),
      '@layout': path.resolve(__dirname, '../src/layout/render.js'),
    }
  },
  entry: path.resolve(__dirname, '../src/index.js'),
  output: {
    filename: '[name].binder.js',
    path: path.resolve(__dirname, '../build')
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
