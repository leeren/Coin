pragma solidity ^0.4.18;

// Inherent from owned to access modifier requiring ownership
contract owned {

    address public owner;

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        // Placement holder for modifier
        _;
    }

    // Transfer ownership to new address
    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

// Specifies interface for contract that must implement this function for approval
interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }

contract YelpCoin is owned {
    struct votingValidator {
        bool vote;
        address validatorAddress;
    }
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    uint public numValidators;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    mapping (address => uint256) public validators;
    mapping (bytes32 => uint) public reviews;
    mapping (bytes32 => votingValidator[]) public votingValidators;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Burn(address indexed from, uint256 value);

    function YelpCoin(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
        numValidators = 0;
    }

    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        // Check sender has enough
        require(balanceOf[_from] >= _value);
        // No overflows
        require(balanceOf[_to] + _value > balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        tokenRecipient spender = tokenRecipient(_spender);
        spender.receiveApproval(msg.sender, _value, this, _extraData);
        return true;
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner public {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, this, mintedAmount);
        Transfer(this, target, mintedAmount);
    }

    function stake(uint256 _value) public {
        // required balance and overflow check
        require(balanceOf[msg.sender] >= _value) ;
        require(validators[msg.sender] + _value > validators[msg.sender]);
        // lock validator's tokens
        validators[msg.sender] += _value;
        balanceOf[msg.sender] -= _value;
        numValidators += 1;
    }

    function addToReviews(bytes32 reviewId) public {
        reviews[reviewId] = 1;
    }

    function castVote(bytes32 reviewId, bool vote) public returns (bool success) {
        // Can only vote if you are a validator
        require(validators[msg.sender] > 0);
        require(reviews[reviewId] > 0);
        if (vote) {
            reviews[reviewId] += 1;
        } else {
            reviews[reviewId] -= 1;
        }
        votingValidators[reviewId].push(votingValidator(vote, msg.sender));
        if(votingValidators[reviewId].length == numValidators) {
            tallyVotes(reviewId);
        }
        return true;
    }

    function tallyVotes(bytes32 reviewId) public {
        bool standard = (reviews[reviewId] >= numValidators/2 + 1);     
        uint lenValidators = votingValidators[reviewId].length;
        for(uint i = 0; i < lenValidators; i++) {
            address currValidator = votingValidators[reviewId][i].validatorAddress;
            if(standard && votingValidators[reviewId][i].vote) {
                balanceOf[currValidator] += validators[currValidator];
            }
            validators[currValidator] = 0;
            numValidators -= 1;
        }
        reviews[reviewId] = 0;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   
        balanceOf[msg.sender] -= _value;            
        totalSupply -= _value;                      
        Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);                
        require(_value <= allowance[_from][msg.sender]);    
        balanceOf[_from] -= _value;                         
        allowance[_from][msg.sender] -= _value;             
        totalSupply -= _value;                              
        Burn(_from, _value);
        return true;
    }
}
