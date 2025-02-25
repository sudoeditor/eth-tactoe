// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Engine} from "../../src/lib/Engine.sol";

import {Test} from "forge-std/Test.sol";

contract EngineTest is Test {
    using Engine for Engine.Grid;

    function test_equal_ReturnsTrueWhenAllBitsMatchAndFalseOtherwise() public pure {
        Engine.Grid grid_1 = Engine.toGrid(0x155); // 0b0000000101010101
        Engine.Grid grid_2 = Engine.toGrid(0x155); // 0b0000000101010101
        Engine.Grid grid_3 = Engine.toGrid(0x1ab); // 0b0000000110101011
        assertTrue(grid_1.equal(grid_2));
        assertFalse(grid_1.equal(grid_3));
    }

    function test_intersection_ResultContainsAllNonZeroBitsInBoth() public pure {
        Engine.Grid grid_1 = Engine.toGrid(0x155); // 0b0000000101010101
        Engine.Grid grid_2 = Engine.toGrid(0x1ab); // 0b0000000110101011
        assertEq(Engine.Grid.unwrap(grid_1.intersection(grid_2)), 0x101); // 0b0000000100000001
    }

    function test_union_ResultContainsAllNonZeroBitsFromBoth() public pure {
        Engine.Grid grid_1 = Engine.toGrid(0x155); // 0b0000000101010101
        Engine.Grid grid_2 = Engine.toGrid(0x0aa); // 0b0000000010101010
        assertEq(Engine.Grid.unwrap(grid_1.union(grid_2)), 0x1ff); // 0b0000000111111111
    }

    function test_toGrid_ZeroesLowerSevenBits() public pure {
        Engine.Grid grid = Engine.toGrid(0xffff); // 0b1111111111111111
        assertEq(Engine.Grid.unwrap(grid), 0x1ff); // 0b0000000111111111
    }
}
