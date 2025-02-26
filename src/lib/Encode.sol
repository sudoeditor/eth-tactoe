// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {IERC5267} from "@openzeppelin/contracts/interfaces/IERC5267.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

library Encode {
    bytes32 private constant TYPEHASH =
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

    function getDomainSeparator(IERC5267 app) internal view returns (bytes32) {
        (, string memory name, string memory version, uint256 chainId, address verifyingContract,,) = app.eip712Domain();
        return keccak256(
            abi.encode(TYPEHASH, keccak256(bytes(name)), keccak256(bytes(version)), chainId, verifyingContract)
        );
    }

    bytes32 private constant CREATE_TYPEHASH = keccak256("Create(address alice,address bob)");

    struct Create {
        address alice;
        address bob;
    }

    function getStructHash(Create memory data) internal pure returns (bytes32) {
        return keccak256(abi.encode(CREATE_TYPEHASH, data.alice, data.bob));
    }

    function toTypedDataHash(IERC5267 app, Create memory data) internal view returns (bytes32) {
        return MessageHashUtils.toTypedDataHash(getDomainSeparator(app), getStructHash(data));
    }

    bytes32 private constant CLOSE_TYPEHASH = keccak256("Close(address winner)");

    struct Close {
        address winner;
    }

    function getStructHash(Close memory data) internal pure returns (bytes32) {
        return keccak256(abi.encode(CLOSE_TYPEHASH, data.winner));
    }

    function toTypedDataHash(IERC5267 app, Close memory data) internal view returns (bytes32) {
        return MessageHashUtils.toTypedDataHash(getDomainSeparator(app), getStructHash(data));
    }
}
