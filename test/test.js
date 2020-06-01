'use strict'
console.log(`当前目录：${__dirname}`);
if (typeof(window) === 'undefined') {
    var currtEnv = 'node'
    var c = require('../src/js/cps.js')
} else {
    var currtEnv = 'electron'
    var c = require(__dirname + '/src/js/cps.js')
    var l = require(__dirname + '/src/js/lw.js')
    var lw_path = __dirname + '/src/js/test12.dll'
}

console.log(`当前环境：${currtEnv}`);
var path = require('path')
var fs = require('fs')



/**
 * 播放下一首
 *
 * @param      {audio对象}  musicObject  传入播放对象
 * @param      {播放列表}  playIndex    传入map格式的播放列表
 * @param      {播放索引}  playType     要播放的索引
 */
function nextPlay(musicObject, mList, playIndex) {
    playIndex = parseInt(playIndex)

    //判断播放索引不能大于播放数量，或者小于0
    if (playIndex > 0 && playIndex < mList.size) {
        let tar = mList.get(playIndex)['fullName']

        musicObject.src = tar
        musicObject.play()
    } else if (playIndex === 0) {
        musicObject.src = mList.get(1)['fullName']
        musicObject.play()
        playIndex = 1
    }

    musicObject.setAttribute('playing', mList.get(playIndex)['name'])
    return playIndex
}

/**
 * 创建播放列表
 *
 * @param      {播放列表的容器}  map       map格式
 * @param      {数组}  listData  存放所有音乐文件的信息
 * @param      {str}  qequ      播放顺序-根据顺序生成播放列表
 * @return     {<type>}  { description_of_the_return_value }
 */
function createMenu(map, listData, qequ) {
    let num = 1
    map.clear()
    console.log('当前输入：', qequ);
    switch (qequ) {
        case '随机':
            console.log('执行随机排序');
            map.set(0, '随机')
            let len = listData.length;
            let tmpList = [].concat(listData)

            //将数组打乱，并重组，达到随机顺序的目的
            for (let i = 0; i < len - 1; i++) {
                let index = parseInt(Math.random() * (len - i));
                let temp = tmpList[index];
                tmpList[index] = tmpList[len - i - 1];
                tmpList[len - i - 1] = temp;
            }

            for (let each of tmpList) {
                map.set(num, each)
                num++
            }

            return map
            break;

        default:
            console.log('执行顺序排序');
            map.set(0, '顺序')
            for (let each of listData) {
                map.set(num, each)
                num++
            }
            return map
            break;
    }

}


/**
 * 判断是否符合格式，生成json为单位的数组
 *
 * @param      {<String>}   file    The file
 * @return     {Promise}  返回一个列表 [{xxxx}]
 */
function appendItemByFiles(file) {
    return new Promise((res, rej) => {
        //判断拖拽目标
        try {
            fs.accessSync(file, fs.constants.F_OK | fs.constants.R_OK)
            let ext = path.extname(file)
            let reslist = []
            let reg = /\#+?/
            if (ext === '.mp3' && file.search(reg) < 0) {
                let fsPath = path.parse(file)
                fsPath['fullName'] = file
                reslist.push(fsPath)
                res(reslist)
            }

        } catch (err) {
            console.log('文件不合法');
            console.log(err);
        }
    })
}

/**
 * 遍历目录，返回符合格式的json
 *
 * @param      {string}   dir     The dir
 * @return     {Promise}  返回一个保存了多个json的列表[{1},{2},{3}]
 */
function appendItemByDir(dir) {
    return new Promise((res, rej) => {
        //判断拖拽目标
        let reslist = []
        try {
            fs.accessSync(dir, fs.constants.F_OK)
            let tmp = fs.readdirSync(dir)

            // 遍历文件夹
            for (let each of fs.readdirSync(dir)) {
                let tar = dir + path.sep + each
                // console.log('1----', tar);
                if (fs.statSync(tar).isFile()) {
                    // console.log('2----');
                    appendItemByFiles(tar)
                        .then(function(data) {
                            // console.log((data));
                            reslist.push(...data)
                        })

                } else if (fs.statSync(tar).isDirectory()) {
                    // console.log('3----');
                    appendItemByDir(tar)
                        .then(function(data) {
                            res(data)
                        })
                }
            }
            res(reslist)

        } catch (err) {
            console.log('无法读取文件夹' + tar);
            console.log(err);
            rej(null)
        }
    })
}


/**
 * 通过map生成span歌曲的播放目录
 *
 * @param      {audioObject}  musicObject  导入播放对象
 * @param      {mapObject}  map          导入播放列表 map格式
 */
function addMusicElementWhithMap(musicObject, map) {
    // 清空元素
    musicObject.innerHTML = ''
    for (let i = 1; i < map.size; i++) {
        let node = document.createTextNode(i + '、' + map.get(i)['name'])
        //创建歌曲html元素
        let tmp = document.createElement('span')
        tmp.setAttribute('index', i)
        tmp.setAttribute('ext', map.get(i)['ext'])
        tmp.setAttribute('name', map.get(i)['name'])
        tmp.setAttribute('class', 'musicItem')
        tmp.appendChild(node)
        musicObject.appendChild(tmp)
    }
    return musicObject
}

//加载后执行
if (currtEnv === 'electron') {
    window.onload = () => {
        let testBtn = c.$('#testBtn')
        const lw = l.createObject()
        lw.init(lw_path)
        if (testBtn) {
            console.log('发现测试按钮');
            testBtn.onclick = () => {
                lw.ver()
            }
        } else {
            console.log('没有发现测试按钮');
        }


        //查找id为CPS_music的audio标签
        const music = c.$('#CPS_music')

        if (!music) {
            alert('音乐组件需要一个id为CPS_music的div标签。' + music)
            return;
        }

        let currtIndex = 1
        let currtPlay = ""

        //创建播放对象
        const audioObject = c.addElement(music, 'audio');
        const mCurrtTime = 0

        //创建标题
        const mTitle = c.addElement(music, 'h3', "CPS音乐播放器");
        const musicCount = 0


        //map格式的播放列表
        let playList = new Map()

        //所有音乐文件的数据
        let musicInfo = []

        const playOlList = c.addElement(music, 'ol');
        playOlList.setAttribute('id', 'musicList')

        let spanItem = playOlList.getElementsByTagName('span')


        //创建控制台
        const consoleBar = c.addElement(music, 'div');
        consoleBar.setAttribute('id', 'consoleBar')
        const backBtn = c.addElement(consoleBar, 'span', '上一首');
        const playBtn = c.addElement(consoleBar, 'span', '播放/暂停');
        const nextBtn = c.addElement(consoleBar, 'span', '下一首');

        /*======================监听事件======================*/
        let x = function() { console.log('ccccccccc'); }
        //播放列表-监听拖放动作
        playOlList.addEventListener('drop', (e) => {
            e.preventDefault()
            const dropList = e.dataTransfer.files //获取对象的文件列表
            if (dropList.length > 0) {
                console.log('当前已选择：' + dropList.length);
                console.log(dropList[0].path);
                for (let each of dropList) {
                    if (fs.statSync(each.path).isFile()) { //处理文件
                        console.log('添加文件');
                        appendItemByFiles(each.path)
                            .then(function(res) {
                                //记录歌曲到数据库
                                musicInfo.push(...res)
                                createMenu(playList, musicInfo)

                                //根据播放信息创建新列表
                                addMusicElementWhithMap(playOlList, playList)

                            }, null)

                    } else if (fs.statSync(each.path).isDirectory()) { //处理目录
                        console.log('添加目录');
                        appendItemByDir(each.path)
                            .then(function(res) {
                                //记录歌曲到数据库
                                musicInfo.push(...res)
                                createMenu(playList, musicInfo)

                                //根据播放信息创建新列表
                                addMusicElementWhithMap(playOlList, playList)

                            }, null)
                    }
                }
            }
        })

        //点击选择歌曲
        playOlList.addEventListener('click', (e) => {
            if (e.target.className) {
                try {
                    currtIndex = nextPlay(audioObject, playList, parseInt(e.target.getAttribute('index')))
                } catch (err) {
                    alert('播放发生错误' + err)
                }
            } else {
                console.log('元素名称不是播放文件：', e.target.localName)
            }

        })

        // 播放列表-屏蔽其他拖放操作
        playOlList.ondragenter = playOlList.ondragover = playOlList.ondragleave = (e) => {
            e.preventDefault()
            return false
        }

        //上一首
        backBtn.onclick = () => {
            // console.log('当前媒体的播放位置：', audioObject.currentTime);
            // console.log('当前媒体的播放位置：', audioObject.currentTime);
            // console.log('当前媒体的音量：', audioObject.volume);
            // console.log('当前媒体是否静音：', audioObject.muted);
            // console.log('当前媒体播放长度：', audioObject.duration);
            // console.log('当前媒体的播放位置：', audioObject.currentTime);
            // console.log('当前媒体的缓冲范围：', audioObject.buffered)
            // console.log('当前媒体的寻址范围：', audioObject.seekable)
            // console.log('当前媒体是否已播放过：', audioObject.played);
            // console.log('媒体默认速率：', audioObject.defaultPlaybackRate);
            // console.log('媒体当前速率：', audioObject.playbackRate);
            currtIndex = nextPlay(audioObject, playList, currtIndex - 1)
        }

        //下一首
        nextBtn.onclick = () => {
            currtIndex = nextPlay(audioObject, playList, currtIndex + 1)
        }

        //播放/暂停
        playBtn.onclick = () => {
            console.dir(playOlList)

            if (!audioObject.src) {
                console.log('无播放对象')
                return false

            } else {
                console.log('播放/暂停');


            }

            //播放/暂停 状态切换
            if (audioObject.paused) {
                audioObject.play()
            } else {
                audioObject.pause()
            }


        }

        //开始播放
        audioObject.addEventListener('play', () => {
            //锁定当前已播放的元素
            console.log('当前 src：', audioObject.getAttribute('playing'))
            for (let each of spanItem) {
                if (audioObject.getAttribute('playing') === each.getAttribute('name')) {
                    each.setAttribute('class', 'playing musicItem')
                    if (currtPlay) {
                        currtPlay.setAttribute('class', 'musicItem')
                    }
                } else {
                    each.setAttribute('class', 'musicItem')
                }
            }
        })

        //结束播放
        audioObject.addEventListener('ended', () => {
            if (currtIndex < playList.size) {
                currtIndex++
            } else {
                currtIndex = 1
            }
            currtIndex = nextPlay(audioObject, playList, currtIndex)
        })

        //错误
        audioObject.addEventListener('error', (err) => {
            console.log('音频播放错误:', err);
        })
    }
} else if (currtEnv === "node") {
    console.log('当前在nodejs环境');
    const ffi = require('ffi-napi')
    const ref = require('ref-napi')
}
