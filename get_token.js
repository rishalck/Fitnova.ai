const surgeSDK = require('surge-sdk');
const client = surgeSDK({ endpoint: 'https://surge.sh' });

const email = 'fitnova.deployer2026@gmail.com';
const password = 'FitnovaDeploy2026!';

client.token(email, password, (err, token) => {
  if (err) {
    console.error('Token error:', err);
  } else {
    console.log('SURGE TOKEN ACQUIRED:', token);
  }
});
