// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Function {
  // Functions can return multiple values
  function returnMany() public pure returns(uint, bool, uint) {
    return (1, true, 2);
  }

  // Return values can be named
  function named() public pure returns(uint x, bool b, uint y) {
    return (1, true , 2);
  }

  //Return values can be assigned to their name, in this case the return statement can be ommited
  function assigned() public pure returns(uint x, bool b, uint y) {
    x = 1;
    b = true;
    y = 2;
  }

  // Use destructing assignment when calling another function that returns multiple values
  function destructingAssignments() public pure
    returns (uint, bool, uint, uint, uint) 
  {
    (uint i, bool b, uint j) = returnMany();

    //Values can be left out
    (uint x, , uint y) = assigned();

    return (i, b, j, x, y);
  }

  // Can use array for input
  function arrayInput(uint[] memory _arr) public {

  }

  // Can use array for output

  uint[] public arr;

  function arrayOutput() public view returns (uint[] memory) {
    return arr;
  }

  uint public x = 1;
  // view functions declare that no state will be changed
  function addToX(uint y) public view returns (uint) {
    return x + y;
  }

  //pure functions declare that no state will be read or changed
  function add(uint i, uint j) public pure returns (uint) {
    return i + j;
  }

}
