/*
  You can define your own type by creating a struct.

  They are useful for grouping togther related data.

  Structs can be declared outside of a contract and imported in another contract.
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Todos {
  struct Todo {
    string text;
    bool completed;
  }

  //an array of public todos
  Todo[] public todos;

  function create(string memory _text) public {
    // 3 ways to initialize a struct
    // - Calling it like a function
    todos.push(Todo(_text, false));

    // key value mapping
    todos.push(Todo({
      text: _text,
      completed: false
    }));

    //initialize an empty struct then update it
    Todo memory todo;
    todo.text = _text; //initialize default bool value for completed - false
    
    todos.push(todo);
  }

  //Solidity automatically creates a getter for 'todos', this is not necessary but for demonstration purposes:
  function get(uint _index) public view 
    returns (string memory text, bool completed)
  {
    Todo storage todo = todos[_index];
    return (todo.text, todo.completed);
  }

  function update(uint _index, string memory _text) public {
    Todo storage todo = todos[_index];
    todo.text = _text;
  }

  function updateCompleted(uint _index) public {
    Todo storage todo = todos[_index];
    todo.completed = !todo.completed;
  }
}
