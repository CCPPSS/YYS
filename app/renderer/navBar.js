// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.


window.addEventListener('DOMContentLoaded', () => {
  //测试按钮
  document.getElementById('test').addEventListener('click', () => {
    ipcRenderer.sendTo(1, 'test', 'test')
    ipcRenderer.sendTo(1, 'checkHwnd')
  })
})

console.log('加载[navBar.js]成功。');