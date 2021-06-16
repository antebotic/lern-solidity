//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

/*
  Mappings:
    - data structures that hold key-value pairs similar to JS objects
    - All keys must have the same type, and all values must have the same type;
    - the keys cannot be of type mapping, dynamic array, enum or struct
    - the values can be of any type, including mapping
    - allways saved in storage, it's a state variable. Mappings declared inside functions are also saved in storage
    - lookup time is constant no matter the size of the mapping, while arrays have linear search time
    - they are not iterable, cant be looped over
    - keys are not saved into the mapping (underlying hash table data structure). To get a value from the mapping
      provide a key, which gets passed through a hashing function, that outputs a predetermined index
      that returns the corresponding value from the mapping
    - if unexisting key is provided, default value is returned
*/

contract Mappings {
  mapping(address => uint) public bids;

  // payable function modifier provides a mechanism for the contract to recieve ether
  function bid() payable public {
    bids[msg.sender] = msg.value; //msg.value stores amount of ether sent from msg.sender 
  }
}