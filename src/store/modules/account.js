import Web3 from 'web3';

const store = {
  namespaced: true,
  state: {
    address: sessionStorage.getItem('address')
      ? sessionStorage.getItem('address')
      : null,
    balance: `${0}`,
    symbol: null,
  },
  getters: {},
  mutations: {
    updateAccountData(state, payload) {
      state.address = payload.address;
      state.balance = Web3.utils.toBN(payload.balance).toString();
      state.symbol = payload.symbol;
    },
    updateBalance(state, payload) {
      state.balance = Web3.utils.toBN(payload).toString();
    },
    decreaseBalance(state, payload) {
      state.balance = Web3.utils
        .toBN(state.balance)
        .sub(Web3.utils.toBN(payload))
        .toString();
    },
    increaseBalance(state, payload) {
      state.balance = Web3.utils.toBN(payload).toString();
    },
  },
  actions: {
    updateAccountData({ commit }, payload) {
      commit('updateAccountData', payload);
    },
  },
};

export default store;
