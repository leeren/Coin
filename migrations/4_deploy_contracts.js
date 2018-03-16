var YelpCoin = artifacts.require("./YelpCoin.sol");
var YelpReviewVote = artifacts.require("./YelpReviewVote");

module.exports = function (deployer) {
	deployer.deploy(YelpCoin, 100, "YelpCoin", "Y").then(()=>{
		deployer.deploy(YelpReviewVote, YelpCoin.address, 1, 10);
	})
};
