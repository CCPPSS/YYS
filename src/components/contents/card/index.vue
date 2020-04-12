<template>
  <div id="cards">

    <el-row :gutter="10">
      <el-col :span="9">
        <div
          :style="cardSize"
          ref="imageTofile"
        >
          <div id="tar">
            <div :style="cardStyle.backTitle">{{backTitle}}</div>
            <div :style="cardStyle.frontTitle">{{frontTitle}}</div>
          </div>
        </div>
      </el-col>

      <el-col :span="9">
        <div :style="cardSize">
          <div id="tar">
            <div :style="cardStyle.backTitle">{{frontTitle}}</div>
            <div id="frontTitle">{{backTitle}}</div>
          </div>
        </div>
      </el-col>

      <el-col :span="6">
        <div id="card_console">
          <el-button @click="toImage()">截图</el-button>
          <el-button @click="test()">测试</el-button>

          <el-select
            v-model="size"
            filterable
            placeholder="纸张尺寸"
          >
            <el-option
              v-for="item in pageSize"
              :key="item.name"
              :label="item.name"
              :value="item.height"
            >
            </el-option>
          </el-select>

          <el-input
            clearable
            @input="getInput"
            v-model="frontTitle"
            placeholder="正面标题"
          ></el-input>

          <el-input
            clearable
            v-model="backTitle"
            placeholder="背面标题"
          ></el-input>

          <el-input
            clearable
            v-model="dpi"
            placeholder="精度倍数"
          ></el-input>

          <el-input
            type="textarea"
            placeholder="正面内容"
          ></el-input>
        </div>

      </el-col>
    </el-row>

    <el-row>
      <div
        id="res"
        :style="cardSize"
      >
        <img
          :src="htmlUrl"
          :style="preStyle"
        >
      </div>

    </el-row>
  </div>
</template>

<script>
"use strict";
import html2canvas from "html2canvas";

let A4 = {
  width: 500,
  height: 600,
}

let A3 = {
  width: 500,
  height: 600,
}

function html2canvasEx(tar) {
  let target = "";
  let width = target.offsetWidth;
  let height = target.offsetheight;
  let enlarge = 3;

  console.log("开始截图");

  html2canvas(target, {
    backgroudColor: null,
    useCORS: true
  }).then(canvas => {
    let url = canvas.toDataURL("image/png");
    this.htmlUrl = url;
    // this.sendUrl()
  });
}

export default {
  name: "card",
  data() {
    return {
      name: "card",
      htmlUrl: "htmlUrl",
      frontTitle: "cc",
      backTitle: "55",
      size: "",
      dpi: 4,
      cardinfo: {
        carname: "请输入名字",
        front: "前面",
        back: "背面"
      },
      preStyle: {
        width: "100%",
        height: "100%",
      },
      pageSize: [{
        name: "a3",
        width: "50px",
        height: "60px"
      }, {
        name: "a4",
        width: "50px",
        height: "60px"
      }],
      cardSize: {
        width: "300px",
        height: "212px",
        backgroundColor: "#D3D4D4"
      },
      cardStyle: {
        backTitle: {
          fontSize: "14px",
          color: "#FC00EF",
          paddingTop: "1%",
          textAlign: "center"
        },
        frontTitle: {
          textAlign: "center",
          color: "#FC0000",
          fontSize: this.fontSize()
        }
      }
    }
  },
  components: {},

  methods: {
    /*动态设置字体*/
    fontSize() {
      return "120px"
    },

    test() {
      console.log(this.preStyle.width);
      this.cardSize.width = "600px";
      this.cardSize.height = "414px";
    },

    getInput(val) {
      console.log(`当前输入:${val}`);
    },
    /**
     * 使用html2canvas截图
     */
    toImage() {
      console.log("开始截图");
      console.log(this.$refs.imageTofile);
      html2canvas(this.$refs.imageTofile, {
        scale: this.dpi,
        backgroudColor: null,
        useCORS: true
      }).then(canvas => {
        let url = canvas.toDataURL("image/png");
        this.htmlUrl = url;
        // this.sendUrl()
      });
    }
  },

  mounted() {
    // 页面加载好后执行
    setTimeout(console.log("加载好了"), 1500);
    setTimeout(this.toImage(), 500);
  }
};

</script>


<style scoped>
#tar {
  align-items: center;
  justify-content: center;
}

#frontTitle {
  color: #FF0000;
  font-size: 140px;
  text-align: center;
}

#cards {
  background-color: #cdec9c;
}

.drawbar {
  display: inline-block;
}

#tar {
  width: 90%;
  height: 90%;
  margin: auto;
  background-color: #ffffff;
  border-radius: 15px;
  border: 2px solid #d1cccc;
}

#card_console {
  height: 300px;
  padding: 5px;
  background-color: #f9caee;
  display: inline-block;
}

</style>
