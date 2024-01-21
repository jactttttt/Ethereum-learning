// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.20;

import { MessageHashUtils } from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { Token } from "./Token.sol";

contract Verify is Ownable {
    mapping(address => bool) public signerMap;

    mapping(bytes32 => bool) public txHashMap; 

    address public signer;

    uint public chainId;

    address public token;

    event CreateToken(address token);

    constructor() Ownable(msg.sender) {
        signer = msg.sender;

        uint id;

        assembly {
            id := chainid()
        }

        chainId = id;
    }

    function createToken(string memory _name, string memory _symbol) external onlyOwner returns(address) {
        address _token = address(new Token{salt: keccak256(abi.encode(_name, _symbol))}(_name, _symbol));

        token = _token;

        emit CreateToken(_token);

        return _token;
    }

    function mint(
        address _to,
        address _token,
        uint _amount,
        string memory _txid,
        bytes memory _sign
    ) external {

        bytes32 messageHash = keccak256(
            abi.encode(
                _to,
                _token,
                _amount,
                _txid,
                chainId
            )
        );

        require(!txHashMap[messageHash], "Parameters duplicate");

        address decodeSigner = ECDSA.recover(
                MessageHashUtils.toEthSignedMessageHash(messageHash),
                _sign
        );

        require(decodeSigner == signer, "Invalid parameters");

        txHashMap[messageHash] = true;

        Token(_token).mint(_to, _amount);
    }
}
