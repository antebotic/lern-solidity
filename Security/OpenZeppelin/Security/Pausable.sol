// SPDX-License-Identifier: MIT
// Typing this for learning purposes as seen on :
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol

pragma solidity ^0.8.0;

//context is imported in the OZ library

abstract contract Context {
  function _msgSender() internal view virtual returns (address){
    return msg.sender;
  }

  function _msgData() internal view virtual returns (bytes calldata){
    return msg.data;
  }
}

/**
  Pausable:
    - allows children to implement an emergency stop mechanism that can be triggered
      by an authorised account.
    - to use, inherit from this module, and apply whenNotPaused and whenPaused modifiers
 */

abstract contract Pausable is Context {
  event Paused(address account);
  event Unpaused(address account);

  bool private _paused;
  constructor(){
    _paused = false;
  }

  function paused() public view virtual returns (bool) {
    return _paused;
  }

  modifier whenNotPaused() {
    require(!paused(), "Pausable: paused");
    _;
  }

  modifier whenPaused(){
    require(paused(), "Pausable: not paused");
    _;
  }

  function _pause() internal virtual whenNotPaused {
    _paused = true;
    emit Paused(_msgSender());
  }

  function _unpause() internal virtual whenPaused {
    _paused = false;
    emit Unpaused(_msgSender());
  }
}

contract VHSPlayer is Pausable {
  enum VHSState{ MoviePlaying, MoviePaused }
  VHSState private playerState;
  
  function playMovie() public whenPaused {
      playerState = VHSState.MoviePlaying;
      _unpause();
  }
  
  function pauseMovie() public whenNotPaused {
      playerState = VHSState.MoviePaused;
      _pause();
  }
    
  function moviePlaying() public view returns (VHSState){
      return playerState;
  } 
}
