// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISimpleStorage {
    function getOwner() external returns(address);
}

contract SimpleStorage {
    uint public num;

    address internal owner;

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

    function getOwner() external view returns(address) {
        return owner;
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

    function getSimpleStorageOwner(address _addr) public returns(address) {
            return ISimpleStorage(_addr).getOwner();
    }
}
