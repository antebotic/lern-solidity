//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

/*
  Struct:
    - a collection of key -> value pairs similar to mapping, but the values can have different types
    - a complex data type composed of elementary data types
    - used to represent singular things that have properties
    - can be used in mappings to represent collections of things with properties
    - saved in storage, and if declared inside a function, reference storage by default
    - can be declared outside of a contract which allows sharing accross multiple contracts
*/

struct Instructor {
  uint age;
  string name;
  address addr;
}

contract Academy {
  Instructor public academyInstructor;

  constructor(uint _age, string memory _name){
    academyInstructor.age = _age;
    academyInstructor.name = _name;
    academyInstructor.addr = msg.sender;
  }

  function changeInstructor(uint _age, string memory _name, address _addr) public {
    //create temporary memory struct, initialize using literal syntax
    Instructor memory myInstructor = Instructor({
      age: _age,
      name: _name,
      addr: _addr
    });

    academyInstructor = myInstructor;
  }
}


/*
  Enum:
    - used to create custom types with a finite set of constant values 
    - explicitly convertible to and from integer, implicit conversion not allowed
    - usefull for current state, or flow of the contract, like a switch
*/

contract School {
  Instructor public schoolInstructor;

  enum State {Open, Closed, Unknown} // semicolon not required
  State public schoolState = State.Open;

  constructor(uint _age, string memory _name){
    schoolInstructor.age = _age;
    schoolInstructor.name = _name;
    schoolInstructor.addr = msg.sender;
  }

  function changeInstructor(uint _age, string memory _name, address _addr) public {
    require(schoolState == State.Open, "School is not open");
    Instructor memory anotherInstructor = Instructor({
      age: _age,
      name: _name,
      addr: _addr
    });

    schoolInstructor = anotherInstructor;
  }
}