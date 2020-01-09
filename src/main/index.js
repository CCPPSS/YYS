/*
 * @Author: CPS
 * @Date: 2020-01-01 11:16:40
 * @Last Modified by: cps-thinkpad
 * @Last Modified time: 2020-01-03 12:50:39
 */

'use strict'

const {
  app,
  BrowserWindow,
  ipcMain
} = require('electron')
const path = require('path')



//主程序窗口
function createMainWindow() {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 900,
    autoHideMenuBar: true, //隐藏菜单栏
    titleBarStyle: 'hidden',
    transparent: true, //窗口透明
    resizable: true, //调整大小开关
    movable: true, //移动开关
    maximizable: true, //是否可以最大化
    alwaysOnTop: false, //置顶开关
    opacity: 1, //透明度0.0 - 1.0
    webPreferences: {
      nodeIntegration: true //渲染进程可以引入内置nodeApi
      //preload: path.join(__dirname, 'preload.js') //预加载
    }
  })

  // and load the index.html of the app.
  //本窗口使用的html文件
  mainWindow.loadFile(path.join(__dirname, '../../dist/index.html'))

  // Open the DevTools.
  mainWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  mainWindow.on('closed', function() {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.

    //发送一个结束时间到渲染进程
    //

    mainWindow = null
  })
}

function createSonWindow(width, height, htmlf) {
  const tmp = null
  tmp = new BrowserWindow({
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

  //定义窗口关闭事件
  tmp.on('closed', function() {
    tmp = null
  })
  return tmp
}

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow = null;

//关闭chrome的缓存
app.commandLine.appendSwitch("--disable-http-cache")

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createMainWindow)


// Quit when all windows are closed.
app.on('window-all-closed', function() {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function() {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) createWindow()
})

ipcMain.on('newSonWindow', function() {
  YYS_ui = createSonWindow(w, h, hf)
})


// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
// "theme": "Default.sublime-theme",
// "color_scheme": "Packages/Color Scheme - Default/Monokai.sublime-color-scheme",
//
// "theme": "Spacegray.sublime-theme",
// "color_scheme": "Packages/Theme - Spacegray/base16-ocean.dark.tmTheme",
//
// "theme": "Spacegray Light.sublime-theme",
// "color_scheme": "Packages/Theme - Spacegray/base16-ocean.light.tmTheme",
//
// "theme": "Spacegray Eighties.sublime-theme",
// "color_scheme": "Packages/Theme - Spacegray/base16-eighties.dark.tmTheme",