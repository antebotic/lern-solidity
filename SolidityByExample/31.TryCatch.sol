// try / catch can only catch errors from external function calls and contract creation.

pragma solidity ^0.7.6;

contract Foo {
  address public owner;

  constructor(address _owner) {
    require(_owner != address(0), "Invalid address");
    assert(owner != 0x0000000000000000000000000000000000000001);
    owner = _owner;
  }

  function myFunc(uint x) public pure returns (string memory) {
    require(x != 0, "Require failed");
    return ("MyFunc was called");
  }
}

contract Bar {
  event Log(string message);
  event LogBytes(bytes data);

  Foo public foo;

  constructor() {
    foo = new Foo(msg.sender);
  }

  function tryCatchExternalCall(uint _i) public {
    try foo.myFunc(_i) returns (string memory result) {
      emit Log(result);  
    } catch {
      emit Log("external call failed");
    }
  }

  function tryCatchNewContract(address _owner) public {
    try new Foo(_owner) returns (Foo foo) {
      emit Log("New Foo created");
    } catch Error(string memory reason){
      emit Log(reason);
    } catch (bytes memory reason) {
      emit LogBytes(reason);
    }
  }
}
