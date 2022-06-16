import { createStore } from 'vuex';

import web3 from './modules/web3';
import account from './modules/account';

const store = createStore({
  state: {
    isLogin: sessionStorage.getItem('address') !== null,
  },

  actions: {
    onLogout({ commit }) {
      commit('onLogout');
    },
  },

  mutations: {
    onLogout() {
      localStorage.removeItem('walletconnect');
      sessionStorage.removeItem('address');
      sessionStorage.removeItem('provider');
      window.location.reload();
    },
  },

  modules: {
    web3,
    account,
  },
});

export default store;
