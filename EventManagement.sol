//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract EventManagement{

    event EventDetails(address owner, string NameOfEvent, uint Date_of_event, uint Price_of_event, uint Number_of_tickets);

    struct TheEvent{
        address owner;
        string nameOfEvent;
        uint dateOfEvent;
        uint _priceOfTicket;
        uint numberOfTickets;
        uint ticketsremaining;   
    }
    
    uint nextId = 1;
    mapping(uint => TheEvent) public AllEvents;
    mapping(address => mapping(uint => uint)) public numberoftickets; 

    function createEvent(string memory _nameOfEvent, uint _dateOfEvent, uint _priceOfTicket, uint _numberOfTickets) external {
        require(_dateOfEvent > block.timestamp,"Event must be in the future");
        AllEvents[nextId] = TheEvent(msg.sender, _nameOfEvent, _dateOfEvent, _priceOfTicket, _numberOfTickets, _numberOfTickets);
        emit EventDetails(msg.sender,  _nameOfEvent, _dateOfEvent, _priceOfTicket, _numberOfTickets);
        nextId++;
    }

    function buyTickets(uint EventId, uint _amountOfTickets) external payable {
        TheEvent storage _event = AllEvents[EventId];
        require(block.timestamp < _event.dateOfEvent, "Event has already passed");
        require(msg.value == _event._priceOfTicket, "Please pay the required amount");
        require(_amountOfTickets < _event.ticketsremaining, "The number of tickets required is less than the number of tickets available");
        _event.ticketsremaining -= _amountOfTickets;
        numberoftickets[msg.sender][EventId] += _amountOfTickets;
    }

    function transfer(uint EventId, uint _amountOfTickets, address _addr) external {
        require(numberoftickets[msg.sender][EventId] >= _amountOfTickets,"Not enough tickets");
        numberoftickets[msg.sender][EventId] -= _amountOfTickets;
        numberoftickets[_addr][EventId] += _amountOfTickets;
    } 
}