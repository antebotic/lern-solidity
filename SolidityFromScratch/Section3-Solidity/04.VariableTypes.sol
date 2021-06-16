//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract VariableTypes {
  // Boolean type, defaults to false if not initialized
  bool public mainnet; //false

  //Signed and Unsigned Integers
  // int8 to int256, uint8 to uint256; in steps of 8
  // int is alias for int256 and uint for uint256
  // default value is 0
  // no full support for float/double precison numbers

  uint8 public unsigned; // 0
  int8 public signed; // 0
}
