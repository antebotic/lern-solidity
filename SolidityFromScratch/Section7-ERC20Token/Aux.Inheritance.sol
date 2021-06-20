//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/*
  Inheritance in Solidity:
    - contract acts as a class, it can inherit from another contract, called base contract
    - multiple inheritance, inculding polymorphism is included.
    - when a contract inheriting from other base contracts gets deployed, the code from the base
      contracts is copied into the contract being deployed
    - all function calls are virtual, which means that the most derived function is called, except
      when the contract name is explicitly given
    - when deploying a derived contract the base contract's constructor is automatically called
    - inheritance is achieved using the "is" keyword
    
  Abstract contracts and virtual functions:
    - abstract contract cannot be deployed to the blockchain, but it can be inherited from
    - functions without implementation must be declared abstract, and are allowed only in abstract contracts
    - contract that inherits from a base contract which has a virtual function, must also implement that 
      function using the "override" keyword 

  Interfaces:
    - similar to abstract contracts. but they cannot have any functions implemented
    - can be inherited
    - cannot inherit from other contracts, but can inherit from other interfaces
    - all declared functions must be external
    - must not declare a constructor
    - must not declare state variables
    - created using "interface" keyword instead of contract
 */

abstract contract BaseContract{
  int public x;
  address public owner;

  constructor(){
    x = 5;
    owner = msg.sender;
  }

  function setX(int _x) public virtual;
}

contract A is BaseContract{
  // when A is deployed constructor of BaseContract is called

  function setX(int _x) public override {
    x = _x;
  }
}

//inheritance from Interface
interface BaseInterface {
  function setX(int _x) external;
}

contract B is BaseInterface {
  int public x;
  int public y = 3;

  function setX(int _x) public override {
    x = _x;
  }
}
