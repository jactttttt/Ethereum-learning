// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStorage {
    uint public num;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function set(uint _num) public {
        require(msg.sender == owner, "no permission");
        num = _num;
    }

    function get() public view returns (uint) {
        return num;
    }
}

contract FactoryContract {
    address public owner;

    uint public index;

    constructor() {
        owner = msg.sender;
    }

    function createContract() public returns(address) {
        address c = address(new SimpleStorage{salt: keccak256(abi.encode(msg.sender, index))}());

        index += 1;

        return c;
    }
}
