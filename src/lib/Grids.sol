// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

import {Panic} from "@openzeppelin/contracts/utils/Panic.sol";

library Grids {
    type Grid is uint16;

    Grid private constant GRID_1 = Grid.wrap(0x0007); // 0b000000111
    Grid private constant GRID_2 = Grid.wrap(0x0038); // 0b000111000
    Grid private constant GRID_3 = Grid.wrap(0x01c0); // 0b111000000
    Grid private constant GRID_4 = Grid.wrap(0x0049); // 0b001001001
    Grid private constant GRID_5 = Grid.wrap(0x0092); // 0b010010010
    Grid private constant GRID_6 = Grid.wrap(0x0124); // 0b100100100
    Grid private constant GRID_7 = Grid.wrap(0x0054); // 0b001010100
    Grid private constant GRID_8 = Grid.wrap(0x0111); // 0b100010001

    modifier checkIndex(uint256 index) {
        if (index >= 9) Panic.panic(Panic.ARRAY_OUT_OF_BOUNDS);
        _;
    }

    function isWinner(Grid self) internal pure returns (bool) {
        if (equal(intersection(self, GRID_1), GRID_1)) return true;
        if (equal(intersection(self, GRID_2), GRID_2)) return true;
        if (equal(intersection(self, GRID_3), GRID_3)) return true;
        if (equal(intersection(self, GRID_4), GRID_4)) return true;
        if (equal(intersection(self, GRID_5), GRID_5)) return true;
        if (equal(intersection(self, GRID_6), GRID_6)) return true;
        if (equal(intersection(self, GRID_7), GRID_7)) return true;
        if (equal(intersection(self, GRID_8), GRID_8)) return true;
        return false;
    }

    function get(Grid self, uint256 index) internal pure checkIndex(index) returns (bool) {
        return ((Grid.unwrap(self) >> index) & 1) == 1;
    }

    function set(Grid self, uint256 index) internal pure checkIndex(index) returns (Grid) {
        return union(self, Grid.wrap(uint16(1 << index)));
    }

    function equal(Grid self, Grid other) internal pure returns (bool) {
        return Grid.unwrap(self) == Grid.unwrap(other);
    }

    function intersection(Grid self, Grid other) internal pure returns (Grid) {
        return Grid.wrap(Grid.unwrap(self) & Grid.unwrap(other));
    }

    function union(Grid self, Grid other) internal pure returns (Grid) {
        return Grid.wrap(Grid.unwrap(self) | Grid.unwrap(other));
    }

    function toGrid(uint16 value) internal pure returns (Grid) {
        return Grid.wrap(value & 0x1ff);
    }

    function newGrid() internal pure returns (Grid) {
        return Grid.wrap(0);
    }
}
