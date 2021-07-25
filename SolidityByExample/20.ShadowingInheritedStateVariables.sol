// Unlike functions, state variables cannot be overridden by re-declaring it in the child contract.

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract A {
  string public name = "Contract A";

  function getName() public view returns (string memory) {
    return name
  }
}

// Shadowing is disallowed in Solidity 0.6
// This code will not compile
/*
  contract B is A {
    string public name = "Contract B"
  }
*/

//Instead update variable in the cunstructor
contract C is A {
  constructor(){
    name = "Contract C";
  }
  
  // C.getName -> returns Contract C
}