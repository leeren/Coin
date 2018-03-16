var YelpCoin = artifacts.require("./YelpCoin.sol");
var YelpReviewVote = artifacts.require("./YelpReviewVote.sol")

module.exports = function (deployer) {
	deployer.deploy(
        YelpCoin, 1000000, "YelpCoin", "Y"
    ).then(function() {
        deployer.deploy(YelpReviewVote, YelpCoin.address, 10, 1)
    });
};
