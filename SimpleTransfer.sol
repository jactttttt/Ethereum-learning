// SPDX-License-Identifier: GPL-3.0

pragma solidity  ^0.8.20;

contract SimpleTransfer {
    address public owner;

    event LogCallWithValue(address sender, uint amount);

    constructor() payable {
        owner = msg.sender;
    }

    function callWithValue() public payable {
        emit LogCallWithValue(msg.sender, msg.value);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getTargetAddressBalance(address _target) public view returns(uint) {
        return address(_target).balance;
    }

    function transferEth(address _target, uint _amount) public {
        require(msg.sender == owner, "no permission");

        (bool success,) = _target.call{value: _amount}("");
        require(success, "transfer failed.");
    }

    receive() external payable {}

    fallback() external payable {}
}
