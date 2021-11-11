// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Posters is ERC721 {
    
    address public minter_address;
    uint256 private tokenId;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    
    modifier onlySalesManager() {
        require(msg.sender == minter_address, "The calling address is not authorized.")
        _;
    }
    
    constructor() ERC721("Poster", "PTR") {
        minter_address = msg.sender;
        tokenId = 0;
    }
    
    function mintTKT(address recipient) public onlySalesManager returns (uint256) {
        uint256 newItemId = tokenId;
        _mint(recipient, newItemId);
        tokenId += 1;
        return newItemId;
    }
    
}