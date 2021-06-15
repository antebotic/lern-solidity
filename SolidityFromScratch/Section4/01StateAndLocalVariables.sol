// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Property{
  int public price;

  /*
    State variables:
      - Declared at contract level
      - Permanently stored in contract storage
      - Can be set as constants
      - EXPENSIVE to use, cost gas - saving 256 bits costs 20k units of gas!
      - Initialized at declaration, using a constructor or after contract deployment 
          by calling setters. Cannot be dynamically added to the contract, adding extra state variables
          requires re-deploy
  */

  int public price;
  string constant public location = "London"; // cannot be changed due to constant keyword
  


  /*
      Local variables:
      - Declared inside functions
      - If using the memory keyword are arrays or struct, they are allocated at runtime.
      - Memory keyword cannot be used at contract level
  */


  function f1() public pure returns(int){
    //function is declared pure as it never reads or updates the blockchain

    int x = 5;
    x = x * 2;

    string memory s1 = "abc"; 

    return x;
  }
}

/*
  EVM saves data to:

  STORAGE
    - Holds state variables
    - Persistent and expensive(consts gas)
    - Analogue to a HDD drive
    - Saving 1 byte costs 5 units of gas

  STACK
    - Holds local variables inside function if they are not referenece types (ex: int)
    - Free to be used, it doesn't cost gas

  MEMORY
    - Holds local variables defined inside functions if they are reference types(string, array, struct and mapping),
      but declared with the memory keyword
    - Holds Function arguments;
    - Analogue to computer RAM
    - Free to be used, no gas cost
*/