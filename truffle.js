module.exports = {
  // mocha: {
  //   reporter: 'eth-gas-reporter',
  //   reporterOptions : {
  //     currency: 'USD',
  //     gasPrice: 1
  //   }
  // }
  networks: {
    local: {
      host: 'localhost',
      port: 4444,
      network_id: '*',
      gas: 4712388
    },
    ganache: {
      host: 'localhost',
      port: 7545,
      network_id: '*',
      gas: 4712388
    }
  }
};
