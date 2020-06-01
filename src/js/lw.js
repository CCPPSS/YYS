'use strict'
const path = require('path')
const fs = require('fs')
const c = require('../js/cps.js')
const ffi = require('ffi-napi')
const ref = require('ref-napi')


/**
 * 创建lw的对象，构造出输入一个函数
 */
class object_lw {
    constructor() {
        this.isinit = false
        this.isbind = false
        this.dll = false
        this.state = 'noinit'
        this.errMsg_init = 'dll对象还未初始化，请使用[对象.init(dll路径)]方法进行初始化.'
    }

    init(dll_path) {
        if (fs.existsSync(dll_path)) {
            console.log('导入dll成功，开始初始化dll。')
            try {
                this.dll = ffi.Library(dll_path, {
                    'ver': ['double', []],
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
                    'leftClick': ['void', []],
                    'test': ['int', []],
                    'findPic': ['string', ['int', 'int', 'int', 'int', 'string', 'string', 'int', 'int', 'int', 'int', 'int', 'int', 'int']],
                    'findColor': ['string', ['int', 'int', 'int', 'int', 'string', 'int', 'int', 'int', 'int', 'int', 'int']],
                    'getOS': ['string', []],
                    'random': ['int', ['int', 'int']],
                })
            } catch (err) {
                console.log('导入模块中发生错误')
                console.log('错误类型：' + err)
            }

            console.log('初始化dll成功。')
            this.isinit = true
        } else {
            console.log('没有找到dll文件，请确认路径是否正确:[' + dll_path + '].')
        }
    }

    ver() {
        if (this.isinit) {
            let tmp = this.dll.ver()
            console.log(tmp)
            return tmp
        } else {
            console.log(this.errMsg_init)

        }
    }

    getOS() {
        if (this.isinit) {
            let tmp = this.dll.getOS()
            console.log(tmp)
            return tmp
        } else {
            console.log(this.errMsg_init)
        }
    }
}

exports.createObject = function() {
    return new object_lw()
}

if (require.main === module) {
    console.log('lw.js')

}