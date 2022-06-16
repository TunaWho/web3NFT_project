import Web3 from 'web3';

const store = {
  namespaced: true,
  state: {
    instance: Web3,
    chainId: null,
    provider: null,
  },
  getters: {},
  mutations: {
    update(state, payload) {
      state.instance = payload.instance;
      state.chainId = payload.chainId;
      state.provider = payload.provider;
    },
    updateChainId(state, payload) {
      state.chainId = payload;
    },
  },
  actions: {
    update({ commit }, payload) {
      commit('update', payload);
    },
    updateChainId({ commit }, payload) {
      commit('updateChainId', payload);
    },
  },
};

export default store;
