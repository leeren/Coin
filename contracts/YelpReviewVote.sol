pragma solidity ^0.4.19;

interface token {
    function transfer(address receiver, uint amount) public ;
}

contract YelpReviewVote{

    struct Voters {
        address[] users;
    }


    mapping (uint => uint) public totalVotes;
    mapping (address => mapping(uint => uint)) reviewVotingByUser;
    mapping (uint => Voters) reviewVotingByReviewId;
    uint minVoteLimit;
    uint reward;
    token public yelpCoinReward;
    uint invalid = uint(-1);
    uint valid = uint(1);

    function YelpReviewVote(
        address addressOfYelpCoin,
        uint voteLimit,
        uint rewardToPay
    ) public {
        yelpCoinReward = token(addressOfYelpCoin);
        minVoteLimit = voteLimit;
        reward = rewardToPay;
    }

    function vote(uint _reviewId, uint _value) public {
        // If the user has not voted
        address sender = msg.sender;
        totalVotes[_reviewId] += 1;
        reviewVotingByUser[sender][_reviewId] = _value;

        if (totalVotes[_reviewId] >= minVoteLimit) {
             _aggregate(_reviewId);
        }

    }

    function _aggregate (uint _reviewId) internal returns (uint)  {
        uint finalValue = 0;
        address[] storage votes = reviewVotingByReviewId[_reviewId].users;
        for (uint i =0; i < votes.length; i++) {
            finalValue += reviewVotingByUser[votes[i]][_reviewId];
        }
        _sendReward(_reviewId, finalValue);
    }

    function _sendReward (uint _reviewId, uint finalValue) internal {
        address[] storage votes = reviewVotingByReviewId[_reviewId].users;
        for (uint i =0; i < votes.length; i++) {
            if (reviewVotingByUser[votes[i]][_reviewId] == finalValue) {
                yelpCoinReward.transfer(votes[i], reward);
            }
        }
    }


}


