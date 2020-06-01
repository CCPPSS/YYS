/*
 * @Author: SSD_WIN10
 * @Date: 2020-05-24 20:35:00
 * @Last Modified by: SSD_WIN10
 * @Last Modified time: 2020-05-24 20:49:47
 */
'use strict'

/**
 * 初始化默认配置文件，识别当前目录等，并生成一个默认的配置文件
 *
 * @return     {Object}  { description_of_the_return_value }
 */

const default_config = {
  "局部变量": {
    "当前模式": 1, //0是生产，1是开发
    "单人多人": 0, //0是担任，1是多人
    "当前模式": "挂机模式",
    "战斗结果": "", //记录最近一次战斗结果
  },

  "全局变量": {
    "账户数量": 0,
    "开启时间": "",
    "开启日期": "",
    "运行时常": 0,
    "游戏目录": "",
    "插件目录": "",
    "配置文件": "",
    "图片路径": "",
    "图片数量": 60, //校验图片数量
  }
}

module.exports.config = default_config