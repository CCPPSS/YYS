<template>
  <div id="contests">

    <el-row>
      <el-col :span="6">
        <left></left>
      </el-col>

      <el-col :span="18">
        <right></right>
      </el-col>
    </el-row>

  </div>
</template>

<script>
/*
 * @Author: cps-thinkpad
 * @Date: 2020-01-03 14:15:39
 * @Last Modified by: home-holy
 * @Last Modified time: 2020-01-07 13:27:50
 */
import left from '@/components/contents/left.vue'
import right from '@/components/contents/right.vue'
export default {
  name: 'contests',
  data() {
    return {

    }
  },
  components: {
    left,
    right,
  }
}

</script>

<style>
#contests {
  width: 100%;
  padding: 0;
  background-color: #CACACA;
  height: 70%;
}

</style>
