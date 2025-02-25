// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Engine} from "../../src/lib/Engine.sol";

import {Test} from "forge-std/Test.sol";
import {stdError} from "forge-std/StdError.sol";

contract EngineTest is Test {
    using Engine for Engine.Grid;

    Engine.Grid public gridA;
    Engine.Grid public gridB;
    Engine.Grid public gridC;

    constructor() {
        gridA = Engine.toGrid(0x155); // 0b0000000101010101
        gridB = Engine.toGrid(0x0aa); // 0b0000000010101010
        gridC = Engine.toGrid(0x1ab); // 0b0000000110101011
    }

    function test_get_RevertsIfIndexIsLowerSeven() public {
        vm.expectRevert(stdError.indexOOBError);

        EngineTest(address(this)).get(gridA, 15);
    }

    function test_get_ResultIsTrueIfBitIsNonZeroAtIndexOrFalseOtherwise() public view {
        assertTrue(gridA.get(0));
        assertFalse(gridA.get(1));
    }

    function test_set_RevertsIfIndexIsLowerSeven() public {
        vm.expectRevert(stdError.indexOOBError);

        EngineTest(address(this)).set(gridA, 15);
    }

    function test_set_ResultHasNonZeroBitAtIndex() public view {
        assertTrue(gridB.set(0).get(0));
    }

    function test_equal_ReturnsTrueWhenAllBitsMatchAndFalseOtherwise() public view {
        assertTrue(gridA.equal(gridA));
        assertFalse(gridA.equal(gridC));
    }

    function test_intersection_ResultContainsAllNonZeroBitsInBoth() public view {
        assertEq(unwrap(gridA.intersection(gridC)), 0x101); // 0b0000000100000001
    }

    function test_union_ResultContainsAllNonZeroBitsFromBoth() public view {
        assertEq(unwrap(gridA.union(gridB)), 0x1ff); // 0b0000000111111111
    }

    function test_toGrid_ZeroesLowerSevenBits() public pure {
        Engine.Grid grid = Engine.toGrid(0xffff); // 0b1111111111111111
        assertEq(unwrap(grid), 0x1ff); // 0b0000000111111111
    }

    function get(Engine.Grid grid, uint256 index) public pure returns (bool) {
        return grid.get(index);
    }

    function set(Engine.Grid grid, uint256 index) public pure returns (Engine.Grid) {
        return grid.set(index);
    }

    function unwrap(Engine.Grid grid) internal pure returns (uint16) {
        return Engine.Grid.unwrap(grid);
    }
}
