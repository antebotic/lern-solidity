/*
  keccak256 computes the Keccak-256 hash of the input.

  Some use cases are:
    - Creating a deterministic unique ID from a input
    - Commit-Reveal scheme
    - Compact cryptographic signature (by signing the hash instead of a larger input)
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract HashFunction {
  function hash(string memory _text, uint _num, address _addr)
    public pure returns (bytes32)
  {
    return keccak256(abi.encodePacked(_text, _num, _addr)) ; 
  }

  // Example of hash collision, occuring here due to more than one dynamic type
  // being passed to abi.encodePacked. Use abi.encode instead
  function collission(string memory _text, string memory _anotherText) 
    public pure returns (bytes32) 
  {
    // encodePacked(AAA, BBB) -> AAABBB
    // encodePacked(AA, ABBB) -> AAABBB
    return keccak256(abi.encodePacked(_text, _anotherText));
  }
}

contract GuessTheMagicWord {
  bytes32 public answer = 
    0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;

  //Magic word is Solidity
  function guess(string memory _guess) public view returns (bool) {
    return keccak256(abi.encodePacked(_guess)) == answer;    
  }
}
