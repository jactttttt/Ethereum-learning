// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.20;

import { MessageHashUtils } from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Verify is Ownable {
    mapping(address => bool) public signerMap;

    mapping(bytes32 => bool) public txHashMap; 

    address public signer;

    uint public chainId;

    address public token;

    constructor(address _token) Ownable(msg.sender) {
        uint id;

        assembly {
            id := chainid()
        }

        chainId = id;
        token = _token;
        signer = msg.sender;
    }

    function mint(
        address _to,
        uint _amount,
        bytes memory _sign
    ) external {

        bytes32 messageHash = keccak256(
            abi.encode(
                _to,
                _amount,
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

        SafeERC20.safeTransfer(
            IERC20(token),
            _to,
            _amount
        );
    }
}
