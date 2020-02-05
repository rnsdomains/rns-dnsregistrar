# DNS registrar for ENS

This project implements a registrar for RNS that grants RNS domains to anyone who can prove ownership of the corresponding domain in DNS; it uses the [DNSSEC Oracle](https://github.com/rnsdomains/rns-dnssec-oracle) to prove this.

<!--
For details on how to use this, see [How to claim your DNS domain in ENS](https://medium.com/the-ethereum-name-service/how-to-claim-your-dns-domain-on-ens-e600ef2d92ca).

## Installing

```
npm install '@ensdomains/dnsregistrar' --save
```

## Including DNSRegistrar within smart contract

```
import '@ensdomains/dnsregistrar/contracts/dnsregistar.sol'
```

### Using js binding

In addition to `DNSRegistrar` Truffle based artifact which you can call the smart contract directly, we provide a javascript wrapper which looks up DNS record, extract a proof, submit the proof via DNSSec Oracle, and register to ENS via DNSRegistrar using the proof

```js
var DNSRegistrarJs = require('@ensdomains/dnsregistrar');
dnsregistrar = new DNSRegistrarJs(provider, dnsregistraraddress);
dnsregistrar.claim('foo.test').then(claim => {
  claim.submit({ from: account });
});
```

For more detail, please [read the doc](https://dnsregistrar.readthedocs.io/en/latest/)
-->
## Contribution guide

### Setting up

```
git clone https://github.com/rnsdomains/rns-dnsregistrar
cd rns-dnsregistrar
npm install
```

### Running test

On top of Ganache:

```
npx truffle test
```

On top RSK:

```
docker build -t regtest -f Dockerfile.RSKRegtest .
docker run --name regtest-node-01 --rm -p 4444:4444 -p 30305:30305 regtest
```
