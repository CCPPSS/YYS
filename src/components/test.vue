<template>
  <div id="btui" class="row">
    <div class="col-md-6">
      <button class="btn btn-success">{{msg}}</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'btui',
  data() {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  }
}

</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
