var YelpCoin = artifacts.require("./YelpCoin.sol");
var Reputation = artifacts.require("./Reputation.sol");

module.exports = function (deployer) {
	deployer.deploy(YelpCoin, 1000000, "YelpCoin", "Y");
	deployer.deploy(Reputation);
};
