// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Engine} from "../../src/lib/Engine.sol";

import {Test} from "forge-std/Test.sol";

contract EngineTest is Test {
    function test_toGrid_ZeroesLowerSevenBits() public pure {
        Engine.Grid grid = Engine.toGrid(0xffff); // 0b1111111111111111
        assertEq(Engine.Grid.unwrap(grid), 0x1ff); // 0b0000000111111111
    }
}
