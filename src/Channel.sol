// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Encode} from "./lib/Encode.sol";

import {EIP712Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract Channel is EIP712Upgradeable {
    using Encode for Encode.Close;
    using Encode for Encode.Reinitialize;

    address public alice;
    address public bob;
    address public winner;

    event Closed(address indexed winner);

    error AlreadyClosed();
    error DeadlinePassed();
    error InvalidCaller();
    error InvalidSigner();
    error InvalidWinner();
    error NotClosed();

    modifier onlyParticipants() {
        if (msg.sender != alice && msg.sender != bob) revert InvalidCaller();
        _;
    }

    modifier whenClosed() {
        if (winner == address(0)) revert NotClosed();
        _;
    }

    modifier whenNotClosed() {
        if (winner != address(0)) revert AlreadyClosed();
        _;
    }

    constructor() {
        _disableInitializers();
    }

    // slither-disable-next-line naming-convention
    function initialize(address _alice, address _bob) external initializer {
        __EIP712_init("Channel", "1");

        // slither-disable-next-line missing-zero-check
        (alice, bob) = (_alice, _bob);
    }

    function reinitialize(uint256 deadline, bytes calldata signature)
        external
        onlyParticipants
        whenClosed
        reinitializer(_getInitializedVersion() + 1)
    {
        // slither-disable-next-line timestamp
        if (block.timestamp > deadline) revert DeadlinePassed();
        if (!isValidSigner(Encode.Reinitialize(deadline).getStructHash(), signature)) revert InvalidSigner();

        __EIP712_init("Channel", Strings.toString(_getInitializedVersion()));

        (alice, bob, winner) = (bob, alice, address(0));
    }

    // slither-disable-next-line naming-convention
    function close(address _winner, bytes calldata signature) external onlyParticipants whenNotClosed {
        if (_winner != alice && _winner != bob) revert InvalidWinner();
        if (!isValidSigner(Encode.Close(_winner).getStructHash(), signature)) revert InvalidSigner();

        emit Closed(winner = _winner);
    }

    function isValidSigner(bytes32 structHash, bytes memory signature) internal view returns (bool) {
        address signer = ECDSA.recover(_hashTypedDataV4(structHash), signature);
        if ((msg.sender == alice) ? signer == bob : signer == alice) return true;
        return false;
    }
}
