pragma solidity >=0.5.0 <0.9.0

contract Overflow {
  uint8 public withinBounds = 255;
  uint8 public zero;
  
  // compiler should catch overflows from version 8 and evm revert if it happens on-chain
  function causeOverflow() public {
    withinBounds += 1;
  }

  function causeUnderflow() public {
    zero -= 1;
  }

  // use unchecked to bypass the built in safe math.
  // this code results in withinBounds = 0 due to overflow
  function causeOverflowUncheck() public {
    unchecked { withinBounds += 1; }
  }

  function causeUnderflowUncheck() public {
    unchecked { zero -= 1;}
  }
}