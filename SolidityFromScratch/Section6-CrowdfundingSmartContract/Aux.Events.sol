pragma solidity ^0.8.4;

/*
  - each Ethereum transaction has a receipt that contains zero or more log entries
  - these are called events in Solidity and Web3, and logs in EVM and Yellow Pages
  - events allow Javascript callback functions that listen to them to update the frontend of the smart contract
  - can only be accessed bu external actors such as JS, not possible within contracts
  - inherited by contracts from an interface or a base contract
  - events are declared using event keyword and by convention start with an uppercase letter
 */

 contract EmitEvent {
   event Transfer(address _to, uint _value);

   emit Transfer(_to, msg.value);
 }