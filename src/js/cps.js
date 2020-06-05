'use strict'

/**
 * 类型判断，返回准确类型
 *
 * @param      {<type>}  data    The data
 * @return     {<type>}  { description_of_the_return_value }
 */
exports.typeof = function(data) {
  let value = /\[object (\w+)\]/.exec(
    Object.prototype.toString.call(data)
  );
  return value ? value[1].toLowerCase() : '';
}


/**
 * 根据id返回一个 dom对象或者多个对象的集合
 *
 * @param      {str}      id      合法的元素id
 * @return     {boolean}  { description_of_the_return_value }
 */
exports.$ = function(id) {
  if (id instanceof String) {
    let tar = id.substring(1)
    switch (id.charAt(0)) {
      case '.':
        return document.getElementsByClassName(tar);
        break;

      case '#':
        return document.getElementById(tar);
        break;

      default:
        return document.getElementsByTagName(id);
        break;
    }
  }
}

/**
 * 判断是否数组
 *
 * @param      {<type>}   tar     The tar
 * @return     {boolean}  True if array, False otherwise.
 */
exports.isArray = function(tar) {
  return typeof(tar) === 'undefined' ? false : tar instanceof Array;
}

/**
 * 直接打印目标对象，如果是数组，自动遍历
 *
 * @param      {<type>}  tar     The tar
 */
exports.print = function(tar) {
  console.log('typeof:', typeof(tar));
  if (tar instanceof Array) {
    console.log('当前是数组');
    let num = 0
    for (let each of tar) {
      console.log(num + '、' + each);
      num++
    }
    console.log(`共有${tar.length}个元素`);
  } else {
    console.log(tar);
  }
}

/**
 * 创建元素
 *
 * @param      {<type>}  doc      The document
 * @param      {<type>}  htmlTag  The html tag
 * @param      {<type>}  value    The value
 */
exports.addElement = function(doc, htmlTag, value) {
  const tmpTag = document.createElement(htmlTag);
  if (typeof(value) !== 'undefined' || value !== undefined) {
    const tmpVal = document.createTextNode(value);
    tmpTag.appendChild(tmpVal);
  }

  doc.appendChild(tmpTag);
  return tmpTag;
}

exports.interval = (callback, delay) => {
  let id = setInterval(() => callback(id), delay);
}

console.log('cps模块成功载入');
