// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Encode} from "../src/lib/Encode.sol";

import {IERC5267} from "@openzeppelin/contracts/interfaces/IERC5267.sol";

import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

abstract contract BaseUtils {
    Vm private constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function sign(uint256 privateKey, IERC5267 app, Encode.Create memory data) internal view returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, Encode.toTypedDataHash(app, data));
        return abi.encodePacked(r, s, v);
    }
}

abstract contract BaseTest is BaseUtils, Test {
    address public alice;
    uint256 public alicePk;

    address public bob;
    uint256 public bobPk;

    address public charlie;
    uint256 public charliePk;

    constructor() {
        (alice, alicePk) = makeAddrAndKey("alice");
        (bob, bobPk) = makeAddrAndKey("bob");
        (charlie, charliePk) = makeAddrAndKey("charlie");
    }
}
