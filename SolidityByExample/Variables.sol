// There are 3 types of variables in Solidity

// local
//  declared inside a function
//  not stored on the blockchain

// state
//  declared outside a function
//  stored on the blockchain

// global (provides information about the blockchain)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Variables {
  //public variables are stored onchain
  string public text = "Hello";
  uint public num = 123;

  function doSomething() public view {
    //this is a variable local to the encapsulating function, it is not stored onchain
    uint i = 256;

    //example global variables
    uint timestamp = block.timestamp;
    address sender = msg.sender;
  }
}