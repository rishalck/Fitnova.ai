const surgeSDK = require('surge-sdk');
const client = surgeSDK({ endpoint: 'https://surge.sh' });
console.log('SDK methods:', Object.keys(client));
