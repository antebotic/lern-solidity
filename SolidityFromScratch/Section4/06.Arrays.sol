//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

/*
  Fixed sized array
    - has a compile time fixed size
    - bytes1, bytes2, ... , bytes32
    - can hold any type
    - member: length


  Dynamicaly sized array
    - bytes
    - string(UTF-8 encoded) is a dynamic array similar to bytes
    - can hold any type
    - members: length, push

*/

contract fixedSizeArrays{
  uint[3] public numbers; // [0, 0, 0]
  uint[5] public moreNumbers = [1, 2, 3, 4, 5];

  function setElement(uint _index, uint _value) public {
    moreNumbers[_index] = _value;
  }

  function getLength() public view returns (uint){
    return moreNumbers.length;
  }

  bytes1 public b1; // 0x00
  bytes2 public b2; // 0x0000
  bytes3 public b3; // 0x000000
  //... up to bytes 32

  function setBytesArray() public {
    b1 = "a";   // 0x61
    b2 = "ab";  // 0x6162
    b3 = "abc"; // 0x616263
    // b3[0] = "c" throws error, after version 8.0.0 it is no longer possible to modify fixed array bytes
  }
  }

contract DynamicalyArrays {
  uint[] public numbers;

  function getLength() public view returns (uint) {
    return numbers.length;
  }

  function addTo(uint _index, uint _number) public {
    numbers[_index] = _number;
  }
  
  //addition is constatnt in price
  function pushTo(uint _number) public {
    numbers.push(_number);
  }

  // cost associated with the size of the element being removed
  function removefrom() public {
    numbers.pop;
  }
  
  // to avoidout of bounds error check if the index exists on the accessed array
  function getElement(uint _i) public view returns (uint){
    if(_i < numbers.length){
      return numbers[_i];
    }

    return 0;
  }

  //keyword new creates a dynamic memory array
  function f() public {
    uint[] memory y = new uint[](3);
    y[0] = 10;
    y[1] = 20;
    y[2] = 30;
    numbers = y;
  }
 }
