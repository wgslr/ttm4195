// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TicketBookingSystem{// is ERC721 {
    
    //Public attributes
    address public minter_address;
    string public show_title;
    
    //Private attributes
    uint256 private tokenId;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    
    //modifiers
    modifier onlySalesManager() {
        require(msg.sender == minter_address, "The calling address is not authorized.")
        _;
    }
    
    modifier correctTimeFrame() {
        _;
    }
    
    constructor() ERC721("TicketBookingSystem", "TKT") {
        minter_address = msg.sender;
        tokenId = 0;
        show_title = "Lion King";
    }
    
    //functions
    function mintTKT(address recipient) private onlySalesManager returns (uint256) {
        uint256 newItemId = tokenId;
        _mint(recipient, newItemId);
        tokenId += 1;
        return newItemId;
    }
    
    function releasePoster() {
        
    }
    
    //main functions
    function buy(string seat, string date, string show) public payable returns (uint256) {
        
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