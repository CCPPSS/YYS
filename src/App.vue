<template>
  <div id="app">
    <cheader></cheader>
    <contents></contents>
    <cfooter></cfooter>
  </div>
</template>

<script>
import test from './components/test.vue'
import cheader from './components/header.vue'
import cfooter from './components/footer.vue'
import contents from './components/contents'

export default {
  name: 'App',
  components: {
    test,
    cheader,
    cfooter,
    contents
  }
}

</script>

<style>
#app {
  background-color: #EB86F3;
  height: 700px;
  width: 1100px;
}

</style>
