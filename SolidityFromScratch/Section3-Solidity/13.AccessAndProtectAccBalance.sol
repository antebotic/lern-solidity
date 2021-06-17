//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract AccessAndProtect {
  address public owner;

  constructor() {
    owner = msg.sender;
  }
  receive() external payable {}

  function getBalance() public view returns (uint){
    return address(this).balance;
  }

  function sendEther() public payable {}

  function transferEther(address payable recipient, uint amount) public returns (bool){
    require(msg.sender == owner, "requires owner");

    if(amount <= getBalance()){
      recipient.transfer(amount);
      return true;
    }

    return false;
  }

  // Send one eth to the contract addres from the owner account, withdraw 1 eth from the contract back to the wallet
  // contract address: 0xf249a0c1D302f3Dda2b0fDAB91Ad60Ed128929A0
}