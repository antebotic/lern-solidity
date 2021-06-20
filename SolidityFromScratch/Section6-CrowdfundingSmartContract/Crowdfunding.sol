//SPDX-License-Identifier: GPL-3.0

/*
   - the admin will start a campaign for crowdfunding with a specific monetary goal and deadline
   - contributors will contribute to that project by sending ETH
   - the admin has to crate a Spending Request and the contributors can vote on it
   - if more than 50% of the total contributors voted for that request then the admin would
      have the permission to spend the amount specified in the spending request
   - the power is moved from the campaign's admin to those that donated money
   - the contributors can request a refund if the monetary goal was not reached within the deadline
 */


contract CrowdFunding{
  
}



//Trying to implement this contract on my own based only on video titles, got stuck at voting for request
 contract CrowdFundingSoloTry {
   mapping(address => uint) contributors;
   uint public deadline;
   uint public fundingGoal;


    constructor(uint _goal, uint _deadline) public {
      deadline = block.timestamp + _deadline; //expire in aprox 5 mins
      fundingGoal = _goal;
    }
    
    bool internal locked;
    modifier noReentrance() {
      require(!locked, "no reentrancy");
      locked = true;
      _;
      locked = false;
    }
    
    modifier beforeDeadline(){
        require(block.timestamp < deadline);
        _;
    }
  
   // Contribute to the cf campaign
    function contribute() public payable beforeDeadline {
      contributors[msg.sender] += msg.value;
    }

   //Getting a refund
    function getRefund() public payable noReentrance {
      require(block.timestamp >= deadline, "still ongoing");
      require(contributors[msg.sender] > 0, "no funds accociated with this address");

      address payable recipient = payable(msg.sender);
      recipient.transfer(contributors[msg.sender]);
      contributors[msg.sender]=0;
    }
    
    function getCurrentBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function getCurrentBlock() public view returns (uint) {
        return block.timestamp;
    }
    
  
   //Creating a spend request
    
   //Voting for a request

   //Making a payment
 }