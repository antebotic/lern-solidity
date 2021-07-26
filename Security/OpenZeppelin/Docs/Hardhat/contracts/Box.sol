// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;


import '@openzeppelin/contracts/access/Ownable.sol';

contract Box is Ownable {
  uint private _value;

  event ValueChanged(uint value);

  function store(uint value) public {
    _value = value;
    emit ValueChanged(_value);
  }

  function retrieve() public view returns (uint) {
    return _value;
  }
}





import './access-control/Auth.sol';


contract OlderBox {
  uint private _value;
  Auth private _auth;

  constructor(Auth auth) {
    _auth = auth;
  }

  event ValueChanged(uint value);

  function store(uint value) public {
    require(_auth.isAdministrator(msg.sender), "Unauthorized");

    _value = value;
    emit ValueChanged(_value);
  }

  function retrieve() public view returns (uint) {
    return _value;
  }
}
