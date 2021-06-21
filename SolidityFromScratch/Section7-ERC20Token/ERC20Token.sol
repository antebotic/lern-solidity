//SPDX-License-Identifier: GPL-3.

pragma solidity ^0.8.4;

/*
  ERC20 Token Standard:
    - a token is designed to represent something of value, and also things like voting rights
      or discount tokens. It can represent any fungible trading good
    - ERC stands for Ethereum Request for Comments. An erc is a form of proposal and its
      purpose is to define standards and practices
    - EIP stands for Ethereum Improvement Proposal and makes changes to the actual code of Ethereum.
      ERC is a set of guidelines on hot to use different features of Ethereum
    - ERC20 is a proposal that intends to standardize how a token contract should be defined,
      how we interact with such a token contract, and how these contracts interract with each other.
    - in conclusion, ERC20 is a standard interface used by applications such as wallets, dexes, 
      and other actors, on how to interact with tokens
    
    - a token standard is needed for interoperability
    - token holders have full control and complete ownership of their tokens.
    - the token contract keeps track of token ownership
    - tokens can be fully or partialy ERC20 compliant
    - a fully compliant ERC20 token implements 6 functions and 2 events.
      
*/

interface ERC20Interface {
  function totalSupply() external view returns (uint);
  function balanceOf(address tokenowner) external view returns (uint balance);
  function transfer(address to, uint tokens) external returns (bool success);

  function allowance(address tokenOwner, address spender) external view returns (uint remaining);
  function approve(address spender, uint tokens) external returns (bool success);
  function transferFrom(address from, address to, uint tokens) external returns (bool success);

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ERC20Token is ERC20Interface {
  string public name = "Cryptos";
  string public symbol = "CRPT";
  uint public decimals = 0; //18 is most used decimal value (max representable uint)
  uint public override totalSupply;
  
  address public founder;
  mapping(address => uint) public balances;
  mapping(address => mapping(address => uint)) allowed;

  constructor(){
    totalSupply = 1 * 10 ** 6;
    founder = msg.sender;
    balances[founder] = totalSupply;
  }

  function balanceOf(address tokenowner) public view override returns (uint balance){
    return balances[tokenowner];
  }

  function transfer(address to, uint tokens) public virtual override returns (bool success){
    require(balances[msg.sender] >= tokens); // transfers of 0 value must be treated as normal transactions too
    
    balances[msg.sender] -= tokens;
    balances[to] += tokens;
    emit Transfer(msg.sender, to, tokens);

    return true;
  }

  function allowance(address tokenOwner, address spender) view public override returns(uint){
    return allowed[tokenOwner][spender];
  }

  function approve(address spender, uint tokens) public override returns (bool success){
    require(balances[msg.sender] >= tokens);
    require(tokens > 0);

    allowed[msg.sender][spender] = tokens;

    emit Approval(msg.sender, spender, tokens);
    return true;
  }

  function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success){
    require(tokens > 0);
    require(balances[from] >= tokens);
    require(allowed[from][to] >= tokens);
    
    balances[from] -= tokens;
    allowed[from][to] -= tokens;
    balances[to] += tokens;

    emit Transfer(from, to, tokens);
    return true;
  }
}

contract CryptosICO is ERC20Token {
  address public admin;
  address payable public deposit;
  uint tokenPrice = 0.001 ether;
  uint public hardCap = 300 ether;
  uint public raisedAmount;
  uint public saleStart = block.timestamp;
  uint public saleEnd = block.timestamp + 604800; // ends in one week
  uint public tokenTradeStart = saleEnd + 604800;
  uint public maxInvestment = 5 ether;
  uint public minInvestment = 0.1 ether;

  enum State{beforeStart, running, afterEnd, halted}
  State public icoState;

  constructor(address payable _deposit){
    deposit = _deposit;
    admin = msg.sender;
    icoState = State.beforeStart;
  }

  modifier onlyAdmin(){
    require(msg.sender == admin);
    _;
  }

  function halt() public onlyAdmin {
    icoState = State.halted;
  }

  function resume() public onlyAdmin {
    icoState = State.running;
  }

  function changeDepositAddress(address payable _newDepositAddr) public onlyAdmin {
    deposit = _newDepositAddr;
  }

  function getCurrentState() public view returns(State){
    if(icoState == State.halted){
      return State.halted;
    } else if (block.timestamp < saleEnd){
      return State.beforeStart;
    } else if( block.timestamp >= saleStart && block.timestamp <= saleEnd){
      return State.running;
    } else {
      return State.afterEnd;
    }
  }

  event Invest(address investor, uint value, uint tokens);

  function invest() payable public returns(bool){
    icoState = getCurrentState();
    require(icoState == State.running);

    require(msg.value >= minInvestment && msg.value < maxInvestment);
    raisedAmount += msg.value;
    require(raisedAmount <= hardCap);
    
    uint tokens = msg.value /tokenPrice;
    balances[msg.sender] += tokens;
    balances[founder] -= tokens;
    deposit.transfer(msg.value);

    emit Invest(msg.sender, msg.value, tokens);
    
    return true;
  }

  receive() payable external {
    invest();
  }
  
  function transfer(address to, uint tokens) public override returns(bool success){
      require(block.timestamp > tokenTradeStart);
      ERC20Token.transfer(to, tokens);
      return true;
  }
  
  function transferFrom(address from, address to, uint tokens) public override returns (bool success){
      require(block.timestamp > tokenTradeStart);
      ERC20Token.transferFrom(from, to, tokens);
      return true;
  }

  function burn() public returns (bool){
    icoState = getCurrentState();
    require(icoState == State.afterEnd);
    balances[founder] = 0;
    return true;
  }
}