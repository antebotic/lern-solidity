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

contract AuctionCreator {
  Auction[] public allAuctions;

  function createAuction() public { 
    Auction newAuction = new Auction(msg.sender);
    allAuctions.push(newAuction);
  }

}

contract Auction {
  address payable public owner;
  uint public startBlock;
  uint public endBlock;
  string public ipfsHash;

  enum State{Started, Running, Ended, Canceled}
  State public auctionState;

  uint public highestBindingBid;
  address payable public highestBidder;

  mapping(address => uint) public bids;
  uint bidIncrement;

  constructor(address auctionOwner){
    owner = payable(auctionOwner);
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

  function cancelAuction() public onlyOwner {
    auctionState = State.Canceled;
  }

  function placeBid() public payable notOwner afterStart beforeEnd {
    require(auctionState == State.Running, "auction inactive");
    require(msg.value >= 100, "below minimum bid");

    uint currentBid = bids[msg.sender] + msg.value;
    require(currentBid > highestBindingBid, "bid too low");
    
    bids[msg.sender] = currentBid;

    if(currentBid <= bids[highestBidder]){
      highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
    } else {
      highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
      highestBidder = payable(msg.sender);
    }
  }
  // Withdrawal pattern, only send ETH to a user when he explicitly requests it
  // Helps avoiding re-entrance attacks

  function finalizeAuction() public {
    require(auctionState == State.Canceled || block.number > endBlock, "can't be finalized yet");
    require(msg.sender == owner || bids[msg.sender] > 0); // only the owner, or a bidder can finalize the auction

    address payable recipient;
    uint value;

    if(auctionState == State.Canceled) {
      recipient = payable(msg.sender);
      value = bids[msg.sender];
    } else {
      if(msg.sender == owner){
        recipient = owner;
        value = highestBindingBid;
      } else { //auction winner
        if(msg.sender == highestBidder){
          recipient = highestBidder;
          value = bids[highestBidder] - highestBindingBid;
        } else { //auction participant, non winner
          recipient = payable(msg.sender);
          value = bids[msg.sender];
        }
      }
    }

    recipient.transfer(value);
  }
}
