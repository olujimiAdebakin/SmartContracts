
// SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

// EVENT TICKET CONTRACT
contract EventTicket{
    
    // STATE VARIABLES

    uint256 public numberOfTickets;
    uint256 public ticketPrice;
    uint256 public totalNumberOfTicket;
    uint256 public StartAt;
    uint256 public EndAt;
    uint256 public timeRange;
    uint256 public ticketPricePerPerson;
    string public message = "Buy Your First Event Ticket";

    constructor(uint256 _ticketPrice){

        // Global variables
        ticketPrice = _ticketPrice;
        StartAt = block.timestamp;
        EndAt = block.timestamp + 6 days;
        timeRange = (EndAt - StartAt) / 60 / 60 / 24;
    }

    function buyTicket(uint256 _value) public returns(uint256 ticketId){
        numberOfTickets++;
        totalNumberOfTicket += _value;
        ticketId = numberOfTickets;
    }

}