const surge = require('surge')();
const path = require('path');

const projectPath = path.resolve(__dirname);
const domain = 'fitnova-app.surge.sh';

console.log('Publishing FitNova to Surge.sh...');
console.log('Project path:', projectPath);
console.log('Target domain:', domain);

const hooks = {
  ready: function (surgeObj) {
    console.log('Surge ready!');
  }
};

try {
  surge.publish({
    project: projectPath,
    domain: domain,
    login: 'fitnova.deployer2026@gmail.com',
    password: 'FitnovaDeploy2026!'
  })(hooks);
} catch (err) {
  console.error('Surge publish error:', err);
}
