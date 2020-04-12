import Vue from 'vue'
import Router from 'vue-router'
import test from '@/components/test'
import card from '@/components/contents/card/index'

Vue.use(Router)

export default new Router({
  routes: [{
    path: '/',
    name: 'test',
    component: test
  }, {
    path: 'card',
    name: 'card',
    component: card
  }]
})