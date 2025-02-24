// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Channel} from "./Channel.sol";

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract Factory is EIP712("Factory", "1") {
    address public immutable implementation;

    constructor() {
        implementation = address(new Channel());
    }

    function predict(address alice, address bob) external view returns (address) {
        return
            Clones.predictDeterministicAddress(implementation, bytes32(uint256(uint160(alice)) ^ uint256(uint160(bob))));
    }
}
