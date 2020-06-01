/*
 * @Author: SSD_WIN10
 * @Date: 2020-05-20 22:37:42
 * @Last Modified by: SSD_WIN10
 * @Last Modified time: 2020-05-22 11:56:19
 */
'use strict'
const path = require('path')
console.log(`当前目录${__dirname}`)
module.exports = {
  target: 'electron-renderer',
  entry: path.resolve(__dirname, '../entry.js'),
  output: {
    path: path.resolve(__dirname + '/output'),
    filename: "output_[name].js"
  }
}