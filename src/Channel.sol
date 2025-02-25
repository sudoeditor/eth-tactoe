// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {EIP712Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";

contract Channel is EIP712Upgradeable {
    address public alice;
    address public bob;

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
}
