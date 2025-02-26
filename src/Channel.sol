// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {EIP712Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Channel is EIP712Upgradeable {
    bytes32 private constant CLOSE_TYPEHASH = keccak256("Close(address winner)");

    address public alice;
    address public bob;
    address public winner;

    error AlreadyClosed();
    error InvalidCaller();
    error InvalidSigner();
    error InvalidWinner();

    event Closed(address indexed winner);

    constructor() {
        _disableInitializers();
    }

    // slither-disable-next-line naming-convention
    function initialize(address _alice, address _bob) external initializer {
        __EIP712_init("Channel", "1");

        // slither-disable-next-line missing-zero-check
        alice = _alice;
        // slither-disable-next-line missing-zero-check
        bob = _bob;
    }

    // slither-disable-next-line naming-convention
    function close(address _winner, bytes calldata signature) external {
        if (winner != address(0)) revert AlreadyClosed();
        if (msg.sender != alice && msg.sender != bob) revert InvalidCaller();
        if (_winner != alice && _winner != bob) revert InvalidWinner();

        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(CLOSE_TYPEHASH, _winner)));
        address signer = ECDSA.recover(digest, signature);
        if ((msg.sender == alice) ? signer != bob : signer != alice) revert InvalidSigner();

        emit Closed(winner = _winner);
    }
}
