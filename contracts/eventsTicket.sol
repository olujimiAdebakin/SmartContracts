
// SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

// EVENT TICKET CONTRACT
// contract EventTicket{
    
//     // STATE VARIABLES

//     uint256  numberOfTickets;
//     uint256  ticketPrice;
//     uint256  totalNumberOfTicket;
//     uint256  StartAt;
//     uint256  EndAt;
//     uint256  timeRange;
//     uint256  ticketPricePerPerson;
//     string  message = "Buy Your First Event Ticket";

//     constructor(uint256 _ticketPrice){

//         // Global variables
//         ticketPrice = _ticketPrice;
//         StartAt = block.timestamp;
//         EndAt = block.timestamp + 6 days;
//         timeRange = (EndAt - StartAt) / 60 / 60 / 24;
//     }

//     function buyTicket(uint256 _value) public returns(uint256 ticketId){
//         numberOfTickets++;
//         totalNumberOfTicket += _value;
//         ticketId = numberOfTickets;
//     }

//     function getAmount() public view returns (uint256){
//         return totalNumberOfTicket;
//     }

//  }

// EVENT TICKET CONTRACT
contract EventTicket{
    
    // STATE VARIABLES: Global variables that store information about event tickets
    
    uint256  numberOfTickets;      // Unique ID for each ticket purchased by users
    uint256  ticketPrice;          // Price of a single ticket in wei (1 ether = 10^18 wei)
    uint256  totalAmountSold;   // Total number of tickets sold out or remaining
    uint256  StartAt;              // Timestamp when event starts
    uint256  EndAt;                 // Timestamp when event ends
    uint256  timeRange;             // Duration of the event in seconds (calculated from start and end timestamps)
    uint256  ticketPricePerPerson;  // Price per person for a single ticket (same as `ticketPrice`)
    string  message = "Buy Your First Event Ticket";      // Message displayed to users when buying tickets

    constructor(uint256 _ticketPrice){
        // Set global variables during contract deployment
        ticketPrice = _ticketPrice;
        
        // Calculate start and end timestamps for the event (6 days duration)
        StartAt = block.timestamp;  // Current timestamp as event starts at now
        EndAt = block.timestamp + 6 days;  
        timeRange = (EndAt - StartAt) / 60 / 60 / 24;
    }

    function buyTicket(uint256 _value) public returns(uint256 ticketId){
        // User buys tickets: increment unique ID, update total number of sold or remaining tickets
        numberOfTickets++;
        
        // Update the amount of money received from this transaction (in wei)
        totalAmountSold += _value;
        
        // Generate a new unique identifier for each purchased ticket
        ticketId = numberOfTickets;
    }

    function getAmount() public view returns (uint256){
        // Return the current number of tickets sold or remaining
        return totalAmountSold;
    }
}
