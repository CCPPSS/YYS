/*
 * @Author: SSD_WIN10
 * @Date: 2020-05-08 16:20:57
 * @Last Modified by: SSD_WIN10
 * @Last Modified time: 2020-05-28 17:27:28
 */
'use strict'
const EventEmitter = require('events');
class createYYS extends EventEmitter {
  constructor() {
    super();
    this.dicConfig = global.config;
    this.dicDefaultConfig = {};
    this.lw = null;
    this.hwnd = 0;
    this.workerList = [];
  }

  init() {
    this.lw = global.clw(global.dllPath)
    if (this.lw.isinit) {
      return 1
    }
    return 0
  }

  show() {
    return console.log(this.config);
  }

  //获取当前所有关键窗口
  searchHwnd(tar = 'sublime') {
    // let tar = ['阴阳师-网易游戏', 'Win32Window0']
    if (this.lw.isbind) {
      console.log('lw已经绑定');
      this.lw.capture();
    } else {
      let res = this.lw.enumWindow(tar);
      if (res.indexOf(',') > 0) {
        console.log('发现多个窗口');

      } else {
        console.log(`只有一个窗口${res}`);

        //发送绑定事件
        ipcRenderer.send('before-bind');
        return this.hwnd = res;
      }
    }
  }

  //检测当前窗口是否相同
  checkHwnds() {

  }

  show() {
    console.dir(this.lw);
    console.dir(this);
  }
}

//当作是模块被调用时
module.exports = new createYYS()
console.log('导入YYS.js成功');