'use strict'

const {
  remote,
  app,
  BrowserWindow,
  ipcMain
} = require('electron')
const path = require('path')
const fs = require('fs')

let mainWindow;
let mainConfig = {
  width: 1224,
  height: 850,
  frame: false, //无边框模式-无法移动
  autoHideMenuBar: false, //隐藏菜单栏
  // titleBarStyle: 'hidden',
  transparent: false, //窗口透明
  resizable: true, //调整大小开关
  movable: true, //移动开关
  maximizable: true, //是否可以最大化
  alwaysOnTop: false, //置顶开关
  opacity: 1, //透明度0.0 - 1.0
  webPreferences: {
    devtools: true,
    nodeIntegration: true, //渲染进程可以引入
    nodeIntegrationInWorker: true, //启动多线程
    preload: path.resolve(__dirname, 'app/renderer/preload.js') //预处理
  }
}


//主程序窗口
function createMainWindow() {
  mainWindow = new BrowserWindow(mainConfig)

  console.log(mainWindow.id)

  mainWindow.loadFile(path.join(__dirname, 'app/index.html'))

  // 打开chrome开发者工具
  mainWindow.webContents.openDevTools()

  mainWindow.on('closed', function() {
    mainWindow = null
  })
}



function createSonWindow(width, height, htmlf) {
  return new BrowserWindow({
    width: width,
    height: height,
    //frame: false, //无边框模式-无法移动
    autoHideMenuBar: true, //隐藏菜单栏
    //transparent: false, //窗口透明
    resizable: false, //调整大小开关
    movable: false, //移动开关
    maximizable: false, //是否可以最大化
    parent: mainWindow, //建立父窗口关系
  })
  tmp.loadFile(htmlf)
  tmp.on('closed', function() {
    tmp = null
  })
}



//关闭chrome的缓存
app.commandLine.appendSwitch("--disable-http-cache")

//创建主进程窗口
app.on('ready', () => {
  createMainWindow()
  global.AppPath = app.getAppPath()
})


//创建结束事件
app.on('window-all-closed', function() {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

//如果
app.on('activate', function() {
  console.log(`出发activate事件`)
  if (mainWindow === null) createWindow()
})


//创建子菜单功能
ipcMain.on('newSonWindow', function(e) {
  YYS_ui = new BrowserWindow({
    width: 300,
    height: 240,
    //frame: false, //无边框模式-无法移动
    autoHideMenuBar: true, //隐藏菜单栏
    //transparent: false, //窗口透明
    resizable: false, //调整大小开关
    movable: false, //移动开关
    maximizable: false, //是否可以最大化
    parent: mainWindow, //建立父窗口关系
  })
  YYS_ui.loadURL(path.join('file:', __dirname, 'src/html/muise.html'));
  YYS_ui.on('closed', () => {
    YYS_ui = null
  })
})

ipcMain.on('before-bind', function(e) {
  console.log('创建一个前置提示框')
  // createSonWindow(width, height, htmlf)
  e.sender.send('bind')
})