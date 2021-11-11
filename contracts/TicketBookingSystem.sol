// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TicketBookingSystem{
    
    struct  Seat {
        uint16 rowNumber;
        uint16 seatNumber;
        uint64 showTimestamp;
        string seatViewURL;
        uint price;
    }
    
    //Public attributes
    string public show_title;
    Seat[] seats;
    
    //Private attributes

    
    //modifiers
    modifier onlySalesManager() {
        // require(msg.sender == minter_address, "The calling address is not authorized.");
        _;
    }
    
    modifier correctTimeFrame() {
        _;
    }
    
    constructor(string memory title)  {
        show_title = title;
    }
    
    //functions
    function releasePoster() private {
        
    }
    
    //main functions
    function buy() public payable {     //buys tickets
        //if seat is available, blabla...  (string memory seat, string memory date, string memory show)
        // ticketContract.mintTKT(msg.sender);
    }
    
    function verify(uint256 tokenId, address owner) public {    //verifies tickets owners
        
    }
    
    function refund(uint256 tokenId) public {
        
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
    
    function mintTKT(address recipient) public onlySalesManager returns (uint256) {
        uint256 newItemId = tokenId;
        _safeMint(recipient, newItemId);
        tokenId += 1;
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