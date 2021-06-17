//SPDX-Public-License: GPL-3.0

pragma solidity ^0.8.4;

/*
    Public:
      - function is part of the contract interface and can be called both internally and externally
      - default setting for functions
      - getter is automatically created for publuc varuables.
    
    Private:
      - functions and variables are available only in the contract they are defined in.
      - subset of internal 
      - can be accessed in the crurrent contract only by a getter function

    Internal:
      - functions are accessible only from the contract they are defined in and from derived contracts
      - default setting for state variables.
      - can be accessed in the current and derived contracts
    
    External:
      - The function is part of the contract interface, can be accessed from other contracts or EOA accounts
      - automatically public
      - not available for state variables
 */

 contract Visibility {
   int public x = 10;
   int y = 20;

   function get_y() public view returns(int) {
     return y;
   }

    // can only be called from within the contract
   function f1() private view returns (int) {
     return x;
   }

   function f2() public view returns (int) {
     int a;
     a = f1();
     return a;
   }
    //internal functions can be shared using inheritance
   function f3() internal view returns (int){
     return x;
   }

    // can only be called from the outside of the contract
   function f4() external view returns (int){
      return x;
   }

   
 }
  //inherit from contract A
 contract B is Visibility {
   int public xx = f3();
   // int public yy = f1(); inherited function is private and cannot be called from derived contrat
 }

 contract C {
   Visibility public contract_a = new Visibility(); // contract C deploys contract Visibility
   int public xx = contract_a.f4(); //this call to f4 is valid as it's made from an external contract
  // int public y = contract_a.f1() //this is a private function, fails
  // int public yy = contract)a.f1() // this is an internal function, fails
 }