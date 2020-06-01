'use strict'
const ffi = require('ffi-napi')

var env_info = {}
env_info['账号列表'] = [123123213, 22222]

const app = new Vue({
  el: '#YYS_conuts_list',
  data: {
    conuts_list: env_info['账号列表']
  }
})

console.log(env_info)
console.log('载入YYS_ui.js成功')
console.log(ffi)