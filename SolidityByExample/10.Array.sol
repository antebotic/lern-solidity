// Array can have a compile-time fixed size or a dynamic size.

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Array {
  uint[] public arr;
  uint[] public arr2 = [1, 2, 3];
  // Fixed size array, all elements initailize to uint default, 0
  uint[10] public myFixedSizeArr;

  function get(uint i) public view returns (uint) {
    return arr[i];
  }

  //Solidity can return the entire array.
  // This should be avoided to arrays that can grow indefinitely in length
  function getArr() public view returns (uint[] memory) {
    return arr;
  }

  function push(uint i) public {
    //Appends to array
    arr.push(i);
  }

  function pop() public {
    // Removes last element from array
    arr.pop();
  }

  function remove(uint index) public {
    //Does NOT reduce length of the array, rests value at index to default value, for uint 0
    delete arr[index];
  }

  function getLength() public view returns (uint){
    return arr.length;
  }
}

contract CompactArray {
  uint[] public arr;
  
  function add(uint i) public {
      arr.push(i);
  }

  // Deleting an element creates a gap in the array.
  // One trick to keep the array compact is to
  // move the last element into the place to delete.
  function remove(uint index) public {
    arr[index] = arr[arr.length - 1];
    arr.pop();
  }

  function test() public {
    arr.push(1);
    arr.push(2);
    arr.push(3);
    arr.push(4);

    remove(1);
    remove(3);
  }
}