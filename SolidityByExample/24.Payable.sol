// Functions and addresses declared payable can receive ether into the contract.

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Payable {
  //payable address can recieve Ether
  address payable public owner;

  //payable constructor can recieve Ether
  constructor() payable {
    owner = payable(msg.sender);
  }

  // Function to deposit Ether into this contract.
  // Call this function along with some Ether.
  // The balance of this contract will be automatically updated.
  function deposit() public payable {}

  // Function to withdraw all Ether from this contract to the owner address.
  function withdraw() public {
    uint amount = address(this).balance;

    (bool success, ) = owner.call{value: amount}("");
    require(success, "Failed to send ether");
  }

  //Transfer amout to input address
  function transfer(address payable _to, uint _amount) public {
    (bool success, ) = _to.call{value: _amount}("");
    require(success, "Failed to send ether");
  }

}
