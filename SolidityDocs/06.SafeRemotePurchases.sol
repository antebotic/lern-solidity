//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/*
  In the following example, both parties have to put twice the value of the item into the contract as escrow. 
  As soon as this happened, the money will stay locked inside the contract until the buyer confirms that they 
  received the item. After that, the buyer is returned the value (half of their deposit) and the seller gets 
  three times the value (their deposit plus the value). The idea behind this is that both parties have an 
  incentive to resolve the situation or otherwise their money is locked forever.
 */

 contract Purchase {
  uint public value;
  address payable public seller;
  address payable public buyer;

  enum State { Created, Locked, Release, Inactive }
  //the state variable is by default set to the value of the first member
  State public state;

  modifier condition(bool _condition){
    require(_condition);
    _;
  }

  /// Only the buyer can call this function
  error OnlyBuyer();
  /// Only the seller can call this function
  error OnlySeller();
  /// The function cannot be called at the current state
  error InvalidState();
  /// The provided value has to be even
  error ValueNotEven();


  modifier onlyBuyer(){
    if(msg.sender != buyer)
      revert OnlyBuyer();
    _;
  }

  modifier onlySeller(){
    if(msg.sender != buyer)
      revert OnlySeller();
      
     _;
  }

  modifier inState(State _state){
    if(state != _state)
      revert InvalidState();
      
    _;
  }

  event Aborted();
  event PurchaseConfirmed();
  event ItemRecieved();
  event SellerRefunded();

  constructor() payable {
    seller = payable(msg.sender);
    value = msg.value / 2;
    if((2 * value) != msg.value)
      revert ValueNotEven();
  }

  /// Abort the purchase and reclaim ether.
  /// Can only be called by the seller before
  /// the contract is locked.
  function abort() public onlySeller inState(State.Created){
    emit Aborted();
    state = State.Inactive;
    // Transfer is used here directly as it is re-entrancy safe - it is the last call in this function and
    //  the state is changed allready
    seller.transfer(address(this).balance);
  }

  /// Confirm the purchase as the buyer.
  /// Transaction has to include `2 * value` ether.
  /// The ether will be locked until confirmRecieved
  /// is called
  function confirmPurchase() 
    public 
    inState(State.Created) 
    condition(msg.value == (2 * value))
    payable
  {
    emit PurchaseConfirmed();
    buyer = payable(msg.sender);
    state = State.Locked;
  }
  
  /// Confirm that the buyer recieves the item.
  /// This will release the locked ether.
  function confirmRecieved() public onlyBuyer inState(State.Locked){
    emit ItemRecieved();
    //It is important to change state first otherwise it would be vulnerable to re-entrancy
    state = State.Release;
    seller.transfer(value);
  }

  function refundSeller() public onlySeller inState(State.Release){
    emit SellerRefunded();
    // Same as above, to prevent re-entrancy change the state first
    state = State.Inactive;
    buyer.transfer(3 * value);
  }
 }
 