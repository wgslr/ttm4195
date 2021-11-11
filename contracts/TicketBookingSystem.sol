// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TicketBookingSystem{
    
    //Public attributes
    address public minter_address;
    string public show_title;
    
    //Private attributes

    Ticket ticketContract = new Ticket();
    Poster posterContract = new Poster();
    
    //modifiers
    modifier onlySalesManager() {
        require(msg.sender == minter_address, "The calling address is not authorized.")
        _;
    }
    
    modifier correctTimeFrame() {
        _;
    }
    
    constructor() {
        show_title = "Lion King";
    }
    
    //functions
    function releasePoster() {
        
    }
    
    //main functions
    function buy(string seat, string date, string show) public payable returns (uint256) {
        //if seat is available, blabla...
        ticketContract.mintTKT(msg.sender);
    }
    
    function verify(uint256 tokenId, address owner) public returns (bool) {
        
    }
    
    function refund(uint256 tokenId) public {
        
    }
    
    function validate(uint256 tokenId) public correctTimeFrame returns (bool) {
        
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
        require(msg.sender == minter_address, "The calling address is not authorized.")
        _;
    }
    
    function mintTKT(address recipient) private onlySalesManager returns (uint256) {
        uint256 newItemId = tokenId;
        _safeMint(recipient, newItemId);
        tokenId += 1;
        return newItemId;
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
        require(msg.sender == minter_address, "The calling address is not authorized.")
        _;
    }
    
    function mintPTR(address recipient) private onlySalesManager returns (uint256) {
        uint256 newItemId = tokenId;
        _safeMint(recipient, newItemId);
        tokenId += 1;
        return newItemId;
    }
    
}