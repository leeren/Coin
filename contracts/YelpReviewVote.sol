pragma solidity ^0.4.18;

interface YelpCoin {
    function transfer(address receiver, uint256 amount);
    function burn(uint256 amount);
    function burnFrom(address sender, uint256 amount);
}

contract YelpReviewsVote{

    struct Voters {
        address[] users;
    }

    mapping (uint256 => uint256) totalVotes;
    mapping (address => mapping (uint256 => uint256)) reviewVotingByUser;
    mapping (uint256 => Voters) reviewVotingByReviewId;

    uint256 minVoteLimit;
    uint256 reward;
    YelpCoin public yelpCoinReward;

    function YelpReviewsVote(
        address addressOfYelpCoin,
        uint256 voteLimit,
        uint256 rewardToPay
    ) public {
        yelpCoinReward = YelpCoin(addressOfYelpCoin);
        minVoteLimit = voteLimit;
        reward = rewardToPay;
    }

    function vote(uint256 _reviewId, uint256 _value) public {
        // If the user has not voted
        address sender = msg.sender;
        if (reviewVotingByUser[sender][_reviewId] == 0 && totalVotes[_reviewId] < minVoteLimit) {
            totalVotes[_reviewId] = totalVotes[_reviewId] + 1;
            reviewVotingByUser[sender][_reviewId] = _value;
            reviewVotingByReviewId[_reviewId].users.push(sender);
            if (totalVotes[_reviewId] >= minVoteLimit) {
                _aggregate(_reviewId);
            }
        } else {
            revert();
        }
    }

    function _aggregate (uint256 _reviewId) internal {
        uint256 finalValue = 0;
        address[] storage votes = reviewVotingByReviewId[_reviewId].users;
        for (uint256 i =0; i < votes.length; i++) {
            finalValue += reviewVotingByUser[votes[i]][_reviewId];
        }
        _sendReward(_reviewId, finalValue);
    }

    function _sendReward (uint256 _reviewId, uint256 finalValue) internal {
        address[] storage votes = reviewVotingByReviewId[_reviewId].users;
        for (uint256 i =0; i < votes.length; i++) {
            if (reviewVotingByUser[votes[i]][_reviewId] == finalValue) {
                yelpCoinReward.transfer(votes[i], reward);
            }
        }
    }


}


