// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Grids} from "../../src/lib/Grids.sol";

import {Test} from "forge-std/Test.sol";
import {stdError} from "forge-std/StdError.sol";

contract GridsTest is Test {
    using Grids for Grids.Grid;

    Grids.Grid public gridA;
    Grids.Grid public gridB;
    Grids.Grid public gridC;

    constructor() {
        gridA = Grids.toGrid(0x155); // 0b0000000101010101
        gridB = Grids.toGrid(0x0aa); // 0b0000000010101010
        gridC = Grids.toGrid(0x1ab); // 0b0000000110101011
    }

    function test_get_RevertsIfIndexIsLowerSeven() public {
        vm.expectRevert(stdError.indexOOBError);

        GridsTest(address(this)).get(gridA, 15);
    }

    function test_get_ResultIsTrueIfBitIsNonZeroAtIndexOrFalseOtherwise() public view {
        assertTrue(gridA.get(0));
        assertFalse(gridA.get(1));
    }

    function test_set_RevertsIfIndexIsLowerSeven() public {
        vm.expectRevert(stdError.indexOOBError);

        GridsTest(address(this)).set(gridA, 15);
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
        Grids.Grid grid = Grids.toGrid(0xffff); // 0b1111111111111111
        assertEq(unwrap(grid), 0x1ff); // 0b0000000111111111
    }

    function get(Grids.Grid grid, uint256 index) public pure returns (bool) {
        return grid.get(index);
    }

    function set(Grids.Grid grid, uint256 index) public pure returns (Grids.Grid) {
        return grid.set(index);
    }

    function unwrap(Grids.Grid grid) internal pure returns (uint16) {
        return Grids.Grid.unwrap(grid);
    }
}
