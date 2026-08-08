const surge = require('surge')();

process.env.SURGE_LOGIN = 'fitnova.deployer2026@gmail.com';

const opts = {
  email: 'fitnova.deployer2026@gmail.com',
  password: 'FitnovaDeploy2026!'
};

surge.login()(opts);
