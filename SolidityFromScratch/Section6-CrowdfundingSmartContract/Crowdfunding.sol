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
  mapping(address => uint) public contributors;
  address public admin;
  uint public noOfContributors;
  uint public minimumContribution;
  uint public deadline; 
  uint public goal;
  uint public raisedAmount;

  struct Request {
    string description;
    address payable recipient;
    uint value;
    bool completed;
    uint numberOfVoters;
    mapping(address => bool) voters;
  }

  mapping(uint => Request) public requests; // in the latest versions of solidity dynamic arrays cannot contain mappings 
  uint public numRequests;

  constructor(uint _goal, uint _deadline) public {
    admin = msg.sender;
    goal = _goal;
    deadline = block.timestamp + _deadline;
    minimumContribution = 100 wei;
  }

  event ContributionEvent(address _sender, uint _value);
  event CreateRequestEvent(string _description, address _recipient, uint _value);
  event MakePaymentEvent(address _recipient, uint _value);

  function contribute() public payable {
    require(block.timestamp < deadline, "deadline reached");
    require(msg.value >= minimumContribution, "minimum contribution not met");
    
    if(contributors[msg.sender] == 0) { noOfContributors++; }
    contributors[msg.sender] += msg.value; 

    raisedAmount += msg.value;
    emit ContributionEvent(msg.sender, msg.value);
  }

  //to accept ether the recieve function must be defined
  receive() payable external{
    contribute();
  }

  function getBalance() public view returns (uint){
    return address(this).balance;
  }

  function getRefund() public {
    require(block.timestamp > deadline && raisedAmount < goal, "campaign not finished yet");
    require(contributors[msg.sender] > 0, "no funds associated with this address");

    address payable recipient = payable(msg.sender);
    uint value = contributors[msg.sender];

    contributors[msg.sender] -= value;
    recipient.transfer(value);
    // also possible payable(msg.sender).trander(contributors[msg.sender])
  }

  modifier onlyAdmin(){
    require(msg.sender == admin, "unauthorized");
    _;
  }

  function createRequest(
    string memory _description, 
    address payable _recipient, 
    uint _value
  ) public onlyAdmin {
    Request storage newRequest = requests[numRequests];
    numRequests++;

    newRequest.description = _description;
    newRequest.recipient = _recipient;
    newRequest.value = _value;
    newRequest.completed = false;
    newRequest.numberOfVoters = 0;

    emit CreateRequestEvent(newRequest.description, newRequest.recipient, newRequest.value);
  }

  function voteRequest(uint _requestNo) public {
    require(contributors[msg.sender] > 0, "You must be a contributor to vote");
    Request storage thisRequest = requests[_requestNo]; //working on data in storage because of storage keyword

    require(thisRequest.voters[msg.sender] == false, "You have allready voted!");
    thisRequest.voters[msg.sender] = true;
    thisRequest.numberOfVoters++;
  }

  function makePayment(uint _requestNo) public onlyAdmin {
    require(raisedAmount > goal);
    Request storage thisRequest = requests[_requestNo];
    require(thisRequest.completed = false, "The request has been completed");
    require(thisRequest.numberOfVoters > noOfContributors / 2, "Not enough votes");
    
    thisRequest.completed = true;
    thisRequest.recipient.transfer(thisRequest.value);
    
    emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
  }
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
