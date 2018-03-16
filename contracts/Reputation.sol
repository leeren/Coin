import "./zeppelin/ownership/Ownable.sol";

contract Reputation is Ownable{
	mapping (address => uint) public reputationOf;

	function Reputation() {}

	function register(address _user) public {
		require(reputationOf[_user] == 0);
		reputationOf[_user] = 100;
	}

	function increaseRep(address _user) onlyOwner public {
		reputationOf[_user] = lesserOf(reputationOf[_user] + 2, 100);
	}

	function  decreaseRep(address _user) onlyOwner public {
		reputationOf[_user] = greaterOf(1, reputationOf[_user] - 5);
	}
	
	function greaterOf(uint a, uint b) private pure returns (uint) {
        return a > b ? a : b;
    }

    function lesserOf (uint a, uint b) private pure returns (uint) {
    	return a > b ? b : a;
    }
    
}