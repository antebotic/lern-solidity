//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
  In this section we will learn how to build an example implementation of a payment channel. 
  It uses cryptographic signatures to make repeated transfers of Ether between the same parties secure, 
  instantaneous, and without transaction fees. For the example, we need to understand how to sign 
  and verify signatures, and setup the payment channel.
 */

 contract SimplePaymentChannel {
   address payable public sender;
   address payable public recipient;
   uint public expiration;

   constructor(address payable _recipient, uint duration) payable {
     sender = payable(msg.sender);
     recipient = _recipient;
     expiration = block.timestamp + duration;
   }

   /// the recipient can close the channel at any time by presenting a 
   /// signed amount from the sender. the recipient will be sent that amount
   /// and the remainder will go back to the sender
   function close(uint amount, bytes memory signature) public {
     require(msg.sender == recipient);
     require(isValidSignature(amount, signature));

     recipient.transfer(amount);
     selfdestruct(sender);
   }

   /// the sender can extend the expiration at any time
   function extend(uint newExpiration) public {
     require(msg.sender == sender);
     require(newExpiration > expiration);

     expiration = newExpiration;
   }

   /// if the timeout is reached without the recipient closing the channel,
   /// then the Ether is released back to the sender
    function claimTimeout() public {
      require(block.timestamp >= expiration);
      selfdestruct(sender);
    }

    function isValidSignature(uint256 amount, bytes memory signature) internal view returns (bool) {
      bytes32 message = prefixed(keccak256(abi.encodePacked(this, amount)));

      return recoverSigner(message, signature) == sender;
    }

    //  The function splitSignature does not use all security checks. A real implementation should use 
    //  a more rigorously tested library, such as openzepplin’s version of this code.
    function splitSignature(bytes memory sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
      require(sig.length == 65);

      assembly {
        r := mload(add(sig, 32))
        s := mload(add(sig, 64))
        v := byte(0, mload(add(sig, 96)))
      }

      return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
      (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

      return ecrecover(message, v, r, s);
    }

    function prefixed(bytes32 hash) internal pure returns(bytes32) {
      return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
 }

 contract RecieverPays {
   address owner = msg.sender;

  /* 
    A replay attack is when a signed message is reused to claim authorization for a second action.
    To avoid replay attacks we use the same technique as in Ethereum transactions themselves, a so-called nonce,
    which is the number of transactions sent by an account. The smart contract checks if a nonce is used multiple times. 
  */
   mapping(uint256 => bool) usedNonces;
 
  constructor() payable {}

  function claimPayment(uint256 amount, uint256 nonce, bytes memory signature) public {
    require(!usedNonces[nonce]);
    usedNonces[nonce] = true;

    //this recreates the message that was signed on the client
    bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, this)));

    require(recoverSigner(message, signature) == owner);
    payable(msg.sender).transfer(amount);
  }

  /// destroy the contract and reclaim the leftover funds.
  function shutdown() public {
    require(msg.sender == owner);
    selfdestruct(payable(msg.sender));
  }

  /// signature methods
  function splitSignature(bytes memory sig) internal pure returns(uint8 v, bytes32 r, bytes32 s) {
    require(sig.length == 65);

    assembly {
      //first 32 bytes, after the length prefix
      r := mload(add(sig, 32))
      //second 32 bytes
      s := mload(add(sig, 64))
      //final byte (first byte of the next 32 bytes)
      v := byte(0, mload(add(sig, 96)))
    }

    return (v, r, s);
  }

  function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
    (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

    return ecrecover(message, v, r, s);
  }

  function prefixed(bytes32 hash) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
  }
 }