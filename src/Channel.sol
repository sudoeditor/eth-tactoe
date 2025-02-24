// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Channel is Initializable {
    constructor() {
        _disableInitializers();
    }

    function initialize() external initializer {}
}
