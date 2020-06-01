/*
 * @Author: SSD_WIN10
 * @Date: 2020-05-08 16:20:57
 * @Last Modified by: SSD_WIN10
 * @Last Modified time: 2020-05-28 17:27:43
 */
'use strict'



if (require.main === module) {
  console.log('ccvb');
  const lw = require('clw')('../lib/cps.dll');

} else {

  const {
    isMainThread,
    Worker,
    MessagePort,
  } = require('worker_threads');


  if (isMainThread) {
    //主线程不停的检测当前窗口
    console.log('这里是主线程');
    YYS.init();
    YYS.show();
    console.log(YYS.searchHwnd());

    //执行绑定
    ipcRenderer.on('bind', () => {
      console.log('接收到bind事件，来自YYS');
    })

    //搜索窗口
    ipcRenderer.on('checkHwnd', (e) => {
      console.dir(YYS);
      console.dir(YYS.lw);
    })

  } else {
    let n = 0
    let test = setInterval(() => {
      console.log('我在工作' + n.toString());
      n++;
      if (n > 10) {
        clearInterval(test);
      }

    }, 1000);
  }
}


console.log('导入main.js成功');