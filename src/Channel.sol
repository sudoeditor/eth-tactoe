// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {EIP712Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";

contract Channel is EIP712Upgradeable {
    constructor() {
        _disableInitializers();
    }

    function initialize() external initializer {
        __EIP712_init("Channel", "1");
    }
}
