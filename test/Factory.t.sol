// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Channel} from "../src/Channel.sol";
import {Factory} from "../src/Factory.sol";

import {BaseTest} from "./BaseTest.sol";
import {Encode} from "./utils/Encode.sol";

contract FactoryTest is BaseTest {
    Factory public factory;

    constructor() {
        factory = new Factory();
    }

    function test_create_RevertsIfCallerIsNeitherAliceNorBob() public {
        vm.expectRevert(Factory.InvalidCaller.selector);

        vm.prank(charlie);
        factory.create(alice, bob, "");
    }

    function test_create_RevertsIfSignerIsNeitherAliceNorBob() public {
        bytes memory signature = sign(charliePk, factory, Encode.Create(alice, bob));

        for (uint256 i = 0; i < 2; i++) {
            vm.expectRevert(Factory.InvalidSigner.selector);

            vm.prank((i != 0) ? alice : bob);
            factory.create(alice, bob, signature);
        }
    }

    function test_create_RevertsIfCallerIsAliceOrBobAndSignerIsCaller() public {
        for (uint256 i = 0; i < 2; i++) {
            bytes memory signature = sign((i != 0) ? alicePk : bobPk, factory, Encode.Create(alice, bob));

            vm.expectRevert(Factory.InvalidSigner.selector);

            vm.prank((i != 0) ? alice : bob);
            factory.create(alice, bob, signature);
        }
    }
}
