// A constructor is an optional function that is executed upon contract creation.

// Here are examples of how to pass arguments to constructors.

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract X {
  string public name;

  constructor(string memory _name) {
    name = _name;
  }
}

contract Y {
  string public text;

  constructor(string memory _text){
    text = _text;
  }
}

//There are two ways to initialize parent contract with parameters.
// 1.Pass the parameters here in the inheritance list
contract B is X("input to X"), Y("input to Y") {

}


contract C is X, Y {
  string public nameText;
  //2. Pass the parameters required by super X and Y
  constructor(string memory _name, string memory _text) X(_name) Y(_text){
    nameText = string(abi.encodePacked(_name, _text));
  }
}

// Parent constructors are always called in the order of inheritance regardles of the order
// they are listing in the constructor of the child contract

contract D is X, Y {
  constructor() X("X was called") Y("Y was called"){
    // Order of constructors called:
    // 1. Y
    // 2. X
    // 3. D
  }
}

contract E is X, Y {
  constructor() Y("Y was called") X("X was called"){
    // Order of constructors called:
    // 1. Y
    // 2. X
    // 3. E
  }
}

