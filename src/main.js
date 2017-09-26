// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import VueRouter from 'vue-router';

import Languages from './components/Languages';

Vue.use(VueRouter);
Vue.config.productionTip = false;

const router = new VueRouter({
  routes: [
    { path: '/', component: Languages },
    { path: '/:language/:video/:start', component: Languages },
  ],
});

Vue.filter('truncate', (text, stop, clamp) => {
  const end = stop < text.length ? clamp || '...' : '';
  const body = text.slice(0, stop);
  return body + end;
});

Vue.filter('capitalize', text => text[0].toUpperCase() + text.substr(1));

/* eslint-disable no-new */
new Vue({
  router,
}).$mount('#app');
