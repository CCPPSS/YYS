// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.


const {
  ipcRenderer
} = require('electron')


window.addEventListener('DOMContentLoaded', () => {

  //接收事件
  ipcRenderer.on('test-sync', (e, a) => {
    console.log('这里是 renderer 进程，接收到事件' + a.toString())
  })

})

console.log('加载[renderer.js]成功。');