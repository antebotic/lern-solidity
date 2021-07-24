pragma solidity ^0.8.4;


contract Practice {
 // Error: invalid BigNumber string (argument="value", value="", code=INVALID_ARGUMENT, version=bignumber/5.1.1)
  uint[] numbers; 

  function arrayDelete() public returns (uint[]) {
    numbers.push(100);
    numbers.push(22);
    numbers.push(123);

    delete numbers[2];
    return numbers;
  };
  
 // Error: invalid BigNumber string (argument="value", value="", code=INVALID_ARGUMENT, version=bignumber/5.1.1)
  string[] strings;

  function populateString() internal {
    strings.push("Hello");
    strings.push("there");
    strings.push("fren");
  }

  function getString() public retuns (string){
    populateString();

    return strings[2];
  }
}