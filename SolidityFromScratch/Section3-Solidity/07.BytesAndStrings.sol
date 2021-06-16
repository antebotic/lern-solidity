//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

/*
  - Variables of tye byte and string are special dynamic arrays
  - String is equal to bytes but does not allow length or index acces, utf8 encoded
  - Both are reference types, not value types
  - Fixed sized arrays use less gas than dynamic arrays, better suited when the length of array is known in advance
*/

contract BytesAndStrings {
  bytes public b1 = "abc";    // 0x616263
  string public s1 = "abc";   // abc

  function addElement() public {
    b1.push("x");   // 0x61626378
    // s1.push("x"); member push not found or visible, can't push to string
  }

  function getElement(uint _i) public view returns (bytes1) {
    return b1[_i];
    // retrun s1[_i]; index access for string is not possible
  }

  function getLength() public view returns (uint){
    return b1.length;
    // return s1.length; member length not found or visible
  }
}