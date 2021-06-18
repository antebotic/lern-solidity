//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/*
  - decentralized Auction following common auction rules
  - there is an owner, start and end date
  - the owner can cancel the action, also finalize it before the time is up
  - place bids by calling a function placeBids
  - the user can send an amount and define it maximum they are willing to pay,
      contract increments up to that amount over the highest bid
  - after the auction ends, the owner gets the highest bid, and everybot else
      withrdraws their own amount;
 */

 contract Auction {
   address payable public owner;
   uint public startBlock;
   uint public endBlock;
   string public ipfsHash;

   enum State{Running, Ended, Canceled}
   State public auctionState;

   uint public highestBindingBid;
   address payable public highestBidder;

   mapping(address => uint) public bids;
   uint bidIncrement;

   constructor(){
    owner = payable(msg.sender);
    auctionState = State.Running;
    startBlock = block.number;      // it's safer to use block height instead of timestamp, miners can influence timestamps
    endBlock = startBlock + 40320;  // end the auction one week from now
    ipfsHash = "";
    bidIncrement = 100;
   }

  modifier onlyOwner(){
    require(msg.sender == owner, "invalid user");
    _;
  }

  modifier notOwner(){
    require(msg.sender != owner, "invalid user");
    _;
  }

  modifier afterStart(){
    require(block.number >= startBlock, "auction not started");
    _;
  }

  modifier beforeEnd(){
    require(block.number < endBlock, "auction ended");
    _;
  }

  function min(uint a, uint b) pure internal returns (uint) {
    if (a <= b){
      return a;
    } else {
      return b;
    }
  }

  function placeBid() public payable notOwner afterStart beforeEnd {
    require(auctionState == State.Running, "auction inactive");
    require(msg.value >= 100, "below minimum bid");

    uint currentBid = bids[msg.sender] + msg.value;
    require(currentBid > highestBindingBid, "bid too low");

    if(currentBid <= bids[highestBidder]){
      highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
    } else {
      highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
      highestBidder = payable(msg.sender);
    }

  }
    // To be continued
   //EOF
 }



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
