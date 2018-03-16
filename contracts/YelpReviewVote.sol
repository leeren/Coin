pragma solidity ^0.4.19;

interface Token {
    function transfer(address receiver, uint256 amount) public ;
    function mintToken(address target, uint256 _value) public;
    function burn(uint256 _value) public returns (bool success);
    function burnFrom(address _from, uint256 _value) public returns (bool success);
}

contract YelpReviewVote {

    mapping (uint => uint) public totalVotes;
    mapping (address => mapping(uint => uint)) public reviewVotingByUser;
    // mapping (address => uint) public reviewVotingByUser;
    // mapping (uint => address[]) public reviewVotingByReviewId;
    uint minVoteLimit;
    uint reward;
    Token public yelpCoinReward;
    uint invalid = uint(-1);
    uint valid = uint(1);

    function YelpReviewVote(
        address addressOfYelpCoin,
        uint voteLimit,
        uint rewardToPay
    ) public {
        yelpCoinReward = Token(addressOfYelpCoin);
        minVoteLimit = voteLimit;
        reward = rewardToPay;
    }

    function getVoteForUser (uint _reviewId) public returns(uint)  {
        return reviewVotingByUser[msg.sender][_reviewId];
    }

    function vote(uint _reviewId, uint _value) public {
        // If the user has not voted
        address sender = msg.sender;
        totalVotes[_reviewId] += 1;
        reviewVotingByUser[sender][_reviewId] = _value;
        yelpCoinReward.transfer(sender, reward);
        // reviewVotingByReviewId[_reviewId] += 1;
        // if (totalVotes[_reviewId] >= minVoteLimit) {
        //      _aggregate(_reviewId);
        // }
    }

    // function _aggregate (uint _reviewId) internal returns (uint)  {
    //     uint finalValue = 0;
    //     address[] storage votes = reviewVotingByReviewId[_reviewId];
    //     for (uint i =0; i < votes.length; i++) {
    //         finalValue += reviewVotingByUser[votes[i]][_reviewId];
    //     }
    //     _sendReward(_reviewId, finalValue);
    // }

    // function _sendReward (uint _reviewId, uint finalValue) internal {
    //     address[] storage votes = reviewVotingByReviewId[_reviewId];
    //     for (uint i =0; i < votes.length; i++) {
    //         if (reviewVotingByUser[votes[i]][_reviewId] == finalValue) {
    //             yelpCoinReward.transfer(votes[i], reward);
    //         }
    //     }
    // }


}


