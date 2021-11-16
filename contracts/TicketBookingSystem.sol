// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
//import "hardhat/console.sol";

contract TicketBookingSystem {
    struct Seat {
        uint16 rowNumber;
        uint16 seatNumber;
        uint64 timestamp;
        string seatViewURL;
        uint price;
    }

    //Public attributes
    string public show_title;
    uint64 public validationTimeframe;
    Seat[] public seats;

    // tokens must be public for everyone to see ownership
    Ticket public tickets = new Ticket();
    Poster public posters = new Poster();

    //Private attributes
    address private creator;

    //modifiers
    modifier onlySalesManager() {
        require(
            msg.sender == creator,
            "The calling address is not authorized."
        );
        _;
    }

    modifier correctTimeFrame(uint256 tokenId) {
        require(block.timestamp * 1000 <= seats[tokenId].timestamp, "The ticket has expired");
        require(block.timestamp * 1000 >= seats[tokenId].timestamp - validationTimeframe, "The validation period hasn't started.");
        _;
    }

    constructor(
        string memory title,
        uint64 _validationTimeframe, // time before show timestamp when the ticket can be validated
        Seat[] memory _seats
    ) {
        //console.log(
        //    'Initializing BookingSystem "%s" with %d seats',
        //    title,
        //    _seats.length
        //);
        show_title = title;
        validationTimeframe = _validationTimeframe;
        for (uint256 i = 0; i < _seats.length; ++i) {
            seats.push(_seats[i]);
        }
    }

    //functions
    function releasePoster() private {}

    //main functions
    function buy(uint256 seatId) public payable returns (uint256 newTokenId) {
        //buys tickets
        require(
            msg.value >= seats[seatId].price,
            "The price of the ticket is not correct."
        );
        require(
            seats[seatId].timestamp > block.timestamp,
            "The specified ticket is no longer valid."
        );
        return tickets.mintTKT(msg.sender, seatId);
    }

    function verify(uint256 tokenId) public view returns (address) {
        //verifies tickets owners\
        address ticketOwner = tickets.ownerOf(tokenId);
        require(
            block.timestamp * 1000 <= seats[tokenId].timestamp,
            "The ticket has expired"
        );
        return ticketOwner;
    }

    function refund() public {
        for (uint256 id = 0; id < seats.length; ++id) {
            try tickets.ownerOf(id) returns (address owner) {
                payable(owner).transfer(seats[id].price);
                tickets.burnTKT(id);
            } catch {
                // if the ticket does not exist, there is nothing to return
                continue;
            }
        }
    }

    //Destroys the ticket and creates a POSTER token
    function validate(uint256 tokenId) public correctTimeFrame(tokenId) returns (uint256) {
        require(tickets.ownerOf(tokenId) == msg.sender, "The owner of the ticket is invalid."); //The owner of the ticket needs to call this
        tickets.burnTKT(tokenId);        //Destroy original ticket
        return posters.mintPTR(msg.sender, tokenId);  //Create poster that serves as proof-of-purchase
    }

    function tradeTicket(
        address from,
        address to,
        uint256 price
    ) public {}
}

contract Ticket is ERC721, ERC721Burnable {
    address public minter_address;

    constructor() ERC721("Ticket", "TKT") {
        minter_address = msg.sender;
    }

    modifier onlySalesManager() {
        require(
            msg.sender == minter_address,
            "The calling address is not authorized."
        );
        _;
    }

    function mintTKT(address recipient, uint256 seatId)
        public
        onlySalesManager
        returns (uint256)
    {
        _safeMint(recipient, seatId);
        return seatId;
    }
    
    function burnTKT(uint256 seatId)
        public
        onlySalesManager
    {
        _burn(seatId);
    }
}

contract Poster is ERC721 {
    address public minter_address;
    uint256 private tokenId;

    constructor() ERC721("Poster", "PTR") {
        minter_address = msg.sender;
    }

    modifier onlySalesManager() {
        require(
            msg.sender == minter_address,
            "The calling address is not authorized."
        );
        _;
    }

    function mintPTR(address recipient, uint256 itemId)
        public
        onlySalesManager
        returns (uint256)
    {
        _safeMint(recipient, itemId);
        return itemId;
    }
}
