//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;


contract A{
  string[] public cities = ['Kastela', 'Split']; //storage

  function f_memory() public {
    //string or struct array must specify memory or storage explicitly
    string[] memory s1 = cities; // dynamic array local to the function working with the copy of the state 
    s1[0] = 'Trogir';
  }

  function f_storage() public {
    string[] storage s1 = cities; // actually changes the state of the cities variable, as s1 references it
    s1[0] = 'Trogir';
  }
}