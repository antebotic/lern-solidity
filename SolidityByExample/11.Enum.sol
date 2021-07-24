// Solidity supports enumerables and they are useful to model choice and keep track of state.

// Enums can be declared ouside of a contract.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Enum {

  enum Status {
      Pending,
      Shipped,
      Accepted,
      Rejected,
      Canceled
  }

  //Default value is the first element listed in the definition, in this case: Pending

  Status public status; 
    // Returns uint
    // Pending  - 0
    // Shipped  - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4

  function get() public view returns (Status) {
    return status;
  }

  //Updates status by passing uint into _status
  function set(Status _status) public {
    status = _status;
  }

  //Enums can be updated programaticaly using:
  function cancel() public {
    status = Status.Canceled;
  }

  // delete resets the enum to its first value, 0 (Pending)
  function reset() public {
    delete status;
  }
}