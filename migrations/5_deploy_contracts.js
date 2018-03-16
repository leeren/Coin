var contract = require('truffle-contract');
var YelpCoinObject = require('../build/contracts/YelpCoin.json');
var ReputationObject = require('../build/contracts/Reputation.json');
var YelpReviewVote = artifacts.require('./YelpReviewVote.sol');

var YelpCoinContract = contract(YelpCoinObject);
YelpCoinContract.setProvider(web3.currentProvider);

var ReputationContract = contract(ReputationObject);
ReputationContract.setProvider(web3.currentProvider);

var coinAddr = YelpCoinContract.deployed()
.then(function (instance) {
  return instance.address;
})
.catch(function (error) {
  console.log(':::::::Unable to get deployed YelpCoin')
});

var repAddr = ReputationContract.deployed()
.then(function (instance) {
  return instance.address;
})
.catch(function (error) {
  console.log(':::::::Unable to get deployed Reputation')
});

module.exports = function (deployer) {
	deployer.deploy(YelpReviewVote, coinAddr, 5, 1);
};