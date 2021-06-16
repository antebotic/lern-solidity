// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Property{
  int public price; // getter function is automaticly available for a public varaible
  string location = "Split";

  // naming convention in solidity is to use _variableName for function parameters
  // public functions can be called from within and outsideworld

  function setPrice(int _price) public {
    // changes storage variable, needs to be mined, costs gas
    price = _price;
  }

  //if the functions is read only, not altering the storage in any way, it should be declared view or pure
  function getPrice() public view returns (int){
    return price;
  }

  // memory keyword is required explicitly for all parameters of type: array, string, struct and mapping
  // this indicates that the variable should be saved in memory, not storage
  
  function setLocation(string memory _location) public {
    location = _location;
  }

  function getLocation() public view returns (string memory){
    return location;
  }
}