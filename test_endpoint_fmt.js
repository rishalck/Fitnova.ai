const urlAddy = require('url-parse-as-address');
const endpoint = urlAddy('surge.sh');
console.log('Formatted endpoint:', endpoint.format());
