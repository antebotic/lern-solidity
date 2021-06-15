// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;


contract Coin {
  // A variable of type address does not allow arithmetic operations, 160-bit in size
  address public minter;

  //Mapping can only be initialized in the storage data
  mapping (address => uint) balances;

  //Events can be emmited to listeners who recieve the arguments of the event
  event Sent(address from, address to, uint amount);

  //Constructor is executed during creation of the contract and cannot be called afterwards
  constructor(){
    minter = msg.sender; // external address from which the function call came from
  }

  function mint(address reciever, uint amount) public {
    require(msg.sender == minter);
    balances[reciever] += amount;
  }

  error InsufficientBalance(uint requested, uint available);
  /*
    - Errors provide more information to the caller about why a condtion or operation failed
    - Revert statements uncoditionaly abort and revert all the changes made, but require the name 
      of the error and aditional data to be suplied to the caller
  */
  function send(address reciever, uint amount) public {
    if (amount > balances[msg.sender])
      revert InsufficientBalance({ 
        requested: amount,
        available: balances[msg.sender]
      });

      balances[msg.sender] -= amount;
      balances[reciever]   += amount;
      emit Sent(msg.sender, reciever, amount);
  }
}