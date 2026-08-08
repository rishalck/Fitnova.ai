const surgeSDK = require('surge-sdk');
const urlAddy = require('url-parse-as-address');
const endpoint = urlAddy('surge.sh');

const sdk = surgeSDK({ endpoint: endpoint.format() });

const email = 'fitnova.deployer2026@gmail.com';
const pass = 'FitnovaDeploy2026!';

console.log('Fetching token from Surge...');
sdk.token({ user: email, pass: pass }, { msg: 'fitnova-deploy' }, (err, creds) => {
  if (err) {
    console.error('Fetch token error:', err);
  } else {
    console.log('SURGE TOKEN SUCCESS:', creds);
  }
});
