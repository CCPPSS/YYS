'use strict'
const fs = require('fs')
const ffi = require('ffi-napi')
const ref = require('ref-napi')
const currtDll = './test11.dll'

/**
 * 创建lw的对象，构造出输入一个函数
 */
class object_lw {
  constructor(dll_path) {
    this.isinit = false
    this.isbind = false
    this.dll = false
    this.state = 'noinit'
    this.errMsg_init = 'dll对象还未初始化，请使用[const xx = xx(dllpath)]方法进行初始化.'
    this.init(dll_path)
    this.isinit ? console.log(`初始化dll成功,版本:${this.dll.ver()},当前id:${this.isinit}`) : console.log('未初始化的lw')
  }

  /**
   * 通过路径进行初始化
   *
   * @param      {string}  dll_path  dll的路径
   */
  init(dll_path) {
    try {
      this.dll = ffi.Library(dll_path, {
        'ver': ['string', []],
        'enumWindow': ['string', ['string', 'string']],
        'findWindow': ['int', ['string', 'string']],
        'findSonWindow': ['int', ['int', 'string', 'string']],
        'getClientSize': ['string', ['int']],
        'setWindowState': ['int', ['int', 'int']],
        'getWindowState': ['int', ['int', 'int']],
        'getWindowTitle': ['string', ['int']],
        'getWindowClass': ['string', ['int']],
        'bindWindow': ['int', ['int', 'int', 'int', 'int', 'int', 'int']],
        'unBindWindow': ['int', []],
        'unBindWindowEx': ['int', ['int']],
        'getBindState': ['int', []],
        'isBind': ['int', ['int']],
        'getBind': ['int', []],
        'moveTo': ['string', ['int', 'int']],
        'moveToEx': ['string', ['int', 'int', 'int', 'int']],
        'moveToTx': ['string', ['int', 'int', 'int', 'int']],
        'setPath': ['int', ['string']],
        'getPath': ['string', []],
        'capture': ['int', ['int', 'int', 'int', 'int', 'string']],
        'delay': ['int', ['int']],
        'rdelay': ['int', ['int', 'int']],
        'leftClick': ['void', []],
        'test': ['int', []],
        'findPic': ['string', ['int', 'int', 'int', 'int', 'string', 'string', 'int', 'int', 'int', 'int', 'int', 'int', 'int']],
        'findColor': ['string', ['int', 'int', 'int', 'int', 'string', 'int', 'int', 'int', 'int', 'int', 'int']],
        'getOS': ['string', []],
        'random': ['int', ['int', 'int']],
        'toGBK': ['string', ['string']]
      })
      if (this.dll.ver() === '1.0.1') {
        this.isinit = this.dll.random(1, 999) //生成一个识别码
        console.log(`识别${dll_path}成功，开始初始化dll。`)
      } else {
        throw '当前dll不是最新版'
      }
    } catch (err) {
      console.log('导入模块中发生错误')
      console.log('错误信息：' + err)
    }
  }

  enumWindow(search_title, search_class) {
    return this.dll.enumWindow(search_title, search_class)
  }

  ver() {
    console.log(this.dll.ver())
    return this.dll.ver()
  }

  getOS() {
    return this.dll.getOS()
  }

  delay(n) {
    this.dll.delay(Number(n))
  }

  random(n, m) {
    n = Number(n)
    m = Number(m)
    return m > n ? this.dll.random(n, m) : false
  }

  test(str) {
    return (str)
  }
}

if (require.main === module) {
  console.log('lw.js')
  const lw = new object_lw('./test13.dll')
  lw.test()
  lw.ver()
}

module.exports = dll_path => {
  if (fs.existsSync(dll_path)) {
    return new object_lw(dll_path)
  } else if (fs.existsSync(currtDll)) {
    console.log(`${dll_path}识别失败,尝试读取本地${currtDll}`)
    return new object_lw(currtDll)
  } else {
    console.log('没有找到dll文件，请确认路径是否正确:[' + dll_path + '].')
    throw '缺少dll文件.'
  }
}