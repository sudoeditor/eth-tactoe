// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {BaseUtils} from "./BaseUtils.sol";

import {Test} from "forge-std/Test.sol";

abstract contract BaseTest is Test, BaseUtils {
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
