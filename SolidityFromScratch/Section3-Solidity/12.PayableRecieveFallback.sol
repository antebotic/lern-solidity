//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

/*
  - contracts have unique adress that is generated at deployment
  - contract address is generated based on the creator's address and the number of transactions of that account(nonce)
  - address can be plain or payable
  - it is a variable and has the following members:
    address
      .balance
      .transfer()         - should be used in most cases, safest way to send ETH (available only on payable address)
      .send()             - a low level transfer(). If execution fails, the contract will not stop, and send() will return false (available only on payable address)
      .call()             -
      .callcode()         -
      .delegatecall()     -
  
  - smart contract can recieve ETH and can have an ETH balance only if the is a payable function defined
  - a contract recieves ETH in multiple ways:
    - sending ETH to the contract address by an EOA account. In this case, at minimum there should be a function called recieve(), or a fallback()
    - by calling a payable function and sending ETH with that transaction
  
  - the ETH balance of the contract is in possesion of anyone who can call the transfer() function of the address 
*/

contract PayRecieveFallback {
  // recieve was introducted in solidity 0.6, only one function allowed per contract, no arguments, returns nothing
  // on a contract which does not define either of these two functions, sending ETH will result in failure
  receive() external payable {}

  fallback() external payable{}

  function getBalance() public view returns (uint){
    return address(this).balance;
  }

  function sendEther() public payable {}

  // Testing this code on the rinkeby testnet
  // https://rinkeby.etherscan.io/tx/0x1610610515a50d146bc2cf331f7c666ae6982c1ba7a8642678835a7c83eb9c75
  // note: if the InputData on the block explorer is 0x, transaction was sent from a wallet, otherwise a function was called in a smart contract
}