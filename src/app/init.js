'use strict'
// 检测dll是否存在，返回绝对路径
function get_dll_path(dll) {
  const path = require('path');
  const fs = require('fs');

  if (fs.statSync(dll)) {
    //文件存在，返回绝对路径
    console.log('文件存在')
    return path.resolve(dll)
  } else {
    return "0"
  }
}

exports.dll_path = function(dll) {
  return get_dll_path(dll)
}