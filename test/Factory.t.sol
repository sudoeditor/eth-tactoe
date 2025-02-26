// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Channel} from "../src/Channel.sol";
import {Encode} from "../src/lib/Encode.sol";
import {Factory} from "../src/Factory.sol";

import {BaseTest} from "./BaseTest.sol";

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

    function test_create_CreatesNewChannel() public {
        address prediction = factory.predict(alice, bob);
        assertEq(prediction.code.length, 0);

        bytes memory signature = sign(alicePk, factory, Encode.Create(alice, bob));

        vm.prank(bob);
        factory.create(alice, bob, signature);

        assertGt(prediction.code.length, 0);
    }

    function test_create_EmitsCreated() public {
        bytes memory signature = sign(bobPk, factory, Encode.Create(alice, bob));

        vm.expectEmit();
        emit Factory.Created(alice, bob, Channel(factory.predict(alice, bob)));

        vm.prank(alice);
        factory.create(alice, bob, signature);
    }

    function test_create_CallsInitializeOnNewChannel() public {
        bytes memory signature = sign(alicePk, factory, Encode.Create(alice, bob));

        vm.expectCall(factory.predict(alice, bob), abi.encodeWithSelector(Channel.initialize.selector));

        vm.prank(bob);
        factory.create(alice, bob, signature);
    }
}
