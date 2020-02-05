const RNS = artifacts.require('RNS');
const DummyDNSSEC = artifacts.require('./DummyDNSSEC');
const DNSRegistrar = artifacts.require('./DNSRegistrar');
const namehash = require('eth-ens-namehash');
const sha3 = require('js-sha3').keccak_256;
const packet = require('dns-packet');

const tld = 'xyz';

module.exports = function(deployer, network) {
  return deployer.then(async () => {
    await deployer.deploy(RNS);
    await deployer.deploy(DummyDNSSEC);

    const rns = await RNS.deployed();
    const dnssec = await DummyDNSSEC.deployed();

    await deployer.deploy(DNSRegistrar, dnssec.address, rns.address);
    const registrar = await DNSRegistrar.deployed();

    await rns.setSubnodeOwner('0x0', '0x' + sha3(tld), registrar.address);
  });
};
