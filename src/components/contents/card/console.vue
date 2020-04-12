<template>
  <div id="card_console">
    <el-button>截图</el-button>
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
      type="textarea"
      placeholder="正面内容"
    ></el-input>
  </div>
</template>

<script>
/*
 * @Author: home-holy
 * @Date: 2020-01-07 17:54:53
 * @Last Modified by: home-holy
 * @Last Modified time: 2020-01-07 17:57:45
 */
export default {
  name: "card_console",
  data() {
    return {
      name: "card_console",
      frontTitle: '',
      backTitle: '',
    }
  },
  methods: {
    getInput(val) {
      console.log(`当前输入:${val}`)
    },
  },
  components: {

  }
}

</script>


<style scoped>
#card_console {
  width: 120px;
  height: 300px;
  background-color: #5F2B53;
  display: inline-block;
}

</style>
