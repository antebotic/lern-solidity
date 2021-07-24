//SPDx-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Primitives {
  bool public boo; // defaults to true
  bool public fal = false; //false is set explicitly

  /*
    uint stands for unsigned integer, meaning non negative integers
    different sizes are available
      uint8   ranges from 0 to 2 ** 8 - 1
      uint16  ranges from 0 to 2 ** 16 - 1
      ...
      uint256 ranges from 0 to 2 ** 256 - 1
  */

  uint8 public u8 = 1;
  uint256 public u256 = 456; 
  uint public u = 123; //uint is alias for uint256

  /*
    Negative numbers are allowed for int types.
    Like uint, different ranges are available from uint8 to uint256
  */

  int8 public i8 = -1;
  int256 public i256 = 435;
  int public i = -123;


  address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

  //Default values are applied to uninitialized primitive types

  bool public defaultBool; //0
  uint public defaultUint; //0
  int public defaultInt; //0
  address public defaultAddre; //0
}