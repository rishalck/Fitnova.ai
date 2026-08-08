const surgeSDK = require('surge-sdk');
const client = surgeSDK({ endpoint: 'http://router.surge.sh' });

const email = 'fitnova.deployer2026@gmail.com';
const password = 'FitnovaDeploy2026!';

console.log('Registering account on Surge...');
client.account(email, password, (err, account) => {
  if (err) {
    console.error('Account creation error:', err);
  } else {
    console.log('ACCOUNT CREATED:', account);
  }
});
