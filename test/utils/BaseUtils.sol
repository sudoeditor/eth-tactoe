// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Encode} from "./Encode.sol";

import {IERC5267} from "@openzeppelin/contracts/interfaces/IERC5267.sol";

import {Vm} from "forge-std/Vm.sol";

abstract contract BaseUtils {
    Vm private constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function sign(uint256 privateKey, IERC5267 app, Encode.Create memory data) internal view returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, Encode.toTypedDataHash(app, data));
        return abi.encodePacked(r, s, v);
    }
}
