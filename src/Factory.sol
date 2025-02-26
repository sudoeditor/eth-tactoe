// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Channel} from "./Channel.sol";
import {Encode} from "./lib/Encode.sol";

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract Factory is EIP712("Factory", "1") {
    using Encode for Encode.Create;

    address public immutable implementation;

    event Created(address indexed alice, address indexed bob, Channel channel);

    error InvalidCaller();
    error InvalidSigner();

    constructor() {
        implementation = address(new Channel());
    }

    function create(address alice, address bob, bytes calldata signature) external {
        if (msg.sender != alice && msg.sender != bob) revert InvalidCaller();

        address signer = ECDSA.recover(_hashTypedDataV4(Encode.Create(alice, bob).getStructHash()), signature);
        if ((msg.sender == alice) ? signer != bob : signer != alice) revert InvalidSigner();

        Channel channel =
            Channel(Clones.cloneDeterministic(implementation, bytes32(uint256(uint160(alice)) ^ uint256(uint160(bob)))));
        emit Created(alice, bob, channel);
        channel.initialize(alice, bob);
    }

    function predict(address alice, address bob) external view returns (address) {
        return
            Clones.predictDeterministicAddress(implementation, bytes32(uint256(uint160(alice)) ^ uint256(uint160(bob))));
    }
}
