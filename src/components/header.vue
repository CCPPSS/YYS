<template>
  <div id="upbar" class="row">
    {{ccvb}}
  </div>
</template>

<script>
/*
 * @Author: cps-thinkpad
 * @Date: 2020-01-03 14:15:39
 * @Last Modified by: cps-thinkpad
 * @Last Modified time: 2020-01-04 15:30:03
 */


export default {
  name: 'upbar',
  data() {
    return {
      ccvb: "ccvb",
    }
  },
  components: {

  }
}

</script>

<style>
#upbar {
  background-color: #85F0DB;
  height: 15%;
}

</style>
