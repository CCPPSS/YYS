<template>
  <div id="right">
    <card></card>
  </div>
</template>

<script>
/*
 * @Author: cps-thinkpad
 * @Date: 2020-01-03 14:15:39
 * @Last Modified by: home-holy
 * @Last Modified time: 2020-01-07 17:54:21
 */
import card from '@/components/contents/card/index'

export default {
  name: 'right',
  data() {
    return {
      showDismissibleAlert: false
    }
  },
  components: {
    card,
  }
}

</script>

<style>
#right {
  background-color: #EBAC9A;
}

</style>
