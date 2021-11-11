// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tickets is ERC721 {
    
    //Public attributes
    address public minter_address;
    
    //Private attributes
    uint256 private tokenId;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    
    modifier onlySalesManager() {
        require(msg.sender == minter_address, "The calling address is not authorized.")
        _;
    }
    
    constructor() ERC721("Ticket", "TKT") {
        minter_address = msg.sender;
        tokenId = 0;
    }
    
    
}