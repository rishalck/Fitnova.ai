const surgeSDK = require('surge-sdk');

const endpoints = ['https://surge.sh', 'https://router.surge.sh', 'http://surge.sh', 'http://router.surge.sh'];

const email = 'fitnova.deployer2026@gmail.com';
const pass = 'FitnovaDeploy2026!';

endpoints.forEach((ep) => {
  const sdk = surgeSDK({ endpoint: ep });
  sdk.token({ user: email, pass: pass }, { msg: 'fitnova' }, (err, res) => {
    if (err) {
      console.log(`Endpoint ${ep} failed:`, err.status || err.messages);
    } else {
      console.log(`Endpoint ${ep} SUCCESS:`, res);
    }
  });
});
