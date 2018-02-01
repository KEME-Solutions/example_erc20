pragma solidity ^0.4.18;

contract ERC20Interface {

    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


library SafeMath {
     function add(uint a, uint b) internal pure returns (uint c) {
         c = a + b;
         require(c >= a);
     }
     function sub(uint a, uint b) internal pure returns (uint c) {
         require(b <= a);
         c = a - b;
     }
     function mul(uint a, uint b) internal pure returns (uint c) {
         c = a * b;
         require(a == 0 || c / a == b);
     }
     function div(uint a, uint b) internal pure returns (uint c) {
         require(b > 0);
         c = a / b;
     }
}


contract Owned {
    address public owner;
    address public newOwner;
    
    event OwnershipTransferred(address indexed _from, address indexed _to);
    
    function Owned() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Start2CodeToken is ERC20Interface, Owned {
    using SafeMath for uint;
    
    string public name;
    string public symbol;
    uint public decimals;
    uint public _totalSupply;

    mapping (address => uint256) public balances;
    mapping(address => mapping(address => uint)) allowed;
    
    function Start2CodeToken() public {
        name = 'Start2Code';
        symbol = 'S2C';
        decimals = 0;
        _totalSupply = 500000;
        balances[msg.sender] = _totalSupply;
    }
    
    function totalSupply () public constant returns (uint) {
        return _totalSupply;
    }
    
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender].sub(tokens);
        balances[to].add(tokens);
        
        Transfer(msg.sender, to, tokens);
        
        return true;
    }
    
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(from, to, tokens);
        return true;
    }
    
    function () public payable {
        revert();
    }
    
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    
    function createTokens(address to, uint tokens) public onlyOwner returns (bool success) {
        _totalSupply.add(tokens);
        return ERC20Interface(to).transfer(owner, tokens);
    }
}


