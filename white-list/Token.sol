// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.20;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

    address public factory;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        factory = msg.sender;
    }

    function mint(address to, uint amount) external {
        require(msg.sender == factory, "Only factory mint");
        _mint(to, amount);
    } 

    function burn(uint amount) external {
        require(msg.sender == factory, "Only factory burn");
        _burn(msg.sender, amount);
    }
}
