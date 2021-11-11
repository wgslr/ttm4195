// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TicketBookingSystem{
    
    struct  Seat {
        uint16 rowNumber;
        uint16 seatNumber;
        uint64 timestamp;
        string seatViewURL;
        uint price;
    }
    
    //Public attributes
    string public show_title;
    Seat[] public seats;
    
    //Private attributes
    address private creator;
    Ticket tickets = new Ticket();
    Poster posters = new Poster();
    
    //modifiers
    modifier onlySalesManager() {
        require(msg.sender == creator, "The calling address is not authorized.");
        _;
    }
    
    modifier correctTimeFrame() {
        _;
    }
    
    constructor(string memory title, Seat[] memory _seats)  {
        show_title = title;
        for (uint i = 0; i < _seats.length; ++i){ 
            seats.push(_seats[i]);
        }
    }
    
    //functions
    function releasePoster() private {
        
    }
    
    //main functions
    function buy(uint256 tokenId) public payable returns (uint256) {     //buys tickets
        require(seats[tokenId].showTimestamp > block.timestamp, "The specified ticket is no longer valid.");
        uint256 newTicket = ticketContract.mintTKT(msg.sender, tokenId);
        return newTicket;
    }
    
    function verify(uint256 tokenId) public view returns (address) {    //verifies tickets owners\
        address ticketOwner = tickets.ownerOf(tokenId);
        require(block.timestamp * 1000 <= seats[tokenId].timestamp, "The ticket has expired");
        return ticketOwner;
    }
    
    function refund(uint256 tokenId) public onlySalesManager {
        
    }
    
    function validate(uint256 tokenId) public correctTimeFrame {
        
    }
    
    function tradeTicket(address from, address to, uint256 price) public {
        
    }
}

contract Ticket is ERC721{
    
    address public minter_address;
    uint256 private tokenId;
    
    constructor() ERC721("Ticket", "TKT"){
        minter_address = msg.sender;
        tokenId = 0;
    }
    
    modifier onlySalesManager() {
        require(msg.sender == minter_address, "The calling address is not authorized.");
        _;
    }
    
    function mintTKT(address recipient, uint256 seatId) public onlySalesManager returns (uint256) {
        uint256 newItemId = seatId;
        _safeMint(recipient, newItemId);
        return newItemId;
    }
    
    function verifyOwner(address owner, uint256 tokenId) public returns (bool) {
        //if ()
    }
    
}

contract Poster is ERC721{
    
    address public minter_address;
    uint256 private tokenId;
    
    constructor() ERC721("Poster", "PTR"){
        minter_address = msg.sender;
        tokenId = 0;
    }
    
    modifier onlySalesManager() {
        require(msg.sender == minter_address, "The calling address is not authorized.");
        _;
    }
    
    function mintPTR(address recipient) private onlySalesManager returns (uint256) {
        uint256 newItemId = tokenId;
        _safeMint(recipient, newItemId);
        tokenId += 1;
        return newItemId;
    }
}