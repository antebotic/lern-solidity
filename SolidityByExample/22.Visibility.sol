/*
  Functions and state variables have to declare whether they are accessible by other contracts.

  Fucntions can be declared as

    public - any contract and account can call
    private - only inside the contract that defines the function
    internal- only inside contract that inherits an internal function
    external - only other contracts and accounts can call
  
  State variables can be declared as public, private, or internal but not external.

*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Base {
  // Private functions can only be called inside the contract which delares them

  function privateFunc() private pure returns(string memory) {
    return "Private function called";
  }

  function testPrivateFunc() private pure returns (string memory) {
    return privateFunc();
  }

  // Internal functions can be called from within the contract that defines them and 
  // all contracts that inherit from that one

  function internalFunc() internal pure returns (string memory) {
    return "Internal function called";
  }

  function testInternalFunc() public pure virtual returns (string memory) {
    return internalFunc();
  }

  // Public functions can be called inside the contract that defines them, and all other contracts
  function publicFunc() public pure returns (string memory) {
    return "Public Function called";
  }

  // External functions can be accesed by all, except the contract that defined them
  function externalFunc() external pure returns (string memory) {
    return "External Function called";
  }

  //State variables
  string private privateVar = "private variable";
  string internal internalVar = "internal variable";
  string public publicVar = "public variable";

  //Variables can not be external!!
}

contract Child is Base {
  function testInternalFunc() public pure override returns (string memory) {
   return Base.internalFunc();
  }
}
