var YelpCoin = artifacts.require("./YelpCoin.sol");

module.exports = function (deployer) {
	deployer.deploy(YelpCoin, 1000000, "YelpCoin", "Y");
};
