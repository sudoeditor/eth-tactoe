// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.28;

library Engine {
    type Grid is uint16;

    function equal(Grid self, Grid other) internal pure returns (bool) {
        return Grid.unwrap(self) == Grid.unwrap(other);
    }

    function union(Grid self, Grid other) internal pure returns (Grid) {
        return Grid.wrap(Grid.unwrap(self) | Grid.unwrap(other));
    }

    function toGrid(uint16 value) internal pure returns (Grid) {
        return Grid.wrap(value & 0x1ff);
    }
}
