//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/*
  - lottery starts by accepting ETH transactions. Anyone with an ETH wallet can send a 
    fixed amount of 0.1 ETH to the contract address
  - the sender address is registered, contract allows multiple sends
  - if there are at lease three players, at a point in time, random winner is picked,
    and rewarded the entire lottery pool
  - contract is then reset and ready for the next round

  - deployed and tested on rinkeby here:
      https://rinkeby.etherscan.io/address/0x0276ad5996bacd8332cf7f80be8debfdb3b127ec

  Challenge #1
    - Change the contract so that the manager of the lottery can not participate in the lottery.
  Challenge #2
    - Change the contract so that the manager is automatically added to the lottery, without sending any ether.
  Challenge #3
    Change the contract so that anyone can pick the winner and finish the lottery, if there are at least 10 players.
  Challenge #4
    Change the contract so that the manager receives a fee of 10% of the lottery funds.
 */


contract Lottery {
  address payable[] public players;
  address payable public  manager;

  constructor() {
    manager = payable(msg.sender);
  }
  
  //only one receive address per contract, introduced in 0.6.0
  receive() external payable{
    require(msg.sender != manager, "manager can't participate"); // Challenge #1
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

  function pickWinnerChallenge3And4() public {
    require(players.length >= 10, "not enough players to end lottery");
    
    uint r = random();
    address payable winner;

    uint index = r % players.length;
    uint inShare = getBalance() / 10;
    
    winner = players[index];
    players.push(manager);

    winner.transfer(inShare * 9);
    manager.transfer(inShare);

    players = new address payable[](0);
  }
}
