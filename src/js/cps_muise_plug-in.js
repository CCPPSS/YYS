/**
 * cps音乐插件0.0.1
 * 2019-8-21 23:09
 *
 * author:cps
 */

//先判断支持的格式
console.log('已加载：cps音乐插件0.0.1')
var c_audio = document.getElementById("CPS_music_audio")


function check_format_support() {
    let res, ret;
    for (let tmp of ['audio/mp3', 'audio/mp2', 'audio/ogg']) {
        res = c_audio.canPlayType('audio/mp3')
        if (res === "probably") {
            console.log("浏览器支持：" + tmp + "格式。")
        }
    }
}



if (c_audio) {
    check_format_support()
} else {
    console.log("没有发现 id：CPS_music_audio 的标签,插件加载失败");
}