/*
Modifiers are code that can be run before and / or after a function call.

Modifiers can be used to:

  Restrict access
  Validate inputs
  Guard against reentrancy hack
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract FunctionModifier {
  address public owner;
  uint public x = 10;
  bool public locked;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
  }

  //modifiers can take inputs
  modifier validAddress(address _addr) {
    require(_addr != address(0), "Not valid address");
    _;
  }

  function changeOwner(address _newOwner) public onlyOwner validAddress(_newOwner) {
    owner = _newOwner;
  }

  //Modifiers can be called before and/or after a function.
  modifier noReEntrancy() {
    require(!locked, "No reentrancy");
    locked = true;
    _;
    locked = false;
  }

  function decrement(uint i) public noReEntrancy {
    x -= i;

    if(i > 1){
      decrement(i - 1); //fails due to the modifier
    }
  }
}
