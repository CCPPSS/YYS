/*
 * @Author: SSD_WIN10
 * @Date: 2019-11-24 11:03:23
 * @Last Modified by: SSD_WIN10
 * @Last Modified time: 2020-05-28 17:18:27
 */

'use strict'

// 初始加载后执行
const path = require('path');
const {
  ipcRenderer,
  remote
} = require('electron')
global.clw = require('clw')


if (require.main === module) {


} else {
  console.log('加载[prelord.js]成功。');
  window.addEventListener('DOMContentLoaded', () => {

    //初始化需要用到的全局变量
    global.appPath = remote.app.getAppPath()
    global.dllPath = path.resolve(global.appPath, 'app/lib/cps.dll')
    global.config = require(path.resolve(global.appPath, 'app/lib/defualtConfig.js')).config
    global.YYS = require(path.resolve(global.appPath, 'app/lib/YYS.js'));
    global.m = require(path.resolve(global.appPath, 'app/lib/main.js'));
  })
}