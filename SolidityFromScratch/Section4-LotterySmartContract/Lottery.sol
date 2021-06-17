//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/*
  - lottery starts bu accepting ETH transactions. Anyone with an ETH waller can send a 
    fixed amount of 0.1 ETH to the contract address
  - the sender address is registered, contract allows multiple sends
  - if there are at lease three players, at a point in time, random winner is picked,
    and rewarded the entire lottery pool
  - contract is then reset and ready for the next round

  - deployed and tested on rinkeby here:
      https://rinkeby.etherscan.io/address/0x0276ad5996bacd8332cf7f80be8debfdb3b127ec
 */


contract Lottery {
  address payable[] public players;
  address public manager;

  constructor() {
    manager = msg.sender;
  }

  //only one receive address per contract, introduced in 0.6.0
  receive() external payable{
    require(msg.value == 0.1 ether, "amount sent was not 0.1ETH");
    players.push(payable(msg.sender)); // it is necessary to convert regular address to a payable one due to players being payable array
  }

  function getBalance() public view returns (uint) {
    require(msg.sender == manager, "manager only");
    return address(this).balance;
  }

  // don't use this in production mainnet apps, generating randomness in this way can lead to vulnerabilities!!
  // a recomended way of doing randomness is chainlink-vrf

  function random() public view returns (uint) {
    return uint (
      keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length))
    );
  }

  function pickWinner() public {
    require(msg.sender == manager, "manager only");
    require(players.length > 2);
  
    uint r = random();
    address payable winner;

    uint index = r % players.length;
    winner = players[index];
    winner.transfer(getBalance());

    //reset lottery
    players = new address payable[](0); // new empty dynamic array of type address
  }
}