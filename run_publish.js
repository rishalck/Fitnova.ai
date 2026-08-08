const surge = require('surge')();
const path = require('path');

const projectPath = path.resolve(__dirname);
const domain = 'fitnova-app.surge.sh';

console.log('Publishing FitNova to Surge.sh...');
console.log('Project:', projectPath);
console.log('Domain:', domain);

const opts = {
  project: projectPath,
  domain: domain,
  login: 'fitnova.deployer2026@gmail.com',
  password: 'FitnovaDeploy2026!'
};

surge.publish()(opts);
