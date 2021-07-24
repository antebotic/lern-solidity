//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract IfElse{
  function foo(uint _x) public pure returns (uint) {
    if( _x < 10){
      return 0;
    } else if ( _x < 20) {
      return 10;
    } else {
      return 42;
    }
  }
}