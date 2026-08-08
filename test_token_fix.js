const surgeSDK = require('surge-sdk');
const client = surgeSDK({ endpoint: 'https://surge.sh' });

const userCreds = {
  username: 'fitnova.deployer2026@gmail.com',
  password: 'FitnovaDeploy2026!'
};

client.token(userCreds, {}, (err, token) => {
  if (err) {
    console.error('Token error:', err);
  } else {
    console.log('SURGE TOKEN SUCCESS:', token);
  }
});
