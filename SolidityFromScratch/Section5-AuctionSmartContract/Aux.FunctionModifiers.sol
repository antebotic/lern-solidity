//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/*
  Function modifiers:
    - used to modify the behaviour of a function.
    - test a condition before calling a function, executing only if modifier evaluates to true
    - using them avoids redundant-code and possible errors
    - contract properties, and are inherited
    - return nothing, only yse require();
    - defined using modifier keyword
 */

 contract ModifierExample {
  uint public price;
  address public owner;

  constructor(){
    owner = msg.sender;
  }

  modifier onlyOwner(){
    require(msg.sender == owner);
    _; //execute the rest of the function that has this modifier
  }

  function changeOwner(address _owner) public onlyOwner {
    owner = _owner;
  }

  function changePrice(uint _price) public onlyOwner {
    price = _price;
  }
}
