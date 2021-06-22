// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/*
  Libraries:
    - a modular approach to building contracts helps reduce complexity and improve readability
    - helps identify bugs and vulnerabilities during development and code review
    - if behaviour is isolated, interactions that need to be considered are only those 
      between module spcifications and not every other moving part of the contract
 */

 library Balances {
  	function move(
  		mapping(address => uint) storage balances,
			address from,
			address to,
			uint amount
		)	internal 
		{
			require(balances[from] >= amount);
			require(balances[to] + amount >= balances[to]);
			balances[from] -= amount;
			balances[to] += amount;
		}
 }

 contract Token {
	 mapping(address => uint) balances;
	 using Balances for *;
	 mapping(address => mapping(address => uint)) allowed;

	 event Transfer(address from, address to, uint amount);
	 event Approval(address owner, address spender, uint amount);

	 function transfer(address to, uint amount) public returns (bool success) {
		 balances.move(msg.sender, to, amount);
		 emit Transfer(msg.sender, to, amount);
		 return true;
	 }

	 function transferFrom(address from, address to, uint amount) public returns (bool success){
		 require(allowed[from][msg.sender] >= amount);
		 allowed[from][msg.sender] -= amount;
		 balances.move(from, to, amount);
		 emit Transfer(from, to, amount);
		 return true;
	 }

	 function approve(address spender, uint tokens) public returns (bool success) {
		 require(allowed[msg.sender][spender] == 0);
		 allowed[msg.sender][spender] = tokens;
		 emit Approval(msg.sender, spender, tokens);
		 return true;
	 }

	 function balanceOf(address tokenOwner) public view returns (uint balance){
		 return balances[tokenOwner];
	 }
 }