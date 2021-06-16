// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

contract {
  uint private price;
  address public owner;

  constructor(){
    price = 0;
    owner = msg.sender;
  }

  //Function modifier

  modifier onlyOwner(){
    require(msg.sender == owner, "only owner");
    _;
  }

  function changeOwner(address _owner) public onlyOwner {
    owner = _owner;
  }

  function setPrice(uint _price) public {
    price = _price;
  }

  function getPrice() view public returns (uint) {
    return price;
  }
}