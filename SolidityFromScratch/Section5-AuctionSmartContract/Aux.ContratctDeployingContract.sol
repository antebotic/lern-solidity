//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/*
  - different users can create an instance of the contract without having access to the contract bytecode
    which would be a security issues, as the code could be altered before deploying
 */

contract A{
  address public ownerA;

  constructor(address eoa){
    ownerA = eoa;
  }
}

contract Creator{
  address public ownerCreator;
  A[] public deployedA;

  constructor(){
    ownerCreator = msg.sender;
  }

  function deployA() public {
    A new_A_address = new A(msg.sender);
    deployedA.push(new_A_address);
  }
}
