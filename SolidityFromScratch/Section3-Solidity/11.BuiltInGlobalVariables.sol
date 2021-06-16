//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

/*
  msg
    .sender - account address that generated the transaction
    .value  - eth value in wei sent to this contract
    .gas    - remaining gas, will be replaced by gasleft()
    .data   - data field from the transaction or call that executed this function

  this - the current contract, explicitly convertible to Address
  
  block
    .timestamp    - alias for now, returns seconds from the Unix epoch
    .number       - blockheight of the blockchain
    .difficulty   - difficulty of the PoW 
    .gaslimit     - current gas limit for the bloc, ethereum has max gas limit, as bitcoin does with max block size(1MB)

  tx.gasprice - gas price of the transaction
*/


contract GlobalVariables{
  address public owner;
  uint public funds;

  constructor(){
    owner = msg.sender;
  }

  function changeOwner() public {
    owner = msg.sender; // updates owner to the caller of the function
  }
  
  function sendFunds() payable public {
    funds += msg.value;
  }

  function getBalance() public view returns(uint){
    return address(this).balance; // address(this) converts to the address of the contract
  }

  function gasCost() public view returns (uint){
    uint start = gasleft();
    uint j = 1;

    for(uint i=1; i <20; i++){
      j *= i;
    }

    uint end = gasleft();

    return start - end; // + the usual cost of the transaction, usualy around 21k wei
  }
}